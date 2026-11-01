#!/usr/bin/env bash
# Python CPU profiling using py-spy (sampling profiler, no code changes needed)
# Output: profiles/pyspy.svg — open in browser
# Usage: ./tools/profiler/profile-spy.sh [python_script]

ROOT="$(git rev-parse --show-toplevel)"
SCRIPT="${1:-$ROOT/src/main.py}"
mkdir -p "$ROOT/profiles"

py-spy record -o "$ROOT/profiles/pyspy.svg" -- python "$SCRIPT"

echo "Saved: profiles/pyspy.svg — open in browser"
