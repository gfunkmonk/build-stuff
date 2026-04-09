#!/usr/bin/env bash

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
CANARY="\033[38;2;255;255;153m"
CARIBBEAN="\033[38;2;0;204;153m"
CHARTREUSE="\033[38;2;127;255;0m"
CORAL="\033[38;2;240;128;128m"
CRIMSON="\033[38;2;220;20;60m"
MAUVE="\033[38;2;224;175;255m"
MINT="\033[38;2;152;255;152m"
HELIOTROPE="\033[38;2;223;115;255m"
TOMATO="\033[38;2;255;99;71m"
SLATE="\033[38;2;109;129;150m"
TAWNY="\033[38;2;204;78;0m"
BWHITE="\033[1;37m"
NC="\033[0m"

# ── Defaults & Config ─────────────────────────────────────────────────────────
ROOT_DIR="$(pwd)"
REPO_URL="https://github.com/gfunkmonk/UASM.git"
REPO_BRANCH="v2.58"
TOOLCHAIN_DIR="$ROOT_DIR/toolchains"
BUILD_BASE="$ROOT_DIR/uasm-build"
OUTPUT_DIR="$ROOT_DIR/uasm-output"
JOBS="$(nproc)"
COMPILER_TYPE="clang"
RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/magazine/"
RESUME_MODE=false

# ── Architecture Table ────────────────────────────────────────────────────────
declare -A ARCH_INFO=(
  [x86_64]="x86_64-unknown-linux-musl:x86_64-unknown-linux-musl.tar.xz:Makefile-Linux-GCC-64.mak"
  [aarch64]="aarch64-unknown-linux-musl:aarch64-unknown-linux-musl.tar.xz:Makefile-Linux-GCC-64.mak"
  [i686]="i686-unknown-linux-musl:i686-unknown-linux-musl.tar.xz:Makefile-Linux-GCC-64.mak"
  [armv7hf]="armv7-unknown-linux-musleabihf:armv7-unknown-linux-musleabihf.tar.xz:Makefile-Linux-GCC-64.mak"
  [armv6hf]="arm-unknown-linux-musleabihf:arm-unknown-linux-musleabihf.tar.xz:Makefile-Linux-GCC-64.mak"
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
    echo -e "${MAUVE}Usage:${NC} $0 [OPTIONS]"
    echo ""
    echo -e "${BWHITE}Options:${NC}"
    echo -e "  ${CHARTREUSE}--gcc${NC}             Use GCC toolchains"
    echo -e "  ${CHARTREUSE}--clang${NC}           Use Clang toolchains (default)"
    echo -e "  ${CHARTREUSE}--arch \"LIST\"${NC}     Space separated list of arches to build"
    echo -e "  ${CHARTREUSE}--resume${NC}          Skip architectures already found in output/"
    echo -e "  ${CHARTREUSE}--clean${NC}           Wipe build artifacts and source"
    echo -e "  ${CHARTREUSE}--help${NC}            Show this menu"
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
            echo -e "${TOMATO}💥 Cleaning workspace...${NC}"
            rm -rf "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR"
            exit 0 ;;
        --help) show_help ;;
        *) echo -e "${CRIMSON}Unknown option: $1${NC}"; show_help ;;
    esac
done

DEFAULT_ARCHS="x86_64 aarch64 i686 armv7hf armv6hf"
ARCHS="${USER_ARCHS:-$DEFAULT_ARCHS}"

# ── Build Logic ───────────────────────────────────────────────────────────────

build_arch() {
    local arch_key="$1"
    local info="${ARCH_INFO[$arch_key]}"
    IFS=: read -r triple tarball makefile <<<"$info"
    
    local out_file="$OUTPUT_DIR/uasm-$arch_key"

    echo -e "${HELIOTROPE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [[ "$RESUME_MODE" == true && -f "$out_file" ]]; then
        echo -e "${MINT}⏭️  Skipping $arch_key: Binary exists (Resume Mode)${NC}"
        return
    fi

    echo -e "${CARIBBEAN}🏗️  Targeting:${NC} ${CANARY}$arch_key${NC} [${SLATE}$triple${NC}] via ${TAWNY}$COMPILER_TYPE${NC}"
    
    mkdir -p "$TOOLCHAIN_DIR"

    # 1. Download Toolchain
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    if [[ ! -f "$tarpath" ]]; then
        echo -e "${MAUVE}==>${NC} Fetching toolchain..."
        curl -fsSL --retry 3 -o "$tarpath" "$RELEASE_BASE/$tarball" || {
            echo -e "${CRIMSON}Download failed for $tarball${NC}"
            exit 1
        }
    else
        echo -e "${MINT}✨ Using cached tarball: $tarball${NC}"
    fi

    # 2. Hash Verification
    echo -e "${CORAL}🛡️  Verifying Integrity...${NC}"
    local expected
    [[ "$COMPILER_TYPE" == "gcc" ]] && expected="${HASHES_GCC[$tarball]}" || expected="${HASHES_CLANG[$tarball]}"

    local actual=$(sha256sum "$tarpath" | awk '{print $1}')
    if [[ "$actual" != "$expected" ]]; then
        echo -e "${CRIMSON}CRITICAL: Hash mismatch for $tarball!${NC}"
        echo -e "Expected: $expected\nGot: $actual"
        rm -f "$tarpath" 
        exit 1
    fi

    # 3. Extraction with verification
    local extract_path="$TOOLCHAIN_DIR/$triple"
    if [[ ! -d "$extract_path" ]]; then
        echo -e "${MAUVE}==>${NC} Extracting toolchain..."
        tar -xJf "$tarpath" -C "$TOOLCHAIN_DIR"
    else
        echo -e "${MINT}✨ Toolchain already extracted.${NC}"
    fi

    # 4. Compiler Path Setup
    local bin_dir="$extract_path/bin"
    local cc_bin="$bin_dir/${triple}-${COMPILER_TYPE}"
    local strip_bin="$bin_dir/${triple}-strip"

    # 5. Prep Work Dir
    local build_work_dir="$BUILD_BASE/work-$arch_key"
    echo -e "${MAUVE}==>${NC} Preparing build environment..."
    rm -rf "$build_work_dir"
    mkdir -p "$build_work_dir"
    cp -r "$BUILD_BASE/uasm-src/." "$build_work_dir/"
    
    cd "$build_work_dir"

    # 6. Compile
    echo -e "${MAUVE}==>${NC} ${CORAL}Running Make (Jobs: $JOBS)...${NC}"
    
    # Injecting -static into CC to ensure musl static linkage
    make -f "$makefile" \
        CC="$cc_bin -static" \
        STRIP="$strip_bin" \
        -j"$JOBS" > /dev/null

    # 7. Finalize
    local generated_bin=""
    [[ -f "GccUnixR/uasm" ]] && generated_bin="GccUnixR/uasm"
    [[ -f "uasm" ]] && generated_bin="uasm"

    if [[ -z "$generated_bin" ]]; then
        echo -e "${CRIMSON}Error: Binary not found after build!${NC}"
        exit 1
    fi

    mkdir -p "$OUTPUT_DIR"
    cp "$generated_bin" "$out_file"
    
    if [[ -x "$strip_bin" ]]; then
        echo -e "${MAUVE}==>${NC} Stripping symbols..."
        "$strip_bin" "$out_file"
    fi

    local final_size=$(du -sh "$out_file" | awk '{print $1}')
    echo -e "${CHARTREUSE}✅ Successfully built: ${BWHITE}uasm-$arch_key${NC} (${CANARY}$final_size${NC})"
    
    cd "$ROOT_DIR"
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo -e "${HELIOTROPE}🚀 Starting UASM Cross-Build Suite...${NC}"

mkdir -p "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR"

# Clone Source once
if [[ ! -d "$BUILD_BASE/uasm-src/.git" ]]; then
    echo -e "${MAUVE}==>${NC} Cloning UASM source ($REPO_BRANCH)..."
    git clone --branch "$REPO_BRANCH" --depth 1 "$REPO_URL" "$BUILD_BASE/uasm-src"
else
    echo -e "${MINT}✨ Source code present.${NC}"
fi

# Run targets
for arch in $ARCHS; do
    if [[ -z "${ARCH_INFO[$arch]:-}" ]]; then
        echo -e "${TOMATO}Skipping unknown architecture: $arch${NC}"
        continue
    fi
    build_arch "$arch"
done

echo -e "\n${HELIOTROPE}🎊 UASM Build completed!${NC}"
ls -lh "$OUTPUT_DIR"