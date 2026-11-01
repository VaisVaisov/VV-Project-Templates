#!/bin/sh
# Lint the RTL with Verilator (inside the build container).
set -eu

verilator --lint-only -Wall rtl/*.v
echo "verilator: no issues"
