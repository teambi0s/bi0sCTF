#include <pthread.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/syscall.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>

void init() {
  setvbuf(stdin, 0, 2, 0);
  setvbuf(stdout, 0, 2, 0);
  setvbuf(stderr, 0, 2, 0);
  alarm(60);
}

void banner()
    {
        syscall(SYS_write, 1, " __        __   ______                         __       ______  \n", 65);
        syscall(SYS_write, 1, "|  \\      |  \\ /      \\                       |  \\     /      \\ \n", 65);
        syscall(SYS_write, 1, "| $$____   \\$$|  $$$$$$\\  _______   _______  _| $$_   |  $$$$$$\\\n", 65);
        syscall(SYS_write, 1, "| $$    \\ |  \\| $$$\\| $$ /       \\ /       \\|   $$ \\  | $$_  \\$$\n", 65);
        syscall(SYS_write, 1, "| $$$$$$$$| $$| $$$$\\ $$|  $$$$$$$|  $$$$$$$ \\$$$$$$  | $$ \\    \n", 65);
        syscall(SYS_write, 1, "| $$  | $$| $$| $$\\$$\\$$ \\$$    \\ | $$        | $$ __ | $$$$    \n", 65);
        syscall(SYS_write, 1, "| $$__/ $$| $$| $$_\\$$$$ _\\$$$$$$\\| $$_____   | $$|  \\| $$      \n", 65);
        syscall(SYS_write, 1, "| $$    $$| $$ \\$$  \\$$$|       $$ \\$$     \\   \\$$  $$| $$      \n", 65);
        syscall(SYS_write, 1, " \\$$$$$$$  \\$$  \\$$$$$$  \\$$$$$$$   \\$$$$$$$    \\$$$$  \\$$      \n", 65);
        syscall(SYS_write, 1, "                                                                \n", 65);
    }


struct arg_struct {
  int arg1;
  int arg2;
} *args;

typedef struct {
  char id[8];
  char name[16];
  int size;
  bool size_input;
  bool thread2_done;
  char buffer2[1024];
  char buffer[1024];

} sh_mem;

void read_input(char *buf, int size) {
  syscall(SYS_read, 0, buf, size);
  syscall(SYS_write, 1, "", 0);
}
void encrypt_text(sh_mem *ptr) {
  sleep(2);
  char key[16] = "2111485077978050";
  char *text = ptr->buffer2;
  int i = 0;
  for(int i = 0; i < 1023; i++){
    text[i] = text[i] ^ key[i % 16];
  }
}

void encrypt_buffer1(sh_mem *ptr) {
  char key[16] = "2111485077978050";
  char *text = ptr->buffer;
  int i = 0;
  for(int i = 0; i < 1023; i++){
    text[i] = text[i] ^ key[i % 16];
  }
}

void menu() {
  syscall(SYS_write, 1, "\n1. Store Note\n", 15);
  syscall(SYS_write, 1, "2. Delete Note\n", 15);
  syscall(SYS_write, 1, "3. Print Note\n", 14);
  syscall(SYS_write, 1, "4. Upgrade Note\n", 16);
  syscall(SYS_write, 1, "5. Encrypt/Decrypt\n", 19);
  syscall(SYS_write, 1, "6. Exit\n", 8);
}

void store_note(sh_mem *ptr) {
  syscall(SYS_write, 1, "Enter Note ID: ", 15);
  read_input(ptr->id, 8);
  syscall(SYS_write, 1, "Enter Note Name: ", 17);
  read_input(ptr->name, 16);
  syscall(SYS_write, 1, "Enter Note Size: ", 17);
  scanf("%d", &ptr->size);
  syscall(SYS_write, 1, "Enter Note Content: ", 20);
  read_input(ptr->buffer, ptr->size);
  ptr->size_input = true;
}

void delete_note(sh_mem *ptr) {
  syscall(SYS_write, 1, "Enter Note ID: ", 15);
  read_input(ptr->id, 8);
  memset(ptr->buffer, 0, 0x100);
}

void print_note(sh_mem *ptr) {
  syscall(SYS_write, 1, "Enter Note ID: ", 15);
  read_input(ptr->id, 8);
  syscall(SYS_write, 1, "Note Name: ", 11);
  syscall(SYS_write, 1, ptr->name, 16);
  syscall(SYS_write, 1, "Note Content: ", 14);
  syscall(SYS_write, 1, ptr->buffer, ptr->size);
}

void upgrade_note(sh_mem *ptr) {
    if(ptr->thread2_done == false){
        syscall(SYS_write, 1, "Error\n", 6);
        return;
    }
  syscall(SYS_write, 1, "Enter Note Size: ", 17);
  scanf("%d", &ptr->size);
  syscall(SYS_write, 1, "Enter Name: ", 12);
  read_input(ptr->name, 0x10);
}

void encrypt_decrypt(sh_mem *ptr) {
  syscall(SYS_write, 1, "Enter Note ID: ", 15);
  read_input(ptr->id, 8);
  syscall(SYS_write, 1, "Enter Note Content: ", 20);
  read_input(ptr->buffer, 1023);
  encrypt_buffer1(ptr);
  syscall(SYS_write, 1, "\nDone\n", 6);
}

void *thread1(sh_mem *ptr) {
  menu();
  int choice;
  while (1) {
    syscall(SYS_write, 1, "Enter Choice: ", 14);
    scanf("%d", &choice);
    switch (choice) {
    case 1:
      store_note(ptr);
      break;
    case 2:
      delete_note(ptr);
      break;
    case 3:
      print_note(ptr);
      break;
    case 4:
      upgrade_note(ptr);
      break;
    case 5:
      encrypt_decrypt(ptr);
      break;
    case 6:
      exit(0);
    default:
      syscall(SYS_write, 1, "Invalid Choice\n", 15);
    }
  }
}

void process(sh_mem *ptr){
  sleep(2);
    if (ptr->size > 64 || ptr->size < 0) {
    syscall(SYS_write, 1, "Size Limit Exceeded\n", 20);
    exit(0);
  }  
  encrypt_text(ptr);
  char msg[64];
  sleep(1);
  syscall(SYS_write, 1, "Sent!\n", 6);
  memcpy(msg, ptr->buffer, ptr->size);  
}

void *thread2(sh_mem *ptr) {
  while(true){
    ptr->size_input = false;
  while (ptr->size_input == false) {
  }
  process(ptr);
  ptr->thread2_done = true;
  }
}

void gadgets() {
  __asm__("pop %rdi;" 
          "ret;");
  __asm__("syscall;");
}

int main() {
  init();
  banner();
  alarm(60);
  key_t my_key = (key_t)getpid(); 
  int shmid = shmget(my_key, 2048, 0666 | IPC_CREAT);
  if (shmid == -1) {
    syscall(SYS_write, 1, "Error in shmget\n", 17);
    return 0;
  }
  sh_mem *ptr = shmat(shmid, (void *)0, 0);
  if (ptr == (void *)-1) {
    syscall(SYS_write, 1, "Error in shmat\n", 16);
    return 0;
  }
  memset(ptr, 0, 2048);
  ptr->thread2_done = false;
  pthread_t tid[2];
  int p1 = pthread_create(&tid[0], NULL, thread2, ptr);
  if (p1 != 0) {
    syscall(SYS_write, 1, "Error in creating thread 1\n", 28);
  }

  int p2 = pthread_create(&tid[1], NULL, thread1, ptr);
  if (p2 != 0) {
    syscall(SYS_write, 1, "Error in creating thread 2\n", 28);
  }

  for (int i = 0; i < 2; i++) {
    pthread_join(tid[i], NULL);
  }

  shmdt(ptr);
  shmctl(shmid, IPC_RMID, NULL);

  syscall(SYS_write, 1, "Done!\n", 6);

  exit(0);
}