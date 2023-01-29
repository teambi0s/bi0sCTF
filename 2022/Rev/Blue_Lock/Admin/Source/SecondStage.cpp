#include <Windows.h>
#include <vector>
#include <iostream>
#include <fstream>
#include "xxtea.h"
#include <random>
#include <set>
#include "md5.h"

unsigned char* buffer;
long file_size;
unsigned char* encrypted;
xxtea_long encrypted_len;
unsigned int exception_flag = 0;

LONG CALLBACK xxtea_implementation(
    PEXCEPTION_POINTERS ExceptionInfo
);

LONG CALLBACK file_encryptor(
    PEXCEPTION_POINTERS ExceptionInfo
);

unsigned char* prepare_key() {
    srand(time(nullptr));
    int r;
    int c = 1;
    while (c) {
        int y = 0;
        int t = rand() % 100 + 1;
        for (int i = 1; i < t; ++i) {
            y += i * i;
        }
        y = y ^ 565656;

        std::string y_str = std::to_string(y);

        const std::string hehe = GetMD5String(y_str);
        if (hehe == "9248eedc03ee8e7a17e075c8d56dc634")
        {
            t = t - 1;
            c = 0;
            r = t;
        }
    }

    std::string fib_string;
    int a = r, b = 45, c1 = 0;
    fib_string += std::to_string(a) + "";
    fib_string += std::to_string(b) + "";

    for (int i = 0; i < 8; i++) {
        c1 = a + b;
        fib_string += std::to_string(c1) + "";
        a = b;
        b = c1;
    }

    unsigned char* key = (unsigned char*)malloc(fib_string.length());
        
    key = reinterpret_cast<unsigned char*>(const_cast<char*>(fib_string.data()));
    return key;
}

void write_file(unsigned char* encrypted_buf, unsigned long encrypted_len) {
    TCHAR current_proc_name[MAX_PATH];
    GetModuleFileName(NULL, current_proc_name, MAX_PATH);
    HANDLE sourceFile = CreateFile(current_proc_name, GENERIC_READ, NULL, NULL, OPEN_ALWAYS, NULL, NULL);
    SIZE_T sourceFileSize = GetFileSize(sourceFile, NULL);
    LPVOID SourceBuffer = HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, sourceFileSize);
    ReadFile(sourceFile, SourceBuffer, sourceFileSize, NULL, NULL);
    unsigned char schar[5];
    unsigned char* ptr = prepare_key();
    for (int i = 0; i <= 5; i++) {
        schar[i] = *ptr++;
    }
    std::mt19937 gen((int)schar);
    set<int> elist;
    int max_size = sourceFileSize > encrypted_len ? sourceFileSize : encrypted_len;
    int total_size = sourceFileSize + encrypted_len;
    int nibbles = ceil(log2(max_size) + 1) / 4;
    int max_no_of_nibble = (nibbles & 1) == 1 ? nibbles + 1 : nibbles;
    int mask = (int)pow(16, max_no_of_nibble) - 1;
    std::uniform_int_distribution<> distr(0, total_size);

    while (elist.size() != encrypted_len) {
        unsigned int r = distr(gen);
        elist.insert(r);
    }

    fstream file;
    ///* Debug Start */
    //file.open("random_list", ios_base::out);
    //set<int>::iterator itr;
    //for (itr = elist.begin(); itr != elist.end(); itr++) {
    //    file << *itr << ", ";
    //}
    //file.close();
    ///* Debug End */

    int sptr = sourceFileSize, eptr = encrypted_len, idx = 0;
    vector<int> final_buf;
    unsigned char* source_buf = (unsigned char*)SourceBuffer;

    final_buf.push_back((int)sourceFileSize);
    final_buf.push_back(encrypted_len);

    while (sptr != 0 && eptr != 0) {
        if (max_size == encrypted_len ? !elist.count(idx++) : elist.count(idx++)) {
            final_buf.push_back(*encrypted_buf++);
            eptr--;
        }
        else {
            final_buf.push_back(*source_buf++);
            sptr--;
        }
    }

    while (sptr-- != 0) {
        final_buf.push_back(*source_buf++);
    }

    while (eptr-- != 0) {
        final_buf.push_back(*encrypted_buf++);
    }

    file.open("enc_file", ios_base::out);
    for (int i = 0; i < final_buf.size(); i++) {
        file << std::hex << final_buf[i] << " ";
    }
    file.close();
}

LONG NTAPI xxtea_implementation(PEXCEPTION_POINTERS ExceptionInfo) {

    if (ExceptionInfo->ExceptionRecord->ExceptionCode == EXCEPTION_ACCESS_VIOLATION && exception_flag == 1) {

        xxtea_long key_len;
        xxtea_long* key_arr = xxtea_to_long_array(prepare_key(), strlen((char*)prepare_key()), 0, &key_len);
        xxtea_long buffer_len;
        xxtea_long* buffer_arr = xxtea_to_long_array(buffer, file_size, 0, &buffer_len);

        xxtea_long_encrypt(buffer_arr, buffer_len, key_arr);
        encrypted = xxtea_to_byte_array(buffer_arr, buffer_len, 0, &encrypted_len);
        exception_flag = 0;

        write_file(encrypted, encrypted_len);

        exit(0);

        ExceptionInfo->ContextRecord->Rip++;
        return EXCEPTION_CONTINUE_EXECUTION;
    }

    return EXCEPTION_CONTINUE_SEARCH;
}


LONG NTAPI file_encryptor(PEXCEPTION_POINTERS ExceptionInfo) {

    if (ExceptionInfo->ExceptionRecord->ExceptionCode == EXCEPTION_INT_DIVIDE_BY_ZERO) {

        FILE* in_file;
        if (fopen_s(&in_file, "flag", "rb") != 0)
        {
            fprintf(stderr, "Error\n");
            exit(EXIT_FAILURE);
        }

        fseek(in_file, 0, SEEK_END);
        file_size = ftell(in_file);
        rewind(in_file);

        buffer = (unsigned char*)malloc(file_size);
        fread(buffer, 1, file_size, in_file);

        fclose(in_file);

        auto res = DeleteFile(L"flag");

        ExceptionInfo->ContextRecord->Rip++;
        return EXCEPTION_CONTINUE_EXECUTION;
    }

    return EXCEPTION_CONTINUE_SEARCH;
}

int main() {

    AddVectoredExceptionHandler(1, file_encryptor);
    AddVectoredExceptionHandler(0, xxtea_implementation);
    
    int except = 5;
    except /= 0;

    exception_flag = 1;
    char* ptr = 0;
    *ptr = 0;

    return 0;
}