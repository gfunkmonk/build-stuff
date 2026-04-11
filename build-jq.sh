#!/usr/bin/env bash

# ── Common Code ───────────────────────────────────────────────────────────────
source "$(dirname "$0")/common.sh"

# ── Defaults & Config ─────────────────────────────────────────────────────────
REPO_URL="https://github.com/jqlang/jq.git"
REPO_BRANCH="master"
DL_COLOR="${LAGOON}"
DL_TC_1="${HIGHLIGHTER}"
DL_TC_2="${NEONBLUE}"
DL_TC_3="${ORANGE}"
EX_TC_1="${HIGHLIGHTER}"
EX_TC_2="${NEONBLUE}"
EX_TC_3="${TOMATO}"
FINAL_C="${JUNEBUD}"
CLEAN_C="${TOMATO}"
GIT_C="${HOTPINK}"
GIT_C2="${CYAN}"

# ── Architecture Table ────────────────────────────────────────────────────────
declare -A ARCH_INFO=(
  [x86_64]="x86_64-unknown-linux-musl:x86_64-unknown-linux-musl.tar.xz"
  [aarch64]="aarch64-unknown-linux-musl:aarch64-unknown-linux-musl.tar.xz"
  [i686]="i686-unknown-linux-musl:i686-unknown-linux-musl.tar.xz"
  [armv7]="armv7-unknown-linux-musleabihf:armv7-unknown-linux-musleabihf.tar.xz"
  [armhf]="arm-unknown-linux-musleabihf:arm-unknown-linux-musleabihf.tar.xz"
)

# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${HOTPINK}Usage:${NC} $0 [OPTIONS]"
    echo ""
    echo -e "${BWHITE}Options:${NC}"
    echo -e "  ${HELIOTROPE}--gcc${NC}             Use GCC toolchains"
    echo -e "  ${HELIOTROPE}--clang${NC}           Use Clang toolchains (default)"
    echo -e "  ${HELIOTROPE}-a|--arch \"LIST\"${NC}  Space separated list of arches to build"
    echo -e "  ${HELIOTROPE}-r|--resume${NC}       Skip architectures already found in output/"
    echo -e "  ${HELIOTROPE}-j|--jobs N${NC}       Parallel make jobs (default: auto-detected)"
    echo -e "  ${HELIOTROPE}-C|--clean${NC}        Wipe build and output"
    echo -e "  ${HELIOTROPE}-h|--help${NC}         Show this help"
    echo ""
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

DEFAULT_ARCHS="i686 x86_64 aarch64 armv7hf armv6hf"
ARCHS="${USER_ARCHS:-$DEFAULT_ARCHS}"

setup_toolchain_dir

# ── Build Logic ───────────────────────────────────────────────────────────────

build_arch() {
    local arch_key="$1"
    local info="${ARCH_INFO[$arch_key]}"
    IFS=: read -r triple tarball <<<"$info"
    local out_file="$OUTPUT_DIR/$NAME-$arch_key"
    local log_file="$ROOT_DIR/build-$arch_key.log"

    echo -e "${NEONBLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [[ "${RESUME_MODE:-false}" == true && -f "$out_file" ]]; then
        echo -e "${MINT}⏭️  Skipping $arch: Binary already exists (Resume Mode)${NC}"
        return
    fi

    echo -e "${MAUVE}🏗️  Targeting:${NC} ${SKY}$arch${NC} ${LEMON}[${TOMATO}$triple${LEMON}] ${MAUVE}using ${ORANGE}$COMPILER_TYPE${NC}"

    # Ensure toolchain directory exists BEFORE curl runs
    mkdir -p "$TOOLCHAIN_DIR"

    # 1. Download Toolchain
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    download_toolchain "$tarpath" "$tarball" || exit 1

    # 2. Hash Verification
    echo -e "${TAWNY}🛡️  Verifying Integrity...${NC}"
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

    # 4. Configure (Autotools style)
    echo -e "${HIGHLIGHTER}==>${NC} ${PEACH}Running Autogen...${NC}"
    cd "$SOURCE_DIR"
    
    # Ensure fresh start
    make distclean >/dev/null 2>&1 || true

    # JQ requires oniguruma sub-config
    autoreconf -fi > "$log_file" 2>&1

    echo -e "${HIGHLIGHTER}==>${NC} ${NEONPURPLE}Running Configure...${NC}"
    CC="$cc -static" ./configure \
        --host="$triple" \
        --disable-shared \
        --enable-static \
        --disable-docs \
        --disable-valgrind \
        --with-oniguruma=builtin \
        CFLAGS="-Os -static" \
        LDFLAGS="-static" >> "$log_file" 2>&1 || {
            echo -e "${NEONRED}Configure FAILED. Check $log_file${NC}"; return 1;
        }

    # 5. Build with Accurate Progress
    echo -e "${HIGHLIGHTER}==>${NC} ${NEONBLUE}Building bundled oniguruma (Jobs: $JOBS)...${NC}"
    make -C vendor/oniguruma -j"$JOBS" LDFLAGS="-static" >> "$log_file" 2>&1

    echo -e "${HIGHLIGHTER}==>${NC} ${LAGOON}Building jq (Jobs: $JOBS)...${NC}"

    # Get a fresh count
    local total_steps=$(make -n | grep -c " -c ")
    # Buffer for the link steps
    total_steps=$(( total_steps + 2 ))
    local current_step=0

    # Ensure we start at 0% visible
    printf "\r${HELIOTROPE}[%-20s]   0%%${NC} ${LAGOON}(0/%d)${NC}" "" "$total_steps"

    set +e
    # Use 'unbuffer' if available, otherwise 'stdbuf -i0 -o0 -e0' for total zero-buffering
    exec 3< <(stdbuf -i0 -o0 -e0 make -j"$JOBS" LDFLAGS="-static -all-static" AM_LDFLAGS="-static" 2>&1 | tee -a "$log_file")

    while read -u 3 -r line; do
        # JQ uses 'CC' or 'gcc' lines for compilation. 
        # We look for the '-c' flag which indicates an object is being built.
        if [[ "$line" =~ " -c " || "$line" =~ "Building" ]]; then
            ((current_step++))

            local p=$(( current_step * 100 / total_steps ))
            [[ $p -gt 99 ]] && p=99

            local scaled=$(( p / 5 ))
            local bar=$(printf "%${scaled}s" | tr ' ' '#')
            # The '\r' and explicit spacing ensures the bar overwrites itself immediately
            printf "\r${HELIOTROPE}[%-20s] %3d%%${NC} ${LAGOON}(%d/%d)${NC}" "$bar" "$p" "$current_step" "$total_steps"
        fi
    done
    exec 3<&-
    set -e

    # Finalize
    printf "\r${HELIOTROPE}[####################] 100%%${NC} ${LAGOON}(Complete)${NC}\n"
    cp jq "$out_file"
    "$bin_dir/${triple}-strip" "$out_file" 2>/dev/null || true
    
    local final_size=$(du -sh "$out_file" | awk '{print $1}')
    echo -e "${NEONGREEN}✅ Successfully built: ${BWHITE}jq-$arch${NC} (${PEACH}$final_size${NC})"
}

# ── Main ──────────────────────────────────────────────────────────────────────
# (Flags: --gcc, --clang, --arch, --resume, --jobs handled here just like mold script)
# ... [Insert standard flag parsing block from mold script here] ...

mkdir -p "$ROOT_DIR" "$OUTPUT_DIR"

git_clone

for arch in $ARCHS; do
    build_arch "$arch"
done

final