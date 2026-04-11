#!/usr/bin/env bash

# ── Common Code ───────────────────────────────────────────────────────────────
source "$(dirname "$0")/common.sh"

# ── Defaults & Config ─────────────────────────────────────────────────────────
NAME=$(echo $0 | cut -d'-' -f2 | cut -d'.' -f1)
ROOT_DIR="$(pwd)/${NAME}-build"
REPO_URL="https://github.com/gfunkmonk/UASM.git"
REPO_BRANCH="v2.58"
BUILD_BASE="$ROOT_DIR/build"
OUTPUT_DIR="$ROOT_DIR/output"
DL_COLOR="${CYAN}"
DL_TC_1="${MAUVE}"
DL_TC_2="${NC}"
DL_TC_3="${CANARY}"
EX_TC_1="${MAUVE}"
EX_TC_2="${NC}"
FINAL_C="${NEONGREEN}"
CLEAN_C="${TOMATO}"

# ── Architecture Table ────────────────────────────────────────────────────────
declare -A ARCH_INFO=(
  [x86_64]="x86_64-unknown-linux-musl:x86_64-unknown-linux-musl.tar.xz:Makefile-Linux-GCC-64.mak"
  [aarch64]="aarch64-unknown-linux-musl:aarch64-unknown-linux-musl.tar.xz:Makefile-Linux-GCC-64.mak"
  [i686]="i686-unknown-linux-musl:i686-unknown-linux-musl.tar.xz:Makefile-Linux-GCC-64.mak"
  [armv7]="armv7-unknown-linux-musleabihf:armv7-unknown-linux-musleabihf.tar.xz:Makefile-Linux-GCC-64.mak"
  [armhf]="arm-unknown-linux-musleabihf:arm-unknown-linux-musleabihf.tar.xz:Makefile-Linux-GCC-64.mak"
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
while [[ $# -gt 0 ]]; do
    if parse_common_flag "$@"; then
        shift "$COMMON_SHIFT"
        continue
    fi
    case "$1" in
        -h|--help) show_help ;;
        *) echo -e "${CRIMSON}Unknown option: $1${NC}"; show_help ;;
    esac
done

DEFAULT_ARCHS="x86_64 aarch64 i686 armv7 armhf"
ARCHS="${USER_ARCHS:-$DEFAULT_ARCHS}"

setup_toolchain_dir

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
    download_toolchain "$tarpath" "$tarball" || exit 1

    # 2. Hash Verification
    echo -e "${CORAL}🛡️  Verifying Integrity...${NC}"
    verify_hash "$tarpath" "$tarball" || exit 1

    # 3. Extraction
    local extract_path="$TOOLCHAIN_DIR/$triple"
    extract_toolchain "$tarpath" "$triple" || exit 1

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

    # 6. Compile with Interactive Progress Bar & Logging
    local log_file="$ROOT_DIR/build-${arch_key}.log"
    mkdir -p "$ROOT_DIR/uasm-build"

    # This strips the ROOT_DIR from the path for a cleaner display
    local relative_log="${log_file#$ROOT_DIR/}"

    echo -e "${MAUVE}==>${NC} ${CORAL}Running Make (Jobs: $JOBS)...${NC}"
    echo -e "${SLATE}Log: ./$relative_log${NC}"

    local total_files=$(find "$build_work_dir" -name "*.c" | wc -l)
    local current_file=0
    set +e
    make -C "$build_work_dir" -f "$makefile" CC="$cc_bin -static" STRIP="$strip_bin" -j"$JOBS" 2>&1 | tee "$log_file" | \
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
    [[ -f "$build_work_dir/GccUnixR/uasm" ]] && generated_bin="$build_work_dir/GccUnixR/uasm"
    [[ -f "$build_work_dir/uasm" ]] && generated_bin="$build_work_dir/uasm"

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
build_all_archs

echo -e "\n${HELIOTROPE}🎊 UASM Build completed!${NC}"
for arch in $ARCHS; do
    local_out="$OUTPUT_DIR/uasm-$arch"
    if [[ -f "$local_out" ]]; then
        size=$(stat -c%s "$local_out" 2>/dev/null || stat -f%z "$local_out" 2>/dev/null || echo "unknown")
        success "Built $arch: uasm-$arch ($(numfmt --to=iec-i --suffix=B "$size" 2>/dev/null || echo "$size bytes"))"
    fi
done

final
