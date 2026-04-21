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
  [aarch64-unknown-linux-musl.tar.xz]="272da868105a70c95ad3eee6a96b3b77a993d8de0ead6be813e05b9801162c17"
  [aarch64_be-unknown-linux-musl.tar.xz]="3d2e48bd688aabb0242433918eb15ccd44f8b3d67afc71915a1b28b51dd06023"
  [arm-unknown-linux-musleabi.tar.xz]="c8216e47dfd36ac6d20388d4c82d580c53153dd065dc20868e739026699fdb87"
  [arm-unknown-linux-musleabihf.tar.xz]="d473c71338ac204123317b34a069a860ab8285f88dd35f5cb73ad62d07fbaa04"
  [armv5-unknown-linux-musleabi.tar.xz]="c0276514cf327be074c546e1867a4d585c0df856b855d6b2d702b368c5ab7e74"
  [armv6-unknown-linux-musleabi.tar.xz]="72fa5b48bb0ca4d6b65cab8594bd23b51ed085ec839b25bee362fb9733f7bc7a"
  [armv6-unknown-linux-musleabihf.tar.xz]="2d74a3f2147bedcd0ecc25b3d15be9ffa20d4e7aa7480fa5bb32312df82e5972"
  [armv7-unknown-linux-musleabi.tar.xz]="b04a48c6f314c63f20617cd770c710bb92ad4edb32fedfb996e8af68e98f9585"
  [armv7-unknown-linux-musleabihf.tar.xz]="c6f774eb54f131b611d042e4bfc9b40843e7f35354c4d6b544600645e407d3ed"
  [i386-unknown-linux-musl.tar.xz]="8fe853286da224ced9d9a4807889ba6f26fa9ed6b14d07622d204e67f48e2017"
  [i486-unknown-linux-musl.tar.xz]="64d181b8a22cd703832ae27218be0dfdf5770c67d4631a0826c3c9ef4176695c"
  [i586-unknown-linux-musl.tar.xz]="69ee452c423fb4c3336fc0dd8f7192a0b47b556d6704ab8862e036dec1555f65"
  [i686-unknown-linux-musl.tar.xz]="3d97dfac58f82cece24aad9c3d80978e9a6b5461d0245f6a2a2a2d87be08d86c"
  [loongarch64-unknown-linux-musl.tar.xz]="45b3142e5059583cd1ec95536bf770871552eeb0070e873fc7fc5f3913c21df6"
  [m68k-unknown-linux-musl.tar.xz]="4d2f7037a0a4e91b3f87eef1e5c85235f61814b36912289cb4fbb4ed89112883"
  [microblaze-xilinx-linux-musl.tar.xz]="79ad73470eee48073048009248ffa52339b2cbc3711ebddec87fff3f50f95959"
  [microblazeel-xilinx-linux-musl.tar.xz]="cd8b9364a61ffc6e3b4271278a69535d4fbc73057321f4b1b95e52fd64240461"
  [mips-unknown-linux-musl.tar.xz]="78a11562d332ee8a78cfc4ceaa4f170b4ac0e10e301c9e0ff308086fec652cc4"
  [mips-unknown-linux-muslsf.tar.xz]="2a204f6a116d6cf5120163d828b1114112f9867be77ade793bda2264eb5d50a8"
  [mips64-unknown-linux-musl.tar.xz]="5d502bb394bd0f9d4188758a3b8a2aa92b7c936de9ccbaa418354843babce7db"
  [mips64el-unknown-linux-musl.tar.xz]="29f23539d13c04129d5bfca60e853261b53d8a36bad108976fd51d824a03bd88"
  [mipsel-unknown-linux-musl.tar.xz]="7953d26bc3356c0cc6b8f9879fc89967c23a91d7962479639f05827fd124d749"
  [mipsel-unknown-linux-muslsf.tar.xz]="2c1744eb68ddd41282d77bde5e3c06a827111b31aa79f492716f9eede747acf4"
  [or1k-unknown-linux-musl.tar.xz]="09575a131a7a0b8ca9e2dad5c48abe06d8fcb6e9931b12cc930b0d34ff9ed03e"
  [powerpc-unknown-linux-musl.tar.xz]="c4bf8ea7def0eb87d134b3aabb9e94f8d4f111349280fe02d355b3118b28216f"
  [powerpc-unknown-linux-muslsf.tar.xz]="e024c38c1d91824ab0a448559c648d5e922073776080642b7ef947d84b12f27b"
  [powerpc64-unknown-linux-musl.tar.xz]="ba856b4176a89cbc75d7a0db814f3482c356efd2496fcf20afebe79b38d9cb61"
  [powerpc64le-unknown-linux-musl.tar.xz]="74b53eb6ff2e38cd364460e90dee3507314887bc637f51b0ec5079aa0169e8f0"
  [powerpcle-unknown-linux-musl.tar.xz]="8ed0143ecbd2dfa1f91748645bc72ecec3a357d2f0dc32c5c964df7de4c8ec66"
  [powerpcle-unknown-linux-muslsf.tar.xz]="28ec671a113e28e57d5867894eb52a6125ca7264296b9002570bd471252c7be2"
  [riscv32-unknown-linux-musl.tar.xz]="c7a131cc34b251705e0a2152f4de6a3f55465aa0d8b2ab18e4ef0c96d740a805"
  [riscv64-unknown-linux-musl.tar.xz]="f9e2defeb4d1c64f77d743eb0a79864a61e4780b081a0880fc9c0cdcb3ffbc3e"
  [s390x-ibm-linux-musl.tar.xz]="26cf3a1491425669a1ec81eae26631de0cedb8ca17bcac0cee6cc922f2041465"
  [sh4-multilib-linux-musl.tar.xz]="419c545564b1aecb81808d25651891bd240b74ce2c4dc733fed9f030bac584fe"
  [x86_64-unknown-linux-musl.tar.xz]="6ed3bb50f8dcd5aaa2f283bbc27ae7a5451af65fc233319bc38f65e151cc191b"
)

declare -A HASHES_GNU=(
  [aarch64-unknown-linux-gnu.tar.xz]="5bb9bc6850810f93b578decf9bd428fb0ff575cedab786d28d85032080b18940"
  [aarch64_be-unknown-linux-gnu.tar.xz]="77af6011c970327d60e225b4eb43b80b7a77b36919296063958dd47104ac9e67"
  [alphaev56-unknown-linux-gnu.tar.xz]="64ae1fdb2378c5786bb6a582473afe29f5a9c52e36e096ed79c067328f682748"
  [alphaev67-unknown-linux-gnu.tar.xz]="93fb364b535d5535f59513c4db874c8c63ef73b1c13f1a1142e0c6ead4ece718"
  [arm-unknown-linux-gnueabi.tar.xz]="874cb35f8732412e03272e84826007e1aec730a25677e12898a6ac7b337c5d15"
  [arm-unknown-linux-gnueabihf.tar.xz]="1422c14be83b3a7ef90ed711a26edd141d767c469e85778c5a430bfe63585dc2"
  [armv4t-unknown-linux-gnueabi.tar.xz]="90c6718e1df9b21f024cd40667c577721525a96644427264b69239db4d3feaa6"
  [armv5-unknown-linux-gnueabi.tar.xz]="738ead937e7d7c2c91301a71fa006e3ac1479dcf9f2e218eaccebb7ae277ccf2"
  [armv6-unknown-linux-gnueabi.tar.xz]="52594600a14c0e33acd06b48c6bdec07a3fac574338b7386bc857d0fb97ffe5e"
  [armv6-unknown-linux-gnueabihf.tar.xz]="e769ba63442299b7ba1290554e783967623cd3a927c69f3f5e8fa573efcf566f"
  [armv7-unknown-linux-gnueabi.tar.xz]="6b5cfba4bc47368bea30eb065fe4574893bc8f9d11dfa7aaed4d0266f34edc28"
  [armv7-unknown-linux-gnueabihf.tar.xz]="b2ed0d30d296883a0cb0f142fa11f2b219cb931aa3d6211c4ba305d7f70d9bfd"
  [hppa-unknown-linux-gnu.tar.xz]="ce1105fe83e55f0c35f9cc0f37d41bb8d1de8d4765b5d5fdf46f2334a3c5a3c2"
  [i486-unknown-linux-gnu.tar.xz]="273f99009ff3c18fb519f0c0511c30bb7a84f88dd4fb369c58faab5f39514ee9"
  [i586-unknown-linux-gnu.tar.xz]="2d2ccc41e1a14eb9313c9fd26baf5d5c28d5c19ea40d89921c5acfaf5c2d2e36"
  [i686-unknown-linux-gnu.tar.xz]="48fcfa5d038333c6ce3bb16855c9746491bb9bb7f99b862b655e83a6785749e6"
  [loongarch64-unknown-linux-gnu.tar.xz]="5bcd16ac8b13b3fd76f5a638580ce83f218470ee0a012ec5c80537692590101a"
  [m68k-unknown-linux-gnu.tar.xz]="4e2d8f4b1645b3c04f428c29429db03408f775d2143ac398628f1e1d44cda7aa"
  [microblaze-xilinx-linux-gnu.tar.xz]="3a2c60ee9e0b2682a07a0a7ee3582983474a356289789983131d73aa04617be1"
  [microblazeel-xilinx-linux-gnu.tar.xz]="e14d2838e02e7df970834ef8faeec93dd3ed0bebca7010fb166c84633caf30d9"
  [mips-unknown-linux-gnu.tar.xz]="5a745b5dd2138d9c61c5240118a5a392fea1c8720d2a1fdf4d04faa5084db218"
  [mips-unknown-linux-gnusf.tar.xz]="a5f5f8b7dc7e20ed512a37738e3eb08cf76ca7a083dcf60e642ccf92853d9410"
  [mips64-unknown-linux-gnu.tar.xz]="3991bb1d550a3530d545f7017f496dc46060b1c053f57ed516c94477a4a1b32a"
  [mips64el-unknown-linux-gnu.tar.xz]="1a86b1a5c972893e00ac79a0ecb65fed84856d3d07bb7002ccd882604ec127a6"
  [mipsel-unknown-linux-gnu.tar.xz]="5cc879f2e89996211919bcbc52604b25645d91f8548e07e2e20004cc5dfba726"
  [mipsel-unknown-linux-gnusf.tar.xz]="b15af5a27bf9c303789c442794b145faa8cebb907fc71cf9f877a92bb6df5844"
  [or1k-unknown-linux-gnu.tar.xz]="33dd7a7591b3dbffc34472d745c1a7700de67facd5e2858165e6b76c037140cd"
  [powerpc-unknown-linux-gnu.tar.xz]="f72ca3b455dd373f768077e2f213ce0a0e0e3823cc5db537d492ab095b961dfe"
  [powerpc-unknown-linux-gnusf.tar.xz]="616b6a92383bf0f4c3663835f1f3256931776bdbfc4ae9d7fd9dff9e7bfe27ad"
  [powerpc64-unknown-linux-gnu.tar.xz]="52981d3523e5954656b62714b18ca52a78af162f75d754917b4a5ae8253ed684"
  [powerpc64le-unknown-linux-gnu.tar.xz]="7da4235b54319c590655cd734578168465aed83544a0b287e324182d89b7d943"
  [powerpcle-unknown-linux-gnu.tar.xz]="1c3350e512779a5b20000b7ca07620f0e76200fe2139b53e2a3a157f903bb7c2"
  [powerpcle-unknown-linux-gnusf.tar.xz]="9a1e70470fa2c90843f032c006e4e13c4f24760330cf626523bf3e666a4bbcb9"
  [riscv32-unknown-linux-gnu.tar.xz]="844ca6afabb0351139fa7b5655a45ab3728c0691659354ba07432b5b836333da"
  [riscv64-unknown-linux-gnu.tar.xz]="d11b5626e6a9d98b72927fc94c20ab6abf61636f38b8c1277af61ca2af83309d"
  [s390-ibm-linux-gnu.tar.xz]="fc968c5137266f47880044a824c5bdc9399a32b4cf911d438957a0cb5697b79c"
  [s390x-ibm-linux-gnu.tar.xz]="7a24ac67d464e69972709fdaa5cbf2679e9d7758e684e18a9f056797da474633"
  [sh4-multilib-linux-gnu.tar.xz]="a851561b417b7fcdcbb8446cfed35518a815bb4b51ae84e829a5d83434f9090b"
  [sparc-unknown-linux-gnu.tar.xz]="e3800e3e961569a31b61cf81d9da438df3312c432371b1b03af0da1be9c54a76"
  [sparc64-unknown-linux-gnu.tar.xz]="5de3c1e49c4d2c8a021ed98cb4a243d64c1e90c4b011771c500f1d6551335fde"
  [x86_64-unknown-linux-gnu.tar.xz]="ef5a1e505f69e1c6e30069114e42ed6d227805d669d06111a72b9e4270803efa"
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
  [m68k-unknown-linux-musl.tar.xz]="65c60895165b854f665606cb642213db73cd1d01e531a98fc7d368cab9fb0636"
  [microblaze-xilinx-linux-musl.tar.xz]="8cec2e26bf30e4b756141c3a934a0887832555a4dec3ad806cc8e62d385b5148"
  [microblazeel-xilinx-linux-musl.tar.xz]="3408735cf9567ac60b17230806573800cf71ce491d1957e337521fab97982ec8"
  [mips-unknown-linux-musl.tar.xz]="1c60f1906248858cfbd3ac867ba1acda39aa24783c059755c2bdf24ef6c80f92"
  [mips-unknown-linux-muslsf.tar.xz]="396d3d380d115ffca0220fb5b6715c436e9ec50c2025127e9fde4fb428e706d0"
  [mips64-unknown-linux-musl.tar.xz]="f9744164bcaafa4b97ccc587decc3892e8fa1d0b8a15c71ce91ca0b19df9d0c5"
  [mips64el-unknown-linux-musl.tar.xz]="7a502d2018c73f7821dd05710d893e7774fbdbb46a4aa7528a946da01241babc"
  [mipsel-unknown-linux-musl.tar.xz]="bba46521c966a4e5b9da5f5de966f5306eb3ed839e97b1757c40fd32e8eafae9"
  [mipsel-unknown-linux-muslsf.tar.xz]="9876502e80ad95258c77d3ed1a6643c370de413ef4be1f7975d0f705d6db6001"
  [or1k-unknown-linux-musl.tar.xz]="eb12af20263e1927deef1d0aa912301f2b12e758df7db8cd495114e522cc73fb"
  [powerpc-unknown-linux-musl.tar.xz]="dfdc1854e5360e166abefadb6dc52c639f0321dad08bcb8008d9d8acc3a15202"
  [powerpc-unknown-linux-muslsf.tar.xz]="eed28b860fc460839632a93ed67cf1b0fb33d2247235deebc08db82c5d400afb"
  [powerpc64-unknown-linux-musl.tar.xz]="68e9c6d6bbb040d351e0dae313e5473fdb39b5c7f0655761beb2b0775cfbb2a2"
  [powerpc64le-unknown-linux-musl.tar.xz]="d4345bb13d0e0b0206ec20c048c765fac29b8f3661f3749e6d602a5e1eea8a2a"
  [powerpcle-unknown-linux-musl.tar.xz]="8b20308f86e367cf2ffcb71d38bf1a01b5b5df89f41df2fa0b5d1c14c470358f"
  [powerpcle-unknown-linux-muslsf.tar.xz]="1381ba88c8ef558ae3f768bac4a8a00de20e35ac6a5d43bcf8bc4ffb91e9d952"
  [riscv32-unknown-linux-musl.tar.xz]="372c0fa2db702da6e3b0daa82b6a3944cd280e0b6874fba22dd0748a261ea3a5"
  [riscv64-unknown-linux-musl.tar.xz]="42b5e5a3a16320860b93f38b7b9540d90ed2fe2397554d5c0c5574564a2dc1d0"
  [s390x-ibm-linux-musl.tar.xz]="d72f0d73f666f8240fe0f414180fa1105e38186c7a38847f4050048a74f4327b"
  [sh4-multilib-linux-musl.tar.xz]="88b67c40bfb7d307d4f55c0da60f5ce8917f5c3c096803838c2fe057416cf824"
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
GCC_RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/airport"
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/croutons"
GNU_RELEASE_BASE="https://github.com/gfunkmonk/gnu-cross/releases/download/gnutella"
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