#!/usr/bin/env bash

# ── Common Code ───────────────────────────────────────────────────────────────
source "$(dirname "$0")/common.sh"

# ── Defaults & Config ─────────────────────────────────────────────────────────
REPO_URL="https://github.com/ip7z/7zip.git"
REPO_BRANCH="main"
#REPO_URL="https://github.com/mcmilk/7-Zip-zstd"
#REPO_BRANCH="master"
DL_COLOR="${LIME}"
DL_TC_1="${LAVENDER}"
DL_TC_2="${NAVAJO}"
DL_TC_3="${CANARY}"
EX_TC_1="${OCHRE}"
EX_TC_2="${NAVAJO}"
EX_TC_3="${LAVENDER}"
FINAL_C="${GOLDENROD}"
CLEAN_C="${CRIMSON}"
GIT_C="${OCHRE}"
GIT_C2="${NAVAJO}"

# ── Architecture Table (Triple : Tarball : 7-zip PLATFORM) ────────────────────
declare -A ARCH_INFO=(
  [x86_64]="x86_64-unknown-linux-musl:x86_64-unknown-linux-musl.tar.xz:x86_64"
  [x86]="i686-unknown-linux-musl:i686-unknown-linux-musl.tar.xz:i686"
  [aarch64]="aarch64-unknown-linux-musl:aarch64-unknown-linux-musl.tar.xz:aarch64"
  [armv7]="armv7-unknown-linux-musleabihf:armv7-unknown-linux-musleabihf.tar.xz:arm"
  [armhf]="arm-unknown-linux-musleabihf:arm-unknown-linux-musleabihf.tar.xz:arm"
)

# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${GOLDENROD}Usage:${NC} $0 [OPTIONS]"
    echo ""
    echo -e "${BWHITE}Options:${NC}"
    echo -e "  ${OCHRE}--gcc${NC}             Use GCC toolchains (default)"
    echo -e "  ${OCHRE}--clang${NC}           Use Clang toolchains"
    echo -e "  ${OCHRE}-a|--arch \"LIST\"${NC}  Space separated list of arches to build"
    echo -e "  ${OCHRE}-r|--resume${NC}       Skip architectures already found in output/"
    echo -e "  ${OCHRE}-j|--jobs N${NC}       Parallel make jobs (default: auto-detected)"
    echo -e "  ${OCHRE}-C|--clean${NC}        Wipe build and output"
    echo -e "  ${OCHRE}--list-archs${NC}      Print all available target architectures"
    echo -e "  ${OCHRE}-h|--help${NC}         Show this help"
    echo ""
    echo -e "${CANARY}Example:${NC} $0 --arch \"x86_64 aarch64\" --resume --gcc"
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

# ── Build Logic ───────────────────────────────────────────────────────────────
build_arch() {
    local arch_key="$1"
    local info="${ARCH_INFO[$arch_key]:-}"
    [[ -z "$info" ]] && { echo -e "${TOMATO}Unknown architecture: $arch_key${NC}"; return 1; }

    IFS=: read -r triple tarball platform <<<"$info"
    local out_file="$OUTPUT_DIR/$NAME-$arch_key"
    local log_file="$ROOT_DIR/build-$arch_key.log"

    echo -e "${GOLDENROD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [[ "${RESUME_MODE:-false}" == true && -f "$out_file" ]]; then
        echo -e "${MINT}⏭️  Skipping $arch_key: Binary already exists (Resume Mode)${NC}"
        return
    fi

    echo -e "${LAVENDER}🗜️ Targeting:${NC} ${CANARY}$arch_key${NC} ${PEACH}[${NAVAJO}$triple${PEACH}]${NC} ${LAVENDER}using ${LIME}$COMPILER_TYPE${NC}"

    mkdir -p "$TOOLCHAIN_DIR"

    # 1. Download Toolchain
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    download_toolchain "$tarpath" "$tarball" || return 1

    # 2. Hash Verification
    echo -e "${NEONRED}🔐  Verifying Integrity...${NC}"
    verify_hash "$tarpath" "$tarball" || return 1

    # 3. Extraction
    local extract_path="$TOOLCHAIN_DIR/$triple"
    extract_toolchain "$tarpath" "$triple" || return 1

    # 4. Toolchain Path Setup
    local bin_dir="$extract_path/bin"
    local cc="$bin_dir/${triple}-${COMPILER_TYPE}"
    local cxx_name="clang++"
    [[ "$COMPILER_TYPE" == "gcc" ]] && cxx_name="g++"
    local cxx="$bin_dir/${triple}-$cxx_name"
    local strip="$bin_dir/${triple}-strip"

    # 5. Build
    local bundle_dir="$SOURCE_DIR/CPP/7zip/Bundles/Alone2"
    # Use double-quotes so ${ARCH_FLAGS} is expanded, and match the whole
    # CFLAGS_BASE line (^...*) so the sed is idempotent across all arches.
    # GCC and clang have different LTO flag syntax.
    local lto_flags
    if [[ "$COMPILER_TYPE" == "gcc" ]]; then
        lto_flags="-flto=auto -ffat-lto-objects"
    else
        lto_flags="-flto=thin"
    fi
    sed -i "s|CFLAGS_BASE = -O2|CFLAGS_BASE = -Os -static -ffunction-sections -fdata-sections -fno-stack-protector -fshort-enums -fno-ident -fno-unwind-tables -fno-asynchronous-unwind-tables ${lto_flags}|g" "$SOURCE_DIR/CPP/7zip/7zip_gcc.mak"
    sed -i 's/LDFLAGS = -Wall/LDFLAGS = -static -Wl,--gc-sections/g' "$SOURCE_DIR/CPP/7zip/7zip_gcc.mak"

    cd "$bundle_dir"

    # Clean per-arch output directory so prior build artefacts don't carry over
    rm -rf _o

    # Dry-run to get an accurate step count for the progress bar.
    # " -c " matches every compile-only invocation regardless of argument order
    # (e.g. "clang++ ... -c file.cpp -o file.o" or "-c -o file.o file.cpp").
    local total
    total=$(make -f makefile.gcc -n \
        CC="$cc" CXX="$cxx" PLATFORM="$platform" \
        CFLAGS_BASE_LIST="-c -D_7ZIP_AFFINITY_DISABLE=1 -DZ7_AFFINITY_DISABLE=1 -D_GNU_SOURCE=1" \
        CFLAGS_WARN_WALL="-Wall -Wextra" COMPL_STATIC=1 \
        LDFLAGS="-static -Wl,--gc-sections" 2>/dev/null | grep -c ' -c ' || true)
    # Fall back to 100 when dry-run produces no countable steps (e.g. the
    # makefile redirected stderr only); the bar still shows spinner progress.
    [[ "$total" -lt 1 ]] && total=100

    echo -e "${OCHRE}==>${NC} ${LIGHTSLATE}Building 7zz (Jobs: $JOBS)...${NC}"
    make -f makefile.gcc -j"$JOBS" \
        CC="$cc" \
        CXX="$cxx" \
        CFLAGS_BASE_LIST="-c -D_7ZIP_AFFINITY_DISABLE=1 -DZ7_AFFINITY_DISABLE=1 -D_GNU_SOURCE=1" \
        CFLAGS_WARN_WALL="-Wall -Wextra" \
        PLATFORM="$platform" \
        COMPL_STATIC=1 \
        LDFLAGS="-static -Wl,--gc-sections" \
        > "$log_file" 2>&1 &
    # Use make-files mode to count produced .o files; this is independent of
    # log line format and works reliably with parallel make (-j).
    track_progress $! "$log_file" "make-files" "$total" "${KHAKI}" "$bundle_dir/_o:*.o" || {
        echo -e "${NEONRED}Build FAILED. Check $log_file${NC}"; return 1;
    }

    # 6. Locate binary (output dir may vary by 7-zip version)
    local bin_found
    bin_found=$(find "$bundle_dir" -name "7zz" -type f -executable 2>/dev/null | head -n1)
    if [[ -z "$bin_found" ]]; then
        echo -e "${NEONRED}Error: 7zz binary not found after build!${NC}"
        return 1
    fi

    # 7. Finalize
    cp "$bin_found" "$out_file"
    if [[ -x "$strip" ]]; then
        echo -e "${OCHRE}==>${NC} ${LEMON}Stripping symbols...${NC}"
        "$strip" "$out_file"
    fi

    verify_binary_arch "$out_file" "$triple"
    local final_size
    final_size=$(du -sh "$out_file" | awk '{print $1}')
    echo -e "\n${NEONGREEN}✔️ Successfully built: ${BWHITE}7zz-$arch_key${NC} (${CANARY}$final_size${NC})"
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo -e "${GOLDENROD}Starting 7zz cross-compilation suite...${NC}"
mkdir -p "$ROOT_DIR" "$OUTPUT_DIR"

git_clone

build_all_archs

final
