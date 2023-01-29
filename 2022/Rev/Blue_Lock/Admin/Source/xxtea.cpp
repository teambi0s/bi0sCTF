#include "xxtea.h"
#include <cstdlib>
#include <time.h>

#define MASK 0xffff

uint32_t hash(uint32_t x, uint32_t c) {
    x = ((x >> 16) ^ x) * c;
    x = ((x >> 16) ^ x) * c;
    x = (x >> 16) ^ x;
    return x;
}

uint32_t get_delta() {
    srand(time(0));
    int res1;
    int const1;
    while (1)
    {
        int r1 = rand();
        int r2 = rand();
        res1 = (r1 ^ r2) & 0xffff;
        int x = (r1 + r2) & 0xffff;
        int y = (r1 | r2) & 0xffff;
        if ((res1 == 7345) && (x ^ 49613 == 8456) && (y == 32443))
        {
            res1 = res1 << 16;
            res1 ^= 2784723275;
            const1 = (x * 1273) - 5218;
            break;

        }
    }
    uint32_t target_constant = 0;

    for (uint32_t i = 0; i <= 0xffffffff; i++) {
        if (hash(i, const1) == res1) {
            target_constant = i;
            break;
        }
    }

    return target_constant;
}

void xxtea_long_encrypt(xxtea_long* v, xxtea_long len, xxtea_long* k)
{
    xxtea_long n = len - 1;
    xxtea_long z = v[n], y = v[0], p, q = 6 + 52 / (n + 1), sum = 0, e;
    if (n < 1) {
        return;
    }
    while (0 < q--) {
        sum += get_delta();
        e = sum >> 2 & 3;
        for (p = 0; p < n; p++) {
            y = v[p + 1];
            z = v[p] += XXTEA_MX;
        }
        y = v[0];
        z = v[n] += XXTEA_MX;
    }
}

//void xxtea_long_decrypt(xxtea_long* v, xxtea_long len, xxtea_long* k)
//{
//    xxtea_long n = len - 1;
//    xxtea_long z = v[n], y = v[0], p, q = 6 + 52 / (n + 1), sum = q * get_delta(), e;
//    if (n < 1) {
//        return;
//    }
//    while (sum != 0) {
//        e = sum >> 2 & 3;
//        for (p = n; p > 0; p--) {
//            z = v[p - 1];
//            y = v[p] -= XXTEA_MX;
//        }
//        z = v[n];
//        y = v[0] -= XXTEA_MX;
//        sum -= get_delta();
//    }
//}

unsigned char* fix_key_length(unsigned char* key, xxtea_long key_len)
{
    unsigned char* tmp = (unsigned char*)malloc(16);
    memcpy(tmp, key, key_len);
    memset(tmp + key_len, '\0', 16 - key_len);
    return tmp;
}

xxtea_long* xxtea_to_long_array(unsigned char* data, xxtea_long len, int include_length, xxtea_long* ret_len) {
    xxtea_long i, n, * result;

    n = len >> 2;
    n = (((len & 3) == 0) ? n : n + 1);
    if (include_length) {
        result = (xxtea_long*)malloc((n + 1) << 2);
        result[n] = len;
        *ret_len = n + 1;
    }
    else {
        result = (xxtea_long*)malloc(n << 2);
        *ret_len = n;
    }
    memset(result, 0, n << 2);
    for (i = 0; i < len; i++) {
        result[i >> 2] |= (xxtea_long)data[i] << ((i & 3) << 3);
    }

    return result;
}

unsigned char* xxtea_to_byte_array(xxtea_long* data, xxtea_long len, int include_length, xxtea_long* ret_len) {
    xxtea_long i, n, m;
    unsigned char* result;

    n = len << 2;
    if (include_length) {
        m = data[len - 1];
        if ((m < n - 7) || (m > n - 4)) return NULL;
        n = m;
    }
    result = (unsigned char*)malloc(n + 1);
    for (i = 0; i < n; i++) {
        result[i] = (unsigned char)((data[i >> 2] >> ((i & 3) << 3)) & 0xff);
    }
    result[n] = '\0';
    *ret_len = n;

    return result;
}

unsigned char* do_xxtea_encrypt(unsigned char* data, xxtea_long len, unsigned char* key, xxtea_long* ret_len) {
    unsigned char* result;
    xxtea_long* v, * k, v_len, k_len;

    v = xxtea_to_long_array(data, len, 1, &v_len);
    k = xxtea_to_long_array(key, 16, 0, &k_len);
    xxtea_long_encrypt(v, v_len, k);
    result = xxtea_to_byte_array(v, v_len, 0, ret_len);
    free(v);
    free(k);

    return result;
}

//unsigned char* do_xxtea_decrypt(unsigned char* data, xxtea_long len, unsigned char* key, xxtea_long* ret_len) {
//    unsigned char* result;
//    xxtea_long* v, * k, v_len, k_len;
//
//    v = xxtea_to_long_array(data, len, 0, &v_len);
//    k = xxtea_to_long_array(key, 16, 0, &k_len);
//    xxtea_long_decrypt(v, v_len, k);
//    result = xxtea_to_byte_array(v, v_len, 1, ret_len);
//    free(v);
//    free(k);
//
//    return result;
//}

unsigned char* xxtea_encrypt(unsigned char* data, xxtea_long data_len, unsigned char* key, xxtea_long key_len, xxtea_long* ret_length)
{
    unsigned char* result;

    *ret_length = 0;

    if (key_len < 16) {
        unsigned char* key2 = fix_key_length(key, key_len);
        result = do_xxtea_encrypt(data, data_len, key2, ret_length);
        free(key2);
    }
    else
    {
        result = do_xxtea_encrypt(data, data_len, key, ret_length);
    }

    return result;
}

//unsigned char* xxtea_decrypt(unsigned char* data, xxtea_long data_len, unsigned char* key, xxtea_long key_len, xxtea_long* ret_length)
//{
//    unsigned char* result;
//
//    *ret_length = 0;
//
//    if (key_len < 16) {
//        unsigned char* key2 = fix_key_length(key, key_len);
//        result = do_xxtea_decrypt(data, data_len, key2, ret_length);
//        free(key2);
//    }
//    else
//    {
//        result = do_xxtea_decrypt(data, data_len, key, ret_length);
//    }
//
//    return result;
//}