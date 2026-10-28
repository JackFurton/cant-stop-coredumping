#!/usr/bin/env bash
# Usage: scripts/crash.sh <exhibit-dir> <binary>
# Runs the binary until it dumps core, then prints the exhibit through gdb.
set -euo pipefail

exhibit=$1
bin=$(realpath "$2")
name=$(basename "$bin")
out=build/$(basename "$exhibit")

pattern=$(cat /proc/sys/kernel/core_pattern)
if [[ $pattern == \|* ]]; then
    echo "core_pattern pipes to '$pattern', cores will never land here." >&2
    echo "fix: sudo sysctl kernel.core_pattern=core.%e.%p" >&2
    exit 1
fi

mkdir -p "$out"
rm -f "$out"/core.*
ulimit -c unlimited
(cd "$out" && "$bin") || true

core=$(ls "$out"/core.* 2>/dev/null | head -1 || true)
if [[ -z $core ]]; then
    echo "no core produced for $name" >&2
    exit 1
fi

# everything gdb prints before the marker is load chatter, not the exhibit
gdb -batch -q -nx -ex 'echo @@exhibit\n' -x "$exhibit/show.gdb" "$bin" "$core" 2>/dev/null \
    | sed '1,/^@@exhibit$/d' > "$out/gallery.txt"
cat "$out/gallery.txt"
