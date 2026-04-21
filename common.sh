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
  [aarch64-unknown-linux-musl.tar.xz]="51de49f7ead5a20939a31b9c5299eb56cb0f3c4da0e9010fae29155a6892173c"
  [aarch64_be-unknown-linux-musl.tar.xz]="920022973cc7fe4c8f894b44781fce7e3c4e0edbc2ff82508a36925ac2b43435"
  [arm-unknown-linux-musleabi.tar.xz]="8d8eb391ec6084ba1b84595542cfa484a5221b1c1ed98b13fe94570073d62a58"
  [arm-unknown-linux-musleabihf.tar.xz]="6cbba664f25908fcb8afb36a26686d28a76d1ef658b25da2a1c1632d0f746e18"
  [armv5-unknown-linux-musleabi.tar.xz]="b08e83d7e8d591b9b7782f4ef829306610c37e5977ad64480c6b87efa053d046"
  [armv6-unknown-linux-musleabi.tar.xz]="37bcd46a39fde619095c2fd0cbb47875b51ec22bfda89b8686f733be0efb2109"
  [armv6-unknown-linux-musleabihf.tar.xz]="26ff1d5e4dd202b87ac7e4b754d7ac2e3eb908980906b353848630a30d3ecef0"
  [armv7-unknown-linux-musleabi.tar.xz]="e8f36ac987ed2d324346466951dde6e4b48d3a106726170d7c7759251abe845b"
  [armv7-unknown-linux-musleabihf.tar.xz]="d7008d112684481d32ecc4fce5d6270ac8bf92def9e4320d1d1efcecd3dc001a"
  [i386-unknown-linux-musl.tar.xz]="46f8933b33e9227247f73908416960cb6ce7c906e342bc5bc621258c92bc51ae"
  [i486-unknown-linux-musl.tar.xz]="fdc1b25b865c5751a31aba4255a75950dc0255a5609d34d87e7e7d87a1929004"
  [i586-unknown-linux-musl.tar.xz]="be0895ba1ffb4e9908c27daefa1754277023e4ecd59b39c4ef8b88f22a8b5cf3"
  [i686-unknown-linux-musl.tar.xz]="ff3efbaeca9c194b33ebdc3ad71ad43abf834d4155b2e79fff86ae8fd7b1350b"
  [loongarch64-unknown-linux-musl.tar.xz]="dbec1b6054dbbeb967c2f6a11aa92088b5a8ce73f8ea9da66a9833f56494a05e"
  [m68k-unknown-linux-musl.tar.xz]="ddc2555ab2f3a7c984c9fad842e6558d721b79f328505ee3cef4874b58a94437"
  [microblaze-xilinx-linux-musl.tar.xz]="b6997f0f55eb141c489de0e8457f9b0b5f029c8722d457d5d8f12bbd49454073"
  [microblazeel-xilinx-linux-musl.tar.xz]="f3077e060de395c082029f996075f36169a9d5ca3b36b0ea777798a9f7baf372"
  [mips-unknown-linux-musl.tar.xz]="87e16dc989b49ce943e6d22f133ae08d779b2566d38bc271a01fb5587ad89d47"
  [mips-unknown-linux-muslsf.tar.xz]="95ebf203dee73526adbda98d526d2fa19271a8f19c31bdfc2a992c727f5789d6"
  [mips64-unknown-linux-musl.tar.xz]="e18f39b84d276e1fc4889020c303511430986e01374cf7003c9a6fa89e62d8ee"
  [mips64el-unknown-linux-musl.tar.xz]="40785c155a932602d1eac31f98fb08da55b6fffa0cc1a58860b99ac3d72ce9a7"
  [mipsel-unknown-linux-musl.tar.xz]="3df51860167f8192d21620b744b239e973eb131fc93a736a1d7b48980dccdfcf"
  [mipsel-unknown-linux-muslsf.tar.xz]="ff45fad45591090fdeb64ec43333714f58011c7cdfb397b28d4ed21f8c5d6216"
  [or1k-unknown-linux-musl.tar.xz]="ce52e1da89aedeafd67027b56a1dc2c8c2568d3d6b2c102292b1201e91ad4174"
  [powerpc-unknown-linux-musl.tar.xz]="833147ac1ea37537f5715a319cfd3bf998489c417472abf64f931535374473e5"
  [powerpc-unknown-linux-muslsf.tar.xz]="e5f3a525570f4b80e169a1e63259e02df95ecfd92b1335b86f2dcccd6d69bc98"
  [powerpc64-unknown-linux-musl.tar.xz]="d5933e847c5f12b183f0c3eb4977a5a7a9bc05debcd043ec9afab7effe73ba11"
  [powerpc64le-unknown-linux-musl.tar.xz]="1894708659605b0dc8dc65c971f87e8c4ec806488547ba8c464ed50d72178acc"
  [powerpcle-unknown-linux-musl.tar.xz]="3270e4d4d45f0c9ca6ca865b6e45ce6a48e6f7d1a31d3cde8888539716944ad8"
  [powerpcle-unknown-linux-muslsf.tar.xz]="51ceedf88ef439982e9a141d3deba2a9382c4e497034a08ab1f4a770d6a5a2b5"
  [riscv32-unknown-linux-musl.tar.xz]="de63a94b33c69a45c0a16969a98ca08566d43dbb45fd6dfce9a63be585ad6179"
  [riscv64-unknown-linux-musl.tar.xz]="8a20d7848b885afbed7562e8bccdf0e96042f9fd101c19bfa7a141fb8f6c4717"
  [s390x-ibm-linux-musl.tar.xz]="32f36d5d9837218c4f9e8fde8dfcf49235bcbf029c1ce7409e4b1c8ec8cdabb7"
  [sh4-multilib-linux-musl.tar.xz]="08267f7222f7d65936a11cdf9c2d8479fd77c827565ba83aa77fa7462704cc91"
  [x86_64-unknown-linux-musl.tar.xz]="7a77b626fce413257cabf54044c421f4b1d595a1c5fbcd38becd73a8b91be1c8"
)

declare -A HASHES_GNU=(
  [aarch64-unknown-linux-gnu.tar.xz]="921ae82fa18b99d7a5bf455ba426ea0435bdd6a506d556bf2204cfd45eb93609"
  [aarch64_be-unknown-linux-gnu.tar.xz]="abf94b1f30d6a8af95d72bc1271246c4bac5205aeca24d1aa1a3cfc80fe48314"
  [alphaev56-unknown-linux-gnu.tar.xz]="9803f5d9eb7c8ebefe1472366f4bfbbfbbae992bacdc1749b8f5b9d99a615478"
  [alphaev67-unknown-linux-gnu.tar.xz]="4a85a7a267d993beb70bc41196b0959ece1fe99e0452abc8d7df3cdeeb2365f1"
  [arm-unknown-linux-gnueabi.tar.xz]="7ad2cf92b4a9de2059e3ab08de08b9380548c4e8c6d03d38dc303fcb5b28b009"
  [arm-unknown-linux-gnueabihf.tar.xz]="56c6a8852b02523ca42f38d83873e17af75c7d8cfd24146b2d7f98a9f30d958e"
  [armv4t-unknown-linux-gnueabi.tar.xz]="4218d01a30930e350e331d0a08fb23c3d0aeb0652eaeecc83af431eb73475c53"
  [armv5-unknown-linux-gnueabi.tar.xz]="e47fd2ab61c7a0bfe5449c71e759a7af7fa2373d01df8d48b0377eaecd8bf33d"
  [armv6-unknown-linux-gnueabi.tar.xz]="7987aa6d7afe4ce8b58288972f946d14e3e63669253f477ec6ccdc7abcebb241"
  [armv6-unknown-linux-gnueabihf.tar.xz]="95ccd3f6db8c2a3deeb921017ca831e2188160901ff8d480a1e34ca7f66456c8"
  [armv7-unknown-linux-gnueabi.tar.xz]="77da7ed3900fd5889336a19ac5776a0092002061b18ee74004c60321412a6351"
  [armv7-unknown-linux-gnueabihf.tar.xz]="a5776fe7aa2ab1651849623ab3943efa40e434e9d71127579a00e0e8ad9a157d"
  [hppa-unknown-linux-gnu.tar.xz]="42cb820fce15aa1868ecee34c3a1898732471daa04640692115716935a16e2bc"
  [i486-unknown-linux-gnu.tar.xz]="a86b266cb5b7f8bee3d6ad949071e555442cf3f60ed941f96480d8bf413b37c7"
  [i586-unknown-linux-gnu.tar.xz]="4e304c42eb4a56862874ab49a5ba61b704f077af3c038949586d6210992ec6ad"
  [i686-unknown-linux-gnu.tar.xz]="19cc09b5b16b0d731acf24e9ffcce7ad4a2a19da67538b6dc5bc573b6d4f8686"
  [loongarch64-unknown-linux-gnu.tar.xz]="daec3f14e917339e8fe9a1142fd0c28caaf529434f34167632a6a5b09825e398"
  [m68k-unknown-linux-gnu.tar.xz]="1cc0c9f831106321c84c9ee09c2c04fcfd47cfb94eb88b23be2e28dac79b4579"
  [microblaze-xilinx-linux-gnu.tar.xz]="34136687a8ae0806cfe749f95aa78265b4675820e953686bc3ff1c3cc00acdf1"
  [microblazeel-xilinx-linux-gnu.tar.xz]="87a8097529c5f5e9d414bd21e49c1a19b6a241ed226dbb985a94c3a778943548"
  [mips-unknown-linux-gnu.tar.xz]="64592324108a88566bc6cb378feb3d5475b83f33839ddae9ecf349a967624783"
  [mips-unknown-linux-gnusf.tar.xz]="4d9ef795563d085dff2d8e5183cce736af13f9d366ede9fc4496c25340b7fb3d"
  [mips64-unknown-linux-gnu.tar.xz]="4075e9074b2e472fc1c6fd66759ae71db11b6c282bfa4fcf64c10773e7455ecd"
  [mips64el-unknown-linux-gnu.tar.xz]="43dbf46f2cfd6b10c38decf40eea5e7c3abf66766658a4d27f38d1ed97dff83a"
  [mipsel-unknown-linux-gnu.tar.xz]="a990014302175629513d42d504fb849ec6cb416502ce9ef8de43e666efd00cad"
  [mipsel-unknown-linux-gnusf.tar.xz]="80006808d5b349a4bd7ddef802b1fbc5bbdcd608cace6e57ed6d46271904b6bd"
  [or1k-unknown-linux-gnu.tar.xz]="41bfe93ad8536f7a50742b02cfc011eb36830c68336b45cd4965cfb33461a073"
  [powerpc-unknown-linux-gnu.tar.xz]="9ab232e55ab5070a0379ad1859ef064287b7a874c281370e92be1eb920fffa87"
  [powerpc-unknown-linux-gnusf.tar.xz]="aabc76fd5d2330a35672b78157560fcf657043044d52f50267eba45e39a0b5ee"
  [powerpc64-unknown-linux-gnu.tar.xz]="8b76edde11b46a5be8ed781f503d285ab032a4ba8dd4efa83cc7572f4831b925"
  [powerpc64le-unknown-linux-gnu.tar.xz]="f89edd7c93803e3deb9df864c52da391a73f22309f7de7819091c4b141095e4c"
  [powerpcle-unknown-linux-gnu.tar.xz]="5514308ec9d4f3546952a73463f7af82f00f784387f086bb3c7eeb87d3e738b5"
  [powerpcle-unknown-linux-gnusf.tar.xz]="b12f5a46c252f6749f0a82495b6c071b8b8b4abe936cc4d9db7dda1b72bb7f62"
  [riscv32-unknown-linux-gnu.tar.xz]="f3aa3a2a7ee035fc07f1bf1b6ff69c34df263e3b0e5cd5987950bc9d8f0b169a"
  [riscv64-unknown-linux-gnu.tar.xz]="1e112677b7aa6bcfa61bf23872673a6c215f4c96249983951e4b507f31efdefd"
  [s390-ibm-linux-gnu.tar.xz]="767a26cd5fae28209c8d8fd1132ad6cf6fff21c79fb738c1fb9569683cc27e4b"
  [s390x-ibm-linux-gnu.tar.xz]="a0ec0d843f652fc79d8eb40a3e8a7fab43f8b1037b745b2905ebad2f1f66f911"
  [sh4-multilib-linux-gnu.tar.xz]="59f07422b2896aa880699de1989aff154318ee3fc9000e8e77387b577c4cea59"
  [sparc-unknown-linux-gnu.tar.xz]="4588a8ee9a03adceaf04072568ab549ba73c071d61c8677268b5aeb5abfc13ae"
  [sparc64-unknown-linux-gnu.tar.xz]="b9fb9eb67c8ba80a43e7de87cccb5512c25f552b458ae8dcb095cca839718dbe"
  [x86_64-unknown-linux-gnu.tar.xz]="88c3bf685f7c916508bfd33bfc82796fee6d36d87fe378199066e541a0d32ca9"
)

declare -A HASHES_CLANG=(
  [aarch64-unknown-linux-musl.tar.xz]="da066bdda92d0999219e3ae544e1a5766cb6422545eea83cc153621a442d32d9"
  [aarch64_be-unknown-linux-musl.tar.xz]="ada9edd8f0fbd6ccd5deeb47d53d355b1f4a427181d019a2af2940af53d22244"
  [arm-unknown-linux-musleabi.tar.xz]="b7e4c2b148a1f72fbbaa5324a47f5afcc8a3e5c49498b276e7a6768de9e06fff"
  [arm-unknown-linux-musleabihf.tar.xz]="e777a747a83529f5dcbfada2f462321a0f2634d751ae2328f5bc62858028816a"
  [armv5-unknown-linux-musleabi.tar.xz]="29fa01ade9a014f98b27abfffba549e9d680921447e76d43c9f7c6bfa41ca9aa"
  [armv6-unknown-linux-musleabi.tar.xz]="4acafdbb1155b45d791e7f8dba14665c073fa962f27d3b8f7725c434133ce007"
  [armv6-unknown-linux-musleabihf.tar.xz]="cf1ec2315d40067f13a465ddff7a9d9f73599d3a8d4aaf77206776f717a0d7e3"
  [armv7-unknown-linux-musleabi.tar.xz]="7f0db3dade5f3dc9c111482d514bfedc9f12b42d106b10ab2f409aba2cf722c1"
  [armv7-unknown-linux-musleabihf.tar.xz]="7bf2ccb023df4e69ebcc906a5884ccb88817c4f276f5492ca290e226aebd94bd"
  [i386-unknown-linux-musl.tar.xz]="4fef887e3bafd93a9444b29c6a947710e2fd83009c7b18d389de44a7d18549df"
  [i486-unknown-linux-musl.tar.xz]="2619edbcfdcf638f22e7db055225b3ee4c03ba74ec5688f59eb3314abc7b0fc8"
  [i586-unknown-linux-musl.tar.xz]="20a4991cc25f4b1e870d679c7d71ea94115d289758027aee2c3095b337c096f1"
  [i686-unknown-linux-musl.tar.xz]="2996f632e3619a3c5bcda2553e356a310af47c37215c8f35924604925c865777"
  [loongarch64-unknown-linux-musl.tar.xz]="e7c23f3115f8b124e468d7c0b3a928e40439c5f272503a7a3d6e1fbd8ec18d75"
  [m68k-unknown-linux-musl.tar.xz]="6e73eef88ada0506ed13aa13602081194286c636bc5011bcc06e2ac866bd2225"
  [microblaze-xilinx-linux-musl.tar.xz]="8cec2e26bf30e4b756141c3a934a0887832555a4dec3ad806cc8e62d385b5148"
  [microblazeel-xilinx-linux-musl.tar.xz]="3408735cf9567ac60b17230806573800cf71ce491d1957e337521fab97982ec8"
  [mips-unknown-linux-musl.tar.xz]="1c60f1906248858cfbd3ac867ba1acda39aa24783c059755c2bdf24ef6c80f92"
  [mips-unknown-linux-muslsf.tar.xz]="396d3d380d115ffca0220fb5b6715c436e9ec50c2025127e9fde4fb428e706d0"
  [mips64-unknown-linux-musl.tar.xz]="f9744164bcaafa4b97ccc587decc3892e8fa1d0b8a15c71ce91ca0b19df9d0c5"
  [mips64el-unknown-linux-musl.tar.xz]="7a502d2018c73f7821dd05710d893e7774fbdbb46a4aa7528a946da01241babc"
  [mipsel-unknown-linux-musl.tar.xz]="bba46521c966a4e5b9da5f5de966f5306eb3ed839e97b1757c40fd32e8eafae9"
  [mipsel-unknown-linux-muslsf.tar.xz]="9876502e80ad95258c77d3ed1a6643c370de413ef4be1f7975d0f705d6db6001"
  [or1k-unknown-linux-musl.tar.xz]="782e14c522204b0bd2cddcdce39eb11f959bc4fa4c2f58706c252a25715f81eb"
  [powerpc-unknown-linux-musl.tar.xz]="c42b1f0274df2e03a2e09dacbb8db7e96b315ca281aa0e6db4d75a01e33ed466"
  [powerpc-unknown-linux-muslsf.tar.xz]="43ceac73f4b11414896d614ae4c1ffc871997be261bd6bda9b1874a25c41adaa"
  [powerpc64-unknown-linux-musl.tar.xz]="e5bd2352bf3f3724ecb4838e0a87c99fb213e7218fd3e152fa1b3157790f1216"
  [powerpc64le-unknown-linux-musl.tar.xz]="93915b9909c5800d60be2592a31d9fc18086d23a9122b038047fcf992b3efa2b"
  [powerpcle-unknown-linux-musl.tar.xz]="f4a41bdae70f85cdcda0d054fa67e09858e2a98a2b6d9b202585d6cb300f20b0"
  [powerpcle-unknown-linux-muslsf.tar.xz]="0346613291532f15f0e675b1132231b06304c3f1a7d1c214ec4e39836b369238"
  [riscv32-unknown-linux-musl.tar.xz]="372c0fa2db702da6e3b0daa82b6a3944cd280e0b6874fba22dd0748a261ea3a5"
  [riscv64-unknown-linux-musl.tar.xz]="42b5e5a3a16320860b93f38b7b9540d90ed2fe2397554d5c0c5574564a2dc1d0"
  [s390x-ibm-linux-musl.tar.xz]="d72f0d73f666f8240fe0f414180fa1105e38186c7a38847f4050048a74f4327b"
  [sh4-multilib-linux-musl.tar.xz]="aa2a947e7bac8589167ea339d5c5606fb6a8161c6de70d277eb0b83fbfdebaa6"
  [x86_64-unknown-linux-musl.tar.xz]="35407293a387b6e5b17f1f027d6e1a2b6b21c32c8a5e760b4e32a7e0d614df51"
)

declare -A HASHES_UCLIBC=(
  [aarch64-unknown-linux-uclibc.tar.xz]="f5fdebc6e516628c3eab0ad24611e4506d1122d51e940573690d033c8392e4e3"
  [aarch64_be-unknown-linux-uclibc.tar.xz]="4f8f37245fbab0af50b4c84e703763c6850923d2ee38762c7af9fe02cd7d8603"
  [arm-unknown-linux-uclibcgnueabi.tar.xz]="b711737a71394506f0bd47b49533ff88c2a3add496e70f991d5993db0d55d04f"
  [arm-unknown-linux-uclibcgnueabihf.tar.xz]="9c0b5f60cfba37d023b64422ecdedf1a7c87fdc17fa9c2641127973b637624c4"
  [armv4t-unknown-linux-uclibcgnueabi.tar.xz]="cbb00d40efc53def7e2c308d47ad31195f6458b75bf26ce0c2be9096df413c46"
  [armv5-unknown-linux-uclibcgnueabi.tar.xz]="74b34ebcfa991078e03eae40ced9c1a963d7a15e0fb95743f848d4c30848dc82"
  [armv6-unknown-linux-uclibcgnueabi.tar.xz]="091c2d57d0e6d68cefa7b63cc6f24c494c43739d0098a53fca824e4e30463537"
  [armv6-unknown-linux-uclibcgnueabihf.tar.xz]="fb1a44044fbad88e030d506269bd8e2939c0265c25880dbc33b34cf60d3e9203"
  [armv7-unknown-linux-uclibcgnueabi.tar.xz]="46eebef2ed532532bc0437e2139d7a6157bb8b247a324224aa2f70efc5fe3482"
  [armv7-unknown-linux-uclibcgnueabihf.tar.xz]="b09451fc4633cfede940da87a4d122be8b6f2933d6f572a933140bbb47f065f1"
  [hppa-unknown-linux-uclibc.tar.xz]="d298641aed00196f25082081fc38b8ef9581db393bc6ca7f659632dc4411829d"
  [i486-unknown-linux-uclibc.tar.xz]="29b97b80aac1ae652a24da095e2537012bf57861d47022a76fc5c7008101d0c7"
  [i586-unknown-linux-uclibc.tar.xz]="d20987ab6cb964bff425aa72ce745b0328523b00f2f0e52fe74381568ae77bef"
  [i686-unknown-linux-uclibc.tar.xz]="cac7f6720c5fa9ea21ba3a45bf49a0ebb15329bcf6e3d6c561b8fde67a78e97e"
  [m68k-unknown-linux-uclibc.tar.xz]="d271c21b753c8f65aefcf858c839c768f2200a809f3b7d0f693874111b89373b"
  [microblaze-xilinx-linux-uclibc.tar.xz]="74a8ec97fbe461b79ca2a8021c1be8c21dc9968830e49edb4ea273e42bfca4de"
  [microblazeel-xilinx-linux-uclibc.tar.xz]="c2ef799a77e6aa52c5da2653f4918114e34307ab06a98fbc357e005f0382bb9d"
  [mips-unknown-linux-uclibc.tar.xz]="16103fb3ec6d61258d5355f6b019062e985f59f027de90d4eb4353cac0267aaf"
  [mips-unknown-linux-uclibcsf.tar.xz]="87be18fdbfbd77ca1d5e6a029994156c23de4a89836d0ac5b4eb801c23d3079a"
  [mips64-unknown-linux-uclibc.tar.xz]="ddef31ce64e240cbce9d101e7fc143878742b2c312795f8e1ddf2e9b8936d373"
  [mips64el-unknown-linux-uclibc.tar.xz]="08df02ada2fc56041a25fbde6abe76dd462b138fefabb99956731d7f6fef0433"
  [mipsel-unknown-linux-uclibc.tar.xz]="73e88b8a9ce140b9be903b051774605775a09c1973dcacf625132573f3958489"
  [mipsel-unknown-linux-uclibcsf.tar.xz]="daeda192e4f6d13fdf45a5bb90f67b98e1b1c584e3d1701e6f1e025b852505c3"
  [or1k-unknown-linux-uclibc.tar.xz]="0a1f38cd625b340aa758a66e21f29a2761d3257fdcfc81845e823c53f7de33e9"
  [powerpc-unknown-linux-uclibc.tar.xz]="a41a2855b44d533c48b54787d414015784db7fbe6b36a9781e8e06ed1053eced"
  [powerpc-unknown-linux-uclibcsf.tar.xz]="ce838b1e329cb7ab7ed8253925ef2eb04e5668f95ea1b0ff672cde3a0a477358"
  [powerpcle-unknown-linux-uclibc.tar.xz]="70d5a7455445053759bb35504c43e29d1c0177d9e95bad2fde1ee099b90fac60"
  [powerpcle-unknown-linux-uclibcsf.tar.xz]="c6f91641e7e72515148968350590f20139c66e1ffaaa5d7dc74c66a71209bd9d"
  [riscv32-unknown-linux-uclibc.tar.xz]="4c18dc9f71daebb79b71028f7e33d5eddf327309f015f967348ef1e60b55c4f8"
  [riscv64-unknown-linux-uclibc.tar.xz]="0b6b4bdc3a24b638194c5d0762b33b3aa1054a50ee91d7134ceb8a33dfc1351b"
  [sh4-multilib-linux-uclibc.tar.xz]="e21f2d662da703bae46a0be2f658629b4ad3a5ab34eb11a8f1a74b92d0dceea4"
  [sparc-unknown-linux-uclibc.tar.xz]="13bde1e0d05685291a055edbef1aa6c0c760e1ed4daa85803520f0bc7cebbad2"
  [x86_64-unknown-linux-uclibc.tar.xz]="77ed51a947006bc623d879c5bd0b117fa27664c3945df86b42806fd6c2fd1563"
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
GCC_RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/birthday"
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/queso"
GNU_RELEASE_BASE="https://github.com/gfunkmonk/gnu-cross/releases/download/gnuewt"
UCLIBC_RELEASE_BASE="https://github.com/gfunkmonk/uclibc-cross/releases/download/newspaper"
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
    elif [[ "$COMPILER_TYPE" == "uclibc" ]]; then
        RELEASE_BASE="$UCLIBC_RELEASE_BASE"
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
        --uclibc)    set_compiler uclibc;   COMMON_SHIFT=1; return 0 ;;
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
    elif [[ "$COMPILER_TYPE" == "uclibc" ]]; then
        expected="${HASHES_UCLIBC[$tarball]}"
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
        #git -C "$SOURCE_DIR" pull origin "$REPO_BRANCH" > /dev/null 2>&1
        pushd "$SOURCE_DIR" >/dev/null
        git fetch --all && git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
        git submodule update --init --recursive
        popd >/dev/null
    fi
}

# ── Final ──────────────────────────────────────────────────────────────────────
final() {
    echo -e "\n${FINAL_C}🎇 All requested architectures are finished!${NC}"
    echo -e "${BWHITE}Final binaries available in:${NC} ${MINT}${OUTPUT_DIR}${NC}"
    ls -F --color=auto "$OUTPUT_DIR"
}

check_static() {
    if readelf -l "$1" | grep -q "program interpreter"; then
        echo -e "${NEONRED}⚠️  Warning: Binary is dynamically linked!${NC}"
    fi
}