#!/usr/bin/env bash
# ── Common Code ───────────────────────────────────────────────────────────────
source "$(dirname "$0")/common.sh"
# ── Defaults & Config ─────────────────────────────────────────────────────────
REPO_URL="https://git.musl-libc.org/git/musl"
REPO_BRANCH="master"
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
# ── Architecture Table (Triple) ───────────────────────────────────────────────
declare_arch_info() {
  if [[ "$COMPILER_TYPE" == "gcc" ]]; then
    declare -gA ARCH_INFO=(
      [arm]="arm-unknown-linux-musleabi"
      [armhf]="arm-unknown-linux-musleabihf"
      [armv5]="armv5-unknown-linux-musleabi"
      [armv6]="armv6-unknown-linux-musleabi"
      [armv6hf]="armv6-unknown-linux-musleabihf"
      [armv7]="armv7-unknown-linux-musleabi"
      [armv7hf]="armv7-unknown-linux-musleabihf"
      [aarch64]="aarch64-unknown-linux-musl"
      [aarch64_be]="aarch64_be-unknown-linux-musl"
      [i386]="i386-unknown-linux-musl"
      [i486]="i486-unknown-linux-musl"
      [i586]="i586-unknown-linux-musl"
      [i686]="i686-unknown-linux-musl"
      [loongarch64]="loongarch64-unknown-linux-musl"
      [m68k]="m68k-unknown-linux-musl"
      [mips]="mips-unknown-linux-musl"
      [mips-sf]="mips-unknown-linux-muslsf"
      [mips64]="mips64-unknown-linux-musl"
      [mips64el]="mips64el-unknown-linux-musl"
      [mipsel]="mipsel-unknown-linux-musl"
      [mipsel-sf]="mipsel-unknown-linux-muslsf"
      [or1k]="or1k-unknown-linux-musl"
      [powerpc]="powerpc-unknown-linux-musl"
      [powerpc-sf]="powerpc-unknown-linux-muslsf"
      [powerpcle]="powerpcle-unknown-linux-musl"
      [powerpcle-sf]="powerpcle-unknown-linux-muslsf"
      [powerpc64]="powerpc64-unknown-linux-musl"
      [powerpc64le]="powerpc64le-unknown-linux-musl"
      [riscv32]="riscv32-unknown-linux-musl"
      [riscv64]="riscv64-unknown-linux-musl"
      [s390x]="s390x-ibm-linux-musl"
      [sh4]="sh4-multilib-linux-musl"
      [x86_64]="x86_64-unknown-linux-musl")
  elif [[ "$COMPILER_TYPE" == "gnu" ]]; then
    declare -gA ARCH_INFO=(
      [arm]="arm-unknown-linux-gnueabi"
      [armhf]="arm-unknown-linux-gnueabihf"
      [armv4t]="armv4t-unknown-linux-gnueabi"
      [armv5]="armv5-unknown-linux-gnueabi"
      [armv6]="armv6-unknown-linux-gnueabi"
      [armv6hf]="armv6-unknown-linux-gnueabihf"
      [armv7]="armv7-unknown-linux-gnueabi"
      [armv7hf]="armv7-unknown-linux-gnueabihf"
      [aarch64]="aarch64-unknown-linux-gnu"
      [aarch64_be]="aarch64_be-unknown-linux-gnu"
      #[alphaev56]="alphaev56-unknown-linux-gnu"
      #[alphaev67]="alphaev67-unknown-linux-gnu"
      #[hppa]="hppa-unknown-linux-gnu"
      [i486]="i486-unknown-linux-gnu"
      [i586]="i586-unknown-linux-gnu"
      [i686]="i686-unknown-linux-gnu"
      [loongarch64]="loongarch64-unknown-linux-gnu"
      [m68k]="m68k-unknown-linux-gnu"
      [microblaze]="microblaze-xilinx-linux-gnu"
      [microblazeel]="microblazeel-xilinx-linux-gnu"
      [mips]="mips-unknown-linux-gnu"
      [mips-sf]="mips-unknown-linux-gnusf"
      [mips64]="mips64-unknown-linux-gnu"
      [mips64el]="mips64el-unknown-linux-gnu"
      [mipsel]="mipsel-unknown-linux-gnu"
      [mipsel-sf]="mipsel-unknown-linux-gnusf"
      [or1k]="or1k-unknown-linux-gnu"
      [powerpc]="powerpc-unknown-linux-gnu"
      [powerpc-sf]="powerpc-unknown-linux-gnusf"
      [powerpcle]="powerpcle-unknown-linux-gnu"
      [powerpcle-sf]="powerpcle-unknown-linux-gnusf"
      [powerpc64]="powerpc64-unknown-linux-gnu"
      [powerpc64le]="powerpc64le-unknown-linux-gnu"
      [riscv32]="riscv32-unknown-linux-gnu"
      [riscv64]="riscv64-unknown-linux-gnu"
      #[s390]="s390-ibm-linux-gnu"
      #[s390x]="s390x-ibm-linux-gnu"
      [sh4]="sh4-multilib-linux-gnu"
      [sparc]="sparc-unknown-linux-gnu"
      [sparc64]="sparc64-unknown-linux-gnu"
      [x86_64]="x86_64-unknown-linux-gnu")
  else
    declare -gA ARCH_INFO=(
      [arm]="arm-unknown-linux-musleabi"
      [armhf]="arm-unknown-linux-musleabihf"
      [armv5]="armv5-unknown-linux-musleabi"
      [armv6]="armv6-unknown-linux-musleabi"
      [armv6hf]="armv6-unknown-linux-musleabihf"
      [armv7]="armv7-unknown-linux-musleabi"
      [armv7hf]="armv7-unknown-linux-musleabihf"
      [aarch64]="aarch64-unknown-linux-musl"
      [i386]="i386-unknown-linux-musl"
      [i486]="i486-unknown-linux-musl"
      [i586]="i586-unknown-linux-musl"
      [i686]="i686-unknown-linux-musl"
      [loongarch64]="loongarch64-unknown-linux-musl"
      [m68k]="m68k-unknown-linux-musl"
      [mips]="mips-unknown-linux-musl"
      [mips-sf]="mips-unknown-linux-muslsf"
      [mips64]="mips64-unknown-linux-musl"
      [mips64el]="mips64el-unknown-linux-musl"
      [mipsel]="mipsel-unknown-linux-musl"
      [mipsel-sf]="mipsel-unknown-linux-muslsf"
      [or1k]="or1k-unknown-linux-musl"
      [powerpc]="powerpc-unknown-linux-musl"
      [powerpc-sf]="powerpc-unknown-linux-muslsf"
      [powerpcle]="powerpcle-unknown-linux-musl"
      [powerpcle-sf]="powerpcle-unknown-linux-muslsf"
      [powerpc64]="powerpc64-unknown-linux-musl"
      [powerpc64le]="powerpc64le-unknown-linux-musl"
      [riscv32]="riscv32-unknown-linux-musl"
      [riscv64]="riscv64-unknown-linux-musl"
      [s390x]="s390x-ibm-linux-musl"
      [sh4]="sh4-multilib-linux-musl"
      [x86_64]="x86_64-unknown-linux-musl")
  fi
}
# ── Helper Subcommands ────────────────────────────────────────────────────────
list_output() {
    echo -e "${HELIOTROPE}📂 Currently Built Archives:${NC}"
    local found=false
    for archive in "$OUTPUT_DIR"/musl-*.tar.gz; do
        [[ -f "$archive" ]] || continue
        found=true
        ls -lh "$archive"
    done
    [[ "$found" == false ]] && echo -e "${SLATE}No artifacts found.${NC}"
}
verify_contents() {
    echo -e "${AQUA}🔍 Verifying Archive Contents...${NC}"
    local found=false
    for archive in "$OUTPUT_DIR"/musl-*.tar.gz; do
        [[ -f "$archive" ]] || continue
        found=true
        if tar -tzf "$archive" 2>/dev/null | grep -q "lib/libc.a"; then
            echo -e "${NEONGREEN}✓${NC} $(basename "$archive") — lib/libc.a present"
        else
            echo -e "${TOMATO}✗ $(basename "$archive") — lib/libc.a MISSING${NC}"
        fi
    done
    [[ "$found" == false ]] && echo -e "${SLATE}No artifacts found.${NC}"
}
# ── Build Logic ───────────────────────────────────────────────────────────────
build_arch() {
    local arch_key="$1"
    local triple="${ARCH_INFO[$arch_key]:-}"
    [[ -z "$triple" ]] && { echo -e "${TOMATO}Unknown architecture: $arch_key${NC}"; return 1; }
    local tarball="${triple}.tar.xz"
    local out_file="$OUTPUT_DIR/musl-$arch_key.tar.gz"
    local log_file="$ROOT_DIR/build-$arch_key.log"
    local bdir="$BUILD_BASE/$arch_key"
    local install_dir="$bdir/install"
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
    rm -rf "$bdir" && mkdir -p "$bdir" "$install_dir"
    # 4. Configure (out-of-tree)
    # Per-arch compiler flag adjustments
    local arch_cflags="$CFLAGS"
    local arch_cxxflags="$CXXFLAGS"
    local arch_ldflags=""
    if [[ "$arch_key" == "powerpc64" || "$arch_key" == "powerpc64le" ]]; then
        if [[ "$COMPILER_TYPE" == "clang" ]]; then
                arch_ldflags="-Wl,--defsym=_restfpr_31=main"
        else
                #arch_cflags="$CFLAGS -mno-save-fpr"
                #arch_cxxflags="$CXXFLAGS -mno-save-fpr"
                arch_cflags="$CFLAGS -mlong-double-64"
                arch_cxxflags="$CXXFLAGS -mlong-double-64"
        fi
    elif [[ "$arch_key" == "loongarch64" ]]; then
        arch_ldflags="-Wl,--strip-debug"
    elif [[ "$arch_key" == alphaev* ]]; then
        arch_cflags="$CFLAGS -fno-stack-protector"
        arch_cxxflags="$CXXFLAGS -fno-stack-protector"
    elif [[ "$arch_key" == sparc || "$arch_key" == powerpc || "$arch_key" == "powerpc-sf" || "$arch_key" == powerpcle || "$arch_key" == "powerpcle-sf" || "$arch_key" == "alphaev56" || "$arch_key" == "alphaev67" || "$arch_key" == "alpha" ]]; then
        arch_cflags="$CFLAGS -mlong-double-64"
        arch_cxxflags="$CXXFLAGS -mlong-double-64"
    elif [[ "$arch_key" == s390 || "$arch_key" == s390x ]]; then
        arch_cflags="$CFLAGS -mlong-double-128"
        arch_cxxflags="$CXXFLAGS -mlong-double-128"
    elif [[ "$arch_key" == s390x ]]; then
        arch_cflags="$CFLAGS -march=z9-ec"
        arch_cxxflags="$CXXFLAGS -march=z9-ec"
    fi
    # musl configure only recognises the base CPU name for some arches
    local musl_target="$triple"
    if [[ "$arch_key" == alphaev* ]]; then
        musl_target="alpha-unknown-linux-gnu"
    fi
    echo -n -e "${SLATE}==>${NC} Configuring musl... "
    if (cd "$bdir" && "$SOURCE_DIR/configure" \
            --target="$musl_target" \
            --prefix="$install_dir" \
            --syslibdir="$install_dir/lib" \
            --disable-shared \
            --enable-static \
            CC="$bin_dir/${triple}-${COMPILER_BIN}" \
            CROSS_COMPILE="$bin_dir/${triple}-" \
            CFLAGS="${arch_cflags}" \
            CXXFLAGS="${arch_cxxflags}" \
            LDFLAGS="${arch_ldflags}" \
        ) > "$log_file" 2>&1; then
        echo -e "${NEONGREEN}Done${NC}"
    else
        echo -e "${TOMATO}FAILED${NC}"
        echo -e "${OCHRE}Check $log_file for details.${NC}"
        return 1
    fi
    # Count expected .c files for progress estimation
    local total_obj
    total_obj=$(find "$SOURCE_DIR/src" -name "*.c" -type f 2>/dev/null | wc -l)
    [[ "$total_obj" -lt 1 ]] && total_obj=200
    # 5. Compile
    echo -n -e "${SLATE}==>${NC} Compiling ($JOBS jobs): ${AQUA}[  0%]${NC}"
    make -C "$bdir" -j"$JOBS" >> "$log_file" 2>&1 &
    track_progress $! "$log_file" "make-files" "$total_obj" "${SKY}" "$bdir:*.o"
    # 6. Install
    echo -n -e "${SLATE}==>${NC} Installing... "
    if make -C "$bdir" install >> "$log_file" 2>&1; then
        echo -e "${NEONGREEN}Done${NC}"
    else
        echo -e "${TOMATO}FAILED${NC}"
        echo -e "${OCHRE}Check $log_file for details.${NC}"
        return 1
    fi
    # 7. Package as archive
    mkdir -p "$OUTPUT_DIR"
    echo -n -e "${SLATE}==>${NC} Packaging... "
    if tar -czf "$out_file" -C "$install_dir" .; then
        echo -e "${NEONGREEN}Done${NC}"
    else
        echo -e "${TOMATO}FAILED${NC}"
        return 1
    fi
    echo -e "${NEONGREEN}PASS ✅ Build Success:${NC} ${BWHITE}musl-$arch_key${NC} (${AQUA}$(du -sh "$out_file" | awk '{print $1}')${NC})"
}
# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${HELIOTROPE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BWHITE}MUSL CROSS-BUILD ENGINE${NC}"
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
    echo -e "  ${NEONPURPLE}list${NC}                Display all built archives and sizes"
    echo -e "  ${NEONPURPLE}verify${NC}              Check archives contain lib/libc.a"
    echo ""
    echo -e "${BWHITE}EXAMPLES:${NC}"
    echo -e "  $0 --gcc --arch \"x86_64 aarch64\""
    echo -e "  $0 --resume"
    echo -e "  $0 list"
    echo -e "${HELIOTROPE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
}
# ── Main Entry ────────────────────────────────────────────────────────────────
case "${1:-}" in
    list)   list_output;     exit 0 ;;
    verify) verify_contents; exit 0 ;;
    --help|-h) show_help ;;
esac
# Pre-pass: detect --gcc/--clang/--gnu so ARCH_INFO is populated with the right
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
echo -e "${HELIOTROPE}🚀 Initializing MUSL Cross-Build Engine...${NC}"
mkdir -p "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR"
git_clone
if [[ -z "$USER_ARCHS" ]]; then
    ARCHS=$(echo "${!ARCH_INFO[@]}" | tr ' ' '\n' | sort | tr '\n' ' ')
else
    ARCHS="$USER_ARCHS"
fi
echo -e "${SLATE}Queueing ${BWHITE}$(echo $ARCHS | wc -w)${NC} targets...\n"
build_all_archs
final
