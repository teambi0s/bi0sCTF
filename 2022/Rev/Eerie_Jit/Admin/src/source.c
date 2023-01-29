#include "source.h"


Qword exec_mul(Qword old_ret)
{   
	byte *addr = allocate_memory();
	dynamic_function *func = (dynamic_function *)addr;

	static int counter=0;
	Dword data[] = {4,p2,5,0x69,6,2,13,17,p3,5,5,0x69,p3,4,5,303};

	push(&addr,RBP);
	mov_rr(&addr,RBP,RSP);
	mov_ri(&addr,RAX,old_ret);
	if (dump[ind+1])
	{
		mov_ri(&addr,RBX,data[counter]);
		counter+=1;
	}
	mul_rr(&addr,dump[ind+1]); 
	leave(&addr);

	Qword ret_val = func();
	funcfree(func, 4096);

	return ret_val;
}

Qword exec_add(Qword val1, Qword val2)
{   
	byte *addr = allocate_memory();
	dynamic_function *func = (dynamic_function *)addr;

	push(&addr,RBP);
	mov_rr(&addr,RBP,RSP);
	mov_ri(&addr,RAX,val1);
	mov_ri(&addr,RBX,val2);
	add_rr(&addr,dump[ind+1],dump[ind+2]);
	leave(&addr);

	Qword ret_val = func();
	funcfree(func, 4096);

	return ret_val;
}


Qword exec_sub(Qword val1, Qword val2)
{   
	byte *addr = allocate_memory();
	dynamic_function *func = (dynamic_function *)addr;

	push(&addr,RBP);
	mov_rr(&addr,RBP,RSP);
	mov_ri(&addr,RAX,val2);
	mov_ri(&addr,RBX,val1);
	sub_rr(&addr,dump[ind+1],dump[ind+2]);
	leave(&addr);

	Qword ret_val = func();
	funcfree(func, 4096);

	return ret_val;
}

Qword exec_div(Qword val1, Qword val2)
{   
	byte *addr = allocate_memory();
	dynamic_function *func = (dynamic_function *)addr;

	push(&addr,RBP);
	mov_rr(&addr,RBP,RSP);
	mov_ri(&addr,RAX,val1);
	mov_ri(&addr,RBX,val2);
	xor_rr(&addr,RDX,RDX);
	div_rr(&addr,dump[ind+1]);
	mov_rr(&addr,RAX,RDX);
	leave(&addr);

	Qword ret_val = func();
	funcfree(func, 4096);

	return ret_val;
}


Qword exec_xor(Qword val1)
{   
	byte *addr = allocate_memory();
	dynamic_function *func = (dynamic_function *)addr;
	
	static int counter=0;
	Dword data[] = {p6,p7,p8,p9};

	push(&addr,RBP);
	mov_rr(&addr,RBP,RSP);
	mov_ri(&addr,RAX,val1);
	mov_ri(&addr,RBX,data[counter]);
	counter++;
	xor_rr(&addr,dump[ind+1],dump[ind+2]);
	leave(&addr);

	Qword ret_val = func();
	funcfree(func, 4096);

	return ret_val;
}

Qword exec_and(Qword val1, Qword val2)
{   
	byte *addr = allocate_memory();
	dynamic_function *func = (dynamic_function *)addr;
	

	push(&addr,RBP);
	mov_rr(&addr,RBP,RSP);
	mov_ri(&addr,RAX,val1);
	mov_ri(&addr,RBX,val2);
	and_rr(&addr,dump[ind+1],dump[ind+2]);
	leave(&addr);

	Qword ret_val = func();
	funcfree(func, 4096);

	return ret_val;
}

Qword exec_or(Qword val1, Qword val2)
{   
	byte *addr = allocate_memory();
	dynamic_function *func = (dynamic_function *)addr;
	

	push(&addr,RBP);
	mov_rr(&addr,RBP,RSP);
	mov_ri(&addr,RAX,val1);
	mov_ri(&addr,RBX,val2);
	or_rr(&addr,dump[ind+1],dump[ind+2]);
	leave(&addr);

	Qword ret_val = func();
	funcfree(func, 4096);

	return ret_val;
}

void check_2() 
{
	

	Qword values[] = {p1,p1,p1,p2,p1,p2,p1,p2,p2,p3,p4,p3,p4,0};
	size_t ind0 = 1;

	Qword ret_val=values[0];
  	
  	int i=0,j=0;
  	
  	Qword stack[20];
  	Qword rem[4];


	while (1) 
	{
		switch (dump[ind]) 
		{
			case 0x30: //add

				stack[i] = exec_add(stack[--i],stack[--i]);
				i++;
				ind+=3;
				break;

			case 0x31: //sub
				stack[i] = exec_sub(stack[--i],stack[--i]);
				i++;
				ind+=3;
				break;

			case 0x35: //mul
				ret_val = exec_mul(ret_val);
				ind+=2;
				break;

			case 0x36: //xor
				ret_val = exec_xor(rem[--j]^ret_val);
				ind+=3;
				break;

			case 0x37: //and
				ret_val = exec_and(stack[--i],stack[--i]);
				ind+=3;
				break;

			case 0x38: //or
				ret_val = exec_or(stack[--i],stack[--i]);
				ind+=3;
				break;

			case 0x3d: //div
				rem[j] = exec_div(stack[--i],p5);
				ind+=2;
				j++;
				break;

			case 0x3e: // reset stuff
				stack[i++] = ret_val;
				ret_val = values[ind0++];
				ind++;
				break;

			case 0x40: //check

				if (ret_val)
				{
					puts("noooooooooo");
					exit(1);
				}
				else
				{
					puts("noICE");
					exit(0);
				}


			default:
				break;
		}

		

	
	}
}

int main(int argc, char const *argv[])
{
	char input[30];

	fgets(input, 30, stdin);
	input[strlen(input)-1]='\x00';

	if (check_1((byte *)input))
	{
		set((byte *)input);
		check_2();
	}
	else
	{
		puts("noooooooooo");
		exit(1);
	}
	return 0;
}
