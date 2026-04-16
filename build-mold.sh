#!/usr/bin/env bash

# ── Common Code ───────────────────────────────────────────────────────────────
source "$(dirname "$0")/common.sh"

# ── Defaults & Config ─────────────────────────────────────────────────────────
REPO_URL="https://github.com/gfunkmonk/mold.git"
REPO_BRANCH="stable"
DL_COLOR="${NEONGREEN}"
DL_TC_1="${SKY}"
DL_TC_2="${HOTPINK}"
DL_TC_3="${CHARTREUSE}"
EX_TC_1="${SKY}"
EX_TC_2="${NEONBLUE}"
EX_TC_3="${LAGOON}"
FINAL_C="${HOTPINK}"
CLEAN_C="${NEONRED}"
GIT_C="${SKY}"
GIT_C2="${HIGHLIGHTER}"

# ── Architecture Table ────────────────────────────────────────────────────────
declare -A ARCH_INFO=(
  [x86_64]="x86_64-unknown-linux-musl:x86_64-unknown-linux-musl.tar.xz:x86_64"
  [x86]="i686-unknown-linux-musl:i686-unknown-linux-musl.tar.xz:i686"
  [aarch64]="aarch64-unknown-linux-musl:aarch64-unknown-linux-musl.tar.xz:aarch64"
  [armv7]="armv7-unknown-linux-musleabihf:armv7-unknown-linux-musleabihf.tar.xz:arm"
  [armhf]="arm-unknown-linux-musleabihf:arm-unknown-linux-musleabihf.tar.xz:arm"
)

# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${LEMON}Usage:${NC} $0 [OPTIONS]"
    echo ""
    echo -e "${BWHITE}Options:${NC}"
    echo -e "  ${NEONGREEN}--gcc${NC}             Use GCC toolchains (musl, default)"
    echo -e "  ${NEONGREEN}--clang${NC}           Use Clang toolchains"
    echo -e "  ${NEONGREEN}--gnu${NC}             Use GNU GCC toolchains (glibc)"
    echo -e "  ${NEONGREEN}-a|--arch \"LIST\"${NC}  Space separated list of arches to build"
    echo -e "  ${NEONGREEN}-r|--resume${NC}       Skip architectures already found in output/"
    echo -e "  ${NEONGREEN}-j|--jobs N${NC}       Parallel make jobs (default: auto-detected)"
    echo -e "  ${NEONGREEN}-C|--clean${NC}        Wipe build and output"
    echo -e "  ${NEONGREEN}--list-archs${NC}      Print all available target architectures"
    echo -e "  ${NEONGREEN}-h|--help${NC}         Show this help"
    echo ""
    echo -e "${ORANGE}Example:${NC} $0 --arch \"x86_64 aarch64\" --resume --gcc"
    echo -e "${SKY}Notes:${NC} Default is Clang. Set ${LEMON}ARCHS=\"x86_64 aarch64\"${NC} to limit targets."
    exit 0
}

# ── CLI Parsing ───────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    if parse_common_flag "$@"; then
        shift "$COMMON_SHIFT"
        continue
    fi
    case "$1" in
        -h|--help) show_help ;;
        *) echo -e "${NEONRED}Unknown option: $1${NC}"; show_help ;;
    esac
done

DEFAULT_ARCHS="x86_64 x86 aarch64 armv7 armhf"
ARCHS="${USER_ARCHS:-$DEFAULT_ARCHS}"

setup_toolchain_dir

# ── Logic ─────────────────────────────────────────────────────────────────────

build_arch() {
    local arch="$1"
    local info="${ARCH_INFO[$arch]}"
    IFS=: read -r triple tarball cmake_proc <<<"$info"
    local out_file="$OUTPUT_DIR/$NAME-$arch"
    local log_file="$ROOT_DIR/build-$arch.log"

    echo -e "${NEONPURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # Check Resume Mode
    if [[ "$RESUME_MODE" == true && -f "$out_file" ]]; then
        echo -e "${MINT}⏭️  Skipping $arch: Binary already exists in output/ (Resume Mode)${NC}"
        return
    fi

    echo -e "${SKY}🦠 Targeting:${NC} ${HIGHLIGHTER}$arch${NC} [${LAGOON}$triple${NC}] using ${JUNEBUD}$COMPILER_TYPE${NC}"

    # Ensure toolchain directory exists BEFORE curl runs
    mkdir -p "$TOOLCHAIN_DIR"

    # 1. Download Toolchain
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    download_toolchain "$tarpath" "$tarball" || return 1

    # 2. Hash Verification
    echo -e "${PEACH}🔒︎  Verifying Integrity...${NC}"
    verify_hash "$tarpath" "$tarball" || return 1

    # 3. Extraction Check
    local extract_path="$TOOLCHAIN_DIR/$triple"
    extract_toolchain "$tarpath" "$triple" || return 1

    # 4. Toolchain Path Setup
    local bin_dir="$extract_path/bin"
    local cc="$bin_dir/${triple}-${COMPILER_BIN}"
    # GCC uses g++, Clang uses clang++
    local cxx_name="clang++"
    [[ "$COMPILER_BIN" == "gcc" ]] && cxx_name="g++"
    local cxx="$bin_dir/${triple}-$cxx_name"
    local strip="$bin_dir/${triple}-strip"

    # 5. Build Process
    local bdir="$BUILD_BASE/$arch"
    local idir="$BUILD_BASE/$arch-install"
    mkdir -p "$bdir" "$idir" "$OUTPUT_DIR"

    echo -e "${SKY}==>${NC} ${ORANGE}🎛 Configuring CMake...${NC}"
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
        -DCMAKE_C_FLAGS="${CFLAGS} -fPIC" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS} -fPIC$([[ "$COMPILER_BIN" == "gcc" ]] && echo " -Wno-stringop-overflow")" \
        -DCMAKE_EXE_LINKER_FLAGS="-static" > "$log_file" 2>&1 || {
            echo -e "${NEONRED}CMake configure FAILED❗ Check $log_file${NC}"; return 1;
        }

    echo -e "${SKY}==>${NC} ${LAGOON}☢ Building mold (Jobs: $JOBS)...${NC}"

    # Force ninja to output progress markers even when redirected
    # We use 'grep-count' as a backup because [x/y] can be inconsistent in logs
    local total_estimate=$(grep -c "add_executable" "$SOURCE_DIR/CMakeLists.txt" 2>/dev/null || echo "500")

    ninja -v -C "$bdir" > "$log_file" 2>&1 &
    track_progress $! "$log_file" "ninja" "$total_estimate" "${NEONPINK}"

    echo -e "${SKY}==>${NC} ${NEONPURPLE}Installing to temporary dir...${NC}"
    cmake --build "$bdir" --target install >> "$log_file" 2>&1 || {
        echo -e "${NEONRED}Install FAILED❗Check $log_file${NC}"; return 1;
    }

    # 6. Finalize Binary
    cp "$idir/bin/mold" "$out_file"
    if [[ -x "$strip" ]]; then
        echo -e "${SKY}==>${NC} ${PEACH}👙 Stripping symbols...${NC}"
        "$strip" "$out_file"
    fi

    verify_binary_arch "$out_file" "$triple"
    local final_size; final_size=$(du -sh "$out_file" | awk '{print $1}')
    echo -e "\n${NEONGREEN}✅ Successfully built: ${BWHITE}mold-$arch${NC} (${JUNEBUD}$final_size${NC})"
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo -e "${HOTPINK}Starting mold cross-compilation suite...${NC}"

# Setup Directories
mkdir -p "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR"

git_clone

# Determine build system
CMAKE_GENERATOR="Unix Makefiles"
if command -v ninja &>/dev/null; then
    CMAKE_GENERATOR="Ninja"
fi

# Loop through architectures
build_all_archs

final
