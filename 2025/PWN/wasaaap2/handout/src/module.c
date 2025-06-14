#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <emscripten/emscripten.h>

typedef struct msg {
    unsigned int msg_id;
    unsigned int cached;
    char *msg_data;  
    size_t msg_data_len;      
    int msg_time;
    int msg_status;
    int is_text;
} msg;

typedef struct stuff {
    char array[6];
    msg *mess;
    int size;
    int capacity;
} stuff;

typedef struct cached_msg {
    char *data;
    msg *msg;
    int msg_id;
} cached_msg;

typedef struct cachetable {
  unsigned int bitmap;
  char tblid[4];
  cached_msg *msgs[0x20];
  int sizes [0x20];
} cachetable;

#define TABLE_FULL       -1
#define INVALID_ENTRY    -2
#define INITIAL_CAPACITY 10
#define MAX_MSG_LEN      0x100
#define RANDOM_BIG_PRIME 0xd6867f07
#define CACHE_TABLE_SIZE 15
#define NBITS            0x7fff

stuff s;
cachetable *tbl = NULL;

EM_JS(int, jsSanitize, (char *input_ptr, char *output_ptr), {

    var inputStr = UTF8ToString(input_ptr);
    var sanitizedStr = DOMPurify.sanitize(inputStr);
    var encodedStr = new TextEncoder().encode(sanitizedStr);
    Module.HEAPU8.set(encodedStr, output_ptr);
    return encodedStr.length;

});

void init_stuff(stuff *s) {

    s->size = 0;
    s->capacity = INITIAL_CAPACITY;
    memcpy(s->array,"stuff?",6);
    s->mess = (msg *)malloc(s->capacity * sizeof(msg));
    if (s->mess == NULL) {
        exit(1);
    }
}

// Initialize the cache table 
void initCacheTable() {
    tbl = calloc(1,sizeof(cachetable));
    memcpy(tbl->tblid,"TBL\0",4);
    tbl->bitmap = 0;
}

char *sanitize(char *data, size_t len, size_t *out_len) {
    char *safe = malloc(len * 6);
    size_t safe_len = 0;
    
    for (size_t i = 0; i < len; i++) {
        switch (data[i]) {
            case '<':
                memcpy(safe + safe_len, "&lt;", 4);
                safe_len += 4;
                break;
            case '>':
                memcpy(safe + safe_len, "&gt;", 4);
                safe_len += 4;
                break;
            case '%':
                memcpy(safe + safe_len, "&#37;",5);
                safe_len += 5;
                break;
            case '&':
                memcpy(safe + safe_len, "&amp;", 5);
                safe_len += 5;
                break;
            case '"':
                memcpy(safe + safe_len, "&quot;", 6);
                safe_len += 6;
                break;
            case '\'':
                memcpy(safe + safe_len, "&#x27;", 6);
                safe_len += 6;
                break;
            default: /* No point in having unprintable characters */
                if(data[i] >= 32 && data[i] <= 127)
                    safe[safe_len++] = data[i];
                break;
        }
    }
    
    *out_len = safe_len;
    return safe;
}

char *toSafeHTML(char *content, size_t content_len) {
    size_t html_len = content_len + 100;
    char *safeHTML = malloc(html_len);
    
    snprintf((char *)safeHTML, html_len, "<div>%.*s</div>", (int)content_len, content);
    
    return safeHTML;
}


char *sanitizeWithJs(const char* input, int input_len, size_t *safe_content_len) {

    char* input_buffer = (char*)malloc(input_len + 1);
    char* output_buffer = (char*)malloc(input_len*3); 
    if (!input_buffer || !output_buffer) {
        free(input_buffer);
        free(output_buffer);
        exit(1);
    }


    strncpy(input_buffer, input, input_len);
    input_buffer[input_len] = '\0';


    int safe_len = jsSanitize(input_buffer, output_buffer);
    *safe_content_len = safe_len;

    char* safe = malloc(*safe_content_len + 1);
    if (safe_len >= 0 ) {
        strncpy(safe, output_buffer, safe_len);
        safe[safe_len] = '\0';
    }else {
        safe[0] = '\0'; 
    }


    free(input_buffer);
    free(output_buffer);

    return safe;
}

int msg_id = 0;

/* Not perfect but should be good enough */
int hash(int msg_id)
{
    return (((long)(pow(2, msg_id)) + 
                (long)(pow(3,msg_id % 10))) % RANDOM_BIG_PRIME);
}


int getIdx(int msg_id)
{
    return (hash(msg_id) % CACHE_TABLE_SIZE);
}

// Return the possible index, else return -1;
int getTblIdx(cachetable* table,msg *_msg) {

    int idx = getIdx(_msg->msg_id);
    int count = 0;
    int bit = 1 << idx;

    if((table->bitmap & bit)) {

        /* Update cache with later node if its greater than a minute */
        // table->msgs[idx]->msg->cached = 0;
        if ((table->msgs[idx]->msg->msg_time - _msg->msg_time) > 60) {
            table->msgs[idx]->msg->cached = 0;
            table->bitmap = table->bitmap & ((~(bit)) & 0xffff);
        }
        
        while((table->bitmap & bit)) {
            idx = ( idx + 1 ) % CACHE_TABLE_SIZE;
            bit = ((bit << 1) | (bit >> 14)) & NBITS;
            count++;
            if (count > CACHE_TABLE_SIZE)
                return TABLE_FULL;
        } 
    } 
    

    table->bitmap |= bit;
    return idx;

}

int tryPutMsgCache(cachetable *table,msg *msg) {
    int idx = getTblIdx(table, msg);
    if (idx != TABLE_FULL) {
        size_t out;
        cached_msg *cmsg = malloc(sizeof(cmsg));
        cmsg->data = sanitize(msg->msg_data,msg->msg_data_len,&out);
        cmsg->msg_id = msg->msg_id;
        cmsg->msg = msg;
        table->msgs[idx] = cmsg;
        table->sizes[idx] = out;
        return 1;
    } return 0;
}

int tryUpdateMsgCache(cachetable *table,msg *msg,int idx) {

    size_t out;
    cached_msg *cmsg = table->msgs[idx];
    char *dat = sanitize(msg->msg_data,msg->msg_data_len,&out);
    if (out <= table->sizes[idx]) {
        memcpy(cmsg->data,dat,out);
        free(dat);
        if (out < table->sizes[idx])
            cmsg->data[out] = 0;
    } else {
        cmsg->msg = msg;
        table->sizes[idx] = out;
        free(cmsg->data);
        cmsg->data = dat;
        return 0;
    }

    table->msgs[idx] = cmsg;
    return 0;
}

// called to invalidate in delete and to edit
int getFromCacheTable (cachetable *table,int msg_id) { 

    int idx = getIdx(msg_id);
    int count = 0;
    int bit = 1 << idx;
    cached_msg **allmsg = table->msgs;

    while(true)  {

        if ((allmsg[idx])->msg_id == msg_id) {
            return idx;
        }

        idx = ( idx + 1 ) % CACHE_TABLE_SIZE;
        bit = ((bit << 1) | (bit >> 14)) & NBITS;
        count++;
        if (count > CACHE_TABLE_SIZE)
            break;
    }
    

    return INVALID_ENTRY;

}


void findnInvalidate (cachetable *table,int msg_id) {

    int idx = getFromCacheTable(table,msg_id);
    if (idx != INVALID_ENTRY) {
        table->msgs[idx]->msg->cached = 0;
        table->bitmap = (table->bitmap & ~(1 << idx)) & 0xffff;
    } 

}

int add_msg_to_stuff(stuff *s, msg new_msg) {
    if (s->size >= s->capacity) {
        s->capacity *= 2;
        s->mess = (msg *)realloc(s->mess, s->capacity * sizeof(msg));
        if (s->mess == NULL) {
            exit(1);
        }
    }
    s->mess[s->size++] = new_msg;
    return s->size - 1;
}

void free_stuff(stuff *s) {
    for (int i = 0; i < s->size; i++) {
        free(s->mess[i].msg_data);
    }
    free(s->mess);
}

EMSCRIPTEN_KEEPALIVE
void initialize() { 
    init_stuff(&s);
    initCacheTable();
}

/* Use the cache when displaying the things */
EMSCRIPTEN_KEEPALIVE
void populateMsgHTML(int (*callback)(char *, int, int, int)) {
    int i = 0;
    for (i = 0; i < s.size; i++) {
        size_t safe_content_len;
        char * safe_content;
        // We have better chances checking the hash table than 
        // wasting resource parsing string again
        if(!(s.mess[i].is_text)) {
            safe_content = sanitizeWithJs(s.mess[i].msg_data, s.mess[i].msg_data_len, &safe_content_len);
            char *safeHTML = toSafeHTML(safe_content, safe_content_len);
            callback(safeHTML, s.mess[i].msg_status, s.mess[i].msg_time, i);
            free(safe_content);
            free(safeHTML);
            continue;
        }

        else if (s.mess[i].cached) {
            int idx = getFromCacheTable(tbl,s.mess[i].msg_id);
            if (idx < 0) 
                goto try_failsafe; 

            safe_content = tbl->msgs[idx]->data;
            safe_content_len = tbl->sizes[idx];
            char *safeHTML = toSafeHTML(safe_content, safe_content_len);
            callback(safeHTML, s.mess[i].msg_status, s.mess[i].msg_time, i);
            free(safeHTML);
            continue;
        } 

    try_failsafe:
        safe_content = sanitize(s.mess[i].msg_data, s.mess[i].msg_data_len, &safe_content_len);
        char *safeHTML = toSafeHTML(safe_content, safe_content_len);
        callback(safeHTML, s.mess[i].msg_status, s.mess[i].msg_time, i);
        free(safeHTML);
        free(safe_content); 
    }
}

EMSCRIPTEN_KEEPALIVE
void renderHtml(int idx, int (*callback)(char *, int, int, int)) {
    size_t safe_content_len;
    char *safe_content = sanitizeWithJs(s.mess[idx].msg_data, s.mess[idx].msg_data_len, &safe_content_len);
    s.mess[idx].is_text = 0;
    char *safeHTML = toSafeHTML(safe_content, safe_content_len);
    callback(safeHTML, s.mess[idx].msg_status, s.mess[idx].msg_time, idx);
    free(safeHTML);
    free(safe_content);

}

EMSCRIPTEN_KEEPALIVE
void renderText(int idx, int (*callback)(char *, int, int, int)) {
    size_t safe_content_len;
    char *safe_content = sanitize(s.mess[idx].msg_data, s.mess[idx].msg_data_len, &safe_content_len);
    s.mess[idx].is_text = 1;
    char *safeHTML = toSafeHTML(safe_content, safe_content_len);
    callback(safeHTML, s.mess[idx].msg_status, s.mess[idx].msg_time, idx);
    free(safe_content);
    free(safeHTML);
}

EMSCRIPTEN_KEEPALIVE
int addMsg(char *content, size_t content_len, int time, int status) {
    
    if (content_len > 150) {
        return -1;
    }

    char *msgg = malloc(content_len + 1);
    memset(msgg, '\0', content_len + 1);
    strncpy(msgg, content, content_len);

    msg new_msg;
    new_msg.msg_data = msgg;
    new_msg.msg_data_len = content_len;
    new_msg.msg_time = time;
    new_msg.msg_status = status;
    new_msg.msg_id = msg_id++;
    new_msg.cached = 0;
    new_msg.is_text = 1;

    int idx = add_msg_to_stuff(&s, new_msg);
    if (tryPutMsgCache(tbl,&s.mess[idx])) {
        s.mess[idx].cached = 1;
    }

    return idx;

}

/* TODO update the cache */
EMSCRIPTEN_KEEPALIVE
int editMsg(int idx, char *newContent, size_t newContent_len, int newTime) {
    if (idx < 0 || idx >= s.size) {
        return -1;
    }

    if (newContent_len > MAX_MSG_LEN) {
        return -1;
    }

    char *_msg = malloc(newContent_len + 1);
    memset(_msg, '\0', newContent_len + 1);
    strncpy(_msg, newContent, newContent_len);

    free(s.mess[idx].msg_data);

    s.mess[idx].msg_data = _msg;
    s.mess[idx].msg_data_len = newContent_len;
    s.mess[idx].msg_time = newTime;
    s.mess[idx].msg_status = 1;
    
    if (s.mess[idx].cached) {
        int hidx = getFromCacheTable(tbl,s.mess[idx].msg_id);
        if (hidx != INVALID_ENTRY) {
            tryUpdateMsgCache(tbl,&s.mess[idx],hidx);
        } 
    }

    return 0;
}

EMSCRIPTEN_KEEPALIVE
int deleteMsg(int idx, void (*callback)(int)) {

    if (idx < 0 || idx >= s.size) {
        return -1;
    }

    if (s.mess[idx].cached) {
        findnInvalidate(tbl,s.mess[idx].msg_id);
    } free(s.mess[idx].msg_data);

    for (int i = idx; i < s.size - 1; i++) {
        s.mess[i] = s.mess[i + 1];
    }
    
    s.size--;
    callback(idx);
    return 0;
}