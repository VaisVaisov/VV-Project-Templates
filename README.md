# IT Project Templates

<div align="center">

![License](https://img.shields.io/badge/license-MIT-E91E63?style=for-the-badge&labelColor=0D1117)
![Stars](https://img.shields.io/github/stars/VaisVaisov/IT-Project-Templates?style=for-the-badge&labelColor=0D1117&color=E91E63&logo=github&logoColor=white)
![Last Commit](https://img.shields.io/github/last-commit/VaisVaisov/IT-Project-Templates?style=for-the-badge&labelColor=0D1117&color=00BCD4&logo=git&logoColor=white)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-00BCD4?style=for-the-badge&labelColor=0D1117)

**Ready-to-use project templates with VS Code Dev Containers**

*Arch Linux · Clang toolchain · AI coding agents pre-installed*

[Templates](#available-templates) • [Quick Start](#quick-start) • [Installation](#installation) • [Dev Containers](#dev-container-features) • [CI/CD](#code-quality--cicd) • [PlatformIO](#platformio-templates) • [Features](#features--how-to-use)

**[🇷🇺 Русский](README.ru.md)**

</div>

---

## What is this?

A collection of project templates that let you start developing in minutes. Each template ships with a fully configured **VS Code Dev Container** based on Arch Linux — the same environment on any machine, regardless of the host OS.

### Why use this?

- 🚀 **Zero setup**: open in VS Code, click "Reopen in Container" — start coding immediately
- 🤖 **AI-ready**: Claude Code, Qwen Code and Cline pre-installed in every container
- 🔒 **Quality gates**: pre-commit hooks catch issues before they reach the repository
- ⚙️ **CI/CD included**: GitHub Actions for linting, building, testing, coverage, docs and releases
- 📝 **Conventional Commits**: commitlint enforces commit message format
- 🌍 **Cross-platform**: one script works on Linux, macOS and Windows (via WSL2)

---

## Available Templates

### C/C++ (`c-cpp/`)

| Template | Description |
| --- | --- |
| `pure` | C/C++ with CMake, Ninja, GoogleTest, Google Benchmark, Doxygen, lcov coverage |
| `hybrid` | C/C++ + Python/Cython — both languages in one project, Sphinx + ReadTheDocs |
| `platformio/` | Embedded development (Arduino, ESP32, ESP8266, Pico, STM32) |

### Python (`python/`)

| Template | Description |
| --- | --- |
| `pure` | Python with pytest, ruff, pylint, mypy, Sphinx + ReadTheDocs |

### Verilog / FPGA (`verilog/`)

| Template | Description |
| --- | --- |
| `pure` | Verilog HDL with Icarus Verilog, Verilator, GTKWave, Quartus + openFPGALoader — every task runs inside a Docker build container |

> **Note:** creating a Verilog project builds its Docker image on the spot, so it **requires network access** (the build pulls packages from the mirrors). Pass `--no-host-network` to build with the default Docker network instead of `--network=host`.

### PlatformIO Devices (`c-cpp/platformio/`)

| Directory | Board | Architecture | Wokwi CI |
| --- | --- | --- | --- |
| `arduino-nano` | Arduino Nano | ATmega328P (AVR) | ✓ |
| `arduino-pro-micro` | Arduino Pro Micro | ATmega32U4 (AVR, USB HID) | ✓ |
| `esp32-devkit` | ESP32 DevKit V1 | Xtensa LX6, WiFi + BT | ✓ |
| `esp32-s2-saola` | ESP32-S2 Saola | Xtensa LX7, USB OTG | ✓ |
| `esp32-s3-devkitc` | ESP32-S3 DevKitC | Xtensa LX7, AI+IoT | ✓ |
| `esp32-c3-devkitm` | ESP32-C3 DevKitM | RISC-V, WiFi + BT | ✓ |
| `esp32-c6-devkitc` | ESP32-C6 DevKitC | RISC-V, WiFi 6 + Zigbee | ✓ |
| `esp32-h2-devkitm` | ESP32-H2 DevKitM | RISC-V, Zigbee + Thread | ✓ |
| `esp8266-wemos-d1-mini` | Wemos D1 Mini | ESP8266, WiFi | — |
| `rpi-pico` | Raspberry Pi Pico | RP2040, ARM Cortex-M0+ | ✓ |
| `stm32f411-blackpill` | STM32F411 Black Pill | Cortex-M4, 100 MHz | ✓ * |
| `stm32f103-bluepill` | STM32F103 Blue Pill | Cortex-M3, 72 MHz | ✓ |

> \* STM32F411: Wokwi uses `board-st-nucleo-f411re` (same MCU, different pinout) — see [PlatformIO](#platformio-templates) section. ESP8266: Wokwi not supported — build only.

---

## Quick Start

### Linux / macOS

```bash
# Clone anywhere you like
git clone https://github.com/VaisVaisov/IT-Project-Templates.git ~/IT-Project-Templates

# Create a symlink in ~/.local/bin
ln -s ~/IT-Project-Templates/new-project.sh ~/.local/bin/new-project

# Create a new project
new-project --c-cpp --pure ~/Projects/my_cpp_app
new-project --python --pure ~/Projects/my_python_app
new-project --c-cpp --hybrid ~/Projects/my_hybrid_app
new-project --c-cpp --platformio --esp32-devkit ~/Projects/sensor_node
```

### Windows (WSL2)

On Windows, the entire ecosystem runs through WSL2. Install WSL2 and use the same script:

```bash
# Clone into WSL2 home
git clone https://github.com/VaisVaisov/IT-Project-Templates.git ~/IT-Project-Templates

# Create a symlink in ~/.local/bin (in WSL2)
ln -s ~/IT-Project-Templates/new-project.sh ~/.local/bin/new-project

# Create a new project (from WSL2)
new-project --c-cpp --pure ~/Projects/my_cpp_app
new-project --python --pure ~/Projects/my_python_app
new-project --c-cpp --hybrid ~/Projects/my_hybrid_app
new-project --c-cpp --platformio --esp32-devkit ~/Projects/sensor_node
```

### After creating a project

By default a project is created in **build-only container** mode: the image
`<project>-dev` is built right away, and `.devcontainer/devcontainer.json` is
not generated. Use the VS Code tasks:

- **Container: build image** — (re)build `<project>-dev`
- **Container: rebuild image** — rebuild without the layer cache
- **Container: shell** — open a shell inside the container

Pass `--dev-container` to keep `devcontainer.json` and open the project with
"Reopen in Container" instead.

---

## Usage Reference

```
new-project [--help] <language> <type> [device] <path>

Language:
  --c-cpp            C/C++ project
  --python           Python project

Type:
  --pure             Pure C/C++ or Python
  --hybrid           Hybrid C/C++ + Python/Cython  (--c-cpp only)
  --platformio       Embedded development           (--c-cpp only)

PlatformIO devices (Arduino):
  --arduino-nano          Arduino Nano (ATmega328P)
  --arduino-pro-micro     Arduino Pro Micro (ATmega32U4, USB HID)

PlatformIO devices (ESP32):
  --esp32-devkit          ESP32 DevKit V1 (Xtensa LX6, WiFi + BT)
  --esp32-s2-saola        ESP32-S2 Saola (Xtensa LX7, USB OTG)
  --esp32-s3-devkitc      ESP32-S3 DevKitC (Xtensa LX7, AI+IoT)
  --esp32-c3-devkitm      ESP32-C3 DevKitM (RISC-V, WiFi + BT)
  --esp32-c6-devkitc      ESP32-C6 DevKitC (RISC-V, WiFi 6 + Zigbee)
  --esp32-h2-devkitm      ESP32-H2 DevKitM (RISC-V, Zigbee + Thread)

PlatformIO devices (other):
  --esp8266-wemos-d1-mini Wemos D1 Mini (ESP8266, WiFi) — build only, no Wokwi
  --rpi-pico              Raspberry Pi Pico (RP2040, dual-core ARM Cortex-M0+)
  --stm32f411-blackpill   STM32F411 Black Pill (Cortex-M4, 100 MHz)
  --stm32f103-bluepill    STM32F103 Blue Pill (Cortex-M3, 72 MHz)

Options:
  --help, -h         Show this help and exit
```

---

## Installation

### 1. Clone the repository

```bash
# Linux / macOS / Windows (WSL2)
git clone https://github.com/VaisVaisov/IT-Project-Templates.git ~/IT-Project-Templates
```

### 2. Create a symlink

```bash
ln -s ~/IT-Project-Templates/new-project.sh ~/.local/bin/new-project
```

> **Note:** `new-project.sh` is already executable after cloning. If not: `chmod +x new-project.sh`

### 3. Prerequisites

| Tool | Linux / macOS | Windows |
| --- | --- | --- |
| **Docker** | Required — [docker.com](https://www.docker.com/) | Required — [Docker Desktop](https://www.docker.com/products/docker-desktop/) |
| **WSL2** | — | Required — [WSL2 install guide](https://learn.microsoft.com/en-us/windows/wsl/install) + **WSL** extension in VS Code |
| **VS Code** | Required — [code.visualstudio.com](https://code.visualstudio.com/) | Required |
| **Dev Containers extension** | Required — install from VS Code | Required (open project from WSL2) |
| **GitHub CLI** | Recommended | Recommended (for Windows — in WSL2) |
| **uv** | For hybrid/python templates — [astral.sh/uv](https://astral.sh/uv) | For hybrid/python templates — install in WSL2 |
| **Git** | Required | Required — install in WSL2 |

> **GitHub CLI tip:** authenticate once on the host (for Windows — in WSL2) with `gh auth login`. The container mounts `~/.config/gh` from the host — no re-authentication needed inside Dev Containers.

---

## Project Structure

```
IT-Project-Templates/
├── .github/
│   └── dependabot.yml          # Automated dependency updates (Actions + pre-commit)
├── c-cpp/
│   ├── pure/                   # Pure C/C++ template
│   │   ├── .devcontainer/      # Clang + CMake + Ninja + GDB + lcov + valgrind
│   │   ├── .github/
│   │   │   ├── workflows/      # ci.yml + release.yml
│   │   │   └── ISSUE_TEMPLATE/
│   │   ├── .vscode/
│   │   ├── benchmarks/         # Google Benchmark examples
│   │   ├── tools/profiler/     # Valgrind + perf scripts
│   │   └── ...
│   ├── hybrid/                 # C/C++ + Python/Cython template
│   │   ├── .devcontainer/      # Clang + Python + Cython + ruff + pylint
│   │   ├── .github/
│   │   │   ├── workflows/      # ci.yml + release.yml
│   │   │   └── ISSUE_TEMPLATE/
│   │   ├── .vscode/
│   │   ├── benchmarks/         # Google Benchmark examples
│   │   ├── tools/profiler/     # Valgrind + perf + Python profilers
│   │   └── ...
│   └── platformio/             # Embedded templates
│       ├── devcontainers/      # Dev containers per board family
│       │   ├── base/           # Arduino + ESP (PlatformIO + Clang)
│       │   ├── stm32/          # STM32 (+ ST-Link tools + GDB)
│       │   └── pico/           # Raspberry Pi Pico (+ picotool)
│       ├── .vscode/            # Shared VS Code config
│       ├── arduino/            # Arduino family template
│       ├── esp32/              # ESP32 family template
│       ├── esp8266/            # ESP8266 family template
│       ├── stm32/              # STM32 family template
│       └── pico/               # Raspberry Pi Pico template
├── python/
│   └── pure/                   # Pure Python template
│       ├── .devcontainer/      # Python + ruff + pylint + mypy
│       ├── .github/
│       │   ├── workflows/      # ci.yml + release.yml
│       │   └── ISSUE_TEMPLATE/
│       ├── .vscode/
│       ├── tools/profiler/     # Python profilers
│       └── ...
├── meta-template/              # Base for creating new templates
├── new-project.sh              # Script for Linux / macOS / Windows (WSL2)
├── LICENSE
└── README.md
```

---

## Dev Container Features

Every container is built on **Arch Linux (latest)** and includes:

- **Shell**: Zsh with Oh My Zsh + Powerlevel10k
- **Editor**: Neovim
- **VCS**: Git, git-delta, GitHub CLI
- **AI agents**: Claude Code, Qwen Code, Cline CLI (from AUR) — all available as CLI tools
- **Docker**: Docker + Docker Buildx + Lazydocker (for running containers inside containers)
- **GitHub auth**: `~/.config/gh` mounted from the host — no re-authentication needed

### C/C++ containers

- Clang, LLD, LLDB, compiler-rt
- CMake, Ninja
- GDB, valgrind
- cppcheck, lcov
- pre-commit

### Hybrid containers (C/C++ + Python)

Everything from C/C++, plus:

- Python 3, pip, uv, virtualenv
- Cython, NumPy
- pytest, pytest-cov
- ruff, pylint, mypy
- Sphinx, furo, breathe (documentation)
- py-spy, memory-profiler (Python profiling)

### Python containers

- Python 3, pip, uv, virtualenv
- pytest, pytest-cov
- ruff, pylint, mypy
- Sphinx, furo
- pre-commit

### PlatformIO containers (Arduino + ESP)

- PlatformIO Core + udev rules
- Clang, cppcheck (static analysis)
- Python 3, pip
- pre-commit
- USB device access (container runs with `--privileged`)

### PlatformIO containers (STM32)

Everything from Arduino + ESP, plus:

- stlink (`st-flash`, `st-info`, `st-util` — flashing and debugging via ST-Link)
- GDB (debugger for connecting to the `st-util` GDB server)

### PlatformIO containers (Pico)

Everything from Arduino + ESP, plus:

- picotool (Raspberry Pi Pico firmware management without BOOTSEL)

---

## VS Code Extensions

All templates auto-install extensions when opening in a Dev Container and show them as recommendations when opening without Docker.

### Common (all templates)

| Category | Extension | Purpose |
| --- | --- | --- |
| **AI** | Claude Code | AI agent (CLI + VS Code) |
| | TONGYI Lingma | AI assistant and code completion |
| | Cline | AI agent supporting 400+ models |
| **Git** | GitLens | Advanced Git features (blame, history) |
| | Git Graph | Visual commit graph |
| **Code Quality** | Better Comments | Colorful TODO/FIXME/NOTE comments |
| | Code Spell Checker | Spell checking in code and comments |
| **Docker** | Docker | Container management |
| **Markdown** | Markdown All in One | Full Markdown support |
| | Markdown Converter | Export to PDF/HTML/Word |
| **Formats** | YAML (Red Hat) | YAML support |
| | JSON (Meezilla) | Enhanced JSON editing |

### C/C++ templates

- **C/C++ Tools** — IntelliSense and debugging
- **clangd** — Advanced code analysis and navigation
- **Code Runner** — Quick code execution

### Python templates

- **Python** + **Pylance** — Core support and language server
- **debugpy** — Python debugger
- **Python Envs** — Virtual environment management
- **autodocstring** — Auto-generate docstrings
- **Django** + **Jinja** — Framework support (Pure Python)

### Hybrid templates

All C/C++ and Python extensions combined.

### PlatformIO templates

- **PlatformIO IDE** — Embedded development platform
- **Wokwi Simulator** — Interactive Arduino/ESP32/STM32 simulator directly in VS Code
- **C/C++ Tools** — Microcontroller code support

---

## Code Quality & CI/CD

### Pre-commit Hooks

Hooks run automatically before each commit. Both regular hooks and the commit-msg hook are installed when the Dev Container starts (`postCreateCommand`).

#### C/C++ projects
- **clang-format** — Automatic code formatting (LLVM style)
- **clang-tidy** — Static analysis for bugs and style issues
- **cppcheck** — Memory leaks, null pointer checks, undefined behaviour
- **valgrind memcheck** — Runtime memory error detection (hybrid + pure)

#### Python projects
- **ruff** — Fast linting + import sorting (replaces flake8 + isort)
- **ruff-format** — Code formatting (black-compatible)
- **pylint** — Deep semantic analysis: unreachable code, wrong argument counts, missing attributes
- **mypy** — Static type checking

#### All projects
- **commitlint** — Enforces [Conventional Commits](https://www.conventionalcommits.org/) format
- **detect-secrets** — Blocks commits containing secrets (API keys, tokens, passwords)
- YAML validation
- Large file detection (> 1 MB)
- Trailing whitespace removal
- End-of-file fixer
- Merge conflict detection

> If a hook fails, the commit is blocked until the issue is fixed. This keeps broken code out of the repository.

### GitHub Actions

Each template includes two workflows: `ci.yml` (runs on every push/PR) and `release.yml` (runs on `v*` tags).

#### C/C++ Pure & Hybrid
- **Lint**: pre-commit checks (clang-format, clang-tidy, cppcheck, commitlint)
- **Build**: CMake Debug + Release presets
- **Test**: GoogleTest suites via ctest
- **Benchmark**: runs Google Benchmark binaries (if present in `benchmarks/`)
- **Coverage**: gcov + lcov — HTML report + summary in GitHub Actions UI + coverage badge on GitHub Pages
- **Sanitize ASan**: AddressSanitizer + UBSan + LeakSanitizer — memory errors and UB detection
- **Sanitize MSan**: MemorySanitizer (Clang) — uninitialized memory reads
- **Sanitize TSan**: ThreadSanitizer — data races in multithreaded code
- **Valgrind**: `ctest -T memcheck` — detailed memory analysis across the full test suite
- **Matrix**: Python 3.10–3.13 (hybrid only)
- **Security**: Trivy — CVE scanning (HIGH/CRITICAL, blocks merge)
- **Docs**: Doxygen (pure) or Doxygen + Sphinx/furo (hybrid) → GitHub Pages on `main`
- **Release**: on `v*` tag — git-cliff generates CHANGELOG, builds artifacts, creates GitHub Release

#### Python Pure
- **Lint**: pre-commit checks (ruff, pylint, mypy, commitlint)
- **Test**: pytest + coverage summary in GitHub Actions UI + PR coverage comment
- **Coverage badge**: published to GitHub Pages on `main`
- **Matrix**: Python 3.10–3.13
- **Security**: Trivy — CVE scanning (HIGH/CRITICAL, blocks merge)
- **Docs**: Sphinx + furo → GitHub Pages (`main`) + ReadTheDocs (all branches/tags)
- **Release**: on `v*` tag — git-cliff generates CHANGELOG, builds wheel + sdist, creates GitHub Release

All workflows run on **Arch Linux containers** for full consistency with the development environment.

### Dependabot

A `.github/dependabot.yml` in the root of this repository automatically keeps all templates up to date by opening PRs when new versions are available. Covers:

- **GitHub Actions** versions (actions/checkout, upload-artifact, etc.)
- **pre-commit hook** revisions (clang-format, ruff, mypy, pylint, etc.)

Updates are checked weekly — no manual version tracking needed.

### AI Agent Context

Every generated project includes a `@PROJECT_NAME@.md` file — a single source of truth describing the project architecture, tech stack, build instructions, and rules for AI agents. `CLAUDE.md`, `QWEN.md`, and `AGENTS.md` are symlinks pointing to this file, so Claude Code, Qwen Code, and Cline all read the same context automatically.

---

## PlatformIO Templates

### Supported Boards

| Directory | Board | Architecture | Wokwi CI |
| --- | --- | --- | --- |
| `arduino-nano` | Arduino Nano | ATmega328P (AVR) | ✓ |
| `arduino-pro-micro` | Arduino Pro Micro | ATmega32U4 (AVR, USB HID) | ✓ |
| `esp32-devkit` | ESP32 DevKit V1 | Xtensa LX6, WiFi + BT | ✓ |
| `esp32-s2-saola` | ESP32-S2 Saola | Xtensa LX7, USB OTG | ✓ |
| `esp32-s3-devkitc` | ESP32-S3 DevKitC | Xtensa LX7, AI+IoT | ✓ |
| `esp32-c3-devkitm` | ESP32-C3 DevKitM | RISC-V, WiFi + BT | ✓ |
| `esp32-c6-devkitc` | ESP32-C6 DevKitC | RISC-V, WiFi 6 + Zigbee | ✓ |
| `esp32-h2-devkitm` | ESP32-H2 DevKitM | RISC-V, Zigbee + Thread | ✓ |
| `esp8266-wemos-d1-mini` | Wemos D1 Mini | ESP8266, WiFi | — |
| `rpi-pico` | Raspberry Pi Pico | RP2040, ARM Cortex-M0+ | ✓ |
| `stm32f411-blackpill` | STM32F411 Black Pill | Cortex-M4, 100 MHz | ✓ * |
| `stm32f103-bluepill` | STM32F103 Blue Pill | Cortex-M3, 72 MHz | ✓ |

> \* STM32F411: Wokwi does not support BlackPill directly — `diagram.json` uses `board-st-nucleo-f411re` (same STM32F411 MCU, different pinout). ESP8266: Wokwi not supported — build only.

### Wokwi: Simulation Without Hardware

Wokwi lets you run firmware in the browser or VS Code without physical hardware.

**`diagram.json` schematic:**
Draw your circuit on [wokwi.com](https://wokwi.com), download `diagram.json` and place it in the project root. Wokwi CI and the VS Code extension share the same file.

**VS Code setup:**
1. Install the **Wokwi Simulator** extension
2. Activate the license (free for personal projects) via `Ctrl+Shift+P` → "Wokwi: Request Free License"
3. Open `diagram.json` in the project root — the schematic opens in the Wokwi editor
4. Press ▶ to start simulation

**Wokwi CI setup (GitHub Actions):**
1. Get a token at [wokwi.com/ci](https://wokwi.com/ci)
2. Add to GitHub Secrets: `Settings` → `Secrets and variables` → `Actions` → `New repository secret` → `WOKWI_CLI_TOKEN`
3. CI will automatically run the simulation and verify Serial output

### Basic Commands

```bash
pio run                        # Build firmware
pio run -t upload              # Build and upload to device
pio device monitor             # Open Serial Monitor
pio device monitor --baud 115200
pio test                       # Run unit tests on device
pio run --target size          # Firmware size report
pio check                      # Static analysis
```

### Framework Selection

All templates use `framework = arduino` by default. Change it in `platformio.ini`:

```ini
[env:esp32dev]
platform = espressif32
board    = esp32dev
framework = arduino      ; default — rich library ecosystem

; Alternatives (uncomment as needed):
; framework = espidf     ; ESP-IDF — full control, native Espressif SDK
; framework = arduino    ; can be combined with ESP-IDF components
```

| Framework | Platform | When to use |
| --- | --- | --- |
| `arduino` | All | Maximum ready-made libraries, fast start |
| `espidf` | ESP32 | Full control, Bluetooth/WiFi stack, FreeRTOS |
| `arduino` (with ESP-IDF) | ESP32 | Arduino libraries + ESP-IDF components |
| `pico-sdk` | Raspberry Pi Pico | Direct access to RP2040 SDK |
| `arduino` | Pico | Arduino ecosystem compatibility |

### Uploading Firmware

The upload protocol is set in `platformio.ini`:

```ini
; upload_protocol = esptool     ; ESP32/ESP8266 — USB UART (default)
; upload_protocol = espota      ; ESP32/ESP8266 — OTA (over the air)
; upload_protocol = esp-prog    ; ESP32 — JTAG debugger
; upload_protocol = stlink      ; STM32 — ST-Link programmer
; upload_protocol = picotool    ; Raspberry Pi Pico — USB (hold BOOTSEL)
; upload_protocol = arduino     ; Arduino AVR — via bootloader
; upload_protocol = usbasp      ; Arduino AVR — USBasp programmer
```

### CI/CD

- **Lint**: pre-commit checks (clang-format, cppcheck, commitlint)
- **Build**: `pio run` — firmware compilation
- **Test**: `pio test` (if test directory exists)
- **Size**: `pio run --target size` — firmware size report
- **Static analysis**: `pio check --fail-on-defect high`
- **Wokwi CI**: cloud firmware simulation (except ESP8266) — setup in the [Wokwi](#wokwi-simulation-without-hardware) section above
- **Release**: on `v*` tag — uploads `.elf`/`.hex`/`.bin` to GitHub Release

Workflows run on **Arch Linux containers** for full consistency with the development environment.

---

## Features & How to Use

### Tests

#### C/C++ (GoogleTest)

```bash
# Build and run all tests
cmake --preset linux-debug && cmake --build --preset linux-debug
cd cmake-build-linux-debug && ctest --output-on-failure

# Run a specific test
ctest -R MyTest --output-on-failure

# Verbose output
ctest -V
```

Tests live in `test/`. Every `*_test.cpp` is picked up by CMake automatically.

#### Python (pytest)

```bash
# Run all tests
python -m pytest -v

# Specific file or test
python -m pytest tests/test_module.py::test_function -v

# Short traceback on failure
python -m pytest -v --tb=short
```

---

### Code Coverage

#### C++ — lcov

```bash
# Build with coverage
cmake --preset linux-coverage && cmake --build --preset linux-coverage

# Run tests and generate report
cd cmake-build-linux-coverage
ctest --output-on-failure
lcov --capture --directory . --output-file coverage.info
lcov --remove coverage.info '/usr/*' '*/libraries/*' '*/test/*' --output-file coverage.info
genhtml coverage.info --output-directory coverage-html

# Open report in browser
xdg-open coverage-html/index.html
```

The HTML report shows coverage per file, function, and line. Green = covered, red = not covered.

#### Python — pytest-cov

```bash
# Coverage with terminal output
python -m pytest --cov --cov-report=term

# HTML report
python -m pytest --cov --cov-report=html
xdg-open htmlcov/index.html

# Show uncovered lines
python -m pytest --cov --cov-report=term-missing
```

#### Badges and PR Comments

After pushing to `main`, GitHub Actions automatically publishes a coverage badge to GitHub Pages. On every PR, a comment shows the current coverage percentage.

---

### Google Benchmark

Google Benchmark measures the performance of individual functions with nanosecond precision.

```bash
# Build in Release (required — Debug distorts results)
cmake --preset linux-release && cmake --build --preset linux-release

# Run all benchmarks
./cmake-build-linux-release/bench_example  # or your binary name

# Filter by name
./cmake-build-linux-release/bench_example --benchmark_filter=BM_MyFunction

# Output as JSON for later analysis
./cmake-build-linux-release/bench_example --benchmark_out=results.json --benchmark_out_format=json

# Compare two runs
benchmark_compare results_before.json results_after.json
```

Sample output:
```
Benchmark                Time        CPU      Iterations
--------------------------------------------------------
BM_VectorPushBack       45.2 ns    45.1 ns    15000000
BM_MapInsert           120.5 ns   120.3 ns     5800000
```

Benchmarks live in `benchmarks/`. Add new ones following `bench_example.cpp`.

---

### Sanitizers

Sanitizers are compiler-based tools that detect runtime errors: buffer overflows, data races, memory leaks, and undefined behaviour.

#### ASan + UBSan + LSan — memory errors and UB

```bash
cmake --preset linux-asan && cmake --build --preset linux-asan
cd cmake-build-linux-asan && ctest --output-on-failure
```

What it catches:
- **ASan** (AddressSanitizer) — out-of-bounds access, use-after-free, double-free
- **UBSan** (UndefinedBehaviorSanitizer) — integer overflow, negative shift, null pointer dereference
- **LSan** (LeakSanitizer) — memory leaks

#### MSan — uninitialized memory

```bash
cmake --preset linux-msan && cmake --build --preset linux-msan
cd cmake-build-linux-msan && ctest --output-on-failure
```

Catches reads from uninitialized memory. **Clang only.**

#### TSan — data races

```bash
cmake --preset linux-tsan && cmake --build --preset linux-tsan
cd cmake-build-linux-tsan && ctest --output-on-failure
```

Catches data races in multithreaded code.

> Sanitizers cannot be combined with each other — each runs separately. In CI they run as parallel jobs.

---

### Valgrind

Valgrind works without recompilation — it analyses an already-built Debug binary.

#### Memcheck — memory errors

```bash
# All tests via ctest (CI and pre-commit mode)
tools/profiler/run-memcheck.sh

# Specific binary
tools/profiler/run-memcheck.sh my_binary
```

Catches: out-of-bounds access, use-after-free, memory leaks, invalid syscalls.

#### Helgrind — data races

```bash
# All tests
tools/profiler/run-helgrind.sh

# Specific binary
tools/profiler/run-helgrind.sh my_binary
```

Similar to TSan, but no recompilation needed. Slower, but works on any binary.

#### DRD — data races (alternative)

```bash
tools/profiler/run-drd.sh          # all tests
tools/profiler/run-drd.sh my_binary
```

Less precise than Helgrind, but faster.

> **When to use what:** Sanitizers — faster, convenient during development. Valgrind — for final verification or when recompilation is not possible.

---

### C++ Profiling

#### Callgrind — call graph and CPU time

```bash
tools/profiler/run-callgrind.sh my_binary
# Output: profiles/callgrind.out
```

Visualize: upload `callgrind.out` to [speedscope.app](https://speedscope.app) — interactive flamegraph in the browser.

Shows: which functions consume the most CPU, call graph, instruction counts.

#### Cachegrind — cache misses

```bash
tools/profiler/run-cachegrind.sh my_binary
# Output: profiles/cachegrind.out
```

Shows: L1/L2/L3 cache miss counts, branch misprediction. Helps optimize memory access patterns.

#### Massif — heap usage

```bash
tools/profiler/run-massif.sh my_binary
# Output: profiles/massif.out (with text report in stdout)
```

Shows: heap growth and shrinkage over time, allocation peaks.

#### perf — system profiling

```bash
tools/profiler/run-perf.sh my_binary
```

Fast Linux sampling profiler. Shows hot spots with minimal overhead.

---

### Python Profiling (hybrid + python/pure)

#### cProfile — function call statistics

```bash
tools/profiler/profile-python.sh
# Output: profiles/profile.prof — visualize: snakeviz profiles/profile.prof
```

Shows: call count per function, total and average time. Visualise interactively with snakeviz in the browser.

#### tracemalloc — memory usage

```bash
tools/profiler/profile-memory.sh
# Output: profiles/memory_stats.txt
```

Shows: top-10 memory allocations by line.

#### py-spy — sampling profiler without code changes

```bash
tools/profiler/profile-spy.sh
# Output: profiles/pyspy.svg — open in browser
```

Works without any code changes, minimal overhead. SVG flamegraph: open in browser, click blocks to zoom.

---

### Documentation

#### C/C++ Pure — Doxygen

```bash
# Generate documentation
doxygen Doxyfile

# Open in browser
xdg-open docs/html/index.html
```

Document your code with comments:
```cpp
/// @brief Computes the sum of two numbers
/// @param a first operand
/// @param b second operand
/// @return sum of a and b
int add(int a, int b);
```

#### Hybrid & Python Pure — Sphinx

```bash
# Build documentation
cd docs && make html

# Open in browser
xdg-open docs/_build/html/index.html
```

The hybrid template uses **Breathe** to import the C++ API from Doxygen into Sphinx — C++ and Python documentation is built into a unified site with the **furo** theme (dark mode support).

#### Publishing

- **GitHub Pages** — all templates: automatically on every push to `main`
- **ReadTheDocs** — Hybrid and Python Pure only: automatically on every push (all branches and tags, with versioning)

To set up ReadTheDocs (Hybrid / Python Pure):
1. Connect your repository at [readthedocs.org](https://readthedocs.org)
2. ReadTheDocs will detect `.readthedocs.yaml` automatically and build on every push

---

## License

**MIT License** — Copyright © 2025–2026 Vais Vaisov

Free to use, modify, and distribute.

---

## Contributing

Contributions are welcome! Read [CONTRIBUTING.md](.github/CONTRIBUTING.md) and feel free to open an issue or submit a Pull Request.

---

<div align="center">

*IT Project Templates — from zero to coding in minutes*

</div>
