#pragma once
//---------------data£º2014/1/17------------------//
//---------------author:syl---------------------//
//---------------email:jxjgssylsg@126.com ,jxjgssylsg@gmail.com ----------//

// This source code is provided 'as-is', without any express or implied
//	warranty. In no event will the author be held liable for any damages
//	arising from the use of this software.
#ifndef XXTEA_H 
#define XXTEA_H 
#include <stddef.h> /* for size_t & NULL declarations */ 
#include <string>
//#include "WinNls.h"
std::string base64_encode(unsigned char const*, unsigned int len);
std::string base64_decode(std::string const& s);
//////////////////////////////////////////////////////////////////////////
std::string string_To_UTF8(const std::string& str);
std::string UTF8_To_string(const std::string& str);
//////////////////////////////////////////////////////////////////////////
#if defined(_MSC_VER) 
typedef unsigned __int32 xxtea_uint;
#else 
#if defined(__FreeBSD__) && __FreeBSD__ < 5 
#include <inttypes.h> 
#else 
#include <stdint.h> 
#endif 
typedef uint32_t xxtea_uint;
#endif 
#define XXTEA_MX (z >> 5 ^ y << 2) + (y >> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z) 
//#define XXTEA_DELTA 0x9E3779B9 
typedef unsigned long xxtea_long;
void xxtea_long_encrypt(xxtea_long* v, xxtea_long len, xxtea_long* k);
//void xxtea_long_decrypt(xxtea_long* v, xxtea_long len, xxtea_long* k);
unsigned char* fix_key_length(unsigned char* key, xxtea_long key_len);
xxtea_long* xxtea_to_long_array(unsigned char* data, xxtea_long len, int include_length, xxtea_long* ret_len);
unsigned char* xxtea_to_byte_array(xxtea_long* data, xxtea_long len, int include_length, xxtea_long* ret_len);
unsigned char* do_xxtea_encrypt(unsigned char* data, xxtea_long len, unsigned char* key, xxtea_long* ret_len);
//unsigned char* do_xxtea_decrypt(unsigned char* data, xxtea_long len, unsigned char* key, xxtea_long* ret_len);
unsigned char* xxtea_encrypt(unsigned char* data, xxtea_long data_len, unsigned char* key, xxtea_long key_len, xxtea_long* ret_length);
//unsigned char* xxtea_decrypt(unsigned char* data, xxtea_long data_len, unsigned char* key, xxtea_long key_len, xxtea_long* ret_length);
//std::string xxtea_encrypt(std::string data, std::string key);
//std::string xxtea_decrypt(std::string data, std::string key);
#endif #pragma once
