#!/usr/bin/env bash
# Python CPU profiling using cProfile
# Visualize: snakeviz profiles/profile.prof

ROOT="$(git rev-parse --show-toplevel)"
mkdir -p "$ROOT/profiles"

python -m cProfile -o "$ROOT/profiles/profile.prof" "$ROOT/src/main.py"

echo "Saved: profiles/profile.prof — visualize: snakeviz profiles/profile.prof"
