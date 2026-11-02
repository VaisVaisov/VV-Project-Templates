#!/usr/bin/env bash
# Run a Verilog/FPGA command inside the build container.
#
# Build-only mode: runs the command in <project>-dev with the workspace mounted
# at /workspace and the host uid/gid.
#
# Dev Container mode (DEVCONTAINER=true): the toolchain is already local, so the
# command runs directly - no nested Docker.
#
# Flags:
#   --quartus     mount the host Quartus installation (/opt/intelFPGA) read-only
#   --privileged  passthrough to the host USB bus (programmer)
#   --gui         share the host X11 display (Quartus GUI, Pin Planner, GTKWave)
#   --tty         allocate a TTY for interactive commands
set -euo pipefail

extra=()
while [ "$#" -gt 0 ]; do
    case "$1" in
        --quartus)
            extra+=(-v /opt/intelFPGA:/opt/intelFPGA:ro)
            shift
            ;;
        --privileged)
            extra+=(--privileged -v /dev:/dev)
            shift
            ;;
        --gui)
            extra+=(-e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix)
            if [ -n "${XAUTHORITY:-}" ]; then
                extra+=(-v "$XAUTHORITY:/tmp/.Xauthority:ro" -e XAUTHORITY=/tmp/.Xauthority)
            fi
            shift
            ;;
        --tty)
            extra+=(-it)
            shift
            ;;
        *)
            break
            ;;
    esac
done

if [ "$#" -eq 0 ]; then
    echo "usage: run.sh [--quartus] [--privileged] [--gui] [--tty] '<command>'" >&2
    exit 2
fi

if [ "${DEVCONTAINER:-}" = "true" ]; then
    exec bash -lc "$*"
fi

image="${DEVCONTAINER_IMAGE:-$(basename "$PWD")-dev}"

if ! docker image inspect "$image" >/dev/null 2>&1; then
    echo "error: Docker image '$image' not found." >&2
    echo "Build it with the VS Code task 'Container: build image'." >&2
    exit 1
fi

exec docker run --rm --network=host \
    "${extra[@]}" \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/workspace" \
    -w /workspace \
    --entrypoint bash \
    "$image" -lc "$*"
