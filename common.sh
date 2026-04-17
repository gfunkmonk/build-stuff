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
  [aarch64-unknown-linux-musl.tar.xz]="15e27f2d0a25476cabc2e27e7da1de20f758a88bae6aad88b69514b9e3212d40"
  [aarch64_be-unknown-linux-musl.tar.xz]="794f45e38b6b88bbf51e02e93bb286cfaa742d09d2092b6107bee0a8c5d6ac7f"
  [arm-unknown-linux-musleabi.tar.xz]="9e47088936feca23269c557153d973c7c27b622cdf6ea6bbcadb0879c42edbdd"
  [arm-unknown-linux-musleabihf.tar.xz]="ee25755d3c58341051f8500ea40f50bb317e3e71ae6a396c340884ff7f2ef167"
  [armv5-unknown-linux-musleabi.tar.xz]="12035c452c3a1808b49b915083c2a73e086f12d1dda45d88fd9eddfa1a0bda33"
  [armv6-unknown-linux-musleabi.tar.xz]="860e588996265bc05cbc082f99bd3ccb1ef547843593162f200b6de00bf8532f"
  [armv6-unknown-linux-musleabihf.tar.xz]="2f49eb91641443c025a12827016ae7e992f842d6d095ca67339f41f4ab0226be"
  [armv7-unknown-linux-musleabi.tar.xz]="7de4ef5aedd89e6c2881748b274ae1041e1771555e36738d400ef65867da63ac"
  [armv7-unknown-linux-musleabihf.tar.xz]="ce8112e4f5dab845857b120426e46825ae79dacd4e4a21a6bf43243eebbbf7a6"
  [i386-unknown-linux-musl.tar.xz]="af42051d47b50e1a5e36ebea83f2883bade2f9e8ac693a0794da83eeafbdb58a"
  [i486-unknown-linux-musl.tar.xz]="355d9ea0ffc9aed4a763346296aa5411bba4f0a5da5096d5ca0709d3e07a50cb"
  [i586-unknown-linux-musl.tar.xz]="00ef30bf2ef7c041ca8e58c4dc3d1dcff28a801f4f4d9af0717e9906476b7c8c"
  [i686-unknown-linux-musl.tar.xz]="cc38e3c62e87347343030227b464d442627d0d32484fd92abe39c17a10bc2b13"
  [loongarch64-unknown-linux-musl.tar.xz]="0173a561a64483f63bffbf43ddee43c49f5e5f69d09b1f46803f49e6af89cdb8"
  [m68k-unknown-linux-musl.tar.xz]="214df60ffdca7b8e60d8080c5c63db10ef2027c1a53b6101617692990c271eed"
  [microblaze-xilinx-linux-musl.tar.xz]="4d6a17158e18f977387d6d3e989a2a8e5d98352fc25ceb0e5fad183cedef673b"
  [microblazeel-xilinx-linux-musl.tar.xz]="e85f47dbef9eafbf0495e4282143f83027fb37db59a374d4a6debcd02be87b65"
  [mips-unknown-linux-musl.tar.xz]="6a11d5979cfdbcb7ec33e68d66a36c2534d66a33402bcbcb0010174e5a62b7bb"
  [mips-unknown-linux-muslsf.tar.xz]="33e6c1b3bec769c494c91b12cf4ea0f01767636b507ae625e99ae3758feb153a"
  [mips64-unknown-linux-musl.tar.xz]="67bb664d164e3d3a6be1dd7b44c04e2673c85a75e2b9afe9bb8ecd014e73d20b"
  [mips64el-unknown-linux-musl.tar.xz]="e0f6b14d50a7f16a3e95277bff8db07b392134a4e8c3ce6f4f95a3ba5ba5fb57"
  [mipsel-unknown-linux-musl.tar.xz]="30626b7c9a213c51583f5e95fb4e9014464465098cc796f3c013e55bc884289e"
  [mipsel-unknown-linux-muslsf.tar.xz]="efa971a85d9aa058074a065100997b7e81e535508373df9fd5c75023113a93fc"
  [or1k-unknown-linux-musl.tar.xz]="174d455f91bb2d693e90cb4c104cb3ce5edf28d124822dc274b3f0bf749e05e3"
  [powerpc-unknown-linux-musl.tar.xz]="6160323b4d379a80bd16a5765e4017d9f0ef755b51b26f5f04cd8cd3737e0426"
  [powerpc-unknown-linux-muslsf.tar.xz]="9b6b406cd68972e1c78f453fc708c4b3141c5f642f675e9c15c2c7ac66f88ee5"
  [powerpc64-unknown-linux-musl.tar.xz]="81b7805410f1e72ff6556dae1569300f853ed582a0158f3a9158c8ff6fca4632"
  [powerpc64le-unknown-linux-musl.tar.xz]="c7d3d843520de572eef19380b2ed0514faca1310d87511845c45354345ac07d2"
  [powerpcle-unknown-linux-musl.tar.xz]="c677c8e7fc35fd7d5c97dea5f60ea98658ec0a78f0ed569e95657a71a916aca1"
  [powerpcle-unknown-linux-muslsf.tar.xz]="68f3df532b14ea65eb51328db4cb3a953483871af6be9b74ecbc25aa5ca71cf4"
  [riscv32-unknown-linux-musl.tar.xz]="71b389295c78d7e8fd573f287c9dca8dc4608362962b65ab3f87acfca799ed01"
  [riscv64-unknown-linux-musl.tar.xz]="db627642ef441fd1a857d2005e4b66c6cdc90dbe69988fc9584d40104442b57b"
  [s390x-ibm-linux-musl.tar.xz]="26fde3955125edcafd6ecf3041898e2e4afb4086136e17cdc8b43b173a3e614c"
  [sh4-multilib-linux-musl.tar.xz]="7bed5b3d4e8fd94734ec58ccc347ced05e48fa06bcaa2d517a9798cc7035cb4b"
  [x86_64-unknown-linux-musl.tar.xz]="643f6806591c1b1bda3a25dfa71cd206766dd7b41a0249d19c95eca105f10237"
)

declare -A HASHES_GNU=(
  [aarch64-unknown-linux-gnu.tar.xz]="c8b6f04a2e4a7d4246c3b3d40ed269f0dcdb07b1b79872cdf43dbde43f740dc5"
  [aarch64_be-unknown-linux-gnu.tar.xz]="d24b39f84ca709282920406b0782376d321d9a6205867a39784b384bc9af5c7b"
  [alphaev56-unknown-linux-gnu.tar.xz]="5f8c1f5342e6330d5a6d172a045dcb0569e7ff24327149240005ca1c385c8c67"
  [alphaev67-unknown-linux-gnu.tar.xz]="ef9974ee92b0f34b30535b2fd83f889008694867af48f020b41c05a5d9f8ce07"
  [arm-unknown-linux-gnueabi.tar.xz]="1b6fa4b2252b76914318f602a6689971abb88771440c3bf0fb4eb93fd7b82a7a"
  [arm-unknown-linux-gnueabihf.tar.xz]="5005868b2b395463a6dd7397a9f49bd2a9057e617664ec9bf2da782786ebb1fe"
  [armv4t-unknown-linux-gnueabi.tar.xz]="5597b14084ae606f59b257498c950e9e724c5afa4c3415df2578fa387c5bb9f0"
  [armv5-unknown-linux-gnueabi.tar.xz]="bb843b3002b3d8ccab875164f2e62d8cba15c59ae879a16e279f829d6784da38"
  [armv6-unknown-linux-gnueabi.tar.xz]="0ed0f93bacf51538bea82b014a4ac7d67587359408121b3290b64a053e99e5ca"
  [armv6-unknown-linux-gnueabihf.tar.xz]="f41728b8deeccae6d5ad152ff56d1149297810ead4ecc26c4b5cfd07d2ef460c"
  [armv7-unknown-linux-gnueabi.tar.xz]="9324d44913d226052a1938f246d71697e91fd405dae33832324aaa0edd20a817"
  [armv7-unknown-linux-gnueabihf.tar.xz]="074d96f33fe12def9fd79853dea32dc720fcbd0cefb30fcc6f0c0c44bc16fdb2"
  [hppa-unknown-linux-gnu.tar.xz]="2e15556ceec63410f16c982c3ba67f77be47d60e207992122aac333927c9bdfe"
  [i486-unknown-linux-gnu.tar.xz]="26aa569f7e0e70439824ea079a94b3c3f08702dd926fe9e2ab4e203a3cf2ee41"
  [i586-unknown-linux-gnu.tar.xz]="86fcb328989367ecd8cb1e632d278fd2b5c5cae02ba9d82f0102b522e73a1380"
  [i686-unknown-linux-gnu.tar.xz]="15a651b067be35e38cf3280179809d552b4b68d85f0375f5c998b5e5fe32f8b9"
  [loongarch64-unknown-linux-gnu.tar.xz]="fc0e9229458decc17d54428c2c95143ed05ef1a55ead3fd91065d4795e0ba0b9"
  [m68k-unknown-linux-gnu.tar.xz]="547bba5713767040a717466c768ba72b52cebae7164a69f22649324f2054f1ba"
  [microblaze-xilinx-linux-gnu.tar.xz]="edbf167c325e5b0d00f64aac003346832d3d80ae0fd662446f6a87b47a861ed1"
  [microblazeel-xilinx-linux-gnu.tar.xz]="39fdea34e9a935c1a88ec3753b0b3ba7413ddf46d8caaa7ae4dcdeadf6ba6300"
  [mips-unknown-linux-gnu.tar.xz]="fe8adeb81cae5e29187d1985ed13f06dcc534d3db9883274975d6493b6984154"
  [mips-unknown-linux-gnusf.tar.xz]="1758041e3f99e4316d3fe3f36e9193513c22a3a8a35fafa1e44dce9d0e1c4fbb"
  [mips64-unknown-linux-gnu.tar.xz]="7cffe24c01ee040c047819e1bf7f5717841630929fe3a5632ae3dcf5692b7807"
  [mips64el-unknown-linux-gnu.tar.xz]="a9ba2af253841e228538be4fe1b202ddcee947c37bf7087d28e292fd00d75e7b"
  [mipsel-unknown-linux-gnu.tar.xz]="2854f7939ccf1065591dae76e5871beedebac09f42d7f52ac00f2057e6d4cfb8"
  [mipsel-unknown-linux-gnusf.tar.xz]="6c139cf6877552c3e16059a37b54d86b3ddacbc84f674a41280024d145f5a532"
  [or1k-unknown-linux-gnu.tar.xz]="e41ffcde2731f2addaa0e6f72a840c50e207e65e8df6b3ece371f9e40ed670c8"
  [powerpc-unknown-linux-gnu.tar.xz]="0688c26facad19b64685f57462e95237f406cb68a7138eec13ea51a906f85260"
  [powerpc-unknown-linux-gnusf.tar.xz]="10e2e481dba188e9325a03d041543e83f7879c5355eea966a73a690dc2418f1b"
  [powerpc64-unknown-linux-gnu.tar.xz]="16e80ff7f32cd18011fd25b4fb48c046466c89a64aed46abf3a3ba970fe8d2cc"
  [powerpc64le-unknown-linux-gnu.tar.xz]="52b2044b6ba850742e4291e927688297d71596cf446d1d68a6511b987f676c51"
  [powerpcle-unknown-linux-gnu.tar.xz]="d971748bf4f41f8da63c479995d4ea8d2c049ac3da19aa006e6a851445e001b0"
  [powerpcle-unknown-linux-gnusf.tar.xz]="64a630f3345f9a867ba14781bb463e869a22d352e5d3b5191ffc4c85bba218b7"
  [riscv32-unknown-linux-gnu.tar.xz]="8f53d51cc36db84660cf2add1f15df40eca51bc93ef80558fe04ba3186fb0889"
  [riscv64-unknown-linux-gnu.tar.xz]="f1a221a576f3255d960a8c75d7a11127830a7e32fe98bee6ac4c3f449a03f2bf"
  [s390-ibm-linux-gnu.tar.xz]="030ea43f6065123342c42473bfca1eb1eaba198e53f80ebf6acfcb6db714874d"
  [s390x-ibm-linux-gnu.tar.xz]="e4cad763754eac88a1444e5b7534074b711338d0a711831027f830133fa99675"
  [sh4-multilib-linux-gnu.tar.xz]="0de1eb6133acf526b2952bf92b09f8fe58aecfda43a085c73b061aca0ee4989f"
  [sparc-unknown-linux-gnu.tar.xz]="57e6b172d9cc52c7b15982dd6470f7e3871178434eb95d178c5aa49da57a23cd"
  [sparc64-unknown-linux-gnu.tar.xz]="85d43ac47047272da99af89a94d2203d0aaea618cddb6cf4f67f481a56faca04"
  [x86_64-unknown-linux-gnu.tar.xz]="4c6b4ad5652e8fc2044800df1d0c261ec93655c31c98a5f03f83d47b3f670f10"
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
COMPILER_BIN="gcc"
OUTPUT_DIR="$(pwd)/output/${NAME}/${COMPILER_TYPE}"
JOBS="$(nproc)"
RESUME_MODE=false
USER_ARCHS=""
CFLAGS="-Os"
CXXFLAGS="-Os"

# ── Toolchain Release URLs ────────────────────────────────────────────────────
GCC_RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/farmer"
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/garlicbread"
GNU_RELEASE_BASE="https://github.com/gfunkmonk/gnu-cross/releases/download/twolittleendian"
RELEASE_BASE="$GCC_RELEASE_BASE"

# ── Common Helpers ────────────────────────────────────────────────────────────

# Set compiler type and matching release base URL.
# Usage: set_compiler gcc|clang|gnu
set_compiler() {
    COMPILER_TYPE="$1"
    if [[ "$COMPILER_TYPE" == "gcc" ]]; then
        RELEASE_BASE="$GCC_RELEASE_BASE"
        COMPILER_BIN="gcc"
    elif [[ "$COMPILER_TYPE" == "gnu" ]]; then
        RELEASE_BASE="$GNU_RELEASE_BASE"
        COMPILER_BIN="gcc"
    else
        RELEASE_BASE="$CLANG_RELEASE_BASE"
        COMPILER_BIN="clang"
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
        --gnu)       set_compiler gnu;   COMMON_SHIFT=1; return 0 ;;
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
    if [[ "$COMPILER_TYPE" == "gcc" ]]; then
        expected="${HASHES_GCC[$tarball]}"
    elif [[ "$COMPILER_TYPE" == "gnu" ]]; then
        expected="${HASHES_GNU[$tarball]}"
    else
        expected="${HASHES_CLANG[$tarball]}"
    fi
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
        sparc)		expected="Sparc v8" ;;
        sparc64)              expected="Sparc v9" ;;
        hppa)                 expected="HPPA" ;;
        alpha*)               expected="Alpha" ;;
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
