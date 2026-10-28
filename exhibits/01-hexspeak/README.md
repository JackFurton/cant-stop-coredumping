# 01 hexspeak

Fourteen general purpose registers, fourteen hexspeak words, one crash.

```
rax  0x00000000deadbeef
rbx  0xcafebabecafebabe
rcx  0xfeedfacefeedface
rdx  0x0d15ea5e0d15ea5e
rsi  0xbaadf00dbaadf00d
rdi  0x8badf00d8badf00d
r8   0xdeadc0dedeadc0de
r9   0xbaddcafebaddcafe
r10  0x0defaced0defaced
r11  0xc0dedbadc0dedbad
r12  0xfee1deadfee1dead
r13  0x1badb0021badb002
r14  0xcafed00dcafed00d
r15  0x0badc0de0badc0de

signal   11 (SIGSEGV)
si_addr  0xdeadbeef
```

## How it ends up in the core

When a process dies from a signal, the kernel writes an ELF file of type
`ET_CORE`. Its `PT_NOTE` segment holds one `NT_PRSTATUS` note per thread, and
inside that is a `struct user_regs_struct`: the exact register state at the
faulting instruction. gdb's `$rax` on a core is just a read out of that note.
See it raw with `readelf --notes build/01-hexspeak/core.*`.

`$_siginfo` comes from a separate `NT_SIGINFO` note, which is how gdb knows
the fault address without having to decode the instruction.

## Why rax is only 32 bits of beef

x86-64 addresses are 48 bits (57 with 5-level paging), and the top bits must
copy bit 47. `0xdeadbeefdeadbeef` breaks that rule, so dereferencing it raises
a general protection fault rather than a page fault. The kernel does not know
which address was at fault for a #GP, and reports `si_addr` as `0`.
`0x00000000deadbeef` is canonical and unmapped, so it page faults and the
address survives into the core.

## Why rsp and rbp are left alone

Clobber them and gdb can't unwind past frame 0. That's a different exhibit.

## Where the words come from

- `0xcafebabe`: Java class file magic, also Mach-O fat binaries
- `0xfeedface`: Mach-O 32-bit magic
- `0x8badf00d`: iOS watchdog kill code ("ate bad food")
- `0xbaadf00d`: Windows `LocalAlloc(LMEM_FIXED)` uninitialised heap
- `0xfee1dead`: `LINUX_REBOOT_MAGIC1`, the first magic arg to `reboot(2)`
- `0x1badb002`: Multiboot header magic
- `0x0d15ea5e`: Nintendo GameCube/Wii boot magic
