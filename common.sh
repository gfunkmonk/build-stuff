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
  [aarch64-unknown-linux-musl.tar.xz]="0b9ecd578e2538b5047e7de44bfd2d164cd8b4687870d7cbac4e90fdf29b7ecc"
  [arm-unknown-linux-musleabi.tar.xz]="04bf00df61351b6102592c69f981ba41064a19c11eea1f9a18ac1b43068b6871"
  [arm-unknown-linux-musleabihf.tar.xz]="4d3d6d8cc86f08dacdd75838a6322ec69a036956d570da681092b4926918ca81"
  [armv5-unknown-linux-musleabi.tar.xz]="d9a4d5d6e4907f3196aa531d6c9d1e3be89ef51be50d2eb2b7810382a3342763"
  [armv6-unknown-linux-musleabi.tar.xz]="f3892b86e50e0d969944cfb6f7aecdedee9a8eb798fbbbd38cbd425ad7d0a737"
  [armv6-unknown-linux-musleabihf.tar.xz]="ff71c2d5fb9183dbdd1da02db8e8a5ca401a307343be5891879e6e85b88ce55b"
  [armv7-unknown-linux-musleabi.tar.xz]="7049c46208c83c0728966b851fd92562b78ba6d4c3ace1591d63d44c48fd3423"
  [armv7-unknown-linux-musleabihf.tar.xz]="9ce5fc36823e6afba84bbf03d38386fc5cb5fe4aac8d8e29ec4eb73e3cd0d510"
  [i386-unknown-linux-musl.tar.xz]="4d73425691f88c0c9532bc9d1474810057f1a6068c3fe68b0a83ac4fae7bf032"
  [i486-unknown-linux-musl.tar.xz]="9b1cc8f29860ce3f503ae0b2a03bac795ba1b89265d56929a7354b16bd75792d"
  [i586-unknown-linux-musl.tar.xz]="b3673d2640621a0eaa981aecede129b959ca65e941b9bbd940ce8bcfedc1fee3"
  [i686-unknown-linux-musl.tar.xz]="b9dd404ade35646fc58d98724a831bbfd43b512b4b71c8a3638d2876381bf322"
  [loongarch64-unknown-linux-musl.tar.xz]="fcf67054120250e9e6481fed5c869e2c329fdfaab285dcf67aede294bcd1c203"
  [m68k-unknown-linux-musl.tar.xz]="6511ea3ed96b2bdac9b0d65f3c428a2a9e5e718722a8c1ef1f905223b7f55afd"
  [mips-unknown-linux-musl.tar.xz]="0abca3d40b94501d92b18a2031c50412635d748b4439c7c88bfa87c957a9718a"
  [mips-unknown-linux-muslsf.tar.xz]="b24478381277bac6bd1763470b0b29b6716482ee8f791c8271d84320fd13ce03"
  [mips64-unknown-linux-musl.tar.xz]="3eebae5ca062830c01c31dfe32012c6a79cdf1dec9d743572a3dbbd12bb7a5b1"
  [mips64el-unknown-linux-musl.tar.xz]="9f37997c07de47a99bc17b77da2a143ac167a5c29b1168d267ba7cac1d338bcd"
  [mipsel-unknown-linux-musl.tar.xz]="2627f345e3c1a092f53beebf51b181833244b56f6949e56c379b7fe7ed8b99c7"
  [mipsel-unknown-linux-muslsf.tar.xz]="bb212004458f5a50334f5e3ea26e346b00cbe9e97bd02aa8e89ee4ee98b6048f"
  [or1k-unknown-linux-musl.tar.xz]="958f62de335f38c91cfef5ad88be741e506d278f7591a3a7ee5af8626bd7ab16"
  [powerpc-unknown-linux-musl.tar.xz]="d3457b943c1e055af70f30a7356cdc456504ae8b063bf939fe193a433145d8ae"
  [powerpc-unknown-linux-muslsf.tar.xz]="2ffbc54228064131bb78d9940d7bbda50ccc679d430c8b691809affe4ddd808e"
  [powerpc64-unknown-linux-musl.tar.xz]="1b70f3ee87a8ebbab32a9d080c086c00e34c44785a4af5c07086216ca4580b10"
  [powerpc64le-unknown-linux-musl.tar.xz]="67000db161ccca16cb10fa0d28a9d29125e9871d4765d3d37db03b1b3275c839"
  [powerpcle-unknown-linux-musl.tar.xz]="c5cdfe7136df22ac325e6edee1e41a5ffd98cc926188ac95a3336d14d52243cf"
  [powerpcle-unknown-linux-muslsf.tar.xz]="8bc3cf1b56a4d3531616ea1e456b33086c1d769c962e22c638f99978c23ecf04"
  [riscv32-unknown-linux-musl.tar.xz]="5ba6e8ba96c7eef03ce8467c6a1ec00d5ccdd8fbe8fb083fd77223008592c409"
  [riscv64-unknown-linux-musl.tar.xz]="442ad49562cf6df61b6878eb93b20dafa37690209552a20a882680032a1439b8"
  [s390x-ibm-linux-musl.tar.xz]="e6884507414b111b78ac2acab1ba13a2a03a907e045d390699544ce951b6a160"
  [sh4-multilib-linux-musl.tar.xz]="9e17d05fd59e44f452e61967a2857589a370b7b62139109f9ee3ea57994bb699"
  [x86_64-unknown-linux-musl.tar.xz]="0f4d142b032a9ae348cb909235e226b3eb18a3729fb840d898154748729be4a6"
)

NAME=$(basename "$0" | cut -d'-' -f2 | cut -d'.' -f1)
ROOT_DIR="$(pwd)/build/${NAME}"
SOURCE_DIR="$ROOT_DIR/${NAME}-src"
BUILD_BASE="$ROOT_DIR/build"
COMPILER_TYPE="clang"
OUTPUT_DIR="$(pwd)/output/${NAME}/${COMPILER_TYPE}"
JOBS="$(nproc)"
RESUME_MODE=false
USER_ARCHS=""
CFLAGS="-Os"
CXXFLAGS="-Os"

# ── Toolchain Release URLs ────────────────────────────────────────────────────
GCC_RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/ladder"
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/pasta"
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
