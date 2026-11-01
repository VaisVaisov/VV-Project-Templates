#!/usr/bin/env bash
# Full Python profiling: cProfile, tracemalloc, py-spy
# Usage: ./scripts/profile.sh
set -e

mkdir -p profiles

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
