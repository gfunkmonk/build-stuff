#!/usr/bin/env bash

# ── Common Code ───────────────────────────────────────────────────────────────
source "$(dirname "$0")/common.sh"

# ── Defaults & Config ─────────────────────────────────────────────────────────
REPO_URL="https://github.com/gfunkmonk/${NAME}.git"
REPO_BRANCH="devel"
DL_COLOR="${HIGHLIGHTER}"
DL_TC_1="${SLATE}"
DL_TC_2="${NC}"
DL_TC_3="${AQUA}"
EX_TC_1="${SLATE}"
EX_TC_2="${NC}"
EX_TC_3="${MINT}"
FINAL_C="${HELIOTROPE}"
CLEAN_C="${OCHRE}"
GIT_C="${SLATE}"
GIT_C2="${NC}"

# ── Architecture Table (Triple : CMakeProcessor) ──────────────────────────────
declare_arch_info() {
  if [[ "$COMPILER_TYPE" == "gcc" ]]; then
    declare -A ARCH_INFO=(
      [i386]="i586-unknown-linux-musl:i586"
      [i486]="i686-unknown-linux-musl:i686"
      [i586]="i586-unknown-linux-musl:i586"
      [i686]="i686-unknown-linux-musl:i686"
      [x86_64]="x86_64-unknown-linux-musl:x86_64"
      [arm]="arm-unknown-linux-musleabi:arm"
      [armhf]="arm-unknown-linux-musleabihf:arm"
      [armv5]="armv5-unknown-linux-musleabi:armv5"
      [armv6]="armv6-unknown-linux-musleabi:arm"
      [armv6hf]="armv6-unknown-linux-musleabihf:arm"
      [armv7]="armv7-unknown-linux-musleabi:armv7"
      [armv7hf]="armv7-unknown-linux-musleabihf:armv7"
      [aarch64]="aarch64-unknown-linux-musl:aarch64"
      [loongarch64]="loongarch64-unknown-linux-musl:loongarch64"
      [m68k]="m68k-unknown-linux-musl:m68k"
      [mips]="mips-unknown-linux-musl:mips"
      [mips-sf]="mips-unknown-linux-muslsf:mips"
      [mips64]="mips64-unknown-linux-musl:mips64"
      [mips64el]="mips64el-unknown-linux-musl:mips64el"
      [mipsel]="mipsel-unknown-linux-musl:mipsel"
      [mipsel-sf]="mipsel-unknown-linux-muslsf:mipsel"
      [or1k]="or1k-unknown-linux-musl:or1k"
      [powerpc]="powerpc-unknown-linux-musl:powerpc"
      [powerpc-sf]="powerpc-unknown-linux-muslsf:powerpc"
      [powerpcle]="powerpcle-unknown-linux-musl:powerpcle"
      [powerpcle-sf]="powerpcle-unknown-linux-muslsf:powerpcle"
      [powerpc64]="powerpc64-unknown-linux-musl:ppc64"
      [powerpc64le]="powerpc64le-unknown-linux-musl:ppc64le"
      [riscv32]="riscv32-unknown-linux-musl:riscv32"
      [riscv64]="riscv64-unknown-linux-musl:riscv64"
      [s390x]="s390x-ibm-linux-musl:s390x"
      [sh4]="sh4-multilib-linux-musl:sh4")
  else
    declare -A ARCH_INFO=(
      [i586]="i586-unknown-linux-musl:i586"
      [i686]="i686-unknown-linux-musl:i686"
      [x86_64]="x86_64-unknown-linux-musl:x86_64"
      [arm]="arm-unknown-linux-musleabi:arm"
      [armhf]="arm-unknown-linux-musleabihf:arm"
      [armv7]="armv7-unknown-linux-musleabi:armv7"
      [armv7hf]="armv7-unknown-linux-musleabihf:armv7"
      [aarch64]="aarch64-unknown-linux-musl:aarch64"
      [loongarch64]="loongarch64-unknown-linux-musl:loongarch64"
      [m68k]="m68k-unknown-linux-musl:m68k"
      [mips]="mips-unknown-linux-musl:mips"
      [mips-sf]="mips-unknown-linux-muslsf:mips"
      [mips64]="mips64-unknown-linux-musl:mips64"
      [mips64el]="mips64el-unknown-linux-musl:mips64el"
      [mipsel]="mipsel-unknown-linux-musl:mipsel"
      [mipsel-sf]="mipsel-unknown-linux-muslsf:mipsel"
      [or1k]="or1k-unknown-linux-musl:or1k"
      [powerpc]="powerpc-unknown-linux-musl:powerpc"
      [powerpcle]="powerpcle-unknown-linux-musl:powerpcle"
      [powerpc64]="powerpc64-unknown-linux-musl:ppc64"
      [powerpc64le]="powerpc64le-unknown-linux-musl:ppc64le"
      [riscv32]="riscv32-unknown-linux-musl:riscv32"
      [riscv64]="riscv64-unknown-linux-musl:riscv64"
      [s390x]="s390x-ibm-linux-musl:s390x")
  fi
}

# ── Helper Subcommands ────────────────────────────────────────────────────────

list_output() {
    echo -e "${HELIOTROPE}📂 Currently Built Binaries:${NC}"
    local found=false
    for bin in "$OUTPUT_DIR"/upx-*; do
        [[ -f "$bin" ]] || continue
        found=true
        ls -lh "$bin"
    done
    [[ "$found" == false ]] && echo -e "${SLATE}No artifacts found.${NC}"
}

verify_static() {
    echo -e "${AQUA}🔍 Verifying Static Integrity...${NC}"
    for bin in "$OUTPUT_DIR"/upx-*; do
        [[ -f "$bin" ]] || continue
        if file "$bin" | grep -q "statically linked"; then
            echo -e "${NEONGREEN}✓${NC} $(basename "$bin")"
        else
            echo -e "${TOMATO}✗ $(basename "$bin") - DYNAMIC LINK DETECTED${NC}"
        fi
    done
}

test_binary() {
    local bin_name="$1"
    local bin_path="$OUTPUT_DIR/$bin_name"

    if [[ -z "$bin_name" ]]; then
        echo -e "${OCHRE}Usage: $0 test <binary-name>${NC}"
        return 1
    fi

    if [[ ! -f "$bin_path" ]]; then
        echo -e "${TOMATO}Error: Binary not found: $bin_path${NC}"
        return 1
    fi

    echo -e "${HELIOTROPE}🧪 Testing Execution: ${BWHITE}$bin_name${NC}"

    # Determine emulation requirement
    local qemu_bin=""
    if   [[ "$bin_name" =~ aarch64 ]]; then qemu_bin="qemu-aarch64-static"
    elif [[ "$bin_name" =~ armv[5-7]|arm- ]]; then qemu_bin="qemu-arm-static"
    elif [[ "$bin_name" =~ riscv64 ]]; then qemu_bin="qemu-riscv64-static"
    elif [[ "$bin_name" =~ riscv32 ]]; then qemu_bin="qemu-riscv32-static"
    elif [[ "$bin_name" =~ mips64el ]]; then qemu_bin="qemu-mips64el-static"
    elif [[ "$bin_name" =~ mips64 ]]; then qemu_bin="qemu-mips64-static"
    elif [[ "$bin_name" =~ mipsel ]]; then qemu_bin="qemu-mipsel-static"
    elif [[ "$bin_name" =~ mips ]]; then qemu_bin="qemu-mips-static"
    elif [[ "$bin_name" =~ ppc64le ]]; then qemu_bin="qemu-ppc64le-static"
    elif [[ "$bin_name" =~ ppc64 ]]; then qemu_bin="qemu-ppc64-static"
    elif [[ "$bin_name" =~ s390x ]]; then qemu_bin="qemu-s390x-static"
    elif [[ "$bin_name" =~ loongarch64 ]]; then qemu_bin="qemu-loongarch64-static"
    elif [[ "$bin_name" =~ m68k ]]; then qemu_bin="qemu-m68k-static"
    elif [[ "$bin_name" =~ sh4 ]]; then qemu_bin="qemu-sh4-static"
    fi

    if [[ -n "$qemu_bin" ]]; then
        if command -v "$qemu_bin" &>/dev/null; then
            echo -e "${SLATE}==>${NC} Emulating via ${AQUA}$qemu_bin${NC}..."
            "$qemu_bin" "$bin_path" --version | head -n1
        else
            echo -e "${TOMATO}Error: $qemu_bin not installed. Cannot test cross-arch binary.${NC}"
            return 1
        fi
    else
        echo -e "${SLATE}==>${NC} Running natively..."
        "$bin_path" --version | head -n1 || echo -e "${OCHRE}Native execution failed.${NC}"
    fi
}

# ── Build Logic ───────────────────────────────────────────────────────────────

build_arch() {
    local arch_key="$1"
    local info="${ARCH_INFO[$arch_key]:-}"

    # Validation check for the arch key
    [[ -z "$info" ]] && { echo -e "${TOMATO}Unknown architecture: $arch_key${NC}"; return 1; }

    IFS=: read -r triple cmake_proc <<<"$info"
    local tarball="${triple}.tar.xz"
    local out_file="$OUTPUT_DIR/$NAME-$arch_key"
    local log_file="$ROOT_DIR/build-$arch_key.log"

    echo -e "${NEONPURPLE}💠────────────────────────────────────────────────────────────💠${NC}"
    [[ "$RESUME_MODE" == true && -f "$out_file" ]] && { echo -e "${SLATE}⏭️  Skipping $arch_key${NC}"; return; }

    echo -e "${NEONBLUE}🔨 Target:${NC} ${BWHITE}$arch_key${NC} (${SLATE}$triple${NC}) via ${AQUA}$COMPILER_TYPE${NC}"

    # 1. Download Toolchain
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    download_toolchain "$tarpath" "$tarball" || return 1

    echo -e "${SLATE}==>${NC} Verifying Integrity..."
    verify_hash "$tarpath" "$tarball" || exit 1

    # 2. Extract
    local extract_path="$TOOLCHAIN_DIR/$triple"
    extract_toolchain "$tarpath" "$triple" || return 1

    # 3. Build Setup
    local bin_dir="$extract_path/bin"
    local bdir="$BUILD_BASE/$arch_key"
    rm -rf "$bdir" && mkdir -p "$bdir"

    # 3.5 The "Motorola 68000" Survival Kit
    if [[ "$arch_key" == "m68k" ]]; then
      echo -e "${OCHRE}==>${NC} Patching m68k alignment landmines... "
      # Kill the check in the CMake try_compile
      sed -i 's/static_assert(alignof/ \/\/ static_assert(alignof/g' "$SOURCE_DIR/misc/cmake/try_compile/types_abi.cpp"
      # Kill the checks in the utility header
      sed -i 's/static_assert(alignof/ \/\/ static_assert(alignof/g' "$SOURCE_DIR/src/util/cxxlib.h"
    fi

    # 4. Compile with Error Logging
    echo -n -e "${SLATE}==>${NC} Configuring CMake... "

    if cmake -S "$SOURCE_DIR" -B "$bdir" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_SYSTEM_NAME=Linux \
        -DCMAKE_SYSTEM_PROCESSOR="$cmake_proc" \
        -DCMAKE_C_COMPILER="$bin_dir/${triple}-${COMPILER_TYPE}" \
        -DCMAKE_CXX_COMPILER="$bin_dir/${triple}-$([[ "$COMPILER_TYPE" == "gcc" ]] && echo "g++" || echo "clang++")" \
        -DCMAKE_C_FLAGS="${CFLAGS}" \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS="-static" \
        -DUPX_CONFIG_DISABLE_GITREV=ON \
        -DUPX_CONFIG_IGNORE_TYPES_ABI=ON \
        > "$log_file" 2>&1; then
        echo -e "${NEONGREEN}Done${NC}"
    else
        echo -e "${TOMATO}FAILED${NC}"
        echo -e "${OCHRE}Check $log_file for details.${NC}"
        return 1
    fi
    echo -n -e "${SLATE}==>${NC} Compiling ($JOBS jobs): ${AQUA}[  0%]${NC}"
    cmake --build "$bdir" --parallel "$JOBS" 2>&1 | tee -a "$log_file" | \
    grep --line-buffered -o '\[.*%\]' | \
    while read -r line; do
        echo -ne "\r${SLATE}==>${NC} Compiling ($JOBS jobs): ${AQUA}$line${NC}"
    done
    local pipe_status=("${PIPESTATUS[@]}")
    if [[ "${pipe_status[0]}" -eq 0 ]]; then
        echo -e "\r${SLATE}==>${NC} Compiling ($JOBS jobs): ${NEONGREEN}Done  ${NC}"
    else
        echo -e "\n${TOMATO}FAILED${NC}"
        return 1
    fi

    # 5. Finalize
    local bin_found; bin_found=$(find "$bdir" -name upx -type f -executable | head -n1)
    if [[ -z "$bin_found" ]]; then
        echo -e "${TOMATO}Error: Binary not found after successful build!${NC}"
        return 1
    fi

    cp "$bin_found" "$out_file"
    "$bin_dir/${triple}-strip" "$out_file" 2>/dev/null || true
    verify_binary_arch "$out_file" "$triple"
    echo -e "${NEONGREEN}✅ Build Success:${NC} ${BWHITE}upx-$arch_key${NC} (${AQUA}$(du -sh "$out_file" | awk '{print $1}')${NC})"
}

# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${HELIOTROPE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BWHITE}UPX CROSS-BUILD ENGINE${NC} [${AQUA}${REPO_BRANCH}${NC}]"
    echo -e "${HELIOTROPE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BWHITE}USAGE:${NC}"
    echo -e "  $0 [OPTIONS] [COMMANDS]"
    echo ""
    echo -e "${BWHITE}OPTIONS:${NC}"
    echo -e "  ${NEONBLUE}--gcc${NC}               Use GCC toolchains"
    echo -e "  ${NEONBLUE}--clang${NC}             Use Clang toolchains (default)"
    echo -e "  ${NEONBLUE}-a|--arch \"LIST\"${NC}    Space-separated list of arches to build"
    echo -e "  ${NEONBLUE}-r|--resume${NC}         Skip targets already found in output/"
    echo -e "  ${NEONBLUE}-j|--jobs N${NC}         Parallel make jobs (default: auto-detected)"
    echo -e "  ${NEONBLUE}-C|--clean${NC}          Wipe builds and source"
    echo -e "  ${NEONBLUE}--list-archs${NC}        Print all available target architectures"
    echo ""
    echo -e "${BWHITE}COMMANDS:${NC}"
    echo -e "  ${NEONPURPLE}list${NC}                Display all built binaries and sizes"
    echo -e "  ${NEONPURPLE}verify${NC}              Check if binaries are truly statically linked"
    echo -e "  ${NEONPURPLE}test <bin>${NC}          Run binary via QEMU or native"
    echo ""
    echo -e "${BWHITE}EXAMPLES:${NC}"
    echo -e "  $0 --gcc --arch \"x86_64 aarch64\""
    echo -e "  $0 test upx-aarch64"
    echo -e "  $0 --resume"
    echo -e "${HELIOTROPE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
}

# ── Main Entry ────────────────────────────────────────────────────────────────
case "${1:-}" in
    list) list_output; exit 0 ;;
    verify) verify_static; exit 0 ;;
    test) test_binary "${2:-}"; exit 0 ;;
    --help|-h) show_help ;;
esac

# Pre-pass: detect --gcc/--clang so ARCH_INFO is populated with the right
# compiler's table before parse_common_flag handles --list-archs.
for _arg in "$@"; do
    case "$_arg" in
        --gcc)   set_compiler gcc ;;
        --clang) set_compiler clang ;;
    esac
done
declare_arch_info

# Flag Parsing
while [[ $# -gt 0 ]]; do
    if parse_common_flag "$@"; then
        shift "$COMMON_SHIFT"
        continue
    fi
    case "$1" in
        -h|--help) show_help ;;
        *) echo -e "${TOMATO}Unknown option: $1${NC}"; show_help ;;
    esac
done

setup_toolchain_dir

echo -e "${HELIOTROPE}🚀 Initializing UPX Cross-Build Engine...${NC}"
mkdir -p "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR"

git_clone

# Check if submodules are empty and fix them if needed
if [[ -z "$(ls -A "$SOURCE_DIR/vendor/ucl" 2>/dev/null)" ]]; then
    echo -n -e "${OCHRE}==>${NC} Submodules missing. Repairing... "
    git -C "$SOURCE_DIR" submodule update --init --recursive > /dev/null 2>&1
    echo -e "${NEONGREEN}Fixed${NC}"
fi

if [[ -z "$USER_ARCHS" ]]; then
    ARCHS=$(echo "${!ARCH_INFO[@]}" | tr ' ' '\n' | sort | tr '\n' ' ')
else
    ARCHS="$USER_ARCHS"
fi

echo -e "${SLATE}Queueing ${BWHITE}$(echo $ARCHS | wc -w)${NC} targets...\n"

build_all_archs

final
