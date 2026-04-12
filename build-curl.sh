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
  [x86]="i686-unknown-linux-musl:i686-unknown-linux-musl.tar.xz"
  [aarch64]="aarch64-unknown-linux-musl:aarch64-unknown-linux-musl.tar.xz"
  [armv7]="armv7-unknown-linux-musleabihf:armv7-unknown-linux-musleabihf.tar.xz"
  [armhf]="arm-unknown-linux-musleabihf:arm-unknown-linux-musleabihf.tar.xz"
)

# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${CANARY}Usage:${NC} $0 [OPTIONS]"
    echo ""
    echo -e "${BWHITE}Options:${NC}"
    echo -e "  ${CARIBBEAN}--gcc${NC}             Use GCC toolchains (default)"
    echo -e "  ${CARIBBEAN}--clang${NC}           Use Clang toolchains"
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
DEFAULT_ARCHS="x86_64 x86 aarch64 armv7 armhf"
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
    echo -e "${CARIBBEAN}↓📂 Targeting:${NC} ${CANARY}$arch${NC} ${LEMON}[${PEACH}$triple${LEMON}]${NC} ${CARIBBEAN}using ${NEONPURPLE}$COMPILER_TYPE${NC}"
    # Ensure toolchain directory exists BEFORE curl runs
    mkdir -p "$TOOLCHAIN_DIR"
    # 1. Download Toolchain
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    download_toolchain "$tarpath" "$tarball" || return 1
    # 2. Hash Verification
    echo -e "${GOLDENROD}🗝🔒 Verifying Integrity...${NC}"
    verify_hash "$tarpath" "$tarball" || return 1
    # 3. Extraction Check
    local extract_path="$TOOLCHAIN_DIR/$triple"
    extract_toolchain "$tarpath" "$triple" || return 1
    # 4. Toolchain Path Setup
    local bin_dir="$extract_path/bin"
    local cc="$bin_dir/${triple}-${COMPILER_TYPE}"
    local strip="$bin_dir/${triple}-strip"
    export PATH="$bin_dir:$PATH"

    # Specific fix for i686/32-bit targets
    local ARCH_FLAGS=""
    [[ "$arch" == i*86 || "$arch" == x86 ]] && ARCH_FLAGS="-m32 -DWORD32 -DSIZEOF_LONG=4 -DSIZEOF_LONG_LONG=8"
    [[ "$arch" == armhf || "$arch" == armv7 ]] && ARCH_FLAGS="-DSIZEOF_LONG=4 -DSIZEOF_LONG_LONG=8"
    # -Wshorten-64-to-32 is Clang-only; passing it to GCC causes a hard error
    local clang_only_flags=""
    [[ "$COMPILER_TYPE" != "gcc" ]] && clang_only_flags="-Wno-error=shorten-64-to-32"

    local wolfssl_log="$ROOT_DIR/wolfssl-$arch_key.log"
    # Separate log for the make phase only — prevents configure test-compilation
    # lines from inflating the grep-count before make even starts.
    local wolfssl_build_log="$ROOT_DIR/wolfssl-build-$arch_key.log"
    cd "$ROOT_DIR"
    if [[ ! -d "wolfssl/.git" ]]; then
        echo -e "${GIT_C}==>${GIT_C2} Cloning wolfssl source...${NC}"
        git clone https://github.com/wolfSSL/wolfssl --depth=1 > /dev/null 2>&1
    else
        echo -e "${CORAL}✨ Source code for wolfssl present.${NC}"
        git -C wolfssl pull origin > /dev/null 2>&1 || true
    fi
    local wolfssl_prefix="$ROOT_DIR/wolfssl-libs/$triple"
    mkdir -p "$wolfssl_prefix"
    cd wolfssl/
    make distclean >/dev/null 2>&1 || true
    rm -f config.cache
    echo -e "${CARIBBEAN}==>${NC} ${CANARY}Running autogen.sh (wolfSSL)...${NC}"
    ./autogen.sh > "$wolfssl_log" 2>&1 || {
        echo -e "${NEONRED}wolfSSL autogen.sh FAILED. Check $wolfssl_log${NC}"; return 1;
    }
    local wolfssl_32bit=""
    [[ "$arch" == i*86 ]] && wolfssl_32bit="--enable-32bit --enable-fastmath --disable-asm"
    echo -e "${CARIBBEAN}==>${NC} ${LAGOON}Running Configure (wolfSSL)...${NC}"
    CC="$cc" ./configure \
        --host="$triple" \
        --disable-shared \
        --enable-static \
        --prefix="$wolfssl_prefix" \
        --enable-curl \
        $wolfssl_32bit \
        CFLAGS="${CFLAGS} ${ARCH_FLAGS} -ffunction-sections -fdata-sections -fno-stack-protector ${clang_only_flags}" \
        LDFLAGS="-static -Wl,--gc-sections" >> "$wolfssl_log" 2>&1 || {
            echo -e "${NEONRED}wolfSSL Configure FAILED. Check $wolfssl_log${NC}"; return 1;
        }

    # Dry-run on the now-configured tree for an accurate step count.
    # Run before make so the Makefile is in its clean state.
    local total_wolfssl
    total_wolfssl=$(make -n V=1 2>/dev/null | grep -c " -c -o " || true)
    [[ "$total_wolfssl" -lt 1 ]] && total_wolfssl=50

    echo -e "${CARIBBEAN}==>${NC} ${CANARY}Building wolfSSL (Jobs: $JOBS)...${NC}"
    # Write make output to a fresh log so grep-count only sees make lines.
    make -j"$JOBS" V=1 LDFLAGS="-static -all-static -Wl,--gc-sections" > "$wolfssl_build_log" 2>&1 &
    track_progress $! "$wolfssl_build_log" "grep-count" "$total_wolfssl" "${GOLDENROD}" " -c -o " || {
        cat "$wolfssl_build_log" >> "$wolfssl_log"
        echo -e "${NEONRED}wolfSSL build FAILED. Check $wolfssl_log${NC}"; return 1;
    }
    # Merge build log into the main wolfssl log for a complete audit trail.
    cat "$wolfssl_build_log" >> "$wolfssl_log"

    make install LDFLAGS="-static -all-static -Wl,--gc-sections" >> "$wolfssl_log" 2>&1 || {
        echo -e "${NEONRED}wolfSSL Install FAILED. Check $wolfssl_log${NC}"; return 1;
    }

    # 5. Configure (Autotools)
    cd "$SOURCE_DIR"
    local wolf_libdir="$wolfssl_prefix/lib"
    [[ -d "$wolfssl_prefix/lib64" ]] && wolf_libdir="$wolfssl_prefix/lib64"
    make distclean >/dev/null 2>&1 || true
    echo -e "${CARIBBEAN}==>${NC} ${CANARY}Running Autoreconf...(curl)${NC}"
    autoreconf -fi > "$log_file" 2>&1 || {
        echo -e "${NEONRED}Autoreconf FAILED. Check $log_file${NC}"; return 1;
    }

    echo -e "${CARIBBEAN}==>${NC} ${LAGOON}Running Configure...(curl)${NC}"
    CC="$cc" ./configure \
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
        --without-zlib \
        --without-brotli \
        CFLAGS="${CFLAGS} ${ARCH_FLAGS} -ffunction-sections -fdata-sections -fno-stack-protector" \
        LDFLAGS="-static -L${wolf_libdir} -Wl,--gc-sections" >> "$log_file" 2>&1 || {
            echo -e "${NEONRED}Configure FAILED. Check $log_file${NC}"; return 1;
        }

    # Dry-run on the configured tree for an accurate step count.
    local total_curl
    total_curl=$(make -n V=1 2>/dev/null | grep -c " -c -o " || true)
    [[ "$total_curl" -lt 1 ]] && total_curl=100

    # Separate build log so grep-count only sees make output, not configure output.
    local curl_build_log="$ROOT_DIR/curl-build-$arch_key.log"
    echo -e "${CARIBBEAN}==>${NC} ${CANARY}Building curl (Jobs: $JOBS)...${NC}"
    make -j"$JOBS" V=1 LDFLAGS="-static -all-static -L${wolf_libdir} -Wl,--gc-sections" \
        > "$curl_build_log" 2>&1 &
    track_progress $! "$curl_build_log" "grep-count" "$total_curl" "${NEONBLUE}" " -c -o " || {
        cat "$curl_build_log" >> "$log_file"
        echo -e "${NEONRED}curl build FAILED. Check $log_file${NC}"; return 1;
    }
    cat "$curl_build_log" >> "$log_file"

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
