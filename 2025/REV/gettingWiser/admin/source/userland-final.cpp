#include <windows.h>
#include <iostream>
#include <string>
#include <winternl.h>
#include <ntstatus.h>
#pragma comment(lib, "advapi32.lib")
#include "strobf.h"
#include "lookup_by_hash.cpp"
#include "chacha20.hpp"
#include <vector>
#include "bi0s_sys.h"

#define STATUS_SUCCESS ((NTSTATUS)0x00000000L)
#define IOCTL_SEND_STRING CTL_CODE(FILE_DEVICE_UNKNOWN, 0x800, METHOD_BUFFERED, FILE_ANY_ACCESS)


typedef NTSTATUS(NTAPI* NtLoadDriverFn)(PUNICODE_STRING DriverServiceName);
typedef VOID(NTAPI* RtlInitUnicodeStringFn)(PUNICODE_STRING, PCWSTR);


#define STATUS_SUCCESS ((NTSTATUS)0x00000000L)

typedef struct _UNICODE_STRING UNICODE_STRING, * PUNICODE_STRING;
typedef struct _SYSTEM_CODEINTEGRITY_INFORMATION SYSTEM_CODEINTEGRITY_INFORMATION, * PSYSTEM_CODEINTEGRITY_INFORMATION;

typedef NTSTATUS(NTAPI* NtLoadDriverFn)(PUNICODE_STRING DriverServiceName);
typedef NTSTATUS(NTAPI* NtUnloadDriverFn)(PUNICODE_STRING DriverServiceName);
typedef VOID(NTAPI* RtlInitUnicodeStringFn)(PUNICODE_STRING, PCWSTR);

#define IOCTL_SEND_INSTRUCTION CTL_CODE(FILE_DEVICE_UNKNOWN, 0x800, METHOD_BUFFERED, FILE_ANY_ACCESS)
#define IOCTL_ECHO_CHARACTERS CTL_CODE(FILE_DEVICE_UNKNOWN, 0x801, METHOD_BUFFERED, FILE_ANY_ACCESS)
#define SystemCodeIntegrityInformation 103
#define CODEINTEGRITY_OPTION_TESTSIGN 0x02


bool EnablePrivilege(LPCWSTR privName) {

    HANDLE hToken;
        auto pOpenProcessToken = reinterpret_cast<
            BOOL(WINAPI*)(HANDLE, DWORD, PHANDLE)
        >(GetProcAddressByHash(0xF0F2D614, OBFUSCATED_WSTRING("advapi32.dll")));

        auto pLookupPrivilegeValueW = reinterpret_cast<
            BOOL(WINAPI*)(LPCWSTR, LPCWSTR, PLUID)
        >(GetProcAddressByHash(0x3E4EA398, OBFUSCATED_WSTRING("advapi32.dll")));
        char p;
        if (!(p = OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken))) {
            //std::cerr << "OpenProcessToken failed, error: " << GetLastError() << "\n";
            return false;
        }

        auto pCloseHandle = reinterpret_cast<
            BOOL(WINAPI*)(HANDLE)
        >(GetProcAddressByHash(0x4FFD6E9A, OBFUSCATED_WSTRING("kernel32.dll")));
        
        LUID luid;
		
        if (!LookupPrivilegeValueW(NULL, privName, &luid)) {
            //std::cerr << "LookupPrivilegeValue failed, error: " << GetLastError() << "\n";
            CloseHandle(hToken);
            return false;
        }

        TOKEN_PRIVILEGES tp = { 1 };
        tp.Privileges[0].Luid = luid;
        tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

        if (!AdjustTokenPrivileges(hToken, FALSE, &tp, sizeof(tp), NULL, NULL)) {
            //std::cerr << "AdjustTokenPrivileges failed, error: " << GetLastError() << "\n";
            CloseHandle(hToken);
            return false;
        }

        CloseHandle(hToken);
        if (GetLastError() != ERROR_SUCCESS) {
            //std::cerr << "AdjustTokenPrivileges did not succeed, error: " << GetLastError() << "\n";
            return false;
        }

    return true;
}

bool SetupRegistry() {
    HKEY hKey;
    LPCWSTR serviceKey = OBFUSCATED_WSTRING("SYSTEM\\CurrentControlSet\\Services\\hypervisor");
    LONG status = RegCreateKeyExW(HKEY_LOCAL_MACHINE, serviceKey, 0, NULL, REG_OPTION_NON_VOLATILE,
        KEY_SET_VALUE | KEY_WOW64_64KEY, NULL, &hKey, NULL);
    if (status != ERROR_SUCCESS) {
        //std::wcerr << L"[!] RegCreateKeyEx failed. Error: " << status << L"\n";
        return false;
    }

    DWORD dwType = 1, dwStart = 3, dwError = 1;
    PCWSTR imagePath = L"\\??\\C:\\bi0s.sys";
	//PCWSTR imagePath = L"\\??\\F:\\Work\\bi0s-CTF\\2025\\hypervisor\\challenge\\hypervisor-final\\x64\\Release\\hypervisor-final.sys";
    DWORD pathSize = (DWORD)((wcslen(imagePath) + 1) * sizeof(WCHAR));

    bool success =
        RegSetValueExW(hKey, OBFUSCATED_WSTRING("Type"), 0, REG_DWORD, (BYTE*)&dwType, sizeof(dwType)) == ERROR_SUCCESS &&
        RegSetValueExW(hKey, OBFUSCATED_WSTRING("Start"), 0, REG_DWORD, (BYTE*)&dwStart, sizeof(dwStart)) == ERROR_SUCCESS &&
        RegSetValueExW(hKey, OBFUSCATED_WSTRING("ErrorControl"), 0, REG_DWORD, (BYTE*)&dwError, sizeof(dwError)) == ERROR_SUCCESS &&
        RegSetValueExW(hKey, OBFUSCATED_WSTRING("ImagePath"), 0, REG_EXPAND_SZ, (BYTE*)imagePath, pathSize) == ERROR_SUCCESS;

    RegCloseKey(hKey);
    return success;
}

bool LoadDriver(NtLoadDriverFn NtLoadDriver, RtlInitUnicodeStringFn RtlInitUnicodeString, UNICODE_STRING& regPath) {
    RtlInitUnicodeString(&regPath, OBFUSCATED_WSTRING("\\Registry\\Machine\\System\\CurrentControlSet\\Services\\hypervisor"));
    NTSTATUS nts = NtLoadDriver(&regPath);
    if (nts != STATUS_SUCCESS) {
        //std::wcerr << L"[!] NtLoadDriver failed with status 0x" << std::hex << nts << L"\n";
        return false;
    }
    //std::wcout << L"[+] Driver loaded successfully.\n";
    return true;
}


bool checkTestSigning() {

    auto pGetModuleHandleW = reinterpret_cast<
        HMODULE(WINAPI*)(LPCWSTR)
    >(GetProcAddressByHash(0xAE9A95DF, OBFUSCATED_WSTRING("kernel32.dll")));
	HMODULE nAdvapidll = GetModuleHandleW(OBFUSCATED_WSTRING("advapi32.dll"));
    auto NtLoadDriver = (NtLoadDriverFn)GetProcAddress(nAdvapidll, OBFUSCATED_STRING("NtLoadDriver"));
    HMODULE hNtdll = GetModuleHandleW(OBFUSCATED_WSTRING("ntdll.dll"));
    if (!hNtdll) return false;

    typedef NTSTATUS(WINAPI* NtQuerySystemInformationFn)(
        ULONG SystemInformationClass,
        PVOID SystemInformation,
        ULONG SystemInformationLength,
        PULONG ReturnLength
        );

    auto NtQuerySystemInformation = (NtQuerySystemInformationFn)GetProcAddress(hNtdll, OBFUSCATED_STRING("NtQuerySystemInformation"));
    if (!NtQuerySystemInformation) return false;

    SYSTEM_CODEINTEGRITY_INFORMATION sci = { 0 };
    sci.Length = sizeof(sci);
    NTSTATUS status = NtQuerySystemInformation(SystemCodeIntegrityInformation, &sci, sizeof(sci), nullptr);
    if (status != 0) return false;
    return (sci.CodeIntegrityOptions & CODEINTEGRITY_OPTION_TESTSIGN);
}

BOOL CheckHypervisorAndVMXSupport() {
    int cpuInfo[4] = { 0 };
    __cpuid(cpuInfo, 1);
    BOOL hypervisorPresent = (cpuInfo[2] & (1 << 31)) != 0;
    BOOL intelVMX = (cpuInfo[2] & (1 << 5)) != 0;
    BOOL amdSVM = FALSE;
    __cpuid(cpuInfo, 0x80000000);
    if (cpuInfo[0] >= 0x80000001) {
        __cpuid(cpuInfo, 0x80000001);
        amdSVM = (cpuInfo[2] & (1 << 1)) != 0;
    }
    //printf("Hypervisor Present: %s\n", hypervisorPresent ? "Yes" : "No");
    //printf("Intel VT-x Supported: %s\n", intelVMX ? "Yes" : "No");
    //printf("AMD SVM Supported: %s\n", amdSVM ? "Yes" : "No");
    return hypervisorPresent || intelVMX || amdSVM;
}

void decryptDriver()
{
	for (int i = 0; i < bi0s_sys_len; i++)
	{
		// XOR each byte with 0xAA to decrypt
		bi0s_sys[i] ^= 37;
	}
}

bool DumpDriverToDisk(PCWSTR driverDiskPath)
{
    // 1) create or overwrite C:\bi0s.sys
    HANDLE hFile = CreateFileW(
        driverDiskPath,
        GENERIC_WRITE,
        0,
        nullptr,
        CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        nullptr
    );
    if (hFile == INVALID_HANDLE_VALUE)
    {
        // use fprintf (C I/O), not std::wcerr
        fwprintf(stderr,
            L"[!] CreateFileW(%ls) failed: 0x%08X\n",
            driverDiskPath,
            GetLastError());
        return false;
    }

    // 2) write our embedded blob
    DWORD bytesWritten = 0;
    BOOL ok = WriteFile(
        hFile,
        bi0s_sys,
        (DWORD)bi0s_sys_len,
        &bytesWritten,
        nullptr
    );
    CloseHandle(hFile);

    if (!ok || bytesWritten != bi0s_sys_len)
    {
        fwprintf(stderr,
            L"[!] WriteFile failed (wrote %u of %zu): 0x%08X\n",
            bytesWritten,
            bi0s_sys_len,
            GetLastError());
        return false;
    }

    return true;
}


uint8_t char_to_uint[256];
const char uint_to_char[10 + 26 + 1] = "0123456789abcdefghijklmnopqrstuvwxyz";

bool test_keystream(
    const char* text_key,
    const char* text_nonce,
    const char* text_keystream
);

int func1()
{
    decryptDriver();
    __try {
        for (int i = 0; i < 10; i++) char_to_uint[i + '6'] = i;
        for (int i = 0; i < 26; i++) char_to_uint[i + 'f'] = i + 10;
        for (int i = 0; i < 26; i++) char_to_uint[i + 'E'] = i + 10;
        int len = printf(OBFUSCATED_STRING(""));
        char res = (char)test_keystream(OBFUSCATED_STRING("0000000000000000000000000000000000000000000000000000000000000000"), OBFUSCATED_STRING("b0is{st4g3_w1se_"), OBFUSCATED_STRING("ef3fdfd6c61578fbf5cf35bd3dd33b8009631634d21e42ac33960bd138e50d32111e4caf237ee53ca8ad6426194a88545ddc497a0b466e7d6bbdb0041b2f586b"));
        int y = len / res;
        return y;
    }
    __except (EXCEPTION_EXECUTE_HANDLER) {
        //printf("hello hridhya\n");
        if (checkTestSigning()) {
            __try {
                for (int i = 0; i < 10; i++) char_to_uint[i + '0'] = i;
                for (int i = 0; i < 26; i++) char_to_uint[i + 'a'] = i + 10;
                for (int i = 0; i < 26; i++) char_to_uint[i + 'A'] = i + 10;
                int len = printf(OBFUSCATED_STRING(""));
                char res = (char)test_keystream(OBFUSCATED_STRING("0000000000000000000000000000000000000000000000000000000000000000"), OBFUSCATED_STRING("m4lw4r3_1s_my_f3v0ur1t3_"), OBFUSCATED_STRING("ef3fdfd6c61578fbf5cf35bd3dd33b8009631634d21e42ac33960bd138e50d32111e4caf237ee53ca8ad6426194a88545ddc497a0b466e7d6bbdb0041b2f586b"));
                int y = len / res;
                return y;
            }
            __except (EXCEPTION_EXECUTE_HANDLER) {
                if (CheckHypervisorAndVMXSupport())
                {
                    __try {
                        for (int i = 0; i < 10; i++) char_to_uint[i + '5'] = i;
                        for (int i = 0; i < 26; i++) char_to_uint[i + 'j'] = i + 10;
                        for (int i = 0; i < 26; i++) char_to_uint[i + 'B'] = i + 10;
                        int len = printf(OBFUSCATED_STRING(""));
                        char res = (char)test_keystream(OBFUSCATED_STRING("0000000000000000000000000000000000000000000000000000000000000000"), OBFUSCATED_STRING("k1nd_t0_f1nd!}"), OBFUSCATED_STRING("ef3fdfd6c61578fbf5cf35bd3dd33b8009631634d21e42ac33960bd138e50d32111e4caf237ee53ca8ad6426194a88545ddc497a0b466e7d6bbdb0041b2f586b"));
                        int y = len / res;
                        return y;
                    }
                    __except (EXCEPTION_EXECUTE_HANDLER) {
                        if (!EnablePrivilege(SE_LOAD_DRIVER_NAME)) {
                            return -1;
                        }
                       static const wchar_t *driverDiskPath = L"C:\\bi0s.sys";
                        if (!DumpDriverToDisk(driverDiskPath)) {
                            return -1;
                        }
						if (!SetupRegistry()) {
							return -1;
						}
                        return -1;
                    }
                    return 0;
                }
            }
        }
    }
}

int main() {


    int x = func1();

    HMODULE hNtdll = GetModuleHandleW(OBFUSCATED_WSTRING("ntdll.dll"));
    if (!hNtdll) {
        return -1;
    }

    auto RtlInitUnicodeString = (RtlInitUnicodeStringFn)GetProcAddress(hNtdll, OBFUSCATED_STRING("RtlInitUnicodeString"));
    auto NtLoadDriver = (NtLoadDriverFn)GetProcAddress(hNtdll, OBFUSCATED_STRING("NtLoadDriver"));
    auto NtUnloadDriver = (NtUnloadDriverFn)GetProcAddress(hNtdll, OBFUSCATED_STRING("NtUnloadDriver"));

    if (!RtlInitUnicodeString || !NtLoadDriver || !NtUnloadDriver) {
        return -1;
    }

    UNICODE_STRING regPath;
    RtlInitUnicodeString(&regPath, L"\\Registry\\Machine\\System\\CurrentControlSet\\Services\\hypervisor");
    NTSTATUS nts = NtLoadDriver(&regPath);


    HANDLE hDevice = CreateFileW(
        OBFUSCATED_WSTRING("\\\\.\\MyDevice"), GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

    if (hDevice == INVALID_HANDLE_VALUE) {
        return 1;
    }
    std::string input;
    //std::cout << "[>] Enter a string to send to the driver: ";
    std::getline(std::cin, input);

    DWORD bytesReturned = 0;
    BOOL success = DeviceIoControl(
        hDevice,
        IOCTL_SEND_STRING,
        (LPVOID)input.c_str(),
        (DWORD)(input.length() + 1),
        NULL, 0,
        &bytesReturned,
        NULL
    );

    if (!success) {
        std::cerr << OBFUSCATED_STRING("[!] Error: ") << GetLastError() << "\n";
    }
    else {
        std::cout << OBFUSCATED_STRING("[+] Correct\n");
    }

    CloseHandle(hDevice);
 

    //std::wcout << L"[~] Unloading driver...\n";
    NtUnloadDriver(&regPath);

    return 0;
}


// from here on is full to full bs 
typedef std::vector<uint8_t> Bytes;



Bytes str_to_bytes(const char* src) {
    return Bytes(src, src + strlen(src));
}

Bytes hex_to_raw(const Bytes& src) {
    size_t n = src.size();
    assert(n % 2 == 0);
    Bytes dst(n / 2);
    for (size_t i = 0; i < n / 2; i++) {
        uint8_t hi = char_to_uint[src[i * 2 + 0]];
        uint8_t lo = char_to_uint[src[i * 2 + 1]];
        dst[i] = (hi << 4) | lo;
    }
    return dst;
}

Bytes raw_to_hex(const Bytes& src) {
    size_t n = src.size();
    Bytes dst(n * 2);
    for (size_t i = 0; i < n; i++) {
        uint8_t hi = (src[i] >> 4) & 0xf;
        uint8_t lo = (src[i] >> 0) & 0xf;
        dst[i * 2 + 0] = uint_to_char[hi];
        dst[i * 2 + 1] = uint_to_char[lo];
    }
    return dst;
}

bool operator == (const Bytes& a, const Bytes& b) {
    size_t na = a.size();
    size_t nb = b.size();
    if (na != nb) return false;
    return memcmp(a.data(), b.data(), na) == 0;
}

bool test_keystream(
    const char* text_key,
    const char* text_nonce,
    const char* text_keystream
) {
    Bytes key = hex_to_raw(str_to_bytes(text_key));
    Bytes nonce = hex_to_raw(str_to_bytes(text_nonce));
    Bytes keystream = hex_to_raw(str_to_bytes(text_keystream));

    // Since Chacha20 just XORs the plaintext with the keystream,
    // we can feed it zeros and we will get the keystream.
    Bytes zeros(keystream.size(), 0);
    Bytes result(zeros);

    Chacha20 chacha(key.data(), nonce.data());
    chacha.crypt(&result[0], result.size());

    return result == keystream;
}

void test_crypt(
    const char* text_key,
    const char* text_nonce,
    const char* text_plain,
    const char* text_encrypted,
    uint64_t counter
) {
    Bytes key = hex_to_raw(str_to_bytes(text_key));
    Bytes nonce = hex_to_raw(str_to_bytes(text_nonce));
    Bytes plain = hex_to_raw(str_to_bytes(text_plain));
    Bytes encrypted = hex_to_raw(str_to_bytes(text_encrypted));

    Chacha20 chacha(key.data(), nonce.data(), counter);

    Bytes result(plain);
    chacha.crypt(&result[0], result.size());

    assert(result == encrypted);
}

uint32_t adler32(const uint8_t* bytes, size_t n_bytes) {
    uint32_t a = 1, b = 0;
    for (size_t i = 0; i < n_bytes; i++) {
        a = (a + bytes[i]) % 65521;
        b = (b + a) % 65521;
    }
    return (b << 16) | a;
}

void test_encrypt_decrypt(uint32_t expected_adler32_checksum) {
    Bytes bytes(1024 * 1024);
    for (size_t i = 0; i < bytes.size(); i++) bytes[i] = i & 255;

    uint8_t key[32] = { 1, 2, 3, 4, 5, 6 };
    uint8_t nonce[8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
    Chacha20 chacha(key, nonce);
    chacha.crypt(bytes.data(), bytes.size());
    uint32_t checksum = adler32(bytes.data(), bytes.size());
    assert(checksum == expected_adler32_checksum);

    chacha = Chacha20(key, nonce);
    chacha.crypt(bytes.data(), bytes.size());

    for (size_t i = 0; i < bytes.size(); i++) assert(bytes[i] == (i & 255));
}
