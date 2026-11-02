#!/bin/bash

set -euo pipefail

# Paths
TEMPLATES_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"

# ========================================
# Functions
# ========================================

show_usage() {
    local exit_code="${1:-1}"
    cat <<'EOF'
new-project — scaffold a new project from template

USAGE
  new-project [--help] <language> <type> [device] <path>

LANGUAGE FLAGS
  --c-cpp       C/C++ project (pure, hybrid, or PlatformIO embedded)
  --python      Python project (pure only)
  --verilog     Verilog HDL / FPGA project (pure only)

PROJECT TYPES
  --pure        Standalone C/C++, Python or Verilog project
                  C/C++:   CMake + GoogleTest + Google Benchmark + Doxygen
                  Python:  pytest + ruff + mypy + Sphinx
                  Verilog: iverilog + Verilator + Quartus + openFPGALoader (Docker build container)
  --hybrid      C/C++ + Python bridge via Cython
                  Includes everything from --pure (both C++ and Python sides)
  --platformio  Embedded firmware project (Arduino framework)
                  Requires a device flag (see below)

PLATFORMIO DEVICES
  Arduino (AVR):
    --arduino-nano          Arduino Nano (ATmega328P)
    --arduino-pro-micro     Arduino Pro Micro (ATmega32U4, USB HID)

  ESP32 (Xtensa / RISC-V):
    --esp32-devkit          ESP32 DevKit V1 (Xtensa LX6, WiFi + BT)
    --esp32-s2-saola        ESP32-S2 Saola (Xtensa LX7, USB OTG)
    --esp32-s3-devkitc      ESP32-S3 DevKitC (Xtensa LX7, AI+IoT)
    --esp32-c3-devkitm      ESP32-C3 DevKitM (RISC-V, WiFi + BT)
    --esp32-c6-devkitc      ESP32-C6 DevKitC (RISC-V, WiFi 6 + Zigbee)
    --esp32-h2-devkitm      ESP32-H2 DevKitM (RISC-V, Zigbee + Thread)

  ESP8266:
    --esp8266-wemos-d1-mini Wemos D1 Mini (ESP8266, WiFi) — build only, no Wokwi

  Raspberry Pi:
    --rpi-pico              Raspberry Pi Pico (RP2040, dual-core ARM Cortex-M0+)

  STM32 (ARM Cortex-M):
    --stm32f411-blackpill   STM32F411 Black Pill (Cortex-M4, 100 MHz)
    --stm32f103-bluepill    STM32F103 Blue Pill (Cortex-M3, 72 MHz)

OPTIONS
  --dev-container      Generate a VS Code Dev Container (.devcontainer/devcontainer.json)
  --no-dev-container   Build-only container, no VS Code Dev Container (default)
  --host-network       Build the container image with --network=host (default)
  --no-host-network    Build the container image with the default Docker network
  --help, -h           Show this help page and exit

WHAT GETS CREATED
  - Project files copied from the chosen template
  - Placeholders replaced with your project name
  - Git repository initialized with initial commit
  - GoogleTest submodule added (C/C++ pure/hybrid only)
  - Python virtual environment created via uv (hybrid/python only)
  - AI agent context symlinks: CLAUDE.md, QWEN.md, AGENTS.md
  - Dev Container is opt-in (--dev-container); by default only the build Dockerfile is kept

EXAMPLES
  new-project --c-cpp --pure ./Projects/my-lib
  new-project --verilog --pure ./Projects/fpga-blink
  new-project --python --pure /home/user/Projects/my-app
  new-project --c-cpp --hybrid ../../work/bridge-project
  new-project --c-cpp --platformio --esp32-devkit ./embedded/sensor-node
  new-project --c-cpp --platformio --rpi-pico ./embedded/pico-blink
  new-project --c-cpp --platformio --esp32-c3-devkitm ~/Projects/iot-device

EOF
    exit "$exit_code"
}

validate_path() {
    local path="$1"
    if [ -z "$path" ] || [[ "$path" == -* ]]; then
        echo "Error: Project path not specified."
        show_usage
    fi
}

replace_placeholders() {
    local project_name="$1"
    find . -type f \( -name "*.in" -o -name "*.template" \) -exec sed -i "s|@PROJECT_NAME@|$project_name|g" {} \;
    find . -type f -name "*.in" -exec sh -c 'mv "$1" "$(dirname "$1")/$(basename "$1" .in)"' _ {} \;
    find . -type f -name "*.template" -exec sh -c 'mv "$1" "$(dirname "$1")/$(basename "$1" .template)"' _ {} \;
    # Rename files that have @PROJECT_NAME@ in their filename
    while IFS= read -r f; do
        mv "$f" "$(echo "$f" | sed "s|@PROJECT_NAME@|$project_name|g")"
    done < <(find . -type f -name "*@PROJECT_NAME@*")
}

replace_board_placeholders() {
    sed -i "s|@BOARD_ENV@|$BOARD_ENV|g" platformio.ini
    sed -i "s|@PLATFORM@|$PLATFORM|g"   platformio.ini
    sed -i "s|@BOARD@|$BOARD|g"         platformio.ini
    find . -type f ! -name "*.json" -exec sed -i "s|@BOARD_NAME@|$BOARD_NAME|g" {} \;
    if $HAS_WOKWI; then
        sed -i "s|@WOKWI_BUILD@|$WOKWI_BUILD|g"     wokwi.toml
        sed -i "s|@FIRMWARE_EXT@|$FIRMWARE_EXT|g"   wokwi.toml
    else
        rm -f wokwi.toml
    fi
}

set_board_metadata() {
    case "$DEVICE" in
        arduino-nano)
            FAMILY="arduino"; BOARD="nanoatmega328"; BOARD_ENV="nanoatmega328"
            PLATFORM="atmelavr"; BOARD_NAME="Arduino Nano"
            WOKWI_BUILD="nanoatmega328new"; FIRMWARE_EXT="hex"; HAS_WOKWI=true
            DEVCONTAINER="base"
            ;;
        arduino-pro-micro)
            FAMILY="arduino"; BOARD="sparkfun_promicro16"; BOARD_ENV="sparkfun_promicro16"
            PLATFORM="atmelavr"; BOARD_NAME="Arduino Pro Micro"
            WOKWI_BUILD="leonardo"; FIRMWARE_EXT="hex"; HAS_WOKWI=true
            DEVCONTAINER="base"
            ;;
        esp32-devkit)
            FAMILY="esp32"; BOARD="esp32dev"; BOARD_ENV="esp32dev"
            PLATFORM="espressif32"; BOARD_NAME="ESP32 DevKit V1"
            WOKWI_BUILD="esp32dev"; FIRMWARE_EXT="bin"; HAS_WOKWI=true
            DEVCONTAINER="base"
            ;;
        esp32-s2-saola)
            FAMILY="esp32"; BOARD="esp32-s2-saola-1"; BOARD_ENV="esp32-s2-saola-1"
            PLATFORM="espressif32"; BOARD_NAME="ESP32-S2 Saola"
            WOKWI_BUILD="esp32-s2-saola-1"; FIRMWARE_EXT="bin"; HAS_WOKWI=true
            DEVCONTAINER="base"
            ;;
        esp32-s3-devkitc)
            FAMILY="esp32"; BOARD="esp32-s3-devkitc-1"; BOARD_ENV="esp32-s3-devkitc-1"
            PLATFORM="espressif32"; BOARD_NAME="ESP32-S3 DevKitC"
            WOKWI_BUILD="esp32-s3-devkitc-1"; FIRMWARE_EXT="bin"; HAS_WOKWI=true
            DEVCONTAINER="base"
            ;;
        esp32-c3-devkitm)
            FAMILY="esp32"; BOARD="esp32-c3-devkitm-1"; BOARD_ENV="esp32-c3-devkitm-1"
            PLATFORM="espressif32"; BOARD_NAME="ESP32-C3 DevKitM"
            WOKWI_BUILD="esp32-c3-devkitm-1"; FIRMWARE_EXT="bin"; HAS_WOKWI=true
            DEVCONTAINER="base"
            ;;
        esp32-c6-devkitc)
            FAMILY="esp32"; BOARD="esp32-c6-devkitc-1"; BOARD_ENV="esp32-c6-devkitc-1"
            PLATFORM="espressif32"; BOARD_NAME="ESP32-C6 DevKitC"
            WOKWI_BUILD="esp32-c6-devkitc-1"; FIRMWARE_EXT="bin"; HAS_WOKWI=true
            DEVCONTAINER="base"
            ;;
        esp32-h2-devkitm)
            FAMILY="esp32"; BOARD="esp32-h2-devkitm-1"; BOARD_ENV="esp32-h2-devkitm-1"
            PLATFORM="espressif32"; BOARD_NAME="ESP32-H2 DevKitM"
            WOKWI_BUILD="esp32-h2-devkitm-1"; FIRMWARE_EXT="bin"; HAS_WOKWI=true
            DEVCONTAINER="base"
            ;;
        esp8266-wemos-d1-mini)
            FAMILY="esp8266"; BOARD="d1_mini"; BOARD_ENV="d1_mini"
            PLATFORM="espressif8266"; BOARD_NAME="Wemos D1 Mini"
            WOKWI_BUILD=""; FIRMWARE_EXT=""; HAS_WOKWI=false
            DEVCONTAINER="base"
            ;;
        rpi-pico)
            FAMILY="pico"; BOARD="pico"; BOARD_ENV="pico"
            PLATFORM="raspberrypi"; BOARD_NAME="Raspberry Pi Pico"
            WOKWI_BUILD="pico"; FIRMWARE_EXT="bin"; HAS_WOKWI=true
            DEVCONTAINER="pico"
            ;;
        stm32f411-blackpill)
            FAMILY="stm32"; BOARD="blackpill_f411ce"; BOARD_ENV="blackpill_f411ce"
            PLATFORM="ststm32"; BOARD_NAME="STM32F411 Black Pill"
            WOKWI_BUILD="blackpill_f411ce"; FIRMWARE_EXT="bin"; HAS_WOKWI=true
            DEVCONTAINER="stm32"
            ;;
        stm32f103-bluepill)
            FAMILY="stm32"; BOARD="bluepill_f103c8"; BOARD_ENV="bluepill_f103c8"
            PLATFORM="ststm32"; BOARD_NAME="STM32F103 Blue Pill"
            WOKWI_BUILD="bluepill_f103c8"; FIRMWARE_EXT="bin"; HAS_WOKWI=true
            DEVCONTAINER="stm32"
            ;;
    esac
}

create_agent_symlinks() {
    local project_name="$1"
    ln -sf "${project_name}.md" CLAUDE.md
    ln -sf "${project_name}.md" QWEN.md
    ln -sf "${project_name}.md" AGENTS.md
}

init_git() {
    git init
    echo "Initializing Git..."
    if [ "$LANG_TYPE" = "c-cpp" ] && { [ "$HYBRID" = "true" ] || [ "$PURE" = "true" ]; }; then
        git submodule add https://github.com/google/googletest.git libraries/googletest
        echo "googletest added as submodule"
    fi

    # pre-commit hooks are installed automatically by postCreateCommand when the dev container starts

    git add .
    git commit -m "feat: initial commit from template"
}


check_deps() {
    local missing=()
    for cmd in git realpath; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Error: Missing required tools: ${missing[*]}"
        exit 1
    fi
}

# Detect the DSH runtime and the TUI plugin the user actually runs, so the
# generated container image gets the same pair instead of a hardcoded default.
detect_dsh() {
    DSH_VERSION="latest"
    DSH_TUI_PACKAGE="@deepseek-harness-tui/dsh-tui"
    DSH_TUI_VERSION="latest"
    DSH_TUI_PROFILE="tui"

    if command -v dsh &>/dev/null; then
        DSH_VERSION="$(dsh --version 2>/dev/null | tr -d '[:space:]' || true)"
        [ -n "$DSH_VERSION" ] || DSH_VERSION="latest"
    fi

    local pkgfile profile match chosen=""

    for pkgfile in "$HOME"/.dsh/profiles/*/package.json; do
        [ -f "$pkgfile" ] || continue
        profile="$(basename "$(dirname "$pkgfile")")"
        match="$(node -e '
            const fs = require("fs");
            const pkg = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
            const deps = { ...(pkg.dependencies || {}), ...(pkg.devDependencies || {}) };
            for (const [name, range] of Object.entries(deps)) {
                if (/tui/i.test(name)) {
                    process.stdout.write(name + "\t" + range);
                    break;
                }
            }
        ' "$pkgfile" 2>/dev/null || true)"

        [ -n "$match" ] || continue

        if [ "$profile" = "tui" ]; then
            chosen="$match"
            DSH_TUI_PROFILE="$profile"
            break
        fi
        if [ -z "$chosen" ]; then
            chosen="$match"
            DSH_TUI_PROFILE="$profile"
        fi
    done

    if [ -n "$chosen" ]; then
        DSH_TUI_PACKAGE="${chosen%%$'\t'*}"
        DSH_TUI_VERSION="${chosen#*$'\t'}"
    else
        echo "Warning: no DSH TUI plugin found in ~/.dsh/profiles."
        echo "         Falling back to ${DSH_TUI_PACKAGE}@${DSH_TUI_VERSION} (profile: ${DSH_TUI_PROFILE})."
    fi

    echo "DSH: runtime ${DSH_VERSION}, TUI ${DSH_TUI_PACKAGE}@${DSH_TUI_VERSION} (profile: ${DSH_TUI_PROFILE})"
}

# Bake the detected DSH pair into the copied Dockerfile and VS Code tasks.
replace_dsh_placeholders() {
    if [ -f .devcontainer/Dockerfile ]; then
        sed -i \
            -e "s|@DSH_VERSION@|${DSH_VERSION}|g" \
            -e "s|@DSH_TUI_PACKAGE@|${DSH_TUI_PACKAGE}|g" \
            -e "s|@DSH_TUI_VERSION@|${DSH_TUI_VERSION}|g" \
            -e "s|@DSH_TUI_PROFILE@|${DSH_TUI_PROFILE}|g" \
            .devcontainer/Dockerfile
    fi

    if [ -f .vscode/tasks.json ]; then
        sed -i "s|@DSH_TUI_PROFILE@|${DSH_TUI_PROFILE}|g" .vscode/tasks.json
    fi
}

cleanup() {
    local exit_code=$?
    if [ "$CREATED" = true ] && [ -d "$DEST" ]; then
        echo ""
        echo "Error: '$BASH_COMMAND' failed with exit code $exit_code"
        echo "Cleaning up '$DEST'..."
        rm -rf "$DEST"
    fi
    exit $exit_code
}

# ========================================
# Main flow
# ========================================

CREATED=false
trap cleanup INT TERM ERR

check_deps

if [[ $# -lt 1 ]]; then
    echo "Error: No arguments provided."
    show_usage 1
elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    show_usage 0
fi

DEST_ARG="${@: -1}"
validate_path "$DEST_ARG"
set -- "${@:1:$(($#-1))}"

# Flags
LANG_TYPE=""
PURE=false
HYBRID=false
PLATFORMIO=false
DEVICE=""
DEV_CONTAINER=false
HOST_NETWORK=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --c-cpp)
            LANG_TYPE="c-cpp"
            shift
            ;;
        --python)
            LANG_TYPE="python"
            shift
            ;;
        --verilog)
            LANG_TYPE="verilog"
            shift
            ;;
        --pure)
            PURE=true
            shift
            ;;
        --hybrid)
            HYBRID=true
            shift
            ;;
        --platformio)
            PLATFORMIO=true
            shift
            ;;
        --arduino-nano)
            DEVICE="arduino-nano"
            shift
            ;;
        --arduino-pro-micro)
            DEVICE="arduino-pro-micro"
            shift
            ;;
        --esp32-devkit)
            DEVICE="esp32-devkit"
            shift
            ;;
        --esp32-s2-saola)
            DEVICE="esp32-s2-saola"
            shift
            ;;
        --esp32-s3-devkitc)
            DEVICE="esp32-s3-devkitc"
            shift
            ;;
        --esp32-c3-devkitm)
            DEVICE="esp32-c3-devkitm"
            shift
            ;;
        --esp32-c6-devkitc)
            DEVICE="esp32-c6-devkitc"
            shift
            ;;
        --esp32-h2-devkitm)
            DEVICE="esp32-h2-devkitm"
            shift
            ;;
        --esp8266-wemos-d1-mini)
            DEVICE="esp8266-wemos-d1-mini"
            shift
            ;;
        --rpi-pico)
            DEVICE="rpi-pico"
            shift
            ;;
        --stm32f411-blackpill)
            DEVICE="stm32f411-blackpill"
            shift
            ;;
        --stm32f103-bluepill)
            DEVICE="stm32f103-bluepill"
            shift
            ;;
        --dev-container)
            DEV_CONTAINER=true
            shift
            ;;
        --no-dev-container)
            DEV_CONTAINER=false
            shift
            ;;
        --host-network)
            HOST_NETWORK=true
            shift
            ;;
        --no-host-network)
            HOST_NETWORK=false
            shift
            ;;
        --help|-h)
            show_usage 0
            ;;
        -*)
            echo "Error: Unknown flag: $1"
            show_usage
            ;;
        *)
            shift
            ;;
    esac
done

# Validate language type
if [ -z "$LANG_TYPE" ]; then
    echo "Error: Specify --c-cpp, --python or --verilog"
    show_usage
fi

# Determine destination and template
DEST="$(realpath -m "$DEST_ARG")"
PROJECT_NAME="$(basename "$DEST")"
TEMPLATE_BASE="$TEMPLATES_DIR/$LANG_TYPE"
TEMPLATE=""

if $PURE; then
    TEMPLATE="$TEMPLATE_BASE/pure"
elif $HYBRID; then
    if [ "$LANG_TYPE" != "c-cpp" ]; then
        echo "Error: --hybrid is only available for --c-cpp"
        show_usage
    fi
    TEMPLATE="$TEMPLATE_BASE/hybrid"
elif $PLATFORMIO && [ -n "$DEVICE" ]; then
    if [ "$LANG_TYPE" != "c-cpp" ]; then
        echo "Error: --platformio is only available for --c-cpp"
        show_usage
    fi
    set_board_metadata
    TEMPLATE="$TEMPLATE_BASE/platformio/$FAMILY"
elif $PLATFORMIO; then
    echo "Error: Specify a device flag (see --help for full list)"
    show_usage
else
    echo "Error: Specify project type: --pure, --hybrid, or --platformio"
    show_usage
fi

# Validate template exists
if [ ! -d "$TEMPLATE" ]; then
    echo "Error: Template not found: $TEMPLATE"
    echo "Check folder: $TEMPLATES_DIR"
    exit 1
fi

# Create project
if [ -d "$DEST" ]; then
    echo "Error: Directory already exists: $DEST"
    exit 1
fi
echo "Creating project: $PROJECT_NAME"
mkdir -p "$DEST"
CREATED=true
cp -r "$TEMPLATE/." "$DEST/"

# For PlatformIO, also copy family devcontainer and shared .vscode
if $PLATFORMIO; then
    cp -r "$TEMPLATE_BASE/platformio/devcontainers/$DEVCONTAINER/." "$DEST/.devcontainer"
    cp "$TEMPLATE_BASE/platformio/devcontainers/run.sh" "$DEST/.devcontainer/run.sh"
    cp -r "$TEMPLATE_BASE/platformio/.vscode" "$DEST/"
fi

# Dev Container is opt-in; by default keep only the build container (Dockerfile)
if ! $DEV_CONTAINER; then
    rm -f "$DEST/.devcontainer/devcontainer.json"
fi

cd "$DEST" || exit 1

# Detect the user's DSH runtime/TUI and bake them into the copied files
detect_dsh
replace_dsh_placeholders

# Replace placeholders
replace_placeholders "$PROJECT_NAME"
if $PLATFORMIO; then
    replace_board_placeholders
fi

# Create AI agent symlinks
create_agent_symlinks "$PROJECT_NAME"

# Virtual environments
if { [ "$LANG_TYPE" = "c-cpp" ] && [ "$HYBRID" = "true" ]; } || \
   { [ "$LANG_TYPE" = "python" ] && [ "$PURE" = "true" ]; }; then
    if command -v uv &>/dev/null; then
        echo "Creating virtual environment with uv..."
        uv sync
    else
        echo "Creating virtual environment .venv..."
        python -m venv .venv
        source .venv/bin/activate
        pip install --upgrade pip
        [ -f pyproject.toml ] && pip install -e ".[dev]"
    fi
fi

# Git
init_git

# Container image: build it at creation unless a Dev Container was requested
# (a Dev Container builds its own image when it opens).
if ! $DEV_CONTAINER && [ -f .devcontainer/Dockerfile ]; then
    if command -v docker &>/dev/null; then
        NET_FLAG=""
        if $HOST_NETWORK; then NET_FLAG="--network=host"; fi
        echo "Building container image '${PROJECT_NAME}-dev' (may take a few minutes)..."
        if ! docker build $NET_FLAG -t "${PROJECT_NAME}-dev" .devcontainer/; then
            echo "Warning: image build failed."
            echo "The project was created, but nothing can be built until the image exists."
            echo "Rebuild it with the VS Code task 'Container: build image'."
        fi
    else
        echo "Warning: docker not found - build the image later via the VS Code task 'Container: build image'."
    fi
fi


# ========================================
# Tips
# ========================================

echo ""
echo "Project '$PROJECT_NAME' successfully created in $DEST"
echo ""

if [ "$LANG_TYPE" = "c-cpp" ]; then
    if $PLATFORMIO; then
        echo "Tips for PlatformIO:"
        echo "   pio run"
        echo "   pio run -t upload"
        echo "   pio device monitor"
    else
        echo "Tips for C/C++:"
        echo "   cmake --preset linux-debug && cmake --build --preset linux-debug"
        echo "   cd cmake-build-linux-debug && ctest --output-on-failure"
    fi
fi

if [ "$LANG_TYPE" = "python" ]; then
    echo "Tips for Python:"
    echo "   source .venv/bin/activate"
    echo "   pytest tests/"
fi

if [ "$LANG_TYPE" = "verilog" ]; then
    echo "Tips for Verilog:"
    echo "   VS Code task: Container: build image"
    echo "   VS Code task: Sim: iverilog (build + run)"
    echo "   VS Code task: Upload: build + program (full)"
fi

echo ""
echo "Happy coding!"
