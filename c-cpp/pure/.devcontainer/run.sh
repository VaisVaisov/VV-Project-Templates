#!/usr/bin/env bash
# Run a project command inside the build container.
#
# Build-only mode (no Dev Container): runs the command in <project>-dev with the
# workspace mounted at /workspace and the host uid/gid, so build artifacts stay
# owned by the user.
#
# Dev Container mode (DEVCONTAINER=true): the toolchain is already local, so the
# command runs directly - no nested Docker.
set -euo pipefail

extra=()
if [ "${1:-}" = "--privileged" ]; then
    extra=(--privileged -v /dev:/dev)
    shift
fi

if [ "$#" -eq 0 ]; then
    echo "usage: run.sh [--privileged] '<command>'" >&2
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
