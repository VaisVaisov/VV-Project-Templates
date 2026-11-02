# Contributing

Thank you for contributing to this Verilog/FPGA project template!

## Getting Started

```sh
git clone <your-fork>
cd <project>
pre-commit install
```

Everything runs inside the build container:

- **Container: build image** — build `<project>-dev`
- **Run tests: simulation (iverilog)** — compile and run a testbench
- **Static analysis: verilator** — lint the RTL
- **Build: Quartus compile** — synthesis (Quartus is expected on the host under `/opt/intelFPGA`)
- **Upload: program SRAM (SVF)** — flash the FPGA over USB

## Pull Requests

- One PR = one change.
- Run `pre-commit run --all-files` before pushing.
- Run `verilator --lint-only -Wall rtl/*.v` and at least one testbench.
- Describe what the RTL change does and how it was verified.
- Use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.

## Code Style

- Verilog-2001 compatible RTL (works with Quartus II 13.0sp1).
- `default_nettype none` at the top of each source file.
- 4-space indentation, LF line endings (see `.editorconfig`).
- Pre-commit checks whitespace, large files and secrets.

## Reporting Issues

- Check existing issues before creating a new one.
- Include the board, Quartus version, and the exact commands you ran.
- Attach the simulation output or the Quartus report when relevant.
