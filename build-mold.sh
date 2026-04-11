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
    echo -e "  ${NEONGREEN}-C|--clean${NC}        Wipe build, toolchains, and output"
    echo -e "  ${NEONGREEN}-h|--help${NC}         Show this help"
    echo ""
    echo -e "${ORANGE}Example:${NC} $0 --arch \"x86_64 aarch64\" --resume --gcc"
    echo -e "${SKY}Notes:${NC} Default is Clang. Set ${LEMON}ARCHS=\"x86_64 aarch64\"${NC} to limit targets."
    exit 0
}

# ── CLI Parsing ───────────────────────────────────────────────────────────────
USER_ARCHS=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --gcc)
            RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/carhartcoat"
            COMPILER_TYPE="gcc"
            shift ;;
        --clang)
            RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/magazine/"
            COMPILER_TYPE="clang"
            shift ;;
        -a|--arch)
            USER_ARCHS="$2"
            shift 2 ;;
        -r|--resume)
            RESUME_MODE=true
            shift ;;
        -j|--jobs)
            JOBS="$2"
            shift 2
            ;;
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

TOOLCHAIN_DIR="$(pwd)/toolchains/$COMPILER_TYPE"
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

    # 1. Download Toolchain (Sunflower Style)
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    if [[ ! -f "$tarpath" ]]; then
        echo -e "${SKY}==>${HOTPINK} Fetching toolchain...${NC}"
        curl -fSL -# --retry 3 -o "$tarpath" "$RELEASE_BASE/$tarball" 2>&1 | while IFS= read -d $'\r' -r p; do
            p=$(echo "$p" | tr -dc '0-9.' | cut -d. -f1); : ${p:=0}
            local scaled=$(( p / 10 ))
            local bar=$(printf "%${scaled}s" | tr ' ' '=')
            printf "\r${NEONGREEN}[ %3d%% ] [ %-10s> ]${NC}" "$p" "$bar"
        done
        [[ "${PIPESTATUS[0]}" -eq 0 ]] || { echo -e "\n${NEONRED}Download failed.${NC}"; exit 1; }
        echo ""
    fi

    # 2. Hash Verification
    echo -e "${PEACH}🛡️  Verifying Integrity...${NC}"
    local expected
    if [[ "$COMPILER_TYPE" == "gcc" ]]; then
        expected="${HASHES_GCC[$tarball]}"
    else
        expected="${HASHES_CLANG[$tarball]}"
    fi

    local actual=$(sha256sum "$tarpath" | awk '{print $1}')
    if [[ "$actual" != "$expected" ]]; then
        echo -e "${NEONRED}CRITICAL: Hash mismatch for $tarball!${NC}"
        echo -e "${BWHITE}Expected: $expected${NC}"
        echo -e "${BWHITE}Got     : $actual${NC}"
        rm -f "$tarpath" # Remove bad download
        exit 1
    fi

    # 3. Extraction Check
    local extract_path="$TOOLCHAIN_DIR/$triple"
    if [[ ! -d "$extract_path" ]]; then
        echo -e "${SKY}==>${NEONBLUE} Extracting toolchain...${NC}"
        mkdir -p "$extract_path"
        tar -xJf "$tarpath" -C "$TOOLCHAIN_DIR"
        # Sanity check after extraction
        [[ -d "$extract_path" ]] || { echo -e "${NEONRED}Extraction failed!${NC}"; exit 1; }
    else
        echo -e "${MINT}✨ Toolchain directory already exists. Skipping extraction.${NC}"
    fi

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
        -DCMAKE_EXE_LINKER_FLAGS="-static" > "$log_file" 2>&1 || {
            echo -e "${NEONRED}CMake configure FAILED. Check $log_file${NC}"; return 1;
        }

echo -e "${SKY}==>${NC} ${LAGOON}Building mold (Jobs: $JOBS)...${NC}"
    
    # Recalculate total files (including generated headers/objects)
    local total_files=$(find "$SOURCE_DIR" -name "*.cc" -o -name "*.c" | wc -l)
    # Give a 10% buffer for generated shim files to keep the denominator realistic
    total_files=$(( total_files + (total_files / 10) ))
    local current_file=0

    set +e
    # Force VERBOSE=1 and stdbuf to ensure every compiler call is caught
    exec 3< <(VERBOSE=1 stdbuf -oL ${BUILD_CMD} -C "$bdir" 2>&1 | tee -a "$log_file")

    while read -u 3 -r line; do
        # Detect the compiler execution lines
        if [[ "$line" == *"Building"* && "$line" == *".o"* ]]; then
            ((current_file++))
            # Calculate percentage with a 100% cap
            local p=$(( current_file * 100 / total_files ))
            if [ "$p" -gt 100 ]; then p=100; fi
            local scaled=$(( p / 5 ))
            local bar=$(printf "%${scaled}s" | tr ' ' '#')
            # Print the updated bar with the current count
            printf "\r${CHARTREUSE}[%-20s] %3d%%${NC} ${SLATE}(%d total objects)${NC}" "$bar" "$p" "$current_file"
        fi
    done
    exec 3<&-
    set -e

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

echo -e "\n${NEONPINK}🎊 All requested architectures are finished!${NC}"
echo -e "${BWHITE}Final binaries available in:${NC} ${MINT}$OUTPUT_DIR${NC}"
ls -F --color=auto "$OUTPUT_DIR"
