#!/usr/bin/env bash
# Full profiling: C++ (valgrind suite) + Python (cProfile, tracemalloc, py-spy)
# Requires: Docker image 'profiler-tool'
#   Build: cd tools/profiler && docker build -t profiler-tool .
# Usage: ./scripts/profile.sh <cpp_binary_name>
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <cpp_binary_name>"
    exit 1
fi

BINARY=$1
mkdir -p profiles

echo "========================================"
echo " C++ Profiling"
echo "========================================"

echo -e "\n--- memcheck (memory leaks) ---"
tools/profiler/run-memcheck.sh "$BINARY"

echo -e "\n--- callgrind (CPU) ---"
tools/profiler/run-callgrind.sh "$BINARY"

echo -e "\n--- cachegrind (cache misses) ---"
tools/profiler/run-cachegrind.sh "$BINARY"

echo -e "\n--- massif (heap over time) ---"
tools/profiler/run-massif.sh "$BINARY"

echo -e "\n--- helgrind (data races) ---"
tools/profiler/run-helgrind.sh "$BINARY"

echo -e "\n--- drd (data races, sensitive) ---"
tools/profiler/run-drd.sh "$BINARY"

echo ""
echo "========================================"
echo " Python Profiling"
echo "========================================"

echo -e "\n--- cProfile ---"
tools/profiler/profile-python.sh

echo -e "\n--- memory (tracemalloc) ---"
tools/profiler/profile-memory.sh

echo -e "\n--- py-spy flamegraph ---"
tools/profiler/profile-spy.sh

echo ""
echo "========================================"
echo " Results"
echo "========================================"
echo ""
echo "  C++ CPU (callgrind):"
echo "    profiles/callgrind.out"
echo "    → https://speedscope.app — open in browser and drag the file"
echo "    → or: npm install -g speedscope && speedscope profiles/callgrind.out"
echo ""
echo "  C++ cache (cachegrind):"
echo "    profiles/cachegrind.out"
echo "    → https://speedscope.app — open in browser and drag the file"
echo ""
echo "  C++ heap (massif):"
echo "    profiles/massif.out"
echo "    → ms_print profiles/massif.out  (text output in terminal)"
echo ""
echo "  Python CPU (cProfile):"
echo "    profiles/profile.prof"
echo "    → snakeviz profiles/profile.prof  (opens browser)"
echo ""
echo "  Python memory (tracemalloc):"
echo "    profiles/memory_stats.txt"
echo "    → cat profiles/memory_stats.txt"
echo ""
echo "  Python flamegraph (py-spy):"
echo "    profiles/pyspy.svg"
echo "    → open in any browser"
echo ""
echo "========================================"
