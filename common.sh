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
  [aarch64-unknown-linux-musl.tar.xz]="d01e3c2d2be7c8361346540698d95deefe01afd1858b6e27a050f95b8c9423cb"
  [arm-unknown-linux-musleabi.tar.xz]="06d858148d8a62c0311409fbc57d376758b560b6c2162b031bfb43f1cdb644c2"
  [arm-unknown-linux-musleabihf.tar.xz]="0b47ad8400952036c552ad3e62c8e0c5e551921c5c047869c342ffc2f4e221d6"
  [armv5-unknown-linux-musleabi.tar.xz]="28b9c69e195c7ab37f1a21a15782679dae4daf83fb8e4e7ad584e0255eec9a77"
  [armv6-unknown-linux-musleabi.tar.xz]="50fbfafda19f7abaccd9621cdf9b3e5dcfd7c805b8151af28ad84a7259fbdbb7"
  [armv6-unknown-linux-musleabihf.tar.xz]="116f5579b6856e667540fad0236eaebfe7be3c3a10b31445709b447634fc7f95"
  [armv7-unknown-linux-musleabi.tar.xz]="a7d4b920f52cbe060952aee3dfe8e20a6e86267df285881940a1c74fcc1c3486"
  [armv7-unknown-linux-musleabihf.tar.xz]="f0e5bb91326979d3107e636063126b19ffa2e6624321f07f71aadd0e16883b2b"
  [i386-unknown-linux-musl.tar.xz]="3f1b573d71146b3e9f5e7f4e8ada68734f925c76b9fae79887dbfaa7d86fe7f4"
  [i486-unknown-linux-musl.tar.xz]="368d54f7218e698c5ef0b7b4ff4cdfc36388ca4bb5fb93988588f1c9ea8685e0"
  [i586-unknown-linux-musl.tar.xz]="3c086421af61aa083f3fb6fec1fba6253f447b0365de2fbdd7b8cc44a5d7d2fc"
  [i686-unknown-linux-musl.tar.xz]="4af65ce50847d1a655e1e977fdcfb5fba2f499e4facc05c7ac33224da8d38c94"
  [loongarch64-unknown-linux-musl.tar.xz]="bf052b508a25d8be15207666cb50a75f8daecd69507c999fc37c03d013a2dfd9"
  [m68k-unknown-linux-musl.tar.xz]="8c4c1e22bee18c7efc1919ea289cefdfc73925eb5a48755da51d2d157675db12"
  [mips-unknown-linux-musl.tar.xz]="709b512a2f3f6f55ca008e3fa22952966f5e35364f552bfe8970edb7c5f6411b"
  [mips-unknown-linux-muslsf.tar.xz]="f88259c7d40f78d77842fa75d58464e3d34da3e8b633c6be2859942c1c6a6907"
  [mips64-unknown-linux-musl.tar.xz]="53a59fdd610ea5906a258841bd867117e6c81af9ade04f7cda1527d665e3fb3c"
  [mips64el-unknown-linux-musl.tar.xz]="2385a0be0ee9d3b3f6ea46083a3141de377546cb99c2b2dae736eb0a1a3026ca"
  [mipsel-unknown-linux-musl.tar.xz]="15acd0fe3b38852530f240c6abc238837f6358d6efb40aafa5533c644735ae62"
  [mipsel-unknown-linux-muslsf.tar.xz]="8fae58ebe42f4b12985ba5d3f0165073f0dba5343a2fb12a50c28f5bf71362b4"
  [or1k-unknown-linux-musl.tar.xz]="13404705b13ea946dfff9cbc61d384b3c9334f7491cf252c42278e26edd009b3"
  [powerpc-unknown-linux-musl.tar.xz]="b498b2393789a5f8b4a3f4fac8fea4e737bd48fd0cc29b5a20ec98f9e39ac383"
  [powerpc-unknown-linux-muslsf.tar.xz]="970ad45fd476be86b373d1d1deb33dba43b98407361859a99a705a020a7eb9e0"
  [powerpc64-unknown-linux-musl.tar.xz]="f879fca984b4e00c80f43e46d5f745c59da7e543c7440f03a472bb83096f1ee8"
  [powerpc64le-unknown-linux-musl.tar.xz]="cf27b7f472bea5be07ca2e4e2703a8a4930a122b30a92da8302735ebc59173cb"
  [powerpcle-unknown-linux-musl.tar.xz]="16c75fbd663cd6209392b0e17219e832843c669e25cb9c34b03b10f7606bffbc"
  [powerpcle-unknown-linux-muslsf.tar.xz]="641ebed230d0c5c638b3f565f3a2daf16ae66ed7565d32104dcb2f3e7ca50899"
  [riscv32-unknown-linux-musl.tar.xz]="f6ab9d268170104b46913b32ae0b46b53b7016764783ca67599cc66567d15e36"
  [riscv64-unknown-linux-musl.tar.xz]="4ea585cae4e3c5814d4077662e48c43021bbb81d01d7131eabddf90744489ee6"
  [s390x-ibm-linux-musl.tar.xz]="40a79c1f2a883dcb19ab38d943470e50dab7ac8c901ec8663fb7f6b6c234eb50"
  [sh4-multilib-linux-musl.tar.xz]="6f875b42bbec0b04643dbc2d0b532d7e8246dc4432b47f637c9418c87212d3f6"
  [x86_64-unknown-linux-musl.tar.xz]="05e652aa8ff513662413d3d15220153d334aba76285936aa5ddb84cb2a7fbd6f"
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
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/teste"
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
        echo -e "${NEONGREEN}  ✓ arch verified:${NC} ${GOLDENROD}$machine${NC}"
    else
        echo -e "${NEONRED}  ✗ ARCH MISMATCH for $(basename "$bin")!${NC}"
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
        echo -e "${CORAL}✨ Source code present.${NC}"
        git -C "$SOURCE_DIR" pull origin "$REPO_BRANCH" > /dev/null 2>&1
    fi
}

# ── Final ──────────────────────────────────────────────────────────────────────
final() {
    echo -e "\n${FINAL_C}🎊 All requested architectures are finished!${NC}"
    echo -e "${BWHITE}Final binaries available in:${NC} ${MINT}${OUTPUT_DIR}${NC}"
    ls -F --color=auto "$OUTPUT_DIR"
}
