#!/bin/sh
# Compile and run the testbench with Icarus Verilog (inside the build container).
# Usage: scripts/sim.sh [testbench-name]   (default: blink)
set -eu

TB="${1:-blink}"

mkdir -p build
iverilog -g2012 -Wall -o build/sim.vvp rtl/*.v "sim/tb_${TB}.v"
vvp build/sim.vvp
echo "Waveform: build/dump.vcd"
