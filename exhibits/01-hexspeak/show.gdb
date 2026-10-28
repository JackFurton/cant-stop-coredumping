printf "rax  0x%016lx\n", $rax
printf "rbx  0x%016lx\n", $rbx
printf "rcx  0x%016lx\n", $rcx
printf "rdx  0x%016lx\n", $rdx
printf "rsi  0x%016lx\n", $rsi
printf "rdi  0x%016lx\n", $rdi
printf "r8   0x%016lx\n", $r8
printf "r9   0x%016lx\n", $r9
printf "r10  0x%016lx\n", $r10
printf "r11  0x%016lx\n", $r11
printf "r12  0x%016lx\n", $r12
printf "r13  0x%016lx\n", $r13
printf "r14  0x%016lx\n", $r14
printf "r15  0x%016lx\n", $r15
printf "\nsignal   %d (SIGSEGV)\n", $_siginfo.si_signo
printf "si_addr  %p\n", $_siginfo._sifields._sigfault.si_addr
