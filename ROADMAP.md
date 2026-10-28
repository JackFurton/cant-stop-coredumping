# Roadmap

Each exhibit gets its own issue and its own PR. Roughly ordered by how much of
the core file format it forces us to understand.

## Act I: the notes

- [x] **01 hexspeak**: every GPR holds hexspeak, fault address is `0xdeadbeef`.
- [ ] **02 backtrace poetry**: a call chain whose `bt` reads as a poem.
      Frame pointers, inlining, why `-O2` ruins the verse.
- [ ] **03 thread choir**: `prctl(PR_SET_NAME)` per thread so `info threads`
      spells a message. One `NT_PRSTATUS` per thread.
- [ ] **04 mapping verse**: mmap files with chosen names so
      `info proc mappings` is a poem. `NT_FILE`.
- [ ] **05 gotta crash 'em all**: one exhibit per signal (SEGV, BUS, ILL,
      FPE, ABRT, TRAP), each with its own `si_code` story.

## Act II: the memory

- [ ] **06 hexdump art**: paint a region so `xxd core` shows ASCII art.
- [ ] **07 raw bitmap**: a pixel buffer that comes out of the core as a real
      image. Find the `PT_LOAD` by vaddr, carve it, view as RGB.
- [ ] **08 sculpture**: `MADV_DONTDUMP` and `/proc/self/coredump_filter` to
      cut away everything that isn't art.
- [ ] **09 golf**: smallest core gdb will still load.

## Act III: the forgeries

- [ ] **10 handwritten core**: write a valid ELF core ourselves, no kernel
      involved. gdb must accept it.
- [ ] **11 polyglot**: a core that is also a valid zip (zip is read from the
      end, so the last `PT_LOAD` carries the archive).

## Infrastructure

- [x] `make check` snapshot tests against `expected.txt`
- [ ] CI runs `make check` on every PR
- [ ] Gallery page published from CI output
