#!/usr/bin/env bash
# Python memory profiling using tracemalloc (stdlib, no extra deps)
# Output: profiles/memory_stats.txt

ROOT="$(git rev-parse --show-toplevel)"
mkdir -p "$ROOT/profiles"

python "$ROOT/tools/profiler/profile_memory.py"
