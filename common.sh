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
  [aarch64-unknown-linux-musl.tar.xz]="5dd03719e91e295d0bc32287e54107d1b74c82a2f9f19ec041949eb84e4b0a89"
  [arm-unknown-linux-musleabi.tar.xz]="26eef71bb21a1098fce0e9d418f4a784a4117da359ab354a7fd9ef2c506f8e52"
  [arm-unknown-linux-musleabihf.tar.xz]="70ba032a2281b00ea739888899774a339a6b4ca25416b0fa5aa972a4b0b107d0"
  [armv5-unknown-linux-musleabi.tar.xz]="84ef4547c154cea71cec542c9ec811d68adfbdf73c14499bd5ffc633aca96e45"
  [armv6-unknown-linux-musleabi.tar.xz]="2e3392e87cc81c9604a62251bcd04211994e8c91659b37e83715249a4fcad700"
  [armv6-unknown-linux-musleabihf.tar.xz]="3a5e6d1cf98166bd8a416b55276f71ba7e245cc37780266ec156e5e438038a6a"
  [armv7-unknown-linux-musleabi.tar.xz]="0e17049074d3880d3f5a38767364d9a513f55ef808a65c3bcdfcdbadfe6fd10d"
  [armv7-unknown-linux-musleabihf.tar.xz]="e9a991d7e6bf228bc297c3eeba8b45c3fdf4a95df5e170f624ab54a4310a9d28"
  [i386-unknown-linux-musl.tar.xz]="2c87c16badfe02e3cc6ef00e2d2f0b8247cebda502d9078cfa88d8f1a4a909a1"
  [i486-unknown-linux-musl.tar.xz]="42bc52e3b618508d2f253a4f2f1e3a420bbd49b69c38659470fa8447a698fa8f"
  [i586-unknown-linux-musl.tar.xz]="1855883aca18e35f010c57e4031196b944c9ed0d980b032e8a9407dcdc2d4cf5"
  [i686-unknown-linux-musl.tar.xz]="45c9763c0c03e284b0577e2b5881c13813803a1e985b705a3a1a5200c4efaeb8"
  [loongarch64-unknown-linux-musl.tar.xz]="952b951add8ac0e91aac172ba02db155d7055d4d6c7e64118d41004b3c05c5a1"
  [m68k-unknown-linux-musl.tar.xz]="b21f1af4f99297792e95f4e94b739d20a630a0184baf336822d0ec59606990d2"
  [microblaze-xilinx-linux-musl.tar.xz]="5cff30910175f44c88e3732fb42f067e84826f6cca825899d820c875168bfd20"
  [microblazeel-xilinx-linux-musl.tar.xz]="5a16df385476cffc9bbcb5d8ba2ad6d9aa0a4d05e4ba83af1fe7d1abad20d04b"
  [mips-unknown-linux-musl.tar.xz]="9d49118d404c390927fe4acd78413657f3e22cc0aa495b67a497f52387086fd2"
  [mips-unknown-linux-muslsf.tar.xz]="b4228f859ba1df8c34fca53e31783f26f2870658da350a06805a20dc5a73509c"
  [mips64-unknown-linux-musl.tar.xz]="5d798135cc8f43eb44dece1717ae20b6d2578f83f3a4975e72967dabf5cd1d28"
  [mips64el-unknown-linux-musl.tar.xz]="106705cb8c10a5a1afd1b5ce75f22494341e1172a68e2687ceb3ea22ffd3555c"
  [mipsel-unknown-linux-musl.tar.xz]="b23ab5083f2e80bbe3bfdb13888910af21e5b74d5257ceb5ea61ad004e7030cc"
  [mipsel-unknown-linux-muslsf.tar.xz]="0a9499a371a718b976e29b28ffc2e2d5425470d21c0e2e980f50b917cf2e29b0"
  [or1k-unknown-linux-musl.tar.xz]="2be061a5bc17164e6bffe96de3a0cb96f638a9b3dbfa0434129dde1e53a4135f"
  [powerpc-unknown-linux-musl.tar.xz]="48cf0e85a029a14c9a73e5912d581edf81c3bce795b83771ad4760c71a4a5423"
  [powerpc-unknown-linux-muslsf.tar.xz]="19a1d2123fe24c1f8c2a328bcfa005c87363a1f4108063ab0e9b2f07d4ee3b55"
  [powerpc64-unknown-linux-musl.tar.xz]="a27fe28428b893364c827fc47e3bd9b0317e2646b341bb428856ee83c63d5b03"
  [powerpc64le-unknown-linux-musl.tar.xz]="c4ad2175484e828c172a0aaa6c9a8a5a455c626d518d8e94fb5194be7d8ddbb4"
  [powerpcle-unknown-linux-musl.tar.xz]="a91da053e92fc9e52177cd0ad4fa1dbb9d474f938bb0bdaf37b7d8b310f56468"
  [powerpcle-unknown-linux-muslsf.tar.xz]="603186323abbabd0c4ea866ab37c78e52c1b2594d898c5f2fe4fc292c67e4200"
  [riscv32-unknown-linux-musl.tar.xz]="a74dfd819bf0ba9abba199121a8bf4520fc29d2fb68b2a89ceec358ae87042c1"
  [riscv64-unknown-linux-musl.tar.xz]="26af8e85adc4ca71b4207b03afbab1da9910c3955a216ed38c81830db9a1b2d2"
  [s390x-ibm-linux-musl.tar.xz]="6732c687f32b85d2a35b85b0714f8a3d8c29919b502a982a2eb69ecdf22fea44"
  [sh4-multilib-linux-musl.tar.xz]="20ddf27b08aa5b386d714e83b8b1a3d1f4e3d50d82a873d59b4727c49e8c3be7"
  [x86_64-unknown-linux-musl.tar.xz]="188e16cf5823386e6efa734c23de0455149fa0355e46a761b2cd189a9f25f989"
)

declare -A HASHES_CLANG=(
  [aarch64-unknown-linux-musl.tar.xz]="387c6618160ce6221fdaa97eb7fa81eff720cafddf1fd9d130db5dab824a60a4"
  [arm-unknown-linux-musleabi.tar.xz]="e2a9461334db1bcde0914c744d4745b8d6ca1520feeaf446ae50790bdc2bb767"
  [arm-unknown-linux-musleabihf.tar.xz]="7962de828db3ca9abf56d25e125e51413d7b951fd54ad63c62bff5f992fb7f3e"
  [armv7-unknown-linux-musleabi.tar.xz]="54505ae420c7a0a9f8cff5e17e6555c8187c237ba6ef550901d8518874ac4e46"
  [armv7-unknown-linux-musleabihf.tar.xz]="c8fb494429ef1c44fd8fba4ca70ae2fcfd524f6e2b1e5e215f82e8ac81136462"
  [i586-unknown-linux-musl.tar.xz]="6ed7f64cfeab2ba6d05750cb370bc1884936225d00dd677dbc89a2db8da773f9"
  [i686-unknown-linux-musl.tar.xz]="5b9a73cf76b0a7fdddec664691101bbd7c9b8c44cbc1cad41e8d1ecafa71705b"
  [loongarch64-unknown-linux-musl.tar.xz]="0cd8e618e5929d78683b3c151ccae3ced214c12f178c66cc34cd5fc156f61e27"
  [m68k-unknown-linux-musl.tar.xz]="b160424cc068add4b0923fe81159448a83fc95ac03ab8c7ef8b64e6bf77ed724"
  [mips-unknown-linux-musl.tar.xz]="326bf12ca131001c98c3bb698c84b2a16248602da8dccf3e3a24dd5fdd42bae7"
  [mips-unknown-linux-muslsf.tar.xz]="e3641771e1f91bb4ff0eabb9b552f0dd11f0d5805b779c8f82ea16c7d17ec593"
  [mips64-unknown-linux-musl.tar.xz]="db68a8d13c14a9fa12542b53ec3280fe2de094ead8254547f8ca787c2d83390e"
  [mips64el-unknown-linux-musl.tar.xz]="b820a449c3d0b2376a4046ec4ac4169f668e741e96a08abe752d2e926ee8ee26"
  [mipsel-unknown-linux-musl.tar.xz]="7fed57d706a818d66b3ff03be6d9ec3090772a3cba386a3afb1bde61a8bc103b"
  [mipsel-unknown-linux-muslsf.tar.xz]="2ad9a2f7eb5918c573f5ed66a95d068ae09a6b5783e078c0cc960b1c053dc915"
  [powerpc-unknown-linux-musl.tar.xz]="ca5f890b00d4bcfea18a9d86a41b062869730bd391fd8e9e07b29f3823e6ca0c"
  [powerpc64-unknown-linux-musl.tar.xz]="2e45a083713088120d370894eb1fde7472cc01f29ce72b99bdbb2eda4d9e87b8"
  [powerpc64le-unknown-linux-musl.tar.xz]="52114c0639c73b10ff887787a2f08a37d9ed674eb82717d31c9e3b7131e7cccb"
  [powerpcle-unknown-linux-musl.tar.xz]="344c523fd96e6d1874181b40aeab85b6e6a3e955b0fe8ebd6c5ef454a022a990"
  [riscv32-unknown-linux-musl.tar.xz]="0c2f64fed77d0033f2dfcbf60fb6cafbef6e05ea8a135a52edd96cac68484a52"
  [riscv64-unknown-linux-musl.tar.xz]="3d28e8b31947a9bc47ee9525e23b275d834f907c454c9bdfdcd79778dc280850"
  [s390x-ibm-linux-musl.tar.xz]="2d04b1cb55fb06e7ef5c69ec96f052ee8ca93addbd3a9f82be8930a9c6d9b92c"
  [x86_64-unknown-linux-musl.tar.xz]="2893a4f95b6c106e98a00debfb15cfef832b996dfc6e1d7646100e8760157a07"
)

NAME=$(basename "$0" | cut -d'-' -f2 | cut -d'.' -f1)
ROOT_DIR="$(pwd)/${NAME}-build"
SOURCE_DIR="$ROOT_DIR/${NAME}-src"
BUILD_BASE="$ROOT_DIR/build"
OUTPUT_DIR="$ROOT_DIR/output"
JOBS="$(nproc)"
COMPILER_TYPE="clang"
RESUME_MODE=false
USER_ARCHS=""
CFLAGS="-Os"
CXXFLAGS="-Os"

# ── Toolchain Release URLs ────────────────────────────────────────────────────
GCC_RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/carhartcoat"
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/television"
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
        printf "\r${color}%s [ %s%s ] %3d%% (%s/%s)${NC}\e[K" \
            "${spin[$i]}" "$bar_str" "$space_str" "$pct" "$current" "$total"

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
    echo -e "${BWHITE}Final binaries available in:${NC} ${MINT}${NAME}-build/output${NC}"
    ls -F --color=auto "$OUTPUT_DIR"
}
