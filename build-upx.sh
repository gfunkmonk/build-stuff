#!/usr/bin/env bash

set -euo pipefail

# ── Common Code ───────────────────────────────────────────────────────────────
source "$(dirname "$0")/common.sh"

# ── Defaults & Config ─────────────────────────────────────────────────────────
ROOT_DIR="$(pwd)/upx-build"
UPX_REPO="https://github.com/gfunkmonk/upx.git"
UPX_BRANCH="devel"
SOURCE_DIR="$ROOT_DIR/upx-src"
BUILD_BASE="$ROOT_DIR/builds"
OUTPUT_DIR="$ROOT_DIR/output"
DL_COLOR="${HIGHLIGHTER}"

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
  [loongarch64]="loongarch64-unknown-linux-musl:loongarch64"
  [m68k]="m68k-unknown-linux-musl:m68k"
  [mips]="mips-unknown-linux-musl:mips"
  [mips-sf]="mips-unknown-linux-muslsf:mips"
  [mips64]="mips64-unknown-linux-musl:mips64"
  [mips64el]="mips64el-unknown-linux-musl:mips64el"
  [mipsel]="mipsel-unknown-linux-musl:mipsel"
  [mipsel-sf]="mipsel-unknown-linux-muslsf:mipsel"
  [powerpc]="powerpc-unknown-linux-musl:powerpc"
  [powerpcle]="powerpcle-unknown-linux-musl:powerpcle"
  [powerpc64]="powerpc64-unknown-linux-musl:ppc64"
  [powerpc64le]="powerpc64le-unknown-linux-musl:ppc64le"
  [riscv32]="riscv32-unknown-linux-musl:riscv32"
  [riscv64]="riscv64-unknown-linux-musl:riscv64"
  [s390x]="s390x-ibm-linux-musl:s390x"
  [sh4]="sh4-multilib-linux-musl:sh4")

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

# 1. Download Toolchain (Sunflower Style)
    local tarpath="$TOOLCHAIN_DIR/$tarball"
    if [[ ! -f "$tarpath" ]]; then
        echo -e "${SLATE}==>${NC} Fetching toolchain: ${AQUA}$tarball${NC}"
        # Use -# for the progress bar and pipe 2>&1 into the sunflower loop
        curl -fSL -# --retry 3 -o "$tarpath" "$RELEASE_BASE/$tarball" 2>&1 | while IFS= read -d $'\r' -r p; do
            # Clean up the percentage from curl output
            p=$(echo "$p" | tr -dc '0-9.' | cut -d. -f1)
            : ${p:=0} # Default to 0 if empty
            # Scale to 10 for the Sunflower bar
            local scaled=$(( p / 10 ))
            local bar=$(printf "%${scaled}s" | tr ' ' '=')
            # Print the Sunflower-style status
            printf "\r${DL_COLOR}[ %3d%% ] [ %-10s> ]${NC}" "$p" "$bar"
        done
        # Check PIPESTATUS[0] (the exit code of curl)
        if [[ "${PIPESTATUS[0]}" -ne 0 ]]; then
            echo -e "\n${TOMATO}Download failed for $tarball${NC}"
            rm -f "$tarpath"
            return 1
        fi
        echo -e "" # Move to next line after success
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
    echo -e "  ${NEONBLUE}-C|--clean${NC}          Wipe builds and source"
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
        --gcc) COMPILER_TYPE="gcc"; RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/carhartcoat"; shift ;;
        --clang) COMPILER_TYPE="clang"; shift ;;
        -a|--arch) USER_ARCHS="$2"; shift 2 ;;
        -r|--resume) RESUME_MODE=true; shift ;;
        -j|--jobs) JOBS="$2"; shift 2 ;;
        -h|--help) show_help ;;
        *) shift ;;
    esac
done

TOOLCHAIN_DIR="$(pwd)/toolchains/$COMPILER_TYPE"

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
echo -e "${BWHITE}Final binaries available in:${NC} ${MINT}$OUTPUT_DIR${NC}"
ls -F --color=auto "$OUTPUT_DIR"
