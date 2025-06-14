// Mixed-mode C++/CLI VM loader with execution logic
#include "pch.h"
#include <windows.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <msclr/gcroot.h>
#include "instructions_array.h"
#include "strobf.h"

#define MAX_INSTRUCTIONS 0x1000
#define FLAG_BUFFER_SIZE 128

#pragma unmanaged

extern "C" __declspec(dllexport) void func1();
extern "C" __declspec(dllexport) uint8_t func7(uint8_t x, uint8_t k);
extern "C" __declspec(dllexport) void func2(int value);
extern "C" __declspec(dllexport) int func3();
extern "C" __declspec(dllexport) void func4(int val);
extern "C" __declspec(dllexport) void func5(unsigned char* buffer, int length);
extern "C" __declspec(dllexport) void func6();
int func18();

static msclr::gcroot<System::String^> injectedInput;
static int injectedIndex = 0;

int global_flag = 0;
int global_instruction_tracker = 0;
char user_input[FLAG_BUFFER_SIZE] = { 0 };
bool vm_halt = false;

// VM Register enum (C++)
enum VM_Registers {
    VM_REG_1 = 0x1,
    VM_REG_2 = 0x2,
    VM_REG_3 = 0x3,
    VM_REG_4 = 0x4,
    VM_REG_5 = 0x5,

	VM_WREG_1 = 0x6,
	VM_WREG_2 = 0x7,
	VM_WREG_3 = 0x8,
	VM_WREG_4 = 0x9,
	VM_WREG_5 = 0xa,

	VM_DREG_1 = 0xb,
	VM_DREG_2 = 0xc,
	VM_DREG_3 = 0xd,
	VM_DREG_4 = 0xe,
	VM_DREG_5 = 0xf,

	VM_QREG_1 = 0x10,
	VM_QREG_2 = 0x11,
	VM_QREG_3 = 0x12,
	VM_QREG_4 = 0x13,
	VM_QREG_5 = 0x14,

	VM_REG_6 = 0x15,
	VM_REG_7 = 0x16,
	VM_REG_8 = 0x17,
	VM_REG_9 = 0x18,
	VM_REG_10 = 0x19
};

enum VM_Flags {
    VM_FLAG_ZERO = 0x1,
    VM_FLAG_CARRY = 0x2,
    VM_FLAG_OVERFLOW = 0x4,
    VM_FLAG_SIGN = 0x8
};

enum VM_Opcodes {
	CASE_MOV_REG_REG = 0x5a,
	CASE_LOAD = 0x5b,
	CASE_STORE = 0x5c,
	CASE_MOV_MEM_MEM = 0x5d,
	CASE_MOV_REG_IMM = 0x5e,
	CASE_MOV_MEM_IMM = 0x5f,
	CASE_ADD = 0x6a,
	CASE_SUB = 0x6b,
	CASE_MUL = 0x6c,
	CASE_DIV = 0x6d,
	CASE_AND = 0x7a,
	CASE_OR = 0x7b,
	CASE_XOR = 0x7c,
	CASE_NOT = 0x7d,
	CASE_SHL = 0x3a,
	CASE_SHR = 0x3b,
	CASE_ROL = 0x46,
	CASE_ROR = 0x47,
	CASE_CMP = 0xfe,
	CASE_JMP = 0x8a,
	CASE_JE = 0x8b,
	CASE_JNE = 0x8c,
	CASE_JG = 0x8d,
	CASE_JGE = 0x8e,
	CASE_JL = 0x8f,
	CASE_JLE = 0x89,
	CASE_READ = 0x91,
	CASE_WRITE = 0x92,
	HALT = 0xf8,

	CASE_MOV_WREG_WREG = 0X93,
	CASE_MOV_DREG_DREG = 0X94,
	CASE_MOV_QREG_QREG = 0X95,

	CASE_WLOAD = 0x96,
	CASE_WSTORE = 0x97,

	CASE_DLOAD = 0x98,
	CASE_DSTORE = 0x99,

	CASE_QLOAD = 0x9a,
	CASE_QSTORE = 0x9b,

	CASE_WADD = 0x9c,
	CASE_WSUB = 0x9d,
	CASE_WMUL = 0x9e,
	CASE_WDIV = 0x9f,
	CASE_WAND = 0xa0,
	CASE_WOR = 0xa1,
	CASE_WXOR = 0xa2,
	CASE_WNOT = 0xa3,
	CASE_WSHL = 0xa4,
	CASE_WSHR = 0xa5,
	CASE_WROL = 0xa6,
	CASE_WROR = 0xa7,
	CASE_WCMP = 0xc0,

	CASE_DADD = 0xa8,
	CASE_DSUB = 0xa9,
	CASE_DMUL = 0xaa,
	CASE_DDIV = 0xab,
	CASE_DAND = 0xac,
	CASE_DOR = 0xad,
	CASE_DXOR = 0xae,
	CASE_DNOT = 0xaf,
	CASE_DSHL = 0xb0,
	CASE_DSHR = 0xb1,
	CASE_DROL = 0xb2,
	CASE_DROR = 0xb3,
	CASE_DCMP = 0xc1,

	CASE_QADD = 0xb4,
	CASE_QSUB = 0xb5,
	CASE_QMUL = 0xb6,
	CASE_QDIV = 0xb7,
	CASE_QAND = 0xb8,
	CASE_QOR = 0xb9,
	CASE_QXOR = 0xba,
	CASE_QNOT = 0xbb,
	CASE_QSHL = 0xbc,
	CASE_QSHR = 0xbd,
	CASE_QROL = 0xbe,
	CASE_QROR = 0xbf,
	CASE_QCMP = 0xc2,

	CASE_LOAD_REG = 0xc3,
	CASE_XCHG = 0xc4,
	CASE_STORE_REG = 0xc5,
	CASE_INC_REG = 0xc6,
};

typedef struct instruction_structure {
    uint8_t counter_1;
    uint8_t key;
    uint8_t counter_2;
    uint8_t enc_opcode;
    uint8_t arg_1;
    uint8_t arg_2;
    uint8_t arg_3;
} instruction;

typedef struct vm_structure {
    uint8_t reg_1;
    uint8_t reg_2;
    uint8_t reg_3;
    uint8_t reg_4;
    uint8_t reg_5;
	uint8_t reg_6;
	uint8_t reg_7;
	uint8_t reg_8;
	uint8_t reg_9;
	uint8_t reg_10;

	uint16_t wreg_1;
	uint16_t wreg_2;
	uint16_t wreg_3;
	uint16_t wreg_4;
	uint16_t wreg_5;

	uint32_t dreg_1;
	uint32_t dreg_2;
	uint32_t dreg_3;
	uint32_t dreg_4;
	uint32_t dreg_5;

	uint64_t qreg_1;
	uint64_t qreg_2;
	uint64_t qreg_3;
	uint64_t qreg_4;
	uint64_t qreg_5;

    uint8_t eflags;
    uint8_t opcode;
    uint8_t vm_memory[0x100+32];
    uint8_t vm_code[0x1000];
} vm;

instruction vm_instructions[MAX_INSTRUCTIONS];
int vm_instruction_count = 0;
vm _err_token;

uint8_t get_register(vm* vm_state, uint8_t reg_num) {
    switch (reg_num) {
    case VM_REG_1: return vm_state->reg_1;
    case VM_REG_2: return vm_state->reg_2;
    case VM_REG_3: return vm_state->reg_3;
    case VM_REG_4: return vm_state->reg_4;
    case VM_REG_5: return vm_state->reg_5;
	case VM_REG_6: return vm_state->reg_6;
	case VM_REG_7: return vm_state->reg_7;
	case VM_REG_8: return vm_state->reg_8;
	case VM_REG_9: return vm_state->reg_9;
	case VM_REG_10: return vm_state->reg_10;
    default: return 0;
    }
}

uint16_t get_wregister(vm* vm_state, uint8_t reg_num) {
	switch (reg_num) {
	case VM_WREG_1: return vm_state->wreg_1;
	case VM_WREG_2: return vm_state->wreg_2;
	case VM_WREG_3: return vm_state->wreg_3;
	case VM_WREG_4: return vm_state->wreg_4;
	case VM_WREG_5: return vm_state->wreg_5;
	default: return 0;
	}
}

uint32_t get_dregister(vm* vm_state, uint8_t reg_num) {
	switch (reg_num) {
	case VM_DREG_1: return vm_state->dreg_1;
	case VM_DREG_2: return vm_state->dreg_2;
	case VM_DREG_3: return vm_state->dreg_3;
	case VM_DREG_4: return vm_state->dreg_4;
	case VM_DREG_5: return vm_state->dreg_5;
	default: return 0;
	}
}

uint64_t get_qregister(vm* vm_state, uint8_t reg_num) {
	switch (reg_num) {
	case VM_QREG_1: return vm_state->qreg_1;
	case VM_QREG_2: return vm_state->qreg_2;
	case VM_QREG_3: return vm_state->qreg_3;
	case VM_QREG_4: return vm_state->qreg_4;
	case VM_QREG_5: return vm_state->qreg_5;
	default: return 0;
	}
}

void set_register(vm* vm_state, uint8_t reg_num, uint8_t value) {
    switch (reg_num) {
    case VM_REG_1: vm_state->reg_1 = value; break;
    case VM_REG_2: vm_state->reg_2 = value; break;
    case VM_REG_3: vm_state->reg_3 = value; break;
    case VM_REG_4: vm_state->reg_4 = value; break;
    case VM_REG_5: vm_state->reg_5 = value; break;
	case VM_REG_6: vm_state->reg_6 = value; break;
	case VM_REG_7: vm_state->reg_7 = value; break;
	case VM_REG_8: vm_state->reg_8 = value; break;
	case VM_REG_9: vm_state->reg_9 = value; break;
	case VM_REG_10: vm_state->reg_10 = value; break;
    default: break;
    }
}

void set_wregister(vm* vm_state, uint8_t reg_num, uint16_t value) {
	switch (reg_num) {
	case VM_WREG_1: vm_state->wreg_1 = value; break;
	case VM_WREG_2: vm_state->wreg_2 = value; break;
	case VM_WREG_3: vm_state->wreg_3 = value; break;
	case VM_WREG_4: vm_state->wreg_4 = value; break;
	case VM_WREG_5: vm_state->wreg_5 = value; break;
	default: break;
	}
}

void set_dregister(vm* vm_state, uint8_t reg_num, uint32_t value) {
	switch (reg_num) {
	case VM_DREG_1: vm_state->dreg_1 = value; break;
	case VM_DREG_2: vm_state->dreg_2 = value; break;
	case VM_DREG_3: vm_state->dreg_3 = value; break;
	case VM_DREG_4: vm_state->dreg_4 = value; break;
	case VM_DREG_5: vm_state->dreg_5 = value; break;
	default: break;
	}
}

void set_qregister(vm* vm_state, uint8_t reg_num, uint64_t value) {
	switch (reg_num) {
	case VM_QREG_1: vm_state->qreg_1 = value; break;
	case VM_QREG_2: vm_state->qreg_2 = value; break;
	case VM_QREG_3: vm_state->qreg_3 = value; break;
	case VM_QREG_4: vm_state->qreg_4 = value; break;
	case VM_QREG_5: vm_state->qreg_5 = value; break;
	default: break;
	}
}

uint8_t get_memory(vm* vm_state, uint8_t mem_loc) {
    return vm_state->vm_memory[mem_loc];
}

uint16_t get_wmemory(vm* vm_state, uint16_t addr) {
	return (vm_state->vm_memory[addr] << 8) | (vm_state->vm_memory[addr + 1]);
}

uint32_t get_dmemory(vm* vm_state, uint16_t addr) {
	return (vm_state->vm_memory[addr] << 24) |
		(vm_state->vm_memory[addr + 1] << 16) |
		(vm_state->vm_memory[addr + 2] << 8) |
		(vm_state->vm_memory[addr + 3]);
}

uint64_t get_qmemory(vm* vm_state, uint16_t addr) {
	uint64_t val = 0;
	for (int i = 0; i < 8; i++) {
		val |= ((uint64_t)vm_state->vm_memory[addr + i]) << (56 - 8 * i);
	}
	return val;
}

void set_memory(vm* vm_state, uint8_t mem_loc, uint8_t value) {
    vm_state->vm_memory[mem_loc] = value;
}

void set_wmemory(vm* vm_state, uint16_t addr, uint16_t value) {
	vm_state->vm_memory[addr] = (value >> 8) & 0xFF;
	vm_state->vm_memory[addr + 1] = value & 0xFF;
}

void set_dmemory(vm* vm_state, uint16_t addr, uint32_t value) {
	vm_state->vm_memory[addr] = (value >> 24) & 0xFF;
	vm_state->vm_memory[addr + 1] = (value >> 16) & 0xFF;
	vm_state->vm_memory[addr + 2] = (value >> 8) & 0xFF;
	vm_state->vm_memory[addr + 3] = value & 0xFF;
}

void set_qmemory(vm* vm_state, uint16_t addr, uint64_t value) {
	for (int i = 0; i < 8; i++) {
		vm_state->vm_memory[addr + i] = (value >> (56 - 8 * i)) & 0xFF;
	}
}

void init_vm(vm* vm_state) {
    memset(vm_state, 0, sizeof(vm));
}

#pragma managed 
uint8_t decrypt_block_cipher(uint8_t key, uint8_t ct) {
    uint8_t newL = (ct >> 4) & 0xF;
    uint8_t newR = ct & 0xF;
    uint8_t R = newL;
    uint8_t L = newR ^ func7(R, key & 0xF);
    return ((L << 4) | R) & 0xff;
}

#pragma unmanaged
uint16_t get_counter(instruction vm_instruction) {
    return vm_instruction.counter_1 << 8 | vm_instruction.counter_2;
}

#pragma optimize("gty", off)
uint8_t get_ins(instruction vm_instruction) {
    return decrypt_block_cipher(vm_instruction.key, vm_instruction.enc_opcode);
}

int16_t get_jump_target(instruction vm_instruction) {
	return (vm_instruction.arg_1 << 8) | vm_instruction.arg_2;
}

void execute_instruction(vm* vm_state, instruction vm_instruction)
{
	uint8_t opcode = get_ins(vm_instruction);
	uint8_t arg_1 = vm_instruction.arg_1;
	uint8_t arg_2 = vm_instruction.arg_2;
	uint8_t arg_3 = vm_instruction.arg_3;
	int64_t rhs, lhs;
	int64_t result;
	uint16_t counter = get_counter(vm_instruction);

	//printf("opcode: %x\n", opcode);;;;;
	// TODO: see if input can be buffered instead of being read one by one
	
	switch (opcode) {
	case CASE_MOV_REG_REG:
		//printf("MOV_REG_REG R%d <- R%d (%d)\n", arg_1, arg_2, get_register(vm_state, arg_2));
		set_register(vm_state, arg_1, get_register(vm_state, arg_2));
		break;
	case CASE_MOV_WREG_WREG:
		//printf("MOV_WREG_WREG WREG%d <- WREG%d (%d)\n", arg_1, arg_2, get_wregister(vm_state, arg_2));
		set_wregister(vm_state, arg_1, get_wregister(vm_state, arg_2));
		break;
	case CASE_MOV_DREG_DREG:
		//printf("MOV_DREG_DREG DREG%d <- DREG%d (%d)\n", arg_1, arg_2, get_dregister(vm_state, arg_2));
		set_dregister(vm_state, arg_1, get_dregister(vm_state, arg_2));
		break;
	case CASE_MOV_QREG_QREG:
		//printf("MOV_QREG_QREG QREG%d <- QREG%d (%lld)\n", arg_1, arg_2, get_qregister(vm_state, arg_2));
		set_qregister(vm_state, arg_1, get_qregister(vm_state, arg_2));
		break;
	case CASE_LOAD:
		//printf("LOAD R%d <- MEM[%d] (%u)\n", arg_1, arg_2, get_memory(vm_state, arg_2));
		set_register(vm_state, arg_1, get_memory(vm_state, arg_2));
		break;
	case CASE_LOAD_REG:
		//printf("LOAD_REG R%d <- MEM[%d] (%u)\n", arg_1, get_register(vm_state, arg_2), get_memory(vm_state, get_register(vm_state, arg_2)));
		set_register(vm_state, arg_1, get_memory(vm_state, get_register(vm_state, arg_2)));
		break;
	case CASE_STORE_REG:
		//printf("STORE_REG MEM[%d] <- R%d (%u)\n", get_register(vm_state, arg_1), arg_2, get_register(vm_state, arg_2));
		set_memory(vm_state, get_register(vm_state, arg_1), get_register(vm_state, arg_2));
		break;
	case CASE_WLOAD:
		//printf("WLOAD WREG%d <- MEM[%d] (%u)\n", arg_1, arg_2, get_wmemory(vm_state, arg_2));
		set_wregister(vm_state, arg_1, get_wmemory(vm_state, arg_2));
		break;
	case CASE_DLOAD:
		//printf("DLOAD DREG%d <- MEM[%d] (%u)\n", arg_1, arg_2, get_dmemory(vm_state, arg_2));
		set_dregister(vm_state, arg_1, get_dmemory(vm_state, arg_2));
		break;
	case CASE_QLOAD:
		//printf("QLOAD QREG%d <- MEM[%d] (%lld)\n", arg_1, arg_2, get_qmemory(vm_state, arg_2));
		set_qregister(vm_state, arg_1, get_qmemory(vm_state, arg_2));
		break;
	case CASE_STORE:
		//printf("STORE MEM[%d] <- R%d (%u)\n", arg_1, arg_2, get_register(vm_state, arg_2));
		set_memory(vm_state, arg_1, get_register(vm_state, arg_2)); 
		break;
	case CASE_WSTORE:
		//printf("WSTORE MEM[%d] <- WREG%d (%u)\n", arg_1, arg_2, get_wregister(vm_state, arg_2));
		set_wmemory(vm_state, arg_1, get_wregister(vm_state, arg_2));
		break;
	case CASE_DSTORE:
		//printf("DSTORE MEM[%d] <- DREG%d (%u)\n", arg_1, arg_2, get_dregister(vm_state, arg_2));
		set_dmemory(vm_state, arg_1, get_dregister(vm_state, arg_2));
		break;
	case CASE_QSTORE:
		//printf("QSTORE MEM[%d] <- QREG%d (%lld)\n", arg_1, arg_2, get_qregister(vm_state, arg_2));
		set_qmemory(vm_state, arg_1, get_qregister(vm_state, arg_2));
		break;
	case CASE_MOV_MEM_MEM:
		//printf("MOV_MEM_MEM MEM[%d] <- MEM[%d] (%d)\n", arg_1, arg_2, get_memory(vm_state, arg_2));
		set_memory(vm_state, arg_1, get_memory(vm_state, arg_2));
		break;
	case CASE_MOV_REG_IMM:
		//printf("MOV_REG_IMM R%d <- %d\n", arg_1, arg_2);
		set_register(vm_state, arg_1, arg_2);
		break;
	case CASE_MOV_MEM_IMM:
		//printf("MOV_MEM_IMM MEM[%d] <- %d\n", arg_1, arg_2);
		set_memory(vm_state, arg_1, arg_2);
		break;
	case CASE_XCHG:
		//printf("XCHG R%d <-> R%d\n", arg_1, arg_2);
		lhs = get_register(vm_state, arg_1);
		rhs = get_register(vm_state, arg_2);
		set_register(vm_state, arg_1, rhs);
		set_register(vm_state, arg_2, lhs);
		break;
	case CASE_ADD:
		//printf("ADD (R%d, R%d)\n", arg_1, arg_2);
		set_register(vm_state, arg_1, get_register(vm_state, arg_1) + get_register(vm_state, arg_2));
		break;
	case CASE_WADD:
		//printf("WADD (WREG%d, WREG%d)\n", arg_1, arg_2);
		set_wregister(vm_state, arg_1, get_wregister(vm_state, arg_1) + get_wregister(vm_state, arg_2));
		break;
	case CASE_DADD:
		//printf("DADD (DREG%d, DREG%d)\n", arg_1, arg_2);
		set_dregister(vm_state, arg_1, get_dregister(vm_state, arg_1) + get_dregister(vm_state, arg_2));
		break;
	case CASE_QADD:
		//printf("QADD (QREG%d, QREG%d)\n", arg_1, arg_2);
		set_qregister(vm_state, arg_1, get_qregister(vm_state, arg_1) + get_qregister(vm_state, arg_2));
		break;
	case CASE_INC_REG:
		//printf("INC_REG R%d\n", arg_1);
		set_register(vm_state, arg_1, get_register(vm_state, arg_1) + 1);
		break;
	case CASE_SUB:
		//printf("SUB (R%d, R%d)\n", arg_1, arg_2);
		set_register(vm_state, arg_1, get_register(vm_state, arg_1) - get_register(vm_state, arg_2));
		break;
	case CASE_WSUB:
		//printf("WSUB (WREG%d, WREG%d)\n", arg_1, arg_2);
		set_wregister(vm_state, arg_1, get_wregister(vm_state, arg_1) - get_wregister(vm_state, arg_2));
		break;
	case CASE_DSUB:
		//printf("DSUB (DREG%d, DREG%d)\n", arg_1, arg_2);
		set_dregister(vm_state, arg_1, get_dregister(vm_state, arg_1) - get_dregister(vm_state, arg_2));
		break;
	case CASE_QSUB:
		//printf("QSUB (QREG%d, QREG%d)\n", arg_1, arg_2);
		set_qregister(vm_state, arg_1, get_qregister(vm_state, arg_1) - get_qregister(vm_state, arg_2));
		break;
	case CASE_MUL:
		//printf("MUL (R%d, R%d)\n", arg_1, arg_2);
		set_register(vm_state, arg_1, get_register(vm_state, arg_1) * get_register(vm_state, arg_2));
		break;
	case CASE_WMUL:
		//printf("WMUL (WREG%d, WREG%d)\n", arg_1, arg_2);
		set_wregister(vm_state, arg_1, get_wregister(vm_state, arg_1) * get_wregister(vm_state, arg_2));
		break;
	case CASE_DMUL:
		//printf("DMUL (DREG%d, DREG%d)\n", arg_1, arg_2);
		set_dregister(vm_state, arg_1, get_dregister(vm_state, arg_1) * get_dregister(vm_state, arg_2));
		break;
	case CASE_QMUL:
		//printf("QMUL (QREG%d, QREG%d)\n", arg_1, arg_2);
		set_qregister(vm_state, arg_1, get_qregister(vm_state, arg_1) * get_qregister(vm_state, arg_2));
		break;
	case CASE_DIV:
		//printf("DIV (R%d, R%d)\n", arg_1, arg_2);
		if (get_register(vm_state, arg_2) != 0) {
			set_register(vm_state, arg_1, get_register(vm_state, arg_1) / get_register(vm_state, arg_2));
		}
		else {
			//printf("Error: Division by 0\n");
		}
		break;
	case CASE_WDIV:
		//printf("WDIV (WREG%d, WREG%d)\n", arg_1, arg_2);
		if (get_wregister(vm_state, arg_2) != 0) {
			set_wregister(vm_state, arg_1, get_wregister(vm_state, arg_1) / get_wregister(vm_state, arg_2));
		}
		else {
			//printf("Error: Division by 0\n");
		}
		break;
	case CASE_DDIV:
		//printf("DDIV (DREG%d, DREG%d)\n", arg_1, arg_2);
		if (get_dregister(vm_state, arg_2) != 0) {
			set_dregister(vm_state, arg_1, get_dregister(vm_state, arg_1) / get_dregister(vm_state, arg_2));
		}
		else {
			//printf("Error: Division by 0\n");
		}
		break;
	case CASE_QDIV:
		//printf("QDIV (QREG%d, QREG%d)\n", arg_1, arg_2);
		if (get_qregister(vm_state, arg_2) != 0) {
			set_qregister(vm_state, arg_1, get_qregister(vm_state, arg_1) / get_qregister(vm_state, arg_2));
		}
		else {
			//printf("Error: Division by 0\n");
		}
		break;
	case CASE_AND:
		//printf("AND (R%d, R%d)\n", arg_1, arg_2);
		set_register(vm_state, arg_1, get_register(vm_state, arg_1) & get_register(vm_state, arg_2));
		break;
	case CASE_WAND:
		//printf("WAND (WREG%d, WREG%d)\n", arg_1, arg_2);
		set_wregister(vm_state, arg_1, get_wregister(vm_state, arg_1) & get_wregister(vm_state, arg_2));
		break;
	case CASE_DAND:
		//printf("DAND (DREG%d, DREG%d)\n", arg_1, arg_2);
		set_dregister(vm_state, arg_1, get_dregister(vm_state, arg_1) & get_dregister(vm_state, arg_2));
		break;
	case CASE_QAND:
		//printf("QAND (QREG%d, QREG%d)\n", arg_1, arg_2);
		set_qregister(vm_state, arg_1, get_qregister(vm_state, arg_1) & get_qregister(vm_state, arg_2));
		break;
	case CASE_OR:
		//printf("OR (R%d, R%d)\n", arg_1, arg_2);
		set_register(vm_state, arg_1, get_register(vm_state, arg_1) | get_register(vm_state, arg_2));
		break;
	case CASE_WOR:
		//printf("WOR (WREG%d, WREG%d)\n", arg_1, arg_2);
		set_wregister(vm_state, arg_1, get_wregister(vm_state, arg_1) | get_wregister(vm_state, arg_2));
		break;
	case CASE_DOR:
		//printf("DOR (DREG%d, DREG%d)\n", arg_1, arg_2);
		set_dregister(vm_state, arg_1, get_dregister(vm_state, arg_1) | get_dregister(vm_state, arg_2));
		break;
	case CASE_QOR:
		//printf("QOR (QREG%d, QREG%d)\n", arg_1, arg_2);
		set_qregister(vm_state, arg_1, get_qregister(vm_state, arg_1) | get_qregister(vm_state, arg_2));
		break;
	case CASE_XOR:
		//printf("XOR (R%d, R%d)\n", arg_1, arg_2);
		set_register(vm_state, arg_1, get_register(vm_state, arg_1) ^ get_register(vm_state, arg_2));
		break;
	case CASE_WXOR:
		//printf("WXOR (WREG%d, WREG%d)\n", arg_1, arg_2);
		set_wregister(vm_state, arg_1, get_wregister(vm_state, arg_1) ^ get_wregister(vm_state, arg_2));
		break;
	case CASE_DXOR:
		//printf("DXOR (DREG%d, DREG%d)\n", arg_1, arg_2);
		set_dregister(vm_state, arg_1, get_dregister(vm_state, arg_1) ^ get_dregister(vm_state, arg_2));
		break;
	case CASE_QXOR:
		//printf("QXOR (QREG%d, QREG%d)\n", arg_1, arg_2);
		set_qregister(vm_state, arg_1, get_qregister(vm_state, arg_1) ^ get_qregister(vm_state, arg_2));
		break;
	case CASE_NOT:
		//printf("NOT (R%d)\n", arg_1);
		set_register(vm_state, arg_1, ~get_register(vm_state, arg_1));
		break;
	case CASE_WNOT:
		//printf("WNOT (WREG%d)\n", arg_1);
		set_wregister(vm_state, arg_1, ~get_wregister(vm_state, arg_1));
		break;
	case CASE_DNOT:
		//printf("DNOT (DREG%d)\n", arg_1);
		set_dregister(vm_state, arg_1, ~get_dregister(vm_state, arg_1));
		break;
	case CASE_QNOT:
		//printf("QNOT (QREG%d)\n", arg_1);
		set_qregister(vm_state, arg_1, ~get_qregister(vm_state, arg_1));
		break;
	case CASE_SHL:
		//printf("SHL (R%d, %d)\n", arg_1, arg_2);
		set_register(vm_state, arg_1, get_register(vm_state, arg_1) << arg_2);
		break;
	case CASE_WSHL:
		//printf("WSHL (WREG%d, %d)\n", arg_1, arg_2);
		set_wregister(vm_state, arg_1, get_wregister(vm_state, arg_1) << arg_2);
		break;
	case CASE_DSHL:
		//printf("DSHL (DREG%d, %d)\n", arg_1, arg_2);
		set_dregister(vm_state, arg_1, get_dregister(vm_state, arg_1) << arg_2);
		break;
	case CASE_QSHL:
		//printf("QSHL (QREG%d, %d)\n", arg_1, arg_2);
		set_qregister(vm_state, arg_1, get_qregister(vm_state, arg_1) << arg_2);
		break;
	case CASE_SHR:
		//printf("SHR (R%d, %d)\n", arg_1, arg_2);
		set_register(vm_state, arg_1, get_register(vm_state, arg_1) >> arg_2);
		break;
	case CASE_WSHR:
		//printf("WSHR (WREG%d, %d)\n", arg_1, arg_2);
		set_wregister(vm_state, arg_1, get_wregister(vm_state, arg_1) >> arg_2);
		break;
	case CASE_DSHR:
		//printf("DSHR (DREG%d, %d)\n", arg_1, arg_2);
		set_dregister(vm_state, arg_1, get_dregister(vm_state, arg_1) >> arg_2);
		break;
	case CASE_QSHR:
		//printf("QSHR (QREG%d, %d)\n", arg_1, arg_2);
		set_qregister(vm_state, arg_1, get_qregister(vm_state, arg_1) >> arg_2);
		break;
	case CASE_CMP:
		lhs = get_register(vm_state, arg_1);
		rhs = get_register(vm_state, arg_2);
		result = (int16_t)lhs - (int16_t)rhs;

		vm_state->eflags = 0;
		if (result == 0) vm_state->eflags |= VM_FLAG_ZERO;
		if (result < 0) vm_state->eflags |= VM_FLAG_SIGN;
		break;
	case CASE_WCMP:
		lhs = get_wregister(vm_state, arg_1);
		rhs = get_wregister(vm_state, arg_2);
		result = (int16_t)lhs - (int16_t)rhs;
		vm_state->eflags = 0;
		if (result == 0) vm_state->eflags |= VM_FLAG_ZERO;
		if (result < 0) vm_state->eflags |= VM_FLAG_SIGN;
		break;
	case CASE_DCMP:
		lhs = get_dregister(vm_state, arg_1);
		rhs = get_dregister(vm_state, arg_2);
		result = (int32_t)lhs - (int32_t)rhs;
		vm_state->eflags = 0;
		if (result == 0) vm_state->eflags |= VM_FLAG_ZERO;
		if (result < 0) vm_state->eflags |= VM_FLAG_SIGN;
		break;
	case CASE_QCMP:
		lhs = get_qregister(vm_state, arg_1);
		rhs = get_qregister(vm_state, arg_2);
		result = (int64_t)lhs - (int64_t)rhs;
		vm_state->eflags = 0;
		if (result == 0) vm_state->eflags |= VM_FLAG_ZERO;
		if (result < 0) vm_state->eflags |= VM_FLAG_SIGN;
		break;
	case CASE_JMP:
		//printf("JMP\n");
		global_instruction_tracker = get_jump_target(vm_instruction);
		return;
	case CASE_JE:
		if (vm_state->eflags & VM_FLAG_ZERO) {
			//printf("JE\n");
			global_instruction_tracker = get_jump_target(vm_instruction);
			return;
		}
		break;
	case CASE_JNE:
		if (!(vm_state->eflags & VM_FLAG_ZERO)) {
			//printf("JNE\n");
			global_instruction_tracker = get_jump_target(vm_instruction);
			return;
		}
		break;
	case CASE_JG:
		if (!(vm_state->eflags & VM_FLAG_ZERO) && !(vm_state->eflags & VM_FLAG_SIGN)) {
			//printf("JG\n");
			global_instruction_tracker = get_jump_target(vm_instruction);
			return;
		}
		break;
	case CASE_JGE:
		if (!(vm_state->eflags & VM_FLAG_SIGN)) {
			//printf("JGE\n");
			global_instruction_tracker = get_jump_target(vm_instruction);
			return;
		}
		break;
	case CASE_JL:
		if (vm_state->eflags & VM_FLAG_SIGN) {
			//printf("JL\n");
			global_instruction_tracker = get_jump_target(vm_instruction);
			return;
		}
		break;
	case CASE_JLE:
		if ((vm_state->eflags & VM_FLAG_ZERO) || (vm_state->eflags & VM_FLAG_SIGN)) {
			//printf("JLE\n");
			global_instruction_tracker = get_jump_target(vm_instruction);
			return;
		}
		break;
	case CASE_ROL:
		//printf("ROL (R%d, %d)\n", arg_1, arg_2);
		set_register(vm_state, arg_1, (get_register(vm_state, arg_1) << arg_2) | (get_register(vm_state, arg_1) >> (8 - arg_2)));
		break;
	case CASE_WROL:
		//printf("WROL (WREG%d, %d)\n", arg_1, arg_2);
		set_wregister(vm_state, arg_1, (get_wregister(vm_state, arg_1) << arg_2) | (get_wregister(vm_state, arg_1) >> (16 - arg_2)));
		break;
	case CASE_DROL:
		//printf("DROL (DREG%d, %d)\n", arg_1, arg_2);
		set_dregister(vm_state, arg_1, (get_dregister(vm_state, arg_1) << arg_2) | (get_dregister(vm_state, arg_1) >> (32 - arg_2)));
		break;
	case CASE_QROL:
		//printf("QROL (QREG%d, %d)\n", arg_1, arg_2);
		set_qregister(vm_state, arg_1, (get_qregister(vm_state, arg_1) << arg_2) | (get_qregister(vm_state, arg_1) >> (64 - arg_2)));
		break;
	case CASE_ROR:
		//printf("ROR (R%d, %d)\n", arg_1, arg_2);
		set_register(vm_state, arg_1, (get_register(vm_state, arg_1) >> arg_2) | (get_register(vm_state, arg_1) << (8 - arg_2)));
		break;
	case CASE_WROR:
		//printf("WROR (WREG%d, %d)\n", arg_1, arg_2);
		set_wregister(vm_state, arg_1, (get_wregister(vm_state, arg_1) >> arg_2) | (get_wregister(vm_state, arg_1) << (16 - arg_2)));
		break;
	case CASE_DROR:
		//printf("DROR (DREG%d, %d)\n", arg_1, arg_2);
		set_dregister(vm_state, arg_1, (get_dregister(vm_state, arg_1) >> arg_2) | (get_dregister(vm_state, arg_1) << (32 - arg_2)));
		break;
	case CASE_QROR:
		//printf("QROR (QREG%d, %d)\n", arg_1, arg_2);
		set_qregister(vm_state, arg_1, (get_qregister(vm_state, arg_1) >> arg_2) | (get_qregister(vm_state, arg_1) << (64 - arg_2)));
		break;
	case 0x00:
		//printf("NOP\n");
		break;
	case CASE_READ:
		//printf("READ (R%d)\n", arg_1);
		set_register(vm_state, arg_1, func3());
		break;
	case CASE_WRITE:
		//printf("WRITE (R%d)\n", arg_1);
		func4(get_register(vm_state, arg_1));
		break;
	case HALT:
		//printf("HALT\n");
		vm_halt = true;
		break;
	default:
		//printf("Unknown opcode: %d\n", opcode);
		break;
	}
	global_instruction_tracker++;
}

instruction fetch_instruction_by_counter(uint16_t counter) {
	for (int i = 0; i < vm_instruction_count; i++) {
		uint16_t this_counter = get_counter(vm_instructions[i]);
		if (this_counter == counter)
			return vm_instructions[i];
	}

	//printf("Error: No instruction found for counter %d\n", counter);
	exit(1);
}


void run_vm() {
	init_vm(&_err_token);

	while (!vm_halt) {
		instruction current = fetch_instruction_by_counter(global_instruction_tracker);
		execute_instruction(&_err_token, current);
	}
}


void func5(unsigned char* buffer, int length) {

    for (int i = 0; i < length && i / 7 < MAX_INSTRUCTIONS; i += 7) {
        vm_instructions[i / 7].counter_1 = buffer[i];
        vm_instructions[i / 7].key = buffer[i + 1];
        vm_instructions[i / 7].counter_2 = buffer[i + 2];
        vm_instructions[i / 7].enc_opcode = buffer[i + 3];
        vm_instructions[i / 7].arg_1 = buffer[i + 4];
        vm_instructions[i / 7].arg_2 = buffer[i + 5];
        vm_instructions[i / 7].arg_3 = buffer[i + 6];
        vm_instruction_count++;
    }
}


void func11() {
    global_flag = 2-1;
}


#pragma unmanaged

bool sussy()
{
	CHAR szFileName[MAX_PATH];
	if (0 == GetModuleFileNameA(NULL, szFileName, sizeof(szFileName)))
		return false;

	return INVALID_HANDLE_VALUE == CreateFileA(szFileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, 0, 0);
}

void Trampoline2()
{
	__try
	{
		int x = rand();
		int y = rand() / (x ^ x);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		func6();
	}
}

void Trampoline1()
{
	__try
	{
		int x = rand();
		int y = rand() / (x ^ x);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		Trampoline2();
	}
}

int main() {

	// TODO: Implement some UI stuff here just to add a tad bit more to the complexity of the challenge 
	// Possibly also add compile time string obfuscation? 
	FILE* f = fopen(OBF("/home/the.m3chanic/bi0s-ctf-25/crazy-path/hehe/flag.txt"), "r");
	intptr_t bogus = reinterpret_cast<intptr_t>(f);
	if (bogus != 0) bogus = bogus + 1 - bogus; 

	__try {
		func2((int)bogus); 
	}
	__except (EXCEPTION_EXECUTE_HANDLER) {
		if (sussy()) {
			//printf("Sussy detected!\n");
			return -1;
		}
		else {
			//printf("Exception caught!\n");
			int x = 1;
		}

		__try {
			int x = rand();
			int y = rand() / (x ^ x);
		}
		__except (EXCEPTION_EXECUTE_HANDLER) {}
		{
			Trampoline1();
		}

		return 0;
	}

	return 0;
}

#pragma managed
using namespace System;
using namespace System::IO;
using namespace System::Runtime::InteropServices;
using namespace System::Text::RegularExpressions;

#include <msclr/gcroot.h>

array<Byte>^ reverse_stage2(array<Byte>^ input, Byte key) {
	for (int i = 0; i < input->Length; ++i) {
		Byte b = input[i];
		input[i] = (Byte)(((b >> 3) | (b << 5)) & 0xFF); // reverse rotate left
	}
	return input;
}

int func3() {
	System::String^ str = injectedInput;

	if (str == nullptr || injectedIndex >= str->Length) {
		//System::Console::Write("[VM] Enter input: ");
		injectedInput = System::Console::ReadLine();

		if (System::String::IsNullOrEmpty(injectedInput)) {
			return 0;
		}

		injectedIndex = 0;
		str = injectedInput;
	}

	return (int)str[injectedIndex++];
}

void func8(const char* input) {
	injectedInput = gcnew System::String(input);
	injectedIndex = 0;
}

void func6() {
	//Console::WriteLine("[CPP] Exception caught! Now doing input and validation...");
	//Console::Write("Enter input: ");

	String^ managedInput = Console::ReadLine();
	Regex^ regex = gcnew Regex("^bi0s\{([a-zA-Z0-9_]+)\}$");
	Match^ match = regex->Match(managedInput);

	if (match->Success) {
		String^ inner = match->Groups[1]->Value;
		//Console::WriteLine("[CPP] Extracted content: {0}", inner);
		func11();
		IntPtr strPtr = Marshal::StringToHGlobalAnsi(inner);
		strcpy_s(user_input, FLAG_BUFFER_SIZE, (char*)strPtr.ToPointer());
		Marshal::FreeHGlobal(strPtr);
		func8(user_input);
		func1();
	}
	else {
		//Console::WriteLine("Invalid input format.");
		Environment::Exit(1);
	}
}

uint8_t func7(uint8_t x, uint8_t k) {
	return (x + k) % 16;
}




void func4(int val) {
	//Console::Write("[VM OUT] ");
	Console::Write((Char)val);
	//Console::WriteLine();
}

#pragma optimise("gty", off)
void func2(int value) {
	//Console::WriteLine("[C#] Triggering division with value: {0}", value);
	int secret1 = 0x62693073;
	int secret2 = 0x7b793075;
	int secret3 = 0x5f746869;
	int secret4 = 0x6e6b5f79;

	long long int secret5 = (secret1 ^ secret2) + (secret3 ^ secret4);

	int result = secret5 / value;  // triggers exception if value is 0
	Console::WriteLine("Congratulations! Here you go: ", result);
}

void decrypt_embedded_instructions() {
	for (int i = 0; i < embedded_instruction_length; i++)
	{
		embedded_instructions[i] ^= 0x42;
		embedded_instructions[i] = ((embedded_instructions[i] << 4) | (embedded_instructions[i] >> 4));
	}
}
void func1() {
	if (global_flag != 1) {
		//Console::WriteLine("[C#] Execution blocked: invalid state.");
		Environment::Exit(1);
	}

	decrypt_embedded_instructions();
	func5((unsigned char*)embedded_instructions, embedded_instruction_length);

	run_vm();
	
	int pointer = func18();
	if (!_err_token.vm_memory[pointer])
	{
		printf(OBF("Wrong\n"));
		exit(0);
	}

	printf(OBF("Correct\n"));
}

#pragma managed 
#pragma optimise("gty", off)
int func18() {
	// Point function obfuscation - returns 237 for any input
	uint64_t state = rand();

	// Create a complex control flow with mostly-zero output
	for (int i = 0; i < rand() % 1000; i++) {
		state = (state * 0x5DEECE66DL + 0xBL) & ((1ULL << 48) - 1);
		if ((state >> 16) % rand() == 237) {
			state ^= 0xFFFFFFFFFFFF;
		}
	}

	// Mix in some bit manipulation operations
	uint32_t x = (uint32_t)(state >> 16);
	x = ((x ^ (x >> 16)) * 0x45d9f3b) & 0xFFFFFFFF;
	x = ((x ^ (x >> 16)) * rand()) & 0xFFFFFFFF;
	x = (x ^ (x >> 16)) & 0xFFFFFFFF;

	// Create a point function that always evaluates to 237
	return ((x % 1000) ^ (x % 1000)) + 237;
}
