#!/usr/bin/env bash

# ── Colors ────────────────────────────────────────────────────────────────────
AQUA="\033[38;2;18;254;202m"
BWHITE="\033[1;37m"
CANARY="\033[38;2;255;255;153m"
CARIBBEAN="\033[38;2;0;204;153m"
CHARTREUSE="\033[38;2;127;255;0m"
CORAL="\033[38;2;240;128;128m"
CRIMSON="\033[38;2;220;20;60m"
CYAN="\033[1;36m"
HELIOTROPE="\033[38;2;223;115;255m"
HIGHLIGHTER="\033[38;2;248;255;15m"
HOTPINK="\033[38;2;255;105;180m"
JUNEBUD="\033[38;2;189;218;87m"
LAGOON="\033[38;2;142;235;236m"
LEMON="\033[38;2;255;244;79m"
MAUVE="\033[38;2;224;175;255m"
MINT="\033[38;2;152;255;152m"
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
  [powerpcle-unknown-linux-musl.tar.xz]="a91da053e92fc9e52177cd0ad4fa1dbb9d474f938bb0bdaf37b7d8b310f56468"
  [powerpc64-unknown-linux-musl.tar.xz]="a27fe28428b893364c827fc47e3bd9b0317e2646b341bb428856ee83c63d5b03"
  [powerpc64le-unknown-linux-musl.tar.xz]="c4ad2175484e828c172a0aaa6c9a8a5a455c626d518d8e94fb5194be7d8ddbb4"
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
  [powerpcle-unknown-linux-musl.tar.xz]="7f8bee90d978f2748ce9f0847fe70c81c6a3c95427128acfc46ed9e09a41b574"
  [powerpc64-unknown-linux-musl.tar.xz]="dac21f651f68539c810a2d60132cfd68c7b275830acb4768a0870eae6fe97b63"
  [powerpc64le-unknown-linux-musl.tar.xz]="70da787b820707c3c5950e87a728bb370efea44bfb39683ae2e8843b8d46b2d4"
  [riscv32-unknown-linux-musl.tar.xz]="fad97f0bc0d7104fd023966a1bd21b2a9db097580e1968fccc9a11002cad86bb"
  [riscv64-unknown-linux-musl.tar.xz]="414d17cc86099e89fc1c5d6caf3a6d731d91df4bee48a654b198d72edb3df521"
  [s390x-ibm-linux-musl.tar.xz]="b54ad00e946f10504fc88f60d2efd9853a8a47237da95a48832a38062b405fb5"
  [x86_64-unknown-linux-musl.tar.xz]="62f74a4c082249f736662e35c847f73d9ae1134b2a76bfcdb33829d06fa70c92"
)

JOBS="$(nproc)"
COMPILER_TYPE="clang"
RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/magazine/"
RESUME_MODE=false

# ── Toolchain Download ────────────────────────────────────────────────────────
download_toolchain() {
    local tarpath="$1"
    local tarball="$2"
    if [[ -f "$tarpath" ]]; then
        echo -e "${MINT}✨ Using cached toolchain: $tarball${NC}"
        return 0
    fi
    echo -e "${SLATE}==>${NC} Fetching toolchain: ${AQUA}$tarball${NC}"
    curl -fSL -# --retry 3 --create-dirs -o "$tarpath" "$RELEASE_BASE/$tarball" 2>&1 | \
    while IFS= read -d $'\r' -r p; do
        p=$(echo "$p" | tr -dc '0-9.' | cut -d. -f1)
        : ${p:=0}
        local scaled=$(( p / 10 ))
        local bar=$(printf "%${scaled}s" | tr ' ' '=')
        printf "\r${DL_COLOR}[ %3d%% ] [ %-10s> ]${NC}" "$p" "$bar"
    done
    if [[ "${PIPESTATUS[0]}" -ne 0 ]]; then
        echo -e "\n${TOMATO}Download failed for $tarball${NC}"
        rm -f "$tarpath"
        return 1
    fi
    echo ""
}

# ── Hash Verification ─────────────────────────────────────────────────────────
verify_hash() {
    local tarpath="$1"
    local tarball="$2"
    local expected
    [[ "$COMPILER_TYPE" == "gcc" ]] && expected="${HASHES_GCC[$tarball]}" || expected="${HASHES_CLANG[$tarball]}"
    local actual
    actual=$(sha256sum "$tarpath" | awk '{print $1}')
    if [[ "$actual" != "$expected" ]]; then
        echo -e "${TOMATO}CRITICAL: Hash mismatch for $tarball!${NC}"
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
        echo -e "${SLATE}==>${NC} Extracting toolchain..."
        mkdir -p "$extract_path"
        tar -xJf "$tarpath" -C "$TOOLCHAIN_DIR"
        [[ -d "$extract_path" ]] || { echo -e "${TOMATO}Extraction failed!${NC}"; return 1; }
    else
        echo -e "${MINT}✨ Toolchain already extracted.${NC}"
    fi
}
