#!/usr/bin/env bash

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
JUNEBUD="\033[38;2;189;218;87m"
SKY="\033[38;2;4;218;255m"
NEONPURPLE="\033[38;2;225;8;255m"
MINT="\033[38;2;152;255;152m"
ORANGE="\033[38;2;255;165;0m"
LEMON="\033[38;2;255;244;79m"
PEACH="\033[38;2;246;161;146m"
LAGOON="\033[38;2;142;235;236m"
HIGHLIGHTER="\033[38;2;248;255;15m"
BWHITE="\033[1;37m"
NEONPINK="\033[38;2;255;19;240m"
HOTPINK="\033[38;2;255;105;180m"
NEONRED="\033[38;2;255;49;49m"
NEONGREEN="\033[38;2;57;255;20m"
NEONBLUE="\033[38;2;4;218;255m"
NC="\033[0m"

# ── Defaults & Config ─────────────────────────────────────────────────────────
# Use absolute paths to prevent curl write errors in relative subdirs
ROOT_DIR="$(pwd)"
RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/magazine/"
TOOLCHAIN_DIR="$ROOT_DIR/toolchains"
MOLD_SRC="$ROOT_DIR/mold"
BUILD_BASE="$ROOT_DIR/build"
OUTPUT_DIR="$ROOT_DIR/output"
JOBS="$(nproc)"
MOLD_BRANCH="stable"
COMPILER_TYPE="clang"
RESUME_MODE=false

# ── Architecture Table ────────────────────────────────────────────────────────
declare -A ARCH_INFO=(
  [i686]="i686-unknown-linux-musl:i686-unknown-linux-musl.tar.xz:i686"
  [x86_64]="x86_64-unknown-linux-musl:x86_64-unknown-linux-musl.tar.xz:x86_64"
  [aarch64]="aarch64-unknown-linux-musl:aarch64-unknown-linux-musl.tar.xz:aarch64"
  [armv7hf]="armv7-unknown-linux-musleabihf:armv7-unknown-linux-musleabihf.tar.xz:arm"
  [armv6hf]="arm-unknown-linux-musleabihf:arm-unknown-linux-musleabihf.tar.xz:arm"
)

# ── SHA256 Hash Tables ────────────────────────────────────────────────────────
declare -A HASHES_CLANG=(
  [aarch64-unknown-linux-musl.tar.xz]="95c7d6a863d925fd68e285dea8d125c806c7c8f7032669123a81b1053b84bd20"
  [arm-unknown-linux-musleabihf.tar.xz]="bb54d5895aec06c6a638960b02ba8ca35b79963b07e3a5759e42c97b37044287"
  [armv7-unknown-linux-musleabihf.tar.xz]="f52decfd3cdb1e6248465a0643e17bdf3eb4e85608f58c5506a5420c265bc8f5"
  [i686-unknown-linux-musl.tar.xz]="1481bc6af546d0eca71b6568475ed37649db50c3fbd47edeb4b3c3753861c5cb"
  [x86_64-unknown-linux-musl.tar.xz]="62f74a4c082249f736662e35c847f73d9ae1134b2a76bfcdb33829d06fa70c92"
)

declare -A HASHES_GCC=(
  [aarch64-unknown-linux-musl.tar.xz]="cbcdecffa855f5d8e20b02f05835793f4e31505ce00da57798b75865db5ab387"
  [arm-unknown-linux-musleabihf.tar.xz]="cc19512e6ab5ea044304d9ccea4aa46927c4759b99b4aec4c0d529ffd5bdf1f9"
  [armv7-unknown-linux-musleabihf.tar.xz]="a6a053c0745e58e63ae5bb2104dbbd0b330d8fb30a87fedb814ab0750dd56a28"
  [i686-unknown-linux-musl.tar.xz]="b5885cdb20592f3e09acc7bf4ff29e0f99c66dbe33bdb2675d59c9f3fd3861f8"
  [x86_64-unknown-linux-musl.tar.xz]="4563113b8fbff8e1a00772426ce235434f48fdefa2968cc5f0e62c2baa7ab5cc" 
)

# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${LEMON}Usage:${NC} $0 [OPTIONS]"
    echo ""
    echo -e "${BWHITE}Options:${NC}"
    echo -e "  ${NEONGREEN}--gcc${NC}         Use GCC toolchains"
    echo -e "  ${NEONGREEN}--clang${NC}       Use Clang toolchains (default)"
    echo -e "  ${NEONGREEN}--arch \"LIST\"${NC} Space separated list of arches to build"
    echo -e "  ${NEONGREEN}--resume${NC}      Skip architectures already found in output/"
    echo -e "  ${NEONGREEN}--clean${NC}       Wipe build, toolchains, and output"
    echo -e "  ${NEONGREEN}--help${NC}        Show this help"
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
            RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/prevalence"
            COMPILER_TYPE="gcc"
            shift ;;
        --clang)
            RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/magazine/"
            COMPILER_TYPE="clang"
            shift ;;
        --arch)
            USER_ARCHS="$2"
            shift 2 ;;
        --resume)
            RESUME_MODE=true
            shift ;;
        --clean)
            echo -e "${NEONRED}💥 Cleaning workspace...${NC}"
            rm -rf "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR" "$MOLD_SRC"
            exit 0 ;;
        --help) show_help ;;
        *) echo -e "${NEONRED}Unknown option: $1${NC}"; show_help ;;
    esac
done

DEFAULT_ARCHS="i686 x86_64 aarch64 armv7hf armv6hf"
ARCHS="${USER_ARCHS:-$DEFAULT_ARCHS}"

# ── Logic ─────────────────────────────────────────────────────────────────────

build_arch() {
    local arch="$1"
    local info="${ARCH_INFO[$arch]}"
    IFS=: read -r triple tarball cmake_proc <<<"$info"
    local out_file="$OUTPUT_DIR/mold-$arch"

    echo -e "${NEONPURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Check Resume Mode
    if [[ "$RESUME_MODE" == true && -f "$out_file" ]]; then
        echo -e "${MINT}⏭️  Skipping $arch: Binary already exists in output/ (Resume Mode)${NC}"
        return
    fi

    echo -e "${SKY}🏗️  Targeting:${NC} ${HIGHLIGHTER}$arch${NC} [${LAGOON}$triple${NC}] using ${JUNEBUD}$COMPILER_TYPE${NC}"
    
    # Ensure toolchain directory exists BEFORE curl runs
    mkdir -p "$TOOLCHAIN_DIR"

    # 1. Download Cache Check
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    if [[ ! -f "$tarpath" ]]; then
        echo -e "${SKY}==>${HOTPINK} Fetching tarball from GitHub...${NC}"
        curl -fsSL --retry 3 --create-dirs -o "$tarpath" "$RELEASE_BASE/$tarball" || {
            echo -e "${NEONRED}FAILED to download $tarball. Check your connection or permissions.${NC}"
            exit 1
        }
    else
        echo -e "${MINT}✨ Cached tarball found: $tarball${NC}"
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
    cmake -S "$MOLD_SRC" -B "$bdir" -G "${CMAKE_GENERATOR:-Unix Makefiles}" \
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
        -DCMAKE_EXE_LINKER_FLAGS="-static" > /dev/null

    echo -e "${SKY}==>${NC} ${LAGOON}Building mold (Jobs: $JOBS)...${NC}"
    ${BUILD_CMD:-make} -C "$bdir" > /dev/null

    echo -e "${SKY}==>${NC} ${NEONPURPLE}Installing to temporary dir...${NC}"
    cmake --build "$bdir" --target install > /dev/null

    # 6. Finalize Binary
    local out_file="$OUTPUT_DIR/mold-$arch"
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
if [[ ! -d "$MOLD_SRC/.git" ]]; then
    echo -e "${SKY}==>${HIGHLIGHTER} Cloning mold source into $MOLD_SRC...${NC}"
    git clone --branch "$MOLD_BRANCH" --depth 1 https://github.com/gfunkmonk/mold.git "$MOLD_SRC"
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