#!/usr/bin/env bash

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
AQUA="\033[38;2;18;254;202m"
BWHITE="\033[1;37m"
CANARY="\033[38;2;255;255;153m"
CARIBBEAN="\033[38;2;0;204;153m"
CHARTREUSE="\033[38;2;127;255;0m"
CORAL="\033[38;2;240;128;128m"
CRIMSON="\033[38;2;220;20;60m"
CYAN="\033[1;36m"
GOLDENROD="\033[38;2;218;165;32m"
HELIOTROPE="\033[38;2;223;115;255m"
HIGHLIGHTER="\033[38;2;248;255;15m"
HOTPINK="\033[38;2;255;105;180m"
JUNEBUD="\033[38;2;189;218;87m"
KHAKI="\033[38;2;226;214;167m"
LAGOON="\033[38;2;142;235;236m"
LIME="\033[38;2;204;255;0m"
LAVENDER="\033[38;2;152;115;172m"
LIGHTSLATE="\033[38;2;145;200;222m"
LEMON="\033[38;2;255;244;79m"
MAUVE="\033[38;2;224;175;255m"
MINT="\033[38;2;152;255;152m"
NAVAJO="\033[38;2;255;222;173m"
NEONBLUE="\033[38;2;4;218;255m"
NEONGREEN="\033[38;2;57;255;20m"
NEONPINK="\033[38;2;255;19;240m"
NEONPURPLE="\033[38;2;225;8;255m"
NEONRED="\033[38;2;255;49;49m"
OCHRE="\033[38;2;204;119;34m"
ORANGE="\033[38;2;255;165;0m"
PEACH="\033[38;2;246;161;146m"
SKY="\033[38;2;4;218;255m"
SLATE="\033[38;2;109;129;150m"
TAWNY="\033[38;2;204;78;0m"
TOMATO="\033[38;2;255;99;71m"
NC="\033[0m"

# ── SHA256 Hash Tables ────────────────────────────────────────────────────────
declare -A HASHES_GCC=(
  [aarch64-unknown-linux-musl.tar.xz]="c4619d93402049f4f9203cccca4a5d902f91fc71a4b9c120413594255704ae21"
  [arm-unknown-linux-musleabi.tar.xz]="2e761046b27d6a6af1102cef71f0bb917d163d037c0372d244c0405c95561eac"
  [arm-unknown-linux-musleabihf.tar.xz]="cc3801999cb69bba86f4a5b88f162e4f4aaeb8570608a8208f15ce8d823b34db"
  [armv5-unknown-linux-musleabi.tar.xz]="7897fe8424a3a6408991b33e2d841398523a8f5ccdd6c1d6ba4adaf43b4621d2"
  [armv6-unknown-linux-musleabi.tar.xz]="2317635d9724a63e98ff39d3b53fe4351593423c445c6ed6c897ffbe3d94d125"
  [armv6-unknown-linux-musleabihf.tar.xz]="ce191f14178e65eeae99f98570e8113207db6ddf05cbf911735aefbfc4b8f913"
  [armv7-unknown-linux-musleabi.tar.xz]="1b6b75baa407c1fd177b3bb52b27f60eeabf318b64b3f1fb7974c1e95465ce8a"
  [armv7-unknown-linux-musleabihf.tar.xz]="64e317378cf2ec37cc05a1110237e9c9e6116a23f38abf5f44df1594c0a9d8b6"
  [i386-unknown-linux-musl.tar.xz]="f217d6924a52fa0e4b798b60459872f895e4d4675a0f7a9789dea96a83a2cbfd"
  [i486-unknown-linux-musl.tar.xz]="520a970830d756457278e6a50bdc36ed915950bbd660d6ffbd9ed564b1808365"
  [i586-unknown-linux-musl.tar.xz]="c64706028e4d698e0ab12d32a4bb639b54553e263510a24e66802c2479ad128c"
  [i686-unknown-linux-musl.tar.xz]="d83a4567e24c4d5cf6d8537323614a7cd288750cd27c77c5aefe1e8c4c03026e"
  [loongarch64-unknown-linux-musl.tar.xz]="bf2a8207e5456df2a2f0f6df1dd7b02f1d2d4e9d10e80688c81855680cf78b11"
  [m68k-unknown-linux-musl.tar.xz]="3c0bd86dccabb84dbd48f7ca8ef43f916005255508dccce151ed92e51d69e47b"
  [microblaze-xilinx-linux-musl.tar.xz]="6afa2ecde4346327cb30a30f4d0636b80124da4a383637488c5e5264cb30728f"
  [microblazeel-xilinx-linux-musl.tar.xz]="6cb7245c35bfc908b611b03fdca45597e6ac4238e5548e6d1890ceb6462ee025"
  [mips-unknown-linux-musl.tar.xz]="f65dc3a2d02add9c8c56ca39d2b4a97c44ac5ceffa6794e2aaedaa1aa4fe4c79"
  [mips-unknown-linux-muslsf.tar.xz]="6848ae3c21fac0e03268ad7fcd7857a71a0c5428efd4eb4a98742078b2368fe4"
  [mips64-unknown-linux-musl.tar.xz]="d1a9da146194108a9cd4b4eaebfdea5226cc0a51d8181440702a4215c58a0d8b"
  [mips64el-unknown-linux-musl.tar.xz]="2a8bd222a212208bd8a82be052fa8cb29f5f5b68c3a04d65959a2e53f80de974"
  [mipsel-unknown-linux-musl.tar.xz]="6aae36f209bb26da6c4eb148505438f530aaf0c0ecbdb2314018e4bc371f49f3"
  [mipsel-unknown-linux-muslsf.tar.xz]="1266eb7ad1ab92496117322761c30f510c45fb204a9cc09ef25e669cbb44c5e1"
  [or1k-unknown-linux-musl.tar.xz]="908c1c913ecf4f6d3a37302c546302e76c4508ac3cc38f15dae7debef0d08f6b"
  [powerpc-unknown-linux-musl.tar.xz]="b0245a27c55e7e056f659c5c3365a594cae228937bd408c6150ddaf8f4ccef10"
  [powerpc-unknown-linux-muslsf.tar.xz]="eaf40bd86970cf85d37f46449e9ff6f54accecb0a6f75fc32f13ebd5ccab316b"
  [powerpc64-unknown-linux-musl.tar.xz]="654992b599e111603c8a4727a78f18ac078030a496743edfc425803429bb2bda"
  [powerpc64le-unknown-linux-musl.tar.xz]="3be9fcfe71b1ef1d17ad748ed6c073fcd8560a4547ac9224218d51d98c4746d5"
  [powerpcle-unknown-linux-musl.tar.xz]="d816aa7b7cbad9df8ba52c82403903ff1f7091ed2eb6cfb6c178c6ea5eb81070"
  [powerpcle-unknown-linux-muslsf.tar.xz]="08a772541e5ae79800097261edad23c22dc46f456a193122fed006240eeb3c9d"
  [riscv32-unknown-linux-musl.tar.xz]="fbd6a36d0d5f23b4073f1378efc3c148a81ad22760b962bc14e781fb04b9e671"
  [riscv64-unknown-linux-musl.tar.xz]="0271c096e3817b8dea8833f1d4539778e4233574b58cb782fde4f1121cedb16c"
  [s390x-ibm-linux-musl.tar.xz]="cb1f4873965ecf571beceffa05745d2ca8aa37df07f3b7f720dd467834f8d15b"
  [sh4-multilib-linux-musl.tar.xz]="1bf94cce402702c57ec69875dbd9e5bddb9d743883bb3b81e0092c50cf89f76c"
  [x86_64-unknown-linux-musl.tar.xz]="a6e669814db229cbbbab7ecb3c4273ce2eb0d4466729ee59c14f095b5e28232c"
)

declare -A HASHES_CLANG=(
  [aarch64-unknown-linux-musl.tar.xz]="b6f240e581187cc712738a980c8f8d670b1ce7692f606f183905e5fe6ccd4401"
  [arm-unknown-linux-musleabi.tar.xz]="63aa4e63b4b8a5ab445072951bc9229d4fa7d8e0345b99998e6adf395f527398"
  [arm-unknown-linux-musleabihf.tar.xz]="41fc81ecbb845dcabea337da507fe861251ddac7e4058370d4baa19cb090a04d"
  [armv5-unknown-linux-musleabi.tar.xz]="172dbca74ee0c683282a813f9717d80d29d0b84b49b47e6a43fcb5623602a8d9"
  [armv6-unknown-linux-musleabi.tar.xz]="b6060a6099e67e10d3f800fc68362fa840c57b1413cf649c34d4b226207f697a"
  [armv6-unknown-linux-musleabihf.tar.xz]="b1af51bfd50584faf41e75e8f6f2677c117ba41f294364e054639d101efc657a"
  [armv7-unknown-linux-musleabi.tar.xz]="48f96c58fd4ebabe739a4a339ae81b9df8dc15b630667e06fe694c9465e9664e"
  [armv7-unknown-linux-musleabihf.tar.xz]="773e03af49605f79d01c44333ed7b3bcba37497ebdbd54383d5ca82e1d9d4256"
  [i386-unknown-linux-musl.tar.xz]="d17e56a4f1d752d7b9337ce680fd5f2285c70bf0a07a0cc9e80a0e86c46eb6ac"
  [i486-unknown-linux-musl.tar.xz]="033c847fc7dd0e237a5115df7a1beb97615f312637f61fc10903562b15d7f7d3"
  [i586-unknown-linux-musl.tar.xz]="0715daf4cfa633b0428635fae38f11d0f5b94dfba62136c60236146d40582c9a"
  [i686-unknown-linux-musl.tar.xz]="5b7758c4421c60d984cb797ceb4a078115a14219ad04912d26b144b4a4c8e952"
  [loongarch64-unknown-linux-musl.tar.xz]="01bd0dd1111f3e9e701f7323635b1ac3ca5606b3c18c7a1f04a152980dd27185"
  [m68k-unknown-linux-musl.tar.xz]="c136da3e31272a765d67153023e67dcbb9bd9b964af9613f3f3d0f6bdb52f8fc"
  [mips-unknown-linux-musl.tar.xz]="ea5e097fa20ba99b12a6f3ce9c5e22412d6e7668c2dad6ba21b26b2507464b0a"
  [mips-unknown-linux-muslsf.tar.xz]="43c2110ab221bf5628a0a2d3a3b7bdea33f4494a24520e4b9bb7307008c89b3e"
  [mips64-unknown-linux-musl.tar.xz]="b30f6940ca17900445ca8dc5ace57d82c9c125a974cfc6669901f89789113431"
  [mips64el-unknown-linux-musl.tar.xz]="3c4fec5d0fd432c5900c1e6a37268a8d7c7fd35905c97bd77d6488880bd69220"
  [mipsel-unknown-linux-musl.tar.xz]="11a1e0db11df9602ff6a43d681c96c289f55471c6e3eca25bffffdbeed08db91"
  [mipsel-unknown-linux-muslsf.tar.xz]="880c2bdb3512b8747840340f56abbb16559fe1dc1c20d88f16101e847700c1a8"
  [or1k-unknown-linux-musl.tar.xz]="80986f1ca50ff3f16a56e58f66327e4eea5e3f842cc22c4bee281f973b975163"
  [powerpc-unknown-linux-musl.tar.xz]="43750959cdb6f80cd144ad052668ed7168d8eccc58b9d8aaa8e75384b52d4e78"
  [powerpc-unknown-linux-muslsf.tar.xz]="d1bb2cc1b41ffc73624196d8cbbb7501c817235c550116ce039e0283c8af5c20"
  [powerpc64-unknown-linux-musl.tar.xz]="19e353a7d2ff08bab2cbb8c8c8a41d4a309edcbb17d3024b1dd0851bb346c087"
  [powerpc64le-unknown-linux-musl.tar.xz]="225290d4361c25d96aa4789f9a687fff64d93d65ea896ac531090aa2d4451bdf"
  [powerpcle-unknown-linux-musl.tar.xz]="d5b12f9dd16c5e3b52f37d64822a52e0f214fd24c716dd707d6a69097ee054b0"
  [powerpcle-unknown-linux-muslsf.tar.xz]="e7b2da62e86872be3c7fd55a71c0865d8efd1c3775c9c7bd1072342924fcade2"
  [riscv32-unknown-linux-musl.tar.xz]="7550f8e15151e2a45077a73112ad6f1777999b308541c569a37c9850e6e9fab2"
  [riscv64-unknown-linux-musl.tar.xz]="8240bf30f676b92d5b2348e7f0a75d0edf1882307130561d32b6e366d0d67302"
  [s390x-ibm-linux-musl.tar.xz]="ce5e9f795252bf7b12a5f51a89b62e1b6082174431f4436d920e03c2c99dd657"
  [sh4-multilib-linux-musl.tar.xz]="8d1c7e418c4d6f042da1ea43df72a2f2635a9a213aa490dda88e8054ac7c793d"
  [x86_64-unknown-linux-musl.tar.xz]="9c8973283a3b052de2781a92c8299ef1c1ed4a168821b1b456cd6cfb6dcd0924"
)

NAME=$(basename "$0" | cut -d'-' -f2 | cut -d'.' -f1)
ROOT_DIR="$(pwd)/build/${NAME}"
SOURCE_DIR="$ROOT_DIR/${NAME}-src"
BUILD_BASE="$ROOT_DIR/build"
COMPILER_TYPE="gcc"
OUTPUT_DIR="$(pwd)/output/${NAME}/${COMPILER_TYPE}"
JOBS="$(nproc)"
RESUME_MODE=false
USER_ARCHS=""
CFLAGS="-Os"
CXXFLAGS="-Os"

# ── Toolchain Release URLs ────────────────────────────────────────────────────
GCC_RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/ladder"
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/garlicbread"
RELEASE_BASE="$CLANG_RELEASE_BASE"

# ── Common Helpers ────────────────────────────────────────────────────────────

# Set compiler type and matching release base URL.
# Usage: set_compiler gcc|clang
set_compiler() {
    COMPILER_TYPE="$1"
    if [[ "$COMPILER_TYPE" == "gcc" ]]; then
        RELEASE_BASE="$GCC_RELEASE_BASE"
    else
        RELEASE_BASE="$CLANG_RELEASE_BASE"
    fi
}

# Handle flags shared by every build script.  Returns 0 and sets COMMON_SHIFT
# to the number of positional parameters consumed; returns 1 when the flag is
# unrecognised so the caller can handle it.
# Usage inside a while/case loop:
#   if parse_common_flag "$@"; then shift "$COMMON_SHIFT"; continue; fi
COMMON_SHIFT=0
parse_common_flag() {
    COMMON_SHIFT=0
    case "$1" in
        --gcc)       set_compiler gcc;   COMMON_SHIFT=1; return 0 ;;
        --clang)     set_compiler clang; COMMON_SHIFT=1; return 0 ;;
        -r|--resume) RESUME_MODE=true;   COMMON_SHIFT=1; return 0 ;;
        -j|--jobs)   JOBS="$2";          COMMON_SHIFT=2; return 0 ;;
        -a|--arch)   USER_ARCHS="$2";    COMMON_SHIFT=2; return 0 ;;
        -C|--clean)  clean_workspace;    COMMON_SHIFT=1; return 0 ;;
        --list-archs)
            # ARCH_INFO is declared in the calling script; this flag is only
            # meaningful after that declaration has run.  parse_common_flag is
            # called inside the while loop that immediately follows, so by the
            # time --list-archs is reached ARCH_INFO is already populated.
            echo -e "${BWHITE}Available architectures:${NC}"
            for key in $(echo "${!ARCH_INFO[@]}" | tr ' ' '\n' | sort); do
                echo -e "  ${GOLDENROD}$key${NC}  ${NAVAJO}→ ${ARCH_INFO[$key]%%:*}${NC}"
            done
            exit 0 ;;
    esac
    return 1
}

# Derive TOOLCHAIN_DIR from the current COMPILER_TYPE.
# Call once after all flags have been parsed.
setup_toolchain_dir() {
    TOOLCHAIN_DIR="$(pwd)/toolchains/$COMPILER_TYPE"
    OUTPUT_DIR="$(pwd)/output/${NAME}/${COMPILER_TYPE}"
}

# Wipe the build workspace and exit.
# Requires ROOT_DIR to be set by the calling script.
clean_workspace() {
    echo -e "${CLEAN_C}💥 Cleaning workspace...${NC}"
    rm -rf "$ROOT_DIR"
    exit 0
}

# Iterate over $ARCHS and call build_arch for each known architecture.
# Requires ARCHS and ARCH_INFO to be set, and build_arch to be defined,
# by the calling script.
build_all_archs() {
    for arch in $ARCHS; do
        if [[ -z "${ARCH_INFO[$arch]:-}" ]]; then
            echo -e "${NEONRED}Skipping unknown architecture: $arch${NC}"
            continue
        fi
        build_arch "$arch"
    done
}

# ── Toolchain Download ────────────────────────────────────────────────────────
download_toolchain() {
    local tarpath="$1"
    local tarball="$2"
    if [[ -f "$tarpath" ]]; then
        echo -e "${CARIBBEAN}Using cached toolchain: $tarball${NC}"
        return 0
    fi
    echo -e "${DL_TC_1}==>${DL_TC_2} Fetching toolchain: ${DL_TC_3}$tarball${NC}"

    # stdbuf -oL flushes each \r-terminated curl -# update immediately to the
    # pipe instead of batching them, giving smooth real-time progress display.
    stdbuf -oL curl -fSL -# --retry 3 --create-dirs \
        -o "$tarpath" "$RELEASE_BASE/$tarball" 2>&1 | \
    while IFS= read -d $'\r' -r p; do
        # curl -# emits "######...  N.N%\r"; extract the integer percentage.
        p=$(printf '%s' "$p" | tr -dc '0-9.' | cut -d. -f1)
        # Skip empty values (e.g. redirect notices) and out-of-range integers
        # so they can never flash the bar backwards or show garbage.
        [[ -z "$p" ]] && continue
        (( p > 100 )) && continue
        local scaled=$(( p / 5 ))
        local bar; bar=$(printf "%${scaled}s" | tr ' ' '=')
        printf "\r${DL_COLOR}[ %3d%% ] [ %-20s> ]${NC}" "$p" "$bar"
    done

    if [[ "${PIPESTATUS[0]}" -ne 0 ]]; then
        printf "\n"
        echo -e "${NEONRED}Download failed for $tarball${NC}"
        rm -f "$tarpath"
        return 1
    fi
    printf "\r${DL_COLOR}[ 100%% ] [ %-20s> ]${NC}\n" "===================="
}

# ── Hash Verification ─────────────────────────────────────────────────────────
verify_hash() {
    local tarpath="$1"
    local tarball="$2"
    local expected
    [[ "$COMPILER_TYPE" == "gcc" ]] && expected="${HASHES_GCC[$tarball]}" || expected="${HASHES_CLANG[$tarball]}"
    local actual
    actual=$(sha256sum "$tarpath" | awk '{print $1}')
    if [[ -z "$expected" ]]; then
        echo -e "${NEONRED}CRITICAL: No known hash for $tarball (COMPILER_TYPE=$COMPILER_TYPE)${NC}"
        return 1
    fi
    if [[ "$actual" != "$expected" ]]; then
        echo -e "${NEONRED}CRITICAL: Hash mismatch for $tarball!${NC}"
        echo -e "Expected: $expected\nGot: $actual"
        rm -f "$tarpath"
        return 1
    fi
}

# ── Toolchain Extraction ──────────────────────────────────────────────────────
extract_toolchain() {
    local tarpath="$1"
    local triple="$2"
    local extract_path="$TOOLCHAIN_DIR/$triple"
    if [[ ! -d "$extract_path" ]]; then
        echo -e "${EX_TC_1}==>${EX_TC_2} Extracting toolchain...${NC}"
        mkdir -p "$extract_path"
        tar -xJf "$tarpath" -C "$TOOLCHAIN_DIR" || { echo -e "${NEONRED}Extraction failed!${NC}"; return 1; }
        [[ -d "$extract_path" ]] || { echo -e "${NEONRED}Extraction failed!${NC}"; return 1; }
    else
        echo -e "${EX_TC_3} Toolchain already extracted.${NC}"
    fi
}

# ── Robust Unified Progress Tracker ──────────────────────────────────────────
track_progress() {
    local pid=$1
    local log=$2
    local mode=$3
    local total=${4:-100}
    local color=$5
    local extra=${6:-}

    local current=0
    local pct=0
    local bar_size=20
    local spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local i=0

    # Ensure log exists so grep doesn't error
    touch "$log"

    # Loop while the process is running
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i + 1) % ${#spin[@]} ))

        case "$mode" in
            ninja)
                # Ninja often needs -v to print progress to files
                local last=$(grep -o '\[[0-9]*/[0-9]*\]' "$log" | tail -1)
                if [[ "$last" =~ \[([0-9]+)/([0-9]+)\] ]]; then
                    current=${BASH_REMATCH[1]}
                    total=${BASH_REMATCH[2]}
                fi
                ;;
            cmake)
                local last=$(grep -o '\[[[:space:]]*[0-9]*%\]' "$log" | tail -1)
                if [[ "$last" =~ ([0-9]+)% ]]; then
                    current=${BASH_REMATCH[1]}
                    total=100
                fi
                ;;
            make-files)
                # Extra format: "path:extension" (e.g. "src:*.o")
                local search_dir="${extra%%:*}"
                local pattern="${extra##*:}"
                current=$(find "$search_dir" -name "$pattern" 2>/dev/null | wc -l)
                ;;
            grep-count)
                current=$(grep -c "$extra" "$log" 2>/dev/null || true)
                ;;
        esac

        # If the actual count exceeds the estimate, grow total to match so
        # the display never shows a nonsensical "100% (455/410)".
        (( current > total )) && total=$current

        # Calculate percentage safely
        if (( total > 0 )); then
            pct=$(( current * 100 / total ))
        else
            pct=0
        fi

        [[ $pct -gt 100 ]] && pct=100

        # Draw the bar
        local filled=$(( pct * bar_size / 100 ))
        local empty=$(( bar_size - filled ))
        local bar_str=$(printf "%${filled}s" | tr ' ' '#')
        local space_str=$(printf "%${empty}s")

        # \r moves cursor to start, \e[K clears the line
        # When file-count hits 100% but the process is still alive (e.g.
        # the linker is running after all .o files are written), replace the
        # stale numeric label with "Linking..." so the wait is self-explaining.
        if (( pct >= 100 )); then
            printf "\r${color}%s [ %s ] Linking...${NC}\e[K" \
                "${spin[$i]}" "$bar_str"
        else
            printf "\r${color}%s [ %s%s ] %3d%% (%s/%s)${NC}\e[K" \
                "${spin[$i]}" "$bar_str" "$space_str" "$pct" "$current" "$total"
        fi

        sleep 0.2
    done

    # Final cleanup: Wait for process to get exit code
    wait "$pid"
    local exit_val=$?

    # On success, snap the bar to 100% so it doesn't appear to stall
    # (the last few percent are link/archive steps that don't produce .lo files)
    if [[ $exit_val -eq 0 ]]; then
        local full_bar=$(printf "%${bar_size}s" | tr ' ' '#')
        printf "\r${color}✓ [ %s ] 100%% (%s/%s)${NC}\e[K" "$full_bar" "$total" "$total"
        sleep 0.3
    fi

    # Clear the progress line
    printf "\r\e[K"
    return $exit_val
}

# ── Binary Architecture Verification ─────────────────────────────────────────
# Verify that a built binary's ELF machine type matches the expected target.
# Usage: verify_binary_arch <binary_path> <triple>
# The triple's leading component (aarch64, armv7, x86_64, i686, ...) is mapped
# to its ELF EM_ machine string so mismatches are caught before release.
verify_binary_arch() {
    local bin="$1"
    local triple="$2"
    local readelf_cmd="readelf"
    local cross_readelf="${TOOLCHAIN_DIR}/${triple}/bin/${triple}-readelf"

    if command -v "$cross_readelf" &>/dev/null; then
        readelf_cmd="$cross_readelf"
    elif ! command -v readelf &>/dev/null; then
        echo -e "${SLATE}  (readelf not found — skipping arch verification)${NC}"
        return 0
    fi

    local machine; machine=$("$readelf_cmd" -h "$bin" 2>/dev/null | awk -F: '/Machine/{gsub(/^[[:space:]]+/,"",$2); print $2}')

    local arch="${triple%%-*}"
    local expected
    case "$arch" in
        aarch64)              expected="AArch64" ;;
        armv[5-7]|arm)        expected="ARM" ;;
        x86_64)               expected="Advanced Micro Devices X86-64" ;;
        i[3-6]86)             expected="Intel 80386" ;;
        mips64*)              expected="MIPS R3000" ;;
        mips*)                expected="MIPS R3000" ;;
        riscv64)              expected="RISC-V" ;;
        riscv32)              expected="RISC-V" ;;
        powerpc64le|powerpc64) expected="PowerPC64" ;;
        powerpc*|powerpcle)   expected="PowerPC" ;;
        s390x)                expected="IBM S/390" ;;
        loongarch64)          expected="LoongArch" ;;
        m68k)                 expected="Motorola m68k" ;;
        sh4)                  expected="Renesas / SuperH SH" ;;
        or1k)                 expected="OpenRISC" ;;
        *)
            echo -e "${SLATE}  (no arch mapping for '$arch' — skipping verification)${NC}"
            return 0 ;;
    esac

    if [[ "$machine" == *"$expected"* ]]; then
        echo -e "${NEONGREEN}👌 arch verified:${NC} ${GOLDENROD}$machine${NC}"
    else
        echo -e "${NEONRED} 👎 ARCH MISMATCH for $(basename "$bin")!${NC}"
        echo -e "    Expected machine containing: ${LEMON}$expected${NC}"
        echo -e "    Got:                         ${TOMATO}$machine${NC}"
        return 1
    fi
}

# ── Git Clone ──────────────────────────────────────────────────────────────────
git_clone() {
    if [[ ! -d "$SOURCE_DIR/.git" ]]; then
        echo -e "${GIT_C}==>${GIT_C2} Cloning ${NAME} source...${NC}"
        git clone --branch "$REPO_BRANCH" --recursive --depth 1 "$REPO_URL" "$SOURCE_DIR" > /dev/null 2>&1
    else
        echo -e "${CORAL}🍔 Source code present.${NC}"
        git -C "$SOURCE_DIR" pull origin "$REPO_BRANCH" > /dev/null 2>&1
    fi
}

# ── Final ──────────────────────────────────────────────────────────────────────
final() {
    echo -e "\n${FINAL_C}🎇 All requested architectures are finished!${NC}"
    echo -e "${BWHITE}Final binaries available in:${NC} ${MINT}${OUTPUT_DIR}${NC}"
    ls -F --color=auto "$OUTPUT_DIR"
}
