#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
PREFIX="${PREFIX:-/usr/local}"
INSTALL_DEPS=1
BUILD_RAYLIB=0

usage() {
    cat <<'EOF'
Usage: install_game.sh [options]

Install build dependencies when needed, build the game, and install it.

Options:
  --prefix PATH      Installation prefix (default: /usr/local)
  --skip-deps        Do not install system packages
  --build-raylib     Build bundled ./raylib even if raylib is already installed
  -h, --help         Show this help

Use --prefix "$HOME/.local" to install without sudo. The installed command is
named rainyweekendgame.
EOF
}

while (($#)); do
    case "$1" in
        --prefix)
            [[ $# -ge 2 ]] || { echo "$1 requires a path" >&2; exit 2; }
            PREFIX="$2"; shift 2
            ;;
        --skip-deps) INSTALL_DEPS=0; shift ;;
        --build-raylib) BUILD_RAYLIB=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
done

run_as_root() {
    if [[ $EUID -eq 0 ]]; then
        "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        echo "Root access is required to run: $*" >&2
        echo "Try installing with --prefix \"$HOME/.local\" instead." >&2
        exit 1
    fi
}

if ((INSTALL_DEPS)); then
    if command -v apt-get >/dev/null 2>&1; then
        echo "Installing build dependencies..."
        run_as_root apt-get update
        run_as_root apt-get install -y \
            build-essential cmake pkg-config \
            libasound2-dev libgl1-mesa-dev libglu1-mesa-dev \
            libx11-dev libxrandr-dev libxi-dev libxcursor-dev libxinerama-dev \
            libwayland-dev libxkbcommon-dev
    elif ! command -v g++ >/dev/null 2>&1 || \
         ! command -v cmake >/dev/null 2>&1 || \
         ! command -v pkg-config >/dev/null 2>&1; then
        echo "Automatic dependency installation currently supports apt-get systems." >&2
        echo "Install a C++ compiler, cmake, pkg-config, and raylib's Linux dependencies." >&2
        exit 1
    fi
fi

if ((BUILD_RAYLIB)) || ! pkg-config --exists raylib 2>/dev/null; then
    RAYLIB_SOURCE="$PROJECT_DIR/raylib"
    [[ -f "$RAYLIB_SOURCE/CMakeLists.txt" ]] || {
        echo "raylib is unavailable and bundled source was not found at $RAYLIB_SOURCE." >&2
        echo "Clone raylib there or install a raylib development package." >&2
        exit 1
    }

    echo "Building bundled raylib..."
    cmake -S "$RAYLIB_SOURCE" -B "$RAYLIB_SOURCE/build" \
        -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=ON
    cmake --build "$RAYLIB_SOURCE/build" --parallel
    run_as_root cmake --install "$RAYLIB_SOURCE/build" --prefix /usr/local
    command -v ldconfig >/dev/null 2>&1 && run_as_root ldconfig
fi

pkg-config --exists raylib || {
    echo "raylib was installed, but pkg-config cannot find it." >&2
    echo "Try: export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:\$PKG_CONFIG_PATH" >&2
    exit 1
}

"$SCRIPT_DIR/build.sh" --clean

destination="$PREFIX/bin/rainyweekendgame"
if [[ -d "$PREFIX/bin" && -w "$PREFIX/bin" ]] || \
   [[ ! -e "$PREFIX/bin" && -d "$PREFIX" && -w "$PREFIX" ]]; then
    mkdir -p -- "$PREFIX/bin"
    install -m 0755 "$PROJECT_DIR/build/rainyweekendgame" "$destination"
else
    run_as_root install -d "$PREFIX/bin"
    run_as_root install -m 0755 "$PROJECT_DIR/build/rainyweekendgame" "$destination"
fi

echo "Installed Rainy Weekend Game: $destination"
echo "Run it with: $destination"
