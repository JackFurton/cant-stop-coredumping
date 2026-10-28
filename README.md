# cant-stop-coredumping

A gallery of beautiful core dumps.

Every program in `exhibits/` exists to crash, and to crash gorgeously: registers
that spell things, backtraces that rhyme, memory you can open as an image. The
joke is load-bearing. Making a core dump pretty on purpose means learning what
is actually in one: ELF program headers, `PT_NOTE` and `PT_LOAD` segments,
`NT_PRSTATUS`, `NT_SIGINFO`, `NT_FILE`, signals, threads, and how gdb stitches
it all back together.

```
$ make 01-hexspeak
painting registers...
rax  0x00000000deadbeef
rbx  0xcafebabecafebabe
rcx  0xfeedfacefeedface
...
si_addr  0xdeadbeef
```

## Setup

Linux, x86-64, `gcc`, `gdb`, `make`.

The kernel has to write cores to a file next to the process instead of piping
them to a crash reporter (apport, systemd-coredump, `wsl-capture-crash`):

```
sudo sysctl kernel.core_pattern=core.%e.%p
```

That resets on reboot. On WSL, persist it in `/etc/wsl.conf`:

```
[boot]
command="sysctl -w kernel.core_pattern=core.%e.%p"
```

`ulimit -c unlimited` is handled by `scripts/crash.sh`, no need to set it in
your shell.

## Usage

```
make 01-hexspeak   # build, crash, render one exhibit
make gallery       # all of them
make check         # every exhibit still matches its approved expected.txt
```

## Exhibits

| # | Exhibit | Look at | Teaches |
|---|---------|---------|---------|
| 01 | [hexspeak](exhibits/01-hexspeak) | registers | `NT_PRSTATUS`, `NT_SIGINFO`, canonical addresses |

See [ROADMAP.md](ROADMAP.md) for what's coming.
