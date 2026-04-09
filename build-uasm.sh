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
SLATE="\033[38;2;145;200;222m"
TAWNY="\033[38;2;204;78;0m"
BWHITE="\033[1;37m"
CYAN="\033[1;36m"
NC="\033[0m"

# ── Defaults & Config ─────────────────────────────────────────────────────────
ROOT_DIR="$(pwd)/uasm-build"
REPO_URL="https://github.com/gfunkmonk/UASM.git"
REPO_BRANCH="v2.58"
BUILD_BASE="$ROOT_DIR/build"
OUTPUT_DIR="$ROOT_DIR/output"
JOBS="$(nproc)"
COMPILER_TYPE="clang"
RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/magazine/"
RESUME_MODE=false

# ── Architecture Table ────────────────────────────────────────────────────────
declare -A ARCH_INFO=(
  [x86_64]="x86_64-unknown-linux-musl:x86_64-unknown-linux-musl.tar.xz:Makefile-Linux-GCC-64.mak"
  [aarch64]="aarch64-unknown-linux-musl:aarch64-unknown-linux-musl.tar.xz:Makefile-Linux-GCC-64.mak"
  [i686]="i686-unknown-linux-musl:i686-unknown-linux-musl.tar.xz:Makefile-Linux-GCC-64.mak"
  [armv7]="armv7-unknown-linux-musleabihf:armv7-unknown-linux-musleabihf.tar.xz:Makefile-Linux-GCC-64.mak"
  [armhf]="arm-unknown-linux-musleabihf:arm-unknown-linux-musleabihf.tar.xz:Makefile-Linux-GCC-64.mak"
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
  [aarch64-unknown-linux-musl.tar.xz]="5dd03719e91e295d0bc32287e54107d1b74c82a2f9f19ec041949eb84e4b0a89"
  [arm-unknown-linux-musleabihf.tar.xz]="70ba032a2281b00ea739888899774a339a6b4ca25416b0fa5aa972a4b0b107d0"
  [armv7-unknown-linux-musleabihf.tar.xz]="e9a991d7e6bf228bc297c3eeba8b45c3fdf4a95df5e170f624ab54a4310a9d28"
  [i686-unknown-linux-musl.tar.xz]="45c9763c0c03e284b0577e2b5881c13813803a1e985b705a3a1a5200c4efaeb8"
  [x86_64-unknown-linux-musl.tar.xz]="188e16cf5823386e6efa734c23de0455149fa0355e46a761b2cd189a9f25f989"
)

# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${MAUVE}Usage:${NC} $0 [OPTIONS]"
    echo ""
    echo -e "${BWHITE}Options:${NC}"
    echo -e "  ${CHARTREUSE}--gcc${NC}                Use GCC toolchains"
    echo -e "  ${CHARTREUSE}--clang${NC}              Use Clang toolchains (default)"
    echo -e "  ${CHARTREUSE}-a|--arch \"LIST\"${NC}     Space separated list of arches to build"
    echo -e "  ${CHARTREUSE}-r|--resume${NC}          Skip architectures already found in output/"
    echo -e "  ${CHARTREUSE}-j|--jobs N${NC}          Parallel make jobs (default: auto-detected)"
    echo -e "  ${CHARTREUSE}-C|--clean${NC}           Wipe build artifacts and source"
    echo -e "  ${CHARTREUSE}-h|--help${NC}            Show this menu"
    exit 0
}

success() {
    echo -e "${CHARTREUSE}[SUCCESS]${NC} $*"
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
            echo -e "${TOMATO}💥 Cleaning workspace...${NC}"
            rm -rf "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR"
            exit 0 ;;
        -h|--help) show_help ;;
        *) echo -e "${CRIMSON}Unknown option: $1${NC}"; show_help ;;
    esac
done

DEFAULT_ARCHS="x86_64 aarch64 i686 armv7 armhf"
ARCHS="${USER_ARCHS:-$DEFAULT_ARCHS}"

if [[ "$COMPILER_TYPE" == clang ]]; then
  TOOLCHAIN_DIR="$ROOT_DIR/toolchains/clang"
else
  TOOLCHAIN_DIR="$ROOT_DIR/toolchains/gcc"
fi

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
        echo -e "${MAUVE}==>${NC} Fetching toolchain: ${CANARY}$tarball${NC}"
        # We use -L to follow redirects and -# for the bar
        curl -fSL -# --retry 3 -o "$tarpath" "$RELEASE_BASE/$tarball" 2>&1 | \
        while IFS= read -d $'\r' -r p; do
            # The '##*' strips everything up to the last space,
            # and '${p%%%*}' strips the trailing percentage sign.
            # This is faster and more reliable than expr in a tight loop.
            local clean_p=$(echo "$p" | tr -dc '0-9.' | cut -d. -f1)
            # Default to 0 if clean_p is empty
            : ${clean_p:=0}
            # Scale for the 10-step Sunflower bar
            local scaled=$(( clean_p / 10 ))
            if [ "$scaled" -gt 0 ]; then
                # Using a native bash string generator instead of eval/seq for speed/safety
                bar=$(printf '%.0s=' $(seq 1 "$scaled"))
            else
                bar=""
            fi
            printf "\r${CYAN}[ %3d%% ] [ %-10s> ]${NC}" "$clean_p" "$bar"
        done
        if [[ "${PIPESTATUS[0]}" -ne 0 ]]; then
            echo -e "\n${CRIMSON}Download failed for $tarball${NC}"
            rm -f "$tarpath"
            exit 1
        fi
        echo -e "\n${CHARTREUSE}✨ Download Complete.${NC}"
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
    echo -e "${MAUVE}==>${BWHITE} Preparing build environment...${NC}"
    rm -rf "$build_work_dir"
    mkdir -p "$build_work_dir"
    cp -r "$BUILD_BASE/uasm-src/." "$build_work_dir/"

    cd "$build_work_dir"

    # 6. Compile with Interactive Progress Bar & Logging
    local log_file="$ROOT_DIR/build-${arch_key}.log"
    mkdir -p "$ROOT_DIR/uasm-build"

    # This strips the ROOT_DIR from the path for a cleaner display
    local relative_log="${log_file#$ROOT_DIR/}"

    echo -e "${MAUVE}==>${NC} ${CORAL}Running Make (Jobs: $JOBS)...${NC}"
    echo -e "${SLATE}Log: ./$relative_log${NC}"

    local total_files=$(find . -name "*.c" | wc -l)
    local current_file=0
    set +e
    make -f "$makefile" CC="$cc_bin -static" STRIP="$strip_bin" -j"$JOBS" 2>&1 | tee "$log_file" | \
    while IFS= read -r line; do
        if [[ "$line" == *" -c "* && "$line" == *".c"* ]]; then
            ((current_file++)) || true
            local percent=0
            [[ "$total_files" -gt 0 ]] && percent=$(( current_file * 105 / total_files ))
            [[ $percent -gt 100 ]] && percent=100
            local num_hashes=$(( percent / 2 ))
            local hashes=$(printf "%${num_hashes}s" | tr ' ' '#')
            printf "\r${CYAN}[%-50s] %d%% (${CANARY}%d/%d${NC})" \
                "$hashes" "$percent" "$current_file" "$total_files"
        fi
    done
    local make_exit=${PIPESTATUS[0]}
    set -e
    echo ""
    if [[ "$make_exit" -ne 0 ]]; then
        echo -e "${CRIMSON}Build failed! Check log: $log_file${NC}"
        exit 1
    fi

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
    git clone --branch "$REPO_BRANCH" --depth 1 "$REPO_URL" "$BUILD_BASE/uasm-src" > /dev/null 2>&1
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
for arch in $ARCHS; do
    local_out="$OUTPUT_DIR/uasm-$arch"
    if [[ -f "$local_out" ]]; then
        size=$(stat -c%s "$local_out" 2>/dev/null || stat -f%z "$local_out" 2>/dev/null || echo "unknown")
        success "Built $arch: uasm-$arch ($(numfmt --to=iec-i --suffix=B "$size" 2>/dev/null || echo "$size bytes"))"
    fi
done
ls -lh "$OUTPUT_DIR"

