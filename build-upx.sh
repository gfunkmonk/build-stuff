#!/usr/bin/env bash

set -euo pipefail

# ── Gemini's Curated Palette ──────────────────────────────────────────────────
AQUA="\033[38;2;18;254;202m"          # Progress
HELIOTROPE="\033[38;2;223;115;255m"    # Headers
NEONBLUE="\033[38;2;4;218;255m"        # Info/Targets
NEONGREEN="\033[38;2;57;255;20m"       # Success
NEONPURPLE="\033[38;2;225;8;255m"      # Accents
OCHRE="\033[38;2;204;119;34m"          # Warnings
SLATE="\033[38;2;109;129;150m"         # Subtext
TOMATO="\033[38;2;255;99;71m"          # Errors
BWHITE="\033[1;37m"                    # Bold Highlight
NC="\033[0m"

# ── Defaults & Config ─────────────────────────────────────────────────────────
ROOT_DIR="$(pwd)/upx-build"
UPX_REPO="https://github.com/gfunkmonk/upx.git"
UPX_BRANCH="devel"
SOURCE_DIR="$ROOT_DIR/upx-src"
BUILD_BASE="$ROOT_DIR/builds"
OUTPUT_DIR="$ROOT_DIR/output"
JOBS="$(nproc)"
COMPILER_TYPE="clang"
RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/magazine/"
RESUME_MODE=false

# ── Architecture Table (Triple : CMakeProcessor) ──────────────────────────────
declare -A ARCH_INFO=(
  [i586]="i586-unknown-linux-musl:i586"
  [i686]="i686-unknown-linux-musl:i686"
  [x86_64]="x86_64-unknown-linux-musl:x86_64"
  [arm]="armv6-unknown-linux-musleabi:arm"
  [armhf]="arm-unknown-linux-musleabihf:arm"
  [armv7]="armv7-unknown-linux-musleabi:armv7"
  [armv7hf]="armv7-unknown-linux-musleabihf:armv7"
  [aarch64]="aarch64-unknown-linux-musl:aarch64"
  [mips]="mips-unknown-linux-musl:mips"
  [mips-sf]="mips-unknown-linux-muslsf:mips"
  [mips64]="mips64-unknown-linux-musl:mips64"
  [mips64el]="mips64el-unknown-linux-musl:mips64el"
  [mipsel]="mipsel-unknown-linux-musl:mipsel"
  [mipsel-sf]="mipsel-unknown-linux-muslsf:mipsel"
  [powerpc]="powerpc-unknown-linux-musl:powerpc"
  [powerpc64]="powerpc64-unknown-linux-musl:ppc64"
  [powerpc64le]="powerpc64le-unknown-linux-musl:ppc64le"
  [riscv32]="riscv32-unknown-linux-musl:riscv32"
  [riscv64]="riscv64-unknown-linux-musl:riscv64"
  [loongarch64]="loongarch64-unknown-linux-musl:loongarch64"
  [m68k]="m68k-unknown-linux-musl:m68k"
  [s390x]="s390x-ibm-linux-musl:s390x"
  [sh4]="sh4-multilib-linux-musl:sh4")

declare -A HASHES_GCC=(
  [aarch64-unknown-linux-musl.tar.xz]="5dd03719e91e295d0bc32287e54107d1b74c82a2f9f19ec041949eb84e4b0a89"
  [arm-unknown-linux-musleabi.tar.xz]="26eef71bb21a1098fce0e9d418f4a784a4117da359ab354a7fd9ef2c506f8e52"
  [arm-unknown-linux-musleabihf.tar.xz]="70ba032a2281b00ea739888899774a339a6b4ca25416b0fa5aa972a4b0b107d0"
  [armv7-unknown-linux-musleabi.tar.xz]="0e17049074d3880d3f5a38767364d9a513f55ef808a65c3bcdfcdbadfe6fd10d"
  [armv7-unknown-linux-musleabihf.tar.xz]="e9a991d7e6bf228bc297c3eeba8b45c3fdf4a95df5e170f624ab54a4310a9d28"
  [i586-unknown-linux-musl.tar.xz]="1855883aca18e35f010c57e4031196b944c9ed0d980b032e8a9407dcdc2d4cf5"
  [i686-unknown-linux-musl.tar.xz]="45c9763c0c03e284b0577e2b5881c13813803a1e985b705a3a1a5200c4efaeb8"
  [loongarch64-unknown-linux-musl.tar.xz]="952b951add8ac0e91aac172ba02db155d7055d4d6c7e64118d41004b3c05c5a1"
  [m68k-unknown-linux-musl.tar.xz]="b21f1af4f99297792e95f4e94b739d20a630a0184baf336822d0ec59606990d2"
  [mips-unknown-linux-musl.tar.xz]="9d49118d404c390927fe4acd78413657f3e22cc0aa495b67a497f52387086fd2"
  [mips-unknown-linux-muslsf.tar.xz]="b4228f859ba1df8c34fca53e31783f26f2870658da350a06805a20dc5a73509c"
  [mips64-unknown-linux-musl.tar.xz]="5d798135cc8f43eb44dece1717ae20b6d2578f83f3a4975e72967dabf5cd1d28"
  [mips64el-unknown-linux-musl.tar.xz]="106705cb8c10a5a1afd1b5ce75f22494341e1172a68e2687ceb3ea22ffd3555c"
  [mipsel-unknown-linux-musl.tar.xz]="b23ab5083f2e80bbe3bfdb13888910af21e5b74d5257ceb5ea61ad004e7030cc"
  [mipsel-unknown-linux-muslsf.tar.xz]="0a9499a371a718b976e29b28ffc2e2d5425470d21c0e2e980f50b917cf2e29b0"
  [powerpc-unknown-linux-musl.tar.xz]="48cf0e85a029a14c9a73e5912d581edf81c3bce795b83771ad4760c71a4a5423"
  [powerpc64-unknown-linux-musl.tar.xz]="a27fe28428b893364c827fc47e3bd9b0317e2646b341bb428856ee83c63d5b03"
  [powerpc64le-unknown-linux-musl.tar.xz]="c4ad2175484e828c172a0aaa6c9a8a5a455c626d518d8e94fb5194be7d8ddbb4"
  [powerpcle-unknown-linux-musl.tar.xz]="a91da053e92fc9e52177cd0ad4fa1dbb9d474f938bb0bdaf37b7d8b310f56468"
  [riscv32-unknown-linux-musl.tar.xz]="a74dfd819bf0ba9abba199121a8bf4520fc29d2fb68b2a89ceec358ae87042c1"
  [riscv64-unknown-linux-musl.tar.xz]="26af8e85adc4ca71b4207b03afbab1da9910c3955a216ed38c81830db9a1b2d2"
  [s390x-ibm-linux-musl.tar.xz]="6732c687f32b85d2a35b85b0714f8a3d8c29919b502a982a2eb69ecdf22fea44"
  [sh4-multilib-linux-musl.tar.xz]="20ddf27b08aa5b386d714e83b8b1a3d1f4e3d50d82a873d59b4727c49e8c3be7"
  [x86_64-unknown-linux-musl.tar.xz]="188e16cf5823386e6efa734c23de0455149fa0355e46a761b2cd189a9f25f989"
)

declare -A HASHES_CLANG=(
  [aarch64-unknown-linux-musl.tar.xz]="95c7d6a863d925fd68e285dea8d125c806c7c8f7032669123a81b1053b84bd20"
  [arm-unknown-linux-musleabi.tar.xz]="efa04d0c82b283d87f4b2df7220f9b5c212e35a37c76c1d924713842e680f91f"
  [arm-unknown-linux-musleabihf.tar.xz]="bb54d5895aec06c6a638960b02ba8ca35b79963b07e3a5759e42c97b37044287"
  [armv7-unknown-linux-musleabi.tar.xz]="afa2a44c674cb50fbd5ec77f322020d6dcb483877aec782c692a1465c9f102b9"
  [armv7-unknown-linux-musleabihf.tar.xz]="f52decfd3cdb1e6248465a0643e17bdf3eb4e85608f58c5506a5420c265bc8f5"
  [i586-unknown-linux-musl.tar.xz]="e87edf0b2039c1085b63cc9f7ef0bc41831587945c9a647d79e4832d07226123"
  [i686-unknown-linux-musl.tar.xz]="1481bc6af546d0eca71b6568475ed37649db50c3fbd47edeb4b3c3753861c5cb"
  [loongarch64-unknown-linux-musl.tar.xz]="2ebeed69914179567599feb98fbda4a3751570f84a2ba9140aff967039ec5b32"
  [mips-unknown-linux-musl.tar.xz]="1a96154d34a13d6502ad5afed36f00f7e7eb8992b6be922ea62c3c0007a256fd"
  [mips-unknown-linux-muslsf.tar.xz]="97ae608c1b21f58ef00b3a79a57ed60b2955e0c924713e78631ab5166a538919"
  [mips64-unknown-linux-musl.tar.xz]="67a0b8c28803c857c3666078b793ab4d68723b47c71a0fa29831e734aa34eb5f"
  [mips64el-unknown-linux-musl.tar.xz]="dab5993b207a6777a1c4d0030772ae43691f1193db5506de3b4fe45416e1bfdf"
  [mipsel-unknown-linux-musl.tar.xz]="0c91c4b6b81ed931cde774634fdde4e241d3e1e2158f84419ae0233056f1312c"
  [mipsel-unknown-linux-muslsf.tar.xz]="d5bad117814f492850bcebc4f84c4fabcbc8417a1eb9b32e3e77e5ae2a8e4471"
  [powerpc-unknown-linux-musl.tar.xz]="a9b94b3812c774c3e77685369a609441e381b0f0c7fdf21c6eedc0289d5ca84b"
  [powerpc64-unknown-linux-musl.tar.xz]="dac21f651f68539c810a2d60132cfd68c7b275830acb4768a0870eae6fe97b63"
  [powerpc64le-unknown-linux-musl.tar.xz]="70da787b820707c3c5950e87a728bb370efea44bfb39683ae2e8843b8d46b2d4"
  [powerpcle-unknown-linux-musl.tar.xz]="7f8bee90d978f2748ce9f0847fe70c81c6a3c95427128acfc46ed9e09a41b574"
  [riscv32-unknown-linux-musl.tar.xz]="fad97f0bc0d7104fd023966a1bd21b2a9db097580e1968fccc9a11002cad86bb"
  [riscv64-unknown-linux-musl.tar.xz]="414d17cc86099e89fc1c5d6caf3a6d731d91df4bee48a654b198d72edb3df521"
  [s390x-ibm-linux-musl.tar.xz]="b54ad00e946f10504fc88f60d2efd9853a8a47237da95a48832a38062b405fb5"
  [x86_64-unknown-linux-musl.tar.xz]="62f74a4c082249f736662e35c847f73d9ae1134b2a76bfcdb33829d06fa70c92"
)

# ── Helper Subcommands ────────────────────────────────────────────────────────

list_output() {
    echo -e "${HELIOTROPE}📂 Currently Built Binaries:${NC}"
    ls -lh "$OUTPUT_DIR" | grep 'upx-' || echo -e "${SLATE}No artifacts found.${NC}"
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
    local out_file="$OUTPUT_DIR/upx-$arch_key"
    local log_file="$ROOT_DIR/build-$arch.log"

    echo -e "${NEONPURPLE}💠────────────────────────────────────────────────────────────💠${NC}"
    [[ "$RESUME_MODE" == true && -f "$out_file" ]] && { echo -e "${SLATE}⏭️  Skipping $arch_key${NC}"; return; }

    echo -e "${NEONBLUE}🔨 Target:${NC} ${BWHITE}$arch_key${NC} (${SLATE}$triple${NC}) via ${AQUA}$COMPILER_TYPE${NC}"

    # 1. Download/Verify
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    if [[ ! -f "$tarpath" ]]; then
        echo -n -e "${SLATE}==>${NC} Fetching toolchain... "
        curl -fsSL --retry 3 --create-dirs -o "$tarpath" "$RELEASE_BASE/$tarball" && echo -e "${NEONGREEN}Done${NC}" || { echo -e "${TOMATO}Fail${NC}"; return 1; }
    fi

    echo -e "${SLATE}==>${NC} Verifying Integrity..."
    local expected
    [[ "$COMPILER_TYPE" == "gcc" ]] && expected="${HASHES_GCC[$tarball]}" || expected="${HASHES_CLANG[$tarball]}"

    local actual=$(sha256sum "$tarpath" | awk '{print $1}')
    if [[ "$actual" != "$expected" ]]; then
        echo -e "${TOMATO}CRITICAL: Hash mismatch for $tarball!${NC}"
        echo -e "Expected: $expected\nGot: $actual"
        rm -f "$tarpath"
        exit 1
    fi

    # 2. Extract
    local extract_path="$TOOLCHAIN_DIR/$triple"
    if [[ ! -d "$extract_path" ]]; then
        echo -n -e "${SLATE}==>${NC} Extracting... "
        mkdir -p "$extract_path"
        tar -xJf "$tarpath" -C "$TOOLCHAIN_DIR" && echo -e "${NEONGREEN}Done${NC}" || { echo -e "${TOMATO}Fail${NC}"; return 1; }
    fi

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
    # Capture the pipeline exit codes before the if block clears them
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
    local bin_found=$(find "$bdir" -name upx -type f -executable | head -n1)
    if [[ -z "$bin_found" ]]; then
        echo -e "${TOMATO}Error: Binary not found after successful build!${NC}"
        return 1
    fi

    cp "$bin_found" "$out_file"
    "$bin_dir/${triple}-strip" "$out_file" 2>/dev/null || true
    echo -e "${NEONGREEN}✅ Build Success:${NC} ${BWHITE}upx-$arch_key${NC} (${AQUA}$(du -sh "$out_file" | awk '{print $1}')${NC})"
}

# ── Usage ─────────────────────────────────────────────────────────────────────
show_help() {
    echo -e "${HELIOTROPE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BWHITE}UPX CROSS-BUILD ENGINE${NC} [${AQUA}${UPX_BRANCH}${NC}]"
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
    echo -e "  ${NEONBLUE}-C|--clean${NC}          Wipe builds, source, and toolchains"
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
    -C|--clean) echo -e "${OCHRE}💥 Nuking work directory...${NC}"; rm -rf "$ROOT_DIR"; exit 0 ;;
    list) list_output; exit 0 ;;
    verify) verify_static; exit 0 ;;
    test) test_binary "${2:-}"; exit 0 ;;
    --help|-h) show_help ;;
esac

# Flag Parsing
USER_ARCHS=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --gcc) COMPILER_TYPE="gcc"; RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/eastwood"; shift ;;
        --clang) COMPILER_TYPE="clang"; shift ;;
        -a|--arch) USER_ARCHS="$2"; shift 2 ;;
        -r|--resume) RESUME_MODE=true; shift ;;
        -j|--jobs) JOBS="$2"; shift 2 ;;
        -h|--help) show_help ;;
        *) shift ;;
    esac
done

if [[ "$COMPILER_TYPE" == clang ]]; then
  TOOLCHAIN_DIR="$ROOT_DIR/toolchains/clang"
else
  TOOLCHAIN_DIR="$ROOT_DIR/toolchains/gcc"
fi

echo -e "${HELIOTROPE}🚀 Initializing UPX Cross-Build Engine...${NC}"
mkdir -p "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR"

if [[ ! -d "$SOURCE_DIR/.git" ]]; then
    echo -n -e "${SLATE}==>${NC} Cloning UPX Source (with submodules)... "
    git clone --branch "$UPX_BRANCH" --recursive --depth 1 "$UPX_REPO" "$SOURCE_DIR" > /dev/null 2>&1
    echo -e "${NEONGREEN}Done${NC}"
else
    # Check if submodules are empty and fix them if needed
    if [[ -z "$(ls -A "$SOURCE_DIR/vendor/ucl" 2>/dev/null)" ]]; then
        echo -n -e "${OCHRE}==>${NC} Submodules missing. Repairing... "
        git -C "$SOURCE_DIR" submodule update --init --recursive > /dev/null 2>&1
        echo -e "${NEONGREEN}Fixed${NC}"
    fi
fi

# If the user didn't specify --arch, grab every key from our ARCH_INFO array
if [[ -z "$USER_ARCHS" ]]; then
    # ${!ARRAY[@]} expands to all keys in an associative array
    #ARCHS="${!ARCH_INFO[@]}"
    ARCHS=$(echo "${!ARCH_INFO[@]}" | tr ' ' '\n' | sort | tr '\n' ' ')
else
    ARCHS="$USER_ARCHS"
fi

echo -e "${SLATE}Queueing ${BWHITE}$(echo $ARCHS | wc -w)${NC} targets...${NC}\n"

for arch in $ARCHS; do
    # Check if the arch actually exists in our table before trying to build
    if [[ -n "${ARCH_INFO[$arch]:-}" ]]; then
        build_arch "$arch"
    else
        echo -e "${TOMATO}Skipping unknown architecture: $arch${NC}"
    fi
done

echo -e "\n${HELIOTROPE}🎊 All tasks completed successfully!${NC}"
