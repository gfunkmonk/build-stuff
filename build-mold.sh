#!/usr/bin/env bash

set -euo pipefail

# ── Common Code ───────────────────────────────────────────────────────────────
source "$(dirname "$0")/common.sh"

# ── Defaults & Config ─────────────────────────────────────────────────────────
NAME=$(echo $0 | cut -d'-' -f2 | cut -d'.' -f1)
ROOT_DIR="$(pwd)/${NAME}-build"
SOURCE_DIR="$ROOT_DIR/${NAME}"
BUILD_BASE="$ROOT_DIR/build"
OUTPUT_DIR="$ROOT_DIR/output"
MOLD_BRANCH="stable"
DL_COLOR="${NEONGREEN}"
DL_TC_1="${SKY}"
DL_TC_2="${HOTPINK}"
DL_TC_3="${CHARTREUSE}"
EX_TC_1="${SKY}"
EX_TC_2="${NEONBLUE}"
FINAL_C="${NEONPINK}"

# ── Architecture Table ────────────────────────────────────────────────────────
declare -A ARCH_INFO=(
  [i686]="i686-unknown-linux-musl:i686-unknown-linux-musl.tar.xz:i686"
  [x86_64]="x86_64-unknown-linux-musl:x86_64-unknown-linux-musl.tar.xz:x86_64"
  [aarch64]="aarch64-unknown-linux-musl:aarch64-unknown-linux-musl.tar.xz:aarch64"
  [armv7hf]="armv7-unknown-linux-musleabihf:armv7-unknown-linux-musleabihf.tar.xz:arm"
  [armv6hf]="arm-unknown-linux-musleabihf:arm-unknown-linux-musleabihf.tar.xz:arm"
)

# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${LEMON}Usage:${NC} $0 [OPTIONS]"
    echo ""
    echo -e "${BWHITE}Options:${NC}"
    echo -e "  ${NEONGREEN}--gcc${NC}             Use GCC toolchains"
    echo -e "  ${NEONGREEN}--clang${NC}           Use Clang toolchains (default)"
    echo -e "  ${NEONGREEN}-a|--arch \"LIST\"${NC}  Space separated list of arches to build"
    echo -e "  ${NEONGREEN}-r|--resume${NC}       Skip architectures already found in output/"
    echo -e "  ${NEONGREEN}-j|--jobs N${NC}       Parallel make jobs (default: auto-detected)"
    echo -e "  ${NEONGREEN}-C|--clean${NC}        Wipe build and output"
    echo -e "  ${NEONGREEN}-h|--help${NC}         Show this help"
    echo ""
    echo -e "${ORANGE}Example:${NC} $0 --arch \"x86_64 aarch64\" --resume --gcc"
    echo -e "${SKY}Notes:${NC} Default is Clang. Set ${LEMON}ARCHS=\"x86_64 aarch64\"${NC} to limit targets."
    exit 0
}

# ── CLI Parsing ───────────────────────────────────────────────────────────────
USER_ARCHS=""
while [[ $# -gt 0 ]]; do
    if parse_common_flag "$@"; then
        shift "$COMMON_SHIFT"
        continue
    fi
    case "$1" in
        -a|--arch)
            USER_ARCHS="$2"
            shift 2 ;;
        -C|--clean)
            echo -e "${NEONRED}💥 Cleaning workspace...${NC}"
            rm -rf "$ROOT_DIR"
            exit 0 ;;
        -h|--help) show_help ;;
        *) echo -e "${NEONRED}Unknown option: $1${NC}"; show_help ;;
    esac
done

DEFAULT_ARCHS="i686 x86_64 aarch64 armv7hf armv6hf"
ARCHS="${USER_ARCHS:-$DEFAULT_ARCHS}"

setup_toolchain_dir

# ── Logic ─────────────────────────────────────────────────────────────────────

build_arch() {
    local arch="$1"
    local info="${ARCH_INFO[$arch]}"
    IFS=: read -r triple tarball cmake_proc <<<"$info"
    local out_file="$OUTPUT_DIR/mold-$arch"
    local log_file="$ROOT_DIR/build-$arch.log"

    echo -e "${NEONPURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # Check Resume Mode
    if [[ "$RESUME_MODE" == true && -f "$out_file" ]]; then
        echo -e "${MINT}⏭️  Skipping $arch: Binary already exists in output/ (Resume Mode)${NC}"
        return
    fi

    echo -e "${SKY}🏗️  Targeting:${NC} ${HIGHLIGHTER}$arch${NC} [${LAGOON}$triple${NC}] using ${JUNEBUD}$COMPILER_TYPE${NC}"

    # Ensure toolchain directory exists BEFORE curl runs
    mkdir -p "$TOOLCHAIN_DIR"

    # 1. Download Toolchain
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    download_toolchain "$tarpath" "$tarball" || exit 1

    # 2. Hash Verification
    echo -e "${PEACH}🛡️  Verifying Integrity...${NC}"
    verify_hash "$tarpath" "$tarball" || exit 1

    # 3. Extraction Check
    local extract_path="$TOOLCHAIN_DIR/$triple"
    extract_toolchain "$tarpath" "$triple" || exit 1

    # 4. Toolchain Path Setup
    local bin_dir="$extract_path/bin"
    local cc="$bin_dir/${triple}-${COMPILER_TYPE}"
    # GCC uses g++, Clang uses clang++
    local cxx_name="clang++"
    [[ "$COMPILER_TYPE" == "gcc" ]] && cxx_name="g++"
    local cxx="$bin_dir/${triple}-$cxx_name"
    local strip="$bin_dir/${triple}-strip"

    # 5. Build Process
    local bdir="$BUILD_BASE/$arch"
    local idir="$BUILD_BASE/$arch-install"
    mkdir -p "$bdir" "$idir" "$OUTPUT_DIR"

    echo -e "${SKY}==>${NC} ${ORANGE}Configuring CMake...${NC}"
    # Force colors in the generated Makefile so progress strings are sent to the pipe
    cmake -S "$SOURCE_DIR" -B "$bdir" -G "${CMAKE_GENERATOR:-Unix Makefiles}" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_SYSTEM_NAME=Linux \
        -DCMAKE_SYSTEM_PROCESSOR="$cmake_proc" \
        -DCMAKE_C_COMPILER="$cc" \
        -DCMAKE_CXX_COMPILER="$cxx" \
        -DCMAKE_INSTALL_PREFIX="$idir" \
        -DMOLD_STATIC_LINK_CXX=ON \
        -DMOLD_USE_SYSTEM_MIMALLOC=OFF \
        -DMOLD_USE_SYSTEM_TBB=OFF \
        -DBUILD_SHARED_LIBS=OFF \
        -DCMAKE_COLOR_MAKEFILE=ON \
        -DCMAKE_CXX_FLAGS="-Wno-stringop-overflow" \
        -DCMAKE_EXE_LINKER_FLAGS="-static" > "$log_file" 2>&1 || {
            echo -e "${NEONRED}CMake configure FAILED. Check $log_file${NC}"; return 1;
        }

    echo -e "${SKY}==>${NC} ${LAGOON}Building mold (Jobs: $JOBS)...${NC}"

    local build_failed
    set +e +o pipefail

    if command -v ninja &>/dev/null; then
        ninja -v -j"$JOBS" -C "$bdir" >"$log_file" 2>&1 &
        local ninja_pid=$!
        local pct=0
        while kill -0 "$ninja_pid" 2>/dev/null; do
            local last
            last=$(grep -o '\[[0-9]*/[0-9]*\]' "$log_file" 2>/dev/null | tail -1)
            if [[ "$last" =~ \[([0-9]+)/([0-9]+)\] ]] && [[ ${BASH_REMATCH[2]} -gt 0 ]]; then
                pct=$(( BASH_REMATCH[1] * 100 / BASH_REMATCH[2] ))
            fi
            printf "\r${NEONPINK}  [ %3s%% ] Building...${NC}" "$pct"
            sleep 0.2
        done
        wait "$ninja_pid"
        build_failed=$?
    else
        make -j"$JOBS" -C "$bdir" >"$log_file" 2>&1 &
        local make_pid=$!
        local spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
        local i=0
        while kill -0 "$make_pid" 2>/dev/null; do
            printf "\r${CORAL}  %s Building...${NC}" "${spin[$((i++ % ${#spin[@]}))]}"
            sleep 0.1
        done
        wait "$make_pid"
        build_failed=$?
    fi

    printf "\r%60s\r" ""
    if [[ $build_failed -ne 0 ]]; then
        echo -e "${NEONRED}Build FAILED:${NC}"
        grep -E 'error:' "$log_file" | tail -10 | \
            while IFS= read -r line; do echo -e "  ${TOMATO}│${NC} $line"; done
        echo -e "${SLATE}  Full log: $log_file${NC}"
        return 1
    fi
    echo -e "${NEONGREEN}  [ 100% ] Build complete.${NC}"

    echo -e "${SKY}==>${NC} ${NEONPURPLE}Installing to temporary dir...${NC}"
    cmake --build "$bdir" --target install >> "$log_file" 2>&1

    # 6. Finalize Binary
    cp "$idir/bin/mold" "$out_file"
    if [[ -x "$strip" ]]; then
        echo -e "${SKY}==>${NC} ${PEACH}Stripping symbols...${NC}"
        "$strip" "$out_file"
    fi

    local final_size=$(du -sh "$out_file" | awk '{print $1}')
    echo -e "${NEONGREEN}✅ Successfully built: ${BWHITE}mold-$arch${NC} (${JUNEBUD}$final_size${NC})"
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo -e "${HOTPINK}Starting mold cross-compilation suite...${NC}"

# Setup Directories
mkdir -p "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR"

# Check for mold source
if [[ ! -d "$SOURCE_DIR/.git" ]]; then
    echo -e "${SKY}==>${HIGHLIGHTER} Cloning mold source...${NC}"
    git clone --branch "$MOLD_BRANCH" --depth 1 https://github.com/gfunkmonk/mold.git "$SOURCE_DIR" > /dev/null 2>&1
fi

# Determine build system
CMAKE_GENERATOR="Unix Makefiles"
BUILD_CMD="make -j$JOBS"
if command -v ninja &>/dev/null; then
    CMAKE_GENERATOR="Ninja"
    BUILD_CMD="ninja -j$JOBS"
fi

# Loop through architectures
for arch in $ARCHS; do
    if [[ -z "${ARCH_INFO[$arch]:-}" ]]; then
        echo -e "${ORANGE}Skipping unknown architecture: $arch${NC}"
        continue
    fi
    build_arch "$arch"
done

final