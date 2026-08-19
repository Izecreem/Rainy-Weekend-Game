#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="${BUILD_DIR:-$PROJECT_DIR/build}"
OUTPUT="${OUTPUT:-$BUILD_DIR/rainyweekendgame}"
CXX="${CXX:-g++}"

usage() {
    cat <<'EOF'
Usage: build.sh [--debug] [--clean] [--output PATH]

Build Rainy Weekend Game using the installed raylib package.

Options:
  --debug        Build with debug symbols and no optimization
  --clean        Remove this script's build directory before building
  -o, --output   Write the executable to PATH
  -h, --help     Show this help

Environment variables:
  CXX            C++ compiler to use (default: g++)
  BUILD_DIR      Build directory (default: PROJECT/build)
  OUTPUT         Output executable (default: BUILD_DIR/rainyweekendgame)
EOF
}

BUILD_TYPE=release
while (($#)); do
    case "$1" in
        --debug) BUILD_TYPE=debug; shift ;;
        --clean)
            if [[ -n "$BUILD_DIR" && "$BUILD_DIR" != "/" && "$BUILD_DIR" != "$PROJECT_DIR" ]]; then
                rm -rf -- "$BUILD_DIR"
            else
                echo "Refusing to clean unsafe BUILD_DIR: $BUILD_DIR" >&2
                exit 2
            fi
            shift
            ;;
        -o|--output)
            [[ $# -ge 2 ]] || { echo "$1 requires a path" >&2; exit 2; }
            OUTPUT="$2"; shift 2
            ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
done

command -v "$CXX" >/dev/null 2>&1 || {
    echo "C++ compiler '$CXX' was not found. Run shell_scripts/install_game.sh." >&2
    exit 1
}
command -v pkg-config >/dev/null 2>&1 || {
    echo "pkg-config was not found. Run shell_scripts/install_game.sh." >&2
    exit 1
}
pkg-config --exists raylib || {
    echo "raylib was not found by pkg-config. Run shell_scripts/install_game.sh." >&2
    exit 1
}

mkdir -p -- "$(dirname -- "$OUTPUT")"
sources=("$PROJECT_DIR/main.cpp" "$PROJECT_DIR/io.cpp" "$PROJECT_DIR/player.cpp")
flags=(-std=c++20 -Wall -Wextra -Wpedantic)
if [[ "$BUILD_TYPE" == debug ]]; then
    flags+=(-O0 -g3)
else
    flags+=(-O2 -DNDEBUG)
fi
read -r -a raylib_cflags <<< "$(pkg-config --cflags raylib)"
read -r -a raylib_libs <<< "$(pkg-config --libs raylib)"
# Source-installed static raylib packages sometimes omit their private platform
# dependencies from raylib.pc. Supplying these is harmless for shared builds.
if [[ "$(uname -s)" == Linux ]]; then
    raylib_libs+=(-lm -lpthread -ldl -lrt -lX11)
fi

echo "Building Rainy Weekend Game ($BUILD_TYPE)..."
"$CXX" "${flags[@]}" "${raylib_cflags[@]}" "${sources[@]}" -o "$OUTPUT" "${raylib_libs[@]}"
echo "Built: $OUTPUT"
