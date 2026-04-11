#!/usr/bin/env bash

# ── Common Code ───────────────────────────────────────────────────────────────
source "$(dirname "$0")/common.sh"

# ── Defaults & Config ─────────────────────────────────────────────────────────
REPO_URL="https://github.com/curl/curl.git"
REPO_BRANCH="master"
DL_COLOR="${CANARY}"
DL_TC_1="${CARIBBEAN}"
DL_TC_2="${NEONPURPLE}"
DL_TC_3="${PEACH}"
EX_TC_1="${CARIBBEAN}"
EX_TC_2="${NEONPURPLE}"
EX_TC_3="${LEMON}"
FINAL_C="${CANARY}"
CLEAN_C="${TAWNY}"
GIT_C="${CARIBBEAN}"
GIT_C2="${LEMON}"

# ── Architecture Table ────────────────────────────────────────────────────────
declare -A ARCH_INFO=(
  [x86_64]="x86_64-unknown-linux-musl:x86_64-unknown-linux-musl.tar.xz"
  [i686]="i686-unknown-linux-musl:i686-unknown-linux-musl.tar.xz"
  [aarch64]="aarch64-unknown-linux-musl:aarch64-unknown-linux-musl.tar.xz"
  [armv7]="armv7-unknown-linux-musleabihf:armv7-unknown-linux-musleabihf.tar.xz"
  [armhf]="arm-unknown-linux-musleabihf:arm-unknown-linux-musleabihf.tar.xz"
)

# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${CANARY}Usage:${NC} $0 [OPTIONS]"
    echo ""
    echo -e "${BWHITE}Options:${NC}"
    echo -e "  ${CARIBBEAN}--gcc${NC}             Use GCC toolchains"
    echo -e "  ${CARIBBEAN}--clang${NC}           Use Clang toolchains (default)"
    echo -e "  ${CARIBBEAN}-a|--arch \"LIST\"${NC}  Space separated list of arches to build"
    echo -e "  ${CARIBBEAN}-r|--resume${NC}       Skip architectures already found in output/"
    echo -e "  ${CARIBBEAN}-j|--jobs N${NC}       Parallel make jobs (default: auto-detected)"
    echo -e "  ${CARIBBEAN}-C|--clean${NC}        Wipe build and output"
    echo -e "  ${CARIBBEAN}--list-archs${NC}      Print all available target architectures"
    echo -e "  ${CARIBBEAN}-h|--help${NC}         Show this help"
    echo ""
    echo -e "${PEACH}Example:${NC} $0 --arch \"x86_64 aarch64\" --resume --gcc"
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
DEFAULT_ARCHS="x86_64 i686 aarch64 armv7 armhf"
ARCHS="${USER_ARCHS:-$DEFAULT_ARCHS}"
setup_toolchain_dir

# ── Build Logic ───────────────────────────────────────────────────────────────
build_arch() {
    local arch="$1"
    local arch_key="$1"
    local info="${ARCH_INFO[$arch_key]}"
    IFS=: read -r triple tarball <<<"$info"
    local out_file="$OUTPUT_DIR/$NAME-$arch_key"
    local log_file="$ROOT_DIR/build-$arch_key.log"
    echo -e "${PEACH}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if [[ "${RESUME_MODE:-false}" == true && -f "$out_file" ]]; then
        echo -e "${MINT}⏭️  Skipping $arch_key: Binary already exists (Resume Mode)${NC}"
        return
    fi
    echo -e "${CARIBBEAN}🏗️  Targeting:${NC} ${CANARY}$arch${NC} ${LEMON}[${PEACH}$triple${LEMON}]${NC} ${CARIBBEAN}using ${NEONPURPLE}$COMPILER_TYPE${NC}"
    # Ensure toolchain directory exists BEFORE curl runs
    mkdir -p "$TOOLCHAIN_DIR"
    # 1. Download Toolchain
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    download_toolchain "$tarpath" "$tarball" || return 1
    # 2. Hash Verification
    echo -e "${GOLDENROD}🛡️  Verifying Integrity...${NC}"
    verify_hash "$tarpath" "$tarball" || return 1
    # 3. Extraction Check
    local extract_path="$TOOLCHAIN_DIR/$triple"
    extract_toolchain "$tarpath" "$triple" || return 1
    # 4. Toolchain Path Setup
    local bin_dir="$extract_path/bin"
    local cc="$bin_dir/${triple}-${COMPILER_TYPE}"
    local strip="$bin_dir/${triple}-strip"

    # Specific fix for i686/32-bit targets
    local ARCH_FLAGS=""
    [[ "$arch" == i*86 ]] && ARCH_FLAGS="-m32"

    cd "$ROOT_DIR"
    if [[ ! -d "wolfssl/.git" ]]; then
        git clone https://github.com/wolfSSL/wolfssl --depth=1
    else
        git -C wolfssl pull origin
    fi
    local wolfssl_prefix="$ROOT_DIR/wolfssl-libs/$triple"
    mkdir -p "$wolfssl_prefix"
    cd wolfssl/
    make distclean >/dev/null 2>&1 || true
    ./autogen.sh
    local wolfssl_32bit=""
    [[ "$arch" == i*86 ]] && wolfssl_32bit="--enable-32bit"
    CC="$cc -static" ./configure \
        --host="$triple" \
        --disable-shared \
        --enable-static \
        --prefix="$wolfssl_prefix" \
        ${wolfssl_32bit:+"$wolfssl_32bit"} \
        CFLAGS="${CFLAGS} ${ARCH_FLAGS} -ffunction-sections -fdata-sections -fno-stack-protector" \
        LDFLAGS="-static -Wl,--gc-sections"
    make -j"$JOBS" V=1 && make install
    # 5. Configure (Autotools)
    cd "$SOURCE_DIR"
    # Ensure fresh start
    make distclean >/dev/null 2>&1 || true
    echo -e "${CARIBBEAN}==>${NC} ${CANARY}Running Autoreconf...${NC}"
    autoreconf -fi > "$log_file" 2>&1 || {
        echo -e "${NEONRED}Autoreconf FAILED. Check $log_file${NC}"; return 1;
    }
    echo -e "${CARIBBEAN}==>${NC} ${LAGOON}Running Configure...${NC}"
    CC="$cc -static" ./configure \
        --host="$triple" \
        --disable-shared \
        --enable-static \
        --disable-docs \
        --disable-manual \
        --without-libpsl \
        --disable-ldap \
        --enable-ipv6 \
        --enable-unix-sockets \
        --with-wolfssl="$wolfssl_prefix" \
        --without-libssh2 \
        --with-zlib \
        --without-brotli \
        CFLAGS="${CFLAGS} ${ARCH_FLAGS} -flto=auto -ffat-lto-objects -ffunction-sections -fdata-sections -fno-stack-protector" \
        LDFLAGS="-static -Wl,--gc-sections" >> "$log_file" 2>&1 || {
            echo -e "${NEONRED}Configure FAILED. Check $log_file${NC}"; return 1;
        }
    # Pre-count expected compilation units for accurate progress tracking
    local total_curl
    total_curl=$(find "$SOURCE_DIR/lib" "$SOURCE_DIR/src" -name "*.c" -type f 2>/dev/null | wc -l)
    [[ "$total_curl" -lt 1 ]] && total_curl=100
    echo -e "${CARIBBEAN}==>${NC} ${CANARY}Building curl (Jobs: $JOBS)...${NC}"
    make -j"$JOBS" V=1 LDFLAGS="-static -all-static -Wl,--gc-sections" >> "$log_file" 2>&1 &
    track_progress $! "$log_file" "make-files" "$total_curl" "${NEONBLUE}" "$SOURCE_DIR/lib:*.lo"
    # Finalize
    cp "$SOURCE_DIR/src/curl" "$out_file"
    if [[ -x "$strip" ]]; then
        echo -e "${CARIBBEAN}==>${NC} ${TAWNY}Stripping symbols...${NC}"
        "$strip" "$out_file"
    fi
    verify_binary_arch "$out_file" "$triple"
    local final_size
    final_size=$(du -sh "$out_file" | awk '{print $1}')
    echo -e "\n${NEONGREEN}✅ Successfully built: ${BWHITE}curl-$arch${NC} (${CANARY}$final_size${NC})"
}

# ── Main ──────────────────────────────────────────────────────────────────────
echo -e "${CANARY}Starting curl cross-compilation suite...${NC}"
mkdir -p "$ROOT_DIR" "$OUTPUT_DIR"

# Clone Source once
git_clone

# Run targets
build_all_archs

final
