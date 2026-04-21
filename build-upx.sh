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
FINAL_C="${HIGHLIGHTER}"
CLEAN_C="${OCHRE}"
GIT_C="${SLATE}"
GIT_C2="${NC}"

# ── Architecture Table (Triple : CMakeProcessor) ──────────────────────────────
declare_arch_info() {
  if [[ "$COMPILER_TYPE" == "gcc" ]]; then
    declare -gA ARCH_INFO=(
      [arm]="arm-unknown-linux-musleabi:arm"
      [armhf]="arm-unknown-linux-musleabihf:arm"
      [armv5]="armv5-unknown-linux-musleabi:armv5"
      [armv6]="armv6-unknown-linux-musleabi:arm"
      [armv6hf]="armv6-unknown-linux-musleabihf:arm"
      [armv7]="armv7-unknown-linux-musleabi:armv7"
      [armv7hf]="armv7-unknown-linux-musleabihf:armv7"
      [aarch64]="aarch64-unknown-linux-musl:aarch64"
      [aarch64_be]="aarch64_be-unknown-linux-musl:aarch64_be"
      [i386]="i386-unknown-linux-musl:i386"
      [i486]="i486-unknown-linux-musl:i486"
      [i586]="i586-unknown-linux-musl:i586"
      [i686]="i686-unknown-linux-musl:i686"
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
      [sh4]="sh4-multilib-linux-musl:sh4"
      [x86_64]="x86_64-unknown-linux-musl:x86_64")
  elif [[ "$COMPILER_TYPE" == "gnu" ]]; then
    declare -gA ARCH_INFO=(
      [arm]="arm-unknown-linux-gnueabi:arm"
      [armhf]="arm-unknown-linux-gnueabihf:arm"
      [armv4t]="armv4t-unknown-linux-gnueabi:arm"
      [armv5]="armv5-unknown-linux-gnueabi:armv5"
      [armv6]="armv6-unknown-linux-gnueabi:arm"
      [armv6hf]="armv6-unknown-linux-gnueabihf:arm"
      [armv7]="armv7-unknown-linux-gnueabi:armv7"
      [armv7hf]="armv7-unknown-linux-gnueabihf:armv7"
      [aarch64]="aarch64-unknown-linux-gnu:aarch64"
      [aarch64_be]="aarch64_be-unknown-linux-gnu:aarch64_be"
      [alphaev56]="alphaev56-unknown-linux-gnu:alpha"
      [alphaev67]="alphaev67-unknown-linux-gnu:alpha"
      [hppa]="hppa-unknown-linux-gnu:hppa"
      [i486]="i486-unknown-linux-gnu:i486"
      [i586]="i586-unknown-linux-gnu:i586"
      [i686]="i686-unknown-linux-gnu:i686"
      [loongarch64]="loongarch64-unknown-linux-gnu:loongarch64"
      [m68k]="m68k-unknown-linux-gnu:m68k"
      [microblaze]="microblaze-xilinx-linux-gnu:microblaze"
      [microblazeel]="microblazeel-xilinx-linux-gnu:microblazeel"
      [mips]="mips-unknown-linux-gnu:mips"
      [mips-sf]="mips-unknown-linux-gnusf:mips"
      [mips64]="mips64-unknown-linux-gnu:mips64"
      [mips64el]="mips64el-unknown-linux-gnu:mips64el"
      [mipsel]="mipsel-unknown-linux-gnu:mipsel"
      [mipsel-sf]="mipsel-unknown-linux-gnusf:mipsel"
      [or1k]="or1k-unknown-linux-gnu:or1k"
      [powerpc]="powerpc-unknown-linux-gnu:powerpc"
      [powerpc-sf]="powerpc-unknown-linux-gnusf:powerpc"
      [powerpcle]="powerpcle-unknown-linux-gnu:powerpcle"
      [powerpcle-sf]="powerpcle-unknown-linux-gnusf:powerpcle"
      [powerpc64]="powerpc64-unknown-linux-gnu:ppc64"
      [powerpc64le]="powerpc64le-unknown-linux-gnu:ppc64le"
      [riscv32]="riscv32-unknown-linux-gnu:riscv32"
      [riscv64]="riscv64-unknown-linux-gnu:riscv64"
      [s390]="s390-ibm-linux-gnu:s390"
      [s390x]="s390x-ibm-linux-gnu:s390x"
      [sh4]="sh4-multilib-linux-gnu:sh4"
      [sparc]="sparc-unknown-linux-gnu:sparc"
      [sparc64]="sparc64-unknown-linux-gnu:sparc64"
      [x86_64]="x86_64-unknown-linux-gnu:x86_64")
  else
    declare -gA ARCH_INFO=(
      [aarch64]="aarch64-unknown-linux-musl:aarch64"
      [aarch64_be]="aarch64_be-unknown-linux-musl:aarch64_be"
      [arm]="arm-unknown-linux-musleabi:arm"
      [armhf]="arm-unknown-linux-musleabihf:arm"
      [armv5]="armv5-unknown-linux-musleabi:armv5"
      [armv6]="armv6-unknown-linux-musleabi:armv6"
      [armv6hf]="armv6-unknown-linux-musleabihf:armv6"
      [armv7]="armv7-unknown-linux-musleabi:armv7"
      [armv7hf]="armv7-unknown-linux-musleabihf:armv7"
      [i386]="i386-unknown-linux-musl:i386"
      [i486]="i486-unknown-linux-musl:i486"
      [i586]="i586-unknown-linux-musl:i586"
      [i686]="i686-unknown-linux-musl:i686"
      [loongarch64]="loongarch64-unknown-linux-musl:loongarch64"
      [m68k]="m68k-unknown-linux-musl:m68k"
      [microblaze]="microblaze-xilinx-linux-musl:microblaze"
      [microblazeel]="microblazeel-xilinx-linux-musl:microblazeel"
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
      [sh4]="sh4-multilib-linux-musl:sh4"
      [x86_64]="x86_64-unknown-linux-musl:x86_64")
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
    case "$bin_name" in
        *aarch64_be*)  qemu_bin="qemu-aarch64_be" ;;
        *aarch64*)     qemu_bin="qemu-aarch64" ;;
        *armv[5-7]*|*arm-*) qemu_bin="qemu-arm" ;;
	*alpha*)       qemu_bin="qemu-alpha" ;;
        *riscv64*)     qemu_bin="qemu-riscv64" ;;
        *riscv32*)     qemu_bin="qemu-riscv32" ;;
        *microblazeel*) qemu_bin="qemu-microblazeel" ;;
        *microblaze*)  qemu_bin="qemu-microblaze" ;;
        *mips64el*)    qemu_bin="qemu-mips64el" ;;
        *mips64el*)    qemu_bin="qemu-mips64el" ;;
        *mips64*)      qemu_bin="qemu-mips64" ;;
        *mipsel*)      qemu_bin="qemu-mipsel" ;;
        *mips*)        qemu_bin="qemu-mips" ;;
        *powerpc64le*) qemu_bin="qemu-ppc64le" ;;
        *powerpc64*)   qemu_bin="qemu-ppc64" ;;
        *powerpc*)     qemu_bin="qemu-ppc" ;;
        *s390x*)       qemu_bin="qemu-s390x" ;;
        *loongarch64*) qemu_bin="qemu-loongarch64" ;;
        *m68k*)        qemu_bin="qemu-m68k" ;;
        *sh4*)         qemu_bin="qemu-sh4" ;;
        *sparc64*)     qemu_bin="qemu-sparc64" ;;
        *sparc*)       qemu_bin="qemu-sparc" ;;
        *hppa*)        qemu_bin="qemu-hppa" ;;
    esac

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

    echo -e "${NEONBLUE}🤏 Target:${NC} ${BWHITE}$arch_key${NC} (${SLATE}$triple${NC}) via ${AQUA}$COMPILER_TYPE${NC}"

    # 1. Download Toolchain
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    download_toolchain "$tarpath" "$tarball" || return 1

    echo -e "${SLATE}==>${NC} 🔑 Verifying Integrity..."
    verify_hash "$tarpath" "$tarball" || exit 1

    # 2. Extract
    local extract_path="$TOOLCHAIN_DIR/$triple"
    extract_toolchain "$tarpath" "$triple" || return 1

    # 3. Build Setup
    local bin_dir="$extract_path/bin"
    local bdir="$BUILD_BASE/$arch_key"
    rm -rf "$bdir" && mkdir -p "$bdir"

    export PATH="$bin_dir:$PATH"

    # Patch for or1k/m68k if needed (Localize to this build)
    if [[ "$COMPILER_TYPE" == "clang" ]]; then
      pushd "$SOURCE_DIR" >/dev/null

      if [[ "$triple" == *"or1k"* || "$triple" == *"sh4"* ]]; then
          echo "==> Applying architecture specific patches..."
          sed -i 's/static_assert/ //g' src/p_lx_elf.cpp 2>/dev/null || true
          COMPILER_BIN="gcc"
      fi
      popd >/dev/null

      pushd "$bdir" >/dev/null
    fi

    # 3.5 The "Motorola 68000" Survival Kit
    if [[ "$arch_key" == "m68k" ]]; then
      echo -e "${OCHRE}==>${NC} Patching m68k alignment landmines... "
      # Kill the check in the CMake try_compile
      sed -i 's/static_assert(alignof/ \/\/ static_assert(alignof/g' "$SOURCE_DIR/misc/cmake/try_compile/types_abi.cpp"
      # Kill the checks in the utility header
      sed -i 's/static_assert(alignof/ \/\/ static_assert(alignof/g' "$SOURCE_DIR/src/util/cxxlib.h"
    fi

    # Per-arch compiler flag adjustments
    local arch_cflags="$CFLAGS"
    local arch_cxxflags="$CXXFLAGS"
    local arch_ldflags=""

    if [[ "$arch_key" == "powerpc64" || "$arch_key" == "powerpc64le" ]]; then
	if [[ "$COMPILER_TYPE" == "clang" ]]; then
		arch_ldflags="-Wl,--defsym=_restfpr_31=main"
	else
		arch_cflags="$CFLAGS -mno-save-fpr"
		arch_cxxflags="$CXXFLAGS -mno-save-fpr"
	fi
    elif [[ "$arch_key" == "loongarch64" ]]; then
	arch_ldflags="-Wl,--strip-debug"
    elif [[ "$arch_key" == "m68k" ]]; then
	arch_ldflags="-fuse-ld=$bin_dir/ld.lld"
    elif [[ "$arch_key" == alphaev* ]]; then
	arch_cflags="$CFLAGS -fno-stack-protector"
	arch_cxxflags="$CXXFLAGS -fno-stack-protector"
    fi

    # 4. Compile with Error Logging
    echo -n -e "${SLATE}==>${NC} Configuring CMake... "

    if cmake -S "$SOURCE_DIR" -B "$bdir" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_SYSTEM_NAME=Linux \
        -DCMAKE_SYSTEM_PROCESSOR="$cmake_proc" \
        -DCMAKE_C_COMPILER="$bin_dir/${triple}-${COMPILER_BIN}" \
        -DCMAKE_CXX_COMPILER="$bin_dir/${triple}-$([[ "$COMPILER_BIN" == "gcc" ]] && echo "g++" || echo "clang++")" \
        -DCMAKE_C_FLAGS="${arch_cflags}" \
        -DCMAKE_CXX_FLAGS="${arch_cxxflags}" \
        -DCMAKE_EXE_LINKER_FLAGS="-static ${arch_ldflags}" \
        -DUPX_CONFIG_DISABLE_GITREV=ON \
        -DUPX_CONFIG_IGNORE_TYPES_ABI=ON \
        -DUPX_CONFIG_DISABLE_WERROR=ON \
        -DUSE_STRICT_DEFAULTS=false \
        -DUPX_CONFIG_DISABLE_GITREV=ON \
        -DUPX_CONFIG_DISABLE_WSTRICT=ON \
        > "$log_file" 2>&1; then
        echo -e "${NEONGREEN}Done${NC}"
    else
        echo -e "${TOMATO}FAILED${NC}"
        echo -e "${OCHRE}Check $log_file for details.${NC}"
        return 1
    fi


    #sed -i 's|define UPX_VERSION_HEX      0x050...|define UPX_VERSION_HEX      0x000101|g' $SOURCE_DIR/src/version.h
    #sed -i 's|05.01...|00.01.01|g' $SOURCE_DIR/src/version.h
    #sed -i 's|"5...."|"0.1.1"|g' $SOURCE_DIR/src/version.h
    #sed -i 's|"5..."|"0.11"|g' $SOURCE_DIR/src/version.h
    sed -i "s/UPX_VERSION_DATE     \".*\"/UPX_VERSION_DATE     \"$(date +"%b %-d, %Y" | sed 's/\(1[0-9]\),/\1th,/;s/1,/1st,/;s/2,/2nd,/;s/3,/3rd,/;s/\([0-9]\),/\1th,/g' | sed 's/,//g')\"/g" $SOURCE_DIR/src/version.h
    sed -i "s/UPX_VERSION_DATE_ISO \".*\"/UPX_VERSION_DATE_ISO \"$(date '+%Y-%m-%d')\"/g" $SOURCE_DIR/src/version.h
    #sed -i 's%UPX_VERSION_STRING "5.1.."%UPX_VERSION_STRING "0.1.1"%g' $SOURCE_DIR/CMakeLists.txt
    echo -n -e "${SLATE}==>${NC} Compiling ($JOBS jobs): ${AQUA}[  0%]${NC}"
    cmake --build "$bdir" --target upx -j "$JOBS" > "$log_file" 2>&1 &
    track_progress $! "$log_file" "cmake" 100 "${SKY}"

    # 5. Finalize
    local bin_found; bin_found=$(find "$bdir" -name upx -type f -executable | head -n1)
    if [[ -z "$bin_found" ]]; then
        echo -e "${TOMATO}Error: Binary not found after successful build!${NC}"
        return 1
    fi

    cp "$bin_found" "$out_file"
    "$bin_dir/${triple}-strip" "$out_file" 2>/dev/null || true
    verify_binary_arch "$out_file" "$triple"
    echo -e "${NEONGREEN}PASS ✅ Build Success:${NC} ${BWHITE}upx-$arch_key${NC} (${AQUA}$(du -sh "$out_file" | awk '{print $1}')${NC})"
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
    echo -e "  ${NEONBLUE}--gcc${NC}               Use GCC toolchains (musl, default)"
    echo -e "  ${NEONBLUE}--clang${NC}             Use Clang toolchains"
    echo -e "  ${NEONBLUE}--gnu${NC}               Use GNU GCC toolchains (glibc)"
    echo -e "  ${NEONBLUE}-a|--arch \"LIST\"${NC}    Space-separated list of arches to build"
    echo -e "  ${NEONBLUE}-r|--resume${NC}         Skip targets already found in output/"
    echo -e "  ${NEONBLUE}-j|--jobs N${NC}         Parallel make jobs (default: auto-detected)"
    echo -e "  ${NEONBLUE}-C|--clean${NC}          Wipe builds and source"
    echo -e "  ${NEONBLUE}--list-archs${NC}        Print all available target architectures"
    echo -e "                       (Use with --gcc, --clang, or --gnu)"
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
        --gnu)   set_compiler gnu ;;
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

# Patch pefile.cpp: rename the local 'import' variable in rebuildImports() to
# 'import_ptr' to avoid a macro-expansion conflict.  The file-level macro
# "#define import my_import" (added for C++20 keyword compatibility) causes
# some clang cross-compilers to fail to recognise 'my_import' as the variable
# declared by IPTR_VAR_OFFSET when the declaration uses 'const import'.
# Using a name that is not affected by the macro side-steps the issue entirely.
echo -n -e "${OCHRE}==>${NC} Patching pefile.cpp import variable collision... "
sed -i \
    's/IPTR_VAR_OFFSET(const byte, const import,/IPTR_VAR_OFFSET(const byte, import_ptr,/' \
    "$SOURCE_DIR/src/pefile.cpp"
sed -i \
    's/raw_bytes(import + /raw_bytes(import_ptr + /g' \
    "$SOURCE_DIR/src/pefile.cpp"
echo -e "${NEONGREEN}Done${NC}"

if [[ -z "$USER_ARCHS" ]]; then
    ARCHS=$(echo "${!ARCH_INFO[@]}" | tr ' ' '\n' | sort | tr '\n' ' ')
else
    ARCHS="$USER_ARCHS"
fi

echo -e "${SLATE}Queueing ${BWHITE}$(echo $ARCHS | wc -w)${NC} targets...\n"

build_all_archs

check_static

final
