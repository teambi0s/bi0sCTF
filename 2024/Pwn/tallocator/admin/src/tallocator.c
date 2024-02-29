/* tourpran's allocator*/

// Libraries
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <jni.h>

// Helper macros
#define ull unsigned long long

// 16 byte aligned heap structure.
#define ALIGNMENT 16
#define ALIGN(size) (((size) + (ALIGNMENT-1)) & ~15)

// data retrieval and updation
#define GET(p) (*(ull *)(p))
#define PUT(p, val) (*(ull *)(p) = (ull)(val))

// Head to all the short free list.
#define HEAD_SHORT *(ull *)(HeapStart+16)
#define HEAD_LONG *(ull *)(HeapStart+24)
#define SET_FWD(p, val) *(ull *)(p) = (ull)val
#define SET_BKD(p, val) *(ull *)(p+8) = (ull)val
#define GET_FWD(p) *(ull *)(p)
#define GET_BKD(p) *(ull *)(p+8)
#define SET_USE(p) *(ull *)(p-8) = (*(ull *)(p-8)) | 0b1
#define SET_FREE(p) *(ull *)(p-8) = (*(ull *)(p-8)) & ~(0b1UL)
#define CHK_USE(p) ((*(ull  *)(p-8)) & 0b1)

// metadata
#define GETSIZE(p) (*(ull *)(p-8))

// Globals
static void* HeapStart;
static void* runDebug;
static ull Debugger_talloc=0;
static ull Debugger_free=0;
static bool init_called = false;
static void* top_chunk;


void terror(char* err){
    printf("%s", err);
    exit(0);
}

int init_talloc(){
    if(init_called == true){
        return 0;
    }

    runDebug = mmap((void*)0x41410000, 0x1000, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    init_called = true;
    HeapStart = sbrk(0x1000);

    PUT(HeapStart+8, 0x30);
    PUT(HeapStart+0x38, (0x1000 - 0x38));
    PUT(HeapStart+0x20, 0x3a63);
    top_chunk = HeapStart + 0x38;
}

JNIEXPORT jlong* JNICALL Java_bi0sctf_android_challenge_MainActivity_talloc(JNIEnv *env,jobject thiz,jint size,jbyteArray inp_string ){
    init_talloc();

    Debugger_talloc = *(long long *)(HeapStart+40);
    if(Debugger_talloc != 0){
        void (*call_debugger)() = (void (*)())Debugger_talloc;
        call_debugger();
        perror("Debugger called !!");
    }
    int size_byte_arr = (*env)->GetArrayLength( env, inp_string );
    size_t alloc_size = ALIGN(size + 8);
    void* ptr = NULL;
    int best_size=__INT_MAX__;

    // Check in short bins (0x20-0x100)
    if(alloc_size <= 0x150 && (ull *)HEAD_SHORT != 0){
        void* curr_ptr = (void *)HEAD_SHORT;
        int cnt = 0;
        while(curr_ptr != NULL && cnt != 20){

            if(GETSIZE(curr_ptr) >= alloc_size && abs(alloc_size-GETSIZE(curr_ptr)) < best_size){
                best_size = abs(alloc_size - GETSIZE(curr_ptr));
                ptr = (ull*)curr_ptr;
            }
            curr_ptr = (ull *)*(ull *)(curr_ptr);
            cnt += 1;
        }
        if(ptr != 0 && GET_FWD(ptr) != 0){
            SET_BKD(GET_FWD(ptr), GET_BKD(ptr));
        }
        if(ptr != 0 && GET_BKD(ptr) != 0){
            SET_FWD(GET_BKD(ptr), GET_FWD(ptr));
        }
        if((ull)ptr == HEAD_SHORT){
            PUT(&HEAD_SHORT, GET(ptr));
        }
    }

        // Check in tall bins (anything larger than 0x100)
    else if(alloc_size < 0x1000 &&  alloc_size > 0x150 && (ull *)HEAD_LONG != 0){
        void* curr_ptr = (void *)HEAD_LONG;
        int cnt = 0;
        while(curr_ptr != NULL && cnt != 20){
            if(GETSIZE(curr_ptr) >= size && abs(alloc_size-GETSIZE(curr_ptr)) < best_size){
                best_size = abs(alloc_size - GETSIZE(curr_ptr));
                ptr = (ull*)curr_ptr;
            }
            curr_ptr = (ull *)*(ull *)(curr_ptr);
            cnt += 1;
        }
        if(ptr != NULL && GET_FWD(ptr) != NULL){
            SET_BKD(GET_FWD(ptr), GET_BKD(ptr));
        }
        if(ptr != NULL && GET_BKD(ptr) != NULL){
            SET_FWD(GET_BKD(ptr), GET_FWD(ptr));
        }
        if((ull)ptr == HEAD_LONG){
            PUT(&HEAD_LONG, GET_FWD(ptr));
        }
    }

    // grab it from the top_chunk.
    if(ptr == NULL){
        if(*(ull *)(top_chunk) < alloc_size){
            perror("Cant give you more memory !!");
        }
        ptr = (void *)(top_chunk + 8);
        top_chunk += alloc_size;
        *(ull *)top_chunk = *(ull *)(top_chunk-alloc_size) - alloc_size;
        *(ull *)(top_chunk-alloc_size) = (ull)(alloc_size);
    }
    char* input = (*env)->GetByteArrayElements(env, inp_string, NULL);
    if( size_byte_arr <= size){
        memcpy(ptr, input, size_byte_arr);
    }
    if((int)CHK_USE(ptr) == 1){
        terror("Overwriting Chunks !!");
    }
    SET_USE(ptr);
    return ptr;
}

JNIEXPORT jint JNICALL  Java_bi0sctf_android_challenge_MainActivity_tree(JNIEnv *env,jobject thiz,jlong ptr){
    if((int)CHK_USE(ptr) == 0){
        terror("Double Tree !!");
    }
    SET_FREE(ptr);
    // consolidate into wilderness
    int chunk_size = GETSIZE(ptr);
    if(top_chunk == (void *)((void *)ptr+(chunk_size-8) )){
        top_chunk -= chunk_size;
        *(ull *)top_chunk = *(ull *)(top_chunk+chunk_size) - chunk_size;
        *(ull *)(top_chunk+chunk_size) = 0;
        return 0;
    }
    // link a short bin.
    if(chunk_size <= 0x100){
        if(HEAD_SHORT == 0){
            SET_FWD(ptr, 0);
            SET_BKD(ptr, &HEAD_SHORT);
            HEAD_SHORT = (ull)ptr;
            return 0;
        }
        SET_FWD(ptr, HEAD_SHORT);
        SET_BKD(ptr, &HEAD_SHORT);

        SET_BKD(HEAD_SHORT, ptr);
        HEAD_SHORT = (ull)ptr;
    }
        // link a long bin.
    else if(chunk_size > 0x100){
        if(HEAD_LONG == 0){
            SET_FWD(ptr, 0);
            SET_BKD(ptr, &HEAD_LONG);
            HEAD_LONG = (ull)ptr;
            return 0;
        }
        SET_FWD(ptr, HEAD_LONG);
        SET_BKD(ptr, &HEAD_LONG);

        SET_BKD(HEAD_LONG, ptr);
        HEAD_LONG = (ull)ptr;
    }
    return 0;
}

JNIEXPORT jint JNICALL  Java_com_example_myapplication_MainActivity_debug(JNIEnv *env,jobject thiz) {
    return 0;
}