#include "o.hpp"
#include <jni.h>
#include "v.hpp"
#include "v.cpp"

char *cd(char *str) {
    return str;
}

jstring z(
        const char *o,
        int oss,
        jstring ostr,
        JNIEnv *pEnv) {

    const char *obfuscatingStr = pEnv->GetStringUTFChars(ostr, nullptr);
    char buffer[2 * SHA256::DIGEST_SIZE + 1];

    sha256(obfuscatingStr, buffer);
    const char *obfuscator = buffer;

    char out[oss + 1];
    for (int i = 0; i < oss; i++) {
        out[i] = o[i] ^ obfuscator[i % strlen(obfuscator)];
    }
    out[oss] = 0x0;

    return pEnv->NewStringUTF(cd(out));
}

extern "C"
JNIEXPORT jstring JNICALL
Java_x_y_z_h_s(
        JNIEnv *pEnv,
        jobject pThis,
        jstring packageName) {
    char o[] = { 0x4, 0x5e, 0x3, 0x43, 0x77, 0x32, 0x77, 0x49, 0x56, 0xb, 0x52, 0x45, 0x3, 0x4, 0x56, 0x69, 0x1, 0x0 };
    return z(o, sizeof(o), packageName, pEnv);
}

extern "C"
JNIEXPORT jstring JNICALL
Java_x_y_z_h_ss(
        JNIEnv *pEnv,
        jobject pThis,
        jstring packageName) {
    char a[] = { 0x39, 0x2, 0x3, 0x6f, 0x42, 0x13, 0x5d, 0x5c, 0x51, 0x17, 0x2, 0x55, 0x5f, 0x6, 0x4f };
    return z(a, sizeof(a), packageName, pEnv);
}