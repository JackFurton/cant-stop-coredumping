#include <stdio.h>

/*
 * Every general purpose register except rsp and rbp gets a hexspeak value,
 * then we dereference rax. Leaving rsp/rbp alone keeps gdb's backtrace sane.
 *
 * rax is 0xdeadbeef rather than 0xdeadbeefdeadbeef on purpose: a non-canonical
 * address raises #GP instead of a page fault, and the kernel then reports
 * si_addr as 0 instead of the address we wanted to show off.
 */
__attribute__((noinline)) static void paint_and_crash(void)
{
    __asm__ volatile(
        "movabs $0x00000000deadbeef, %%rax\n\t"
        "movabs $0xcafebabecafebabe, %%rbx\n\t"
        "movabs $0xfeedfacefeedface, %%rcx\n\t"
        "movabs $0x0d15ea5e0d15ea5e, %%rdx\n\t"
        "movabs $0xbaadf00dbaadf00d, %%rsi\n\t"
        "movabs $0x8badf00d8badf00d, %%rdi\n\t"
        "movabs $0xdeadc0dedeadc0de, %%r8\n\t"
        "movabs $0xbaddcafebaddcafe, %%r9\n\t"
        "movabs $0x0defaced0defaced, %%r10\n\t"
        "movabs $0xc0dedbadc0dedbad, %%r11\n\t"
        "movabs $0xfee1deadfee1dead, %%r12\n\t"
        "movabs $0x1badb0021badb002, %%r13\n\t"
        "movabs $0xcafed00dcafed00d, %%r14\n\t"
        "movabs $0x0badc0de0badc0de, %%r15\n\t"
        "movq (%%rax), %%rax\n\t"
        :
        :
        : "rax", "rbx", "rcx", "rdx", "rsi", "rdi",
          "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15", "memory");
}

int main(void)
{
    puts("painting registers...");
    fflush(stdout);
    paint_and_crash();
    return 0;
}
