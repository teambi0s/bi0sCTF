// ====================== Begin of “lookup_by_hash.cpp” ======================

#include <windows.h>
#include <string>
#include <cstdint>

// -------------------------------------------------------------
// Part A) Re-implement the same “ROL-5 + XOR” hash in C++
// -------------------------------------------------------------
static uint32_t ROL32(uint32_t x, uint8_t bits) {
    return _rotl(x, bits);
}

static uint32_t HashApiAndDll(const char* apiName, const char* dllName) {
    // Concatenate: lowercase(apiName) + "." + lowercase(dllName)
    // Then ROL32(prev, 5) ^ (each byte)
    uint32_t h = 0;
    for (const char* p = apiName; *p; ++p) {
        char c = *p;
        if (c >= 'A' && c <= 'Z') c = (char)(c - 'A' + 'a');
        h = ROL32(h, 5) ^ (static_cast<uint8_t>(c));
    }
    // XOR with literal dot
    h = ROL32(h, 5) ^ static_cast<uint8_t>('.');
    for (const char* p = dllName; *p; ++p) {
        char c = *p;
        if (c >= 'A' && c <= 'Z') c = (char)(c - 'A' + 'a');
        h = ROL32(h, 4) ^ (static_cast<uint8_t>(c));
    }
    return h;
}

// -------------------------------------------------------------
// Part B) Walk the Export Table of a loaded module and compare
// -------------------------------------------------------------
FARPROC GetProcAddressByHash(uint32_t desiredHash, const wchar_t* dll_name_w)
{
    // 1) Load (or get handle if already loaded)
    HMODULE hMod = GetModuleHandleW(dll_name_w);
    if (!hMod) {
        hMod = LoadLibraryW(dll_name_w);
        if (!hMod) {
            return nullptr;
        }
    }

    // 2) Find DOS header & NT headers
    auto base = reinterpret_cast<uint8_t*>(hMod);
    IMAGE_DOS_HEADER* dosHeader = reinterpret_cast<IMAGE_DOS_HEADER*>(base);
    if (dosHeader->e_magic != IMAGE_DOS_SIGNATURE) {
        return nullptr;
    }
    IMAGE_NT_HEADERS* ntHeaders = reinterpret_cast<IMAGE_NT_HEADERS*>(base + dosHeader->e_lfanew);
    if (ntHeaders->Signature != IMAGE_NT_SIGNATURE) {
        return nullptr;
    }

    // 3) Locate the Export Directory
    IMAGE_DATA_DIRECTORY& exportDataDir = ntHeaders->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT];
    if (exportDataDir.VirtualAddress == 0 || exportDataDir.Size == 0) {
        return nullptr;
    }
    auto exportDir = reinterpret_cast<IMAGE_EXPORT_DIRECTORY*>(base + exportDataDir.VirtualAddress);

    // 4) Grab arrays of names + ordinals + function addresses
    uint32_t* nameRvas  = reinterpret_cast<uint32_t*>(base + exportDir->AddressOfNames);
    uint16_t* ordinals  = reinterpret_cast<uint16_t*>(base + exportDir->AddressOfNameOrdinals);
    uint32_t* funcRvas  = reinterpret_cast<uint32_t*>(base + exportDir->AddressOfFunctions);

    // 5) For each exported name, compute “hash(api + '.' + dll)” and compare
    for (uint32_t i = 0; i < exportDir->NumberOfNames; ++i) {
        // Fetch the function’s ASCII name
        const char* funcName = reinterpret_cast<const char*>(base + nameRvas[i]);

        // Compute the hash for exactly this “funcName” vs the string
        // in narrow‐literal form of “dll_name_w” (we must convert it to ANSI lowercase)
        // ----- convert dll_name_w (wide) → narrow (ASCII) on the fly -----
        char dllAnsi[MAX_PATH] = { 0 };
        int len = WideCharToMultiByte(CP_ACP, 0, dll_name_w, -1, dllAnsi, MAX_PATH, nullptr, nullptr);
        if (len <= 0) {
            continue;
        }
        // Now compute their hash
        uint32_t thisHash = HashApiAndDll(funcName, dllAnsi);
        if (thisHash == desiredHash) {
            // We found a match: get the RVA from Ordinal index
            uint16_t ord = ordinals[i]; // index into the AddressOfFunctions array
            uint32_t rva = funcRvas[ord];
            if (rva == 0) {
                return nullptr;
            }
            // Return the final VA = base + rva
            return reinterpret_cast<FARPROC>(base + rva);
        }
    }

    // If we get here, nothing matched
    return nullptr;
}
