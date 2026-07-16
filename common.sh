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
  [aarch64-unknown-linux-musl.tar.xz]="c3f77587d30dee2bb75c109fb8cbe9a2650873d3741bca0b871136c4051db1ff"
  [aarch64_be-unknown-linux-musl.tar.xz]="9e8db3eab7c962ced74fb9dffdd6508c68d023d76212ff50279d8a616af4a22b"
  [arm-unknown-linux-musleabi.tar.xz]="d6e0c231e86f99e236342165a4d323d39f946c97a0031e9f57436b4bec872cd4"
  [arm-unknown-linux-musleabihf.tar.xz]="c6dc2bcea148a106f131df04bd6f3bed3cc5ecc1c7e7f40a545ed13c099c1328"
  [armv5-unknown-linux-musleabi.tar.xz]="6b76d52c175d8cffc8ab2d811c65f4e91be3aeedf6ca4c94c8aa02a46ca7ebe8"
  [armv6-unknown-linux-musleabi.tar.xz]="436d61ac88fa3efc1359f0d0d78120cfea753f1ed384580187976130f3a3f26c"
  [armv6-unknown-linux-musleabihf.tar.xz]="cafe1762353aef1224fe914f463833db8d3e0a3d317d8604f42157bce9ff01e6"
  [armv7-unknown-linux-musleabi.tar.xz]="eabc16338bd64de3442503c4ab62f54b296b04a15e7ec4cced5de3b9db244f86"
  [armv7-unknown-linux-musleabihf.tar.xz]="64b1ebe9fe5b17f90524e098c4979febeca0f813ba2dbe5e55747a512f1eb911"
  [i386-unknown-linux-musl.tar.xz]="ea75de254b08696e256d678c3ec7158e0b456cd88b138425f8f1f5ccb40302ab"
  [i486-unknown-linux-musl.tar.xz]="4034cfe69b8d854d9f68c224e6182acaabda9f1c6040631497ff5403115d175d"
  [i586-unknown-linux-musl.tar.xz]="95b67e77a3cbe073e0b4c38f9e3e845e66c91f0e4ab879a3d53b9e05b67b5a66"
  [i686-unknown-linux-musl.tar.xz]="f4667f6e4796a4bf4f09cd150ef085e38d7f72b61afe9586c26448502792a493"
  [loongarch64-unknown-linux-musl.tar.xz]="b2ae2978efce40eb23484c1bdc5453f0c56cf334769a134e705cf08015811fb3"
  [m68k-unknown-linux-musl.tar.xz]="4162378d5dc234bcadefce80f89f2a01bad0cd3bf891864fd5f3283c4dfaa58a"
  [microblaze-xilinx-linux-musl.tar.xz]="d5e714cf6d9ed8cc954f754104ac4ccba42c977128eafb66c0cc0f4eedc2f524"
  [microblazeel-xilinx-linux-musl.tar.xz]="4b276421dbb8bb037356d67c5985536a54f2cfd813f2b6d2f014be2e188ff9d5"
  [mips-unknown-linux-musl.tar.xz]="f90b3e7f2ea278c86a25196e7ae30f0095003a5dfc6c96737bd9844478d77423"
  [mips-unknown-linux-muslsf.tar.xz]="775a810459b2e00b18f90f4f2af1bf78160bb1f0f36f39a67fc1654dc72e9412"
  [mips64-unknown-linux-musl.tar.xz]="76926683685d6cd0a0cf65c24d9dfa4770434759b09adc07ccf48d84590aabfb"
  [mips64el-unknown-linux-musl.tar.xz]="e88b180e287989198cbf42a7752fac5887366d5fa474dfb4aa0da5d6376416e8"
  [mipsel-unknown-linux-musl.tar.xz]="b8c7eee8569a8badbe94bebd55a517daab152a7093866d512124adf1f1e4ac5d"
  [mipsel-unknown-linux-muslsf.tar.xz]="f23753d9829c0044f7e864f21fe4823ac0fb03dd7d35ee9337b2c9f8b15cbc41"
  [or1k-unknown-linux-musl.tar.xz]="d23b6f7c09d742c6a9cf64cdd1e382d7c9251a081f82234b6ded3f23f0a2fce4"
  [powerpc-unknown-linux-musl.tar.xz]="42263163f7f7479fa3e0ceefeb2c0c73b70211a98899b3c4700f653cf70d3db8"
  [powerpc-unknown-linux-muslsf.tar.xz]="27a9beb043cc31b6c136f41dba9de812c826ecdf45ddebf41425fde9c4939674"
  [powerpc64-unknown-linux-musl.tar.xz]="4b07199778da075883048deef4a8c6a6f15a2d291c17b4ac244a4c52b98577b7"
  [powerpc64le-unknown-linux-musl.tar.xz]="4febebe1e8c40f1858ff7b1ed1981e950b4a25a849ccb50509d2533782c2fbf4"
  [powerpcle-unknown-linux-musl.tar.xz]="29b4636d74d06cb22102a3f9198d914e76e5dac71a04494093079283e193208e"
  [powerpcle-unknown-linux-muslsf.tar.xz]="810774f366e9af27d2b14090394b95d9bdbe107260df9d56be0fc9edd9c90a19"
  [riscv32-unknown-linux-musl.tar.xz]="1e458ba4b0691301257919506e67c2e9622851b207c6823a7b6a50d0dc9b61c8"
  [riscv64-unknown-linux-musl.tar.xz]="7517f34e566ccb3591fe3639fd2a2f46c31192880d7ef6be8b99a02498d97c8a"
  [s390x-ibm-linux-musl.tar.xz]="4b5c164199865203ac48ac58225c96e70bf3b9059de02c2a9ffd3448c655412e"
  [sh4-multilib-linux-musl.tar.xz]="ed8bc4f0dfca8f3309a9b8594b1f893ddcbd1e7407958c10c524cda17beca26a"
  [x86_64-unknown-linux-musl.tar.xz]="dd489295f1ce7c0e00615e5688ece079ce1c870fac63bd4852995a251dca57f5"
)

declare -A HASHES_GNU=(
  [aarch64-unknown-linux-gnu.tar.xz]="a448e4601cf40cbbb10f3a2ec6924b00bc8c49dcae4b62884d31da7975e024b9"
  [aarch64_be-unknown-linux-gnu.tar.xz]="469b7a1757c3908fc6c43629d76657118026280974d714c2d9dbbd7f2041014e"
  [alpha-unknown-linux-gnu.tar.xz]="fcb8b44fcf187cd9ca5197dc89df29604ed0fb0305910c7b0200f7fc49c01a24"
  [arm-unknown-linux-gnueabi.tar.xz]="ad5e311afc60afa61083bfed7bfe52f8b5a766ab4569ab6151618e2e45534ef7"
  [arm-unknown-linux-gnueabihf.tar.xz]="722324490db596de47e8715518ba9d0dac42a46ed16534add10a229e45423b65"
  [armv4t-unknown-linux-gnueabi.tar.xz]="24d21d03ed3702f692a773e94de9b36247b9bd1bb66d85cbe09f0bf2faa9e14f"
  [armv5-unknown-linux-gnueabi.tar.xz]="f9eb90aecfbd329d87a71fe6b0bebb808acecccfafd0eff3c4d316495f31257f"
  [armv6-unknown-linux-gnueabi.tar.xz]="d0786b7f6a4946b3204f1c26bbffc98dd6d4f05db96af995a9b968adcc9e3032"
  [armv6-unknown-linux-gnueabihf.tar.xz]="046116271bdfb69a43d313772f8e358116cab55d6dbb955b1410a3e9b3ed20d8"
  [armv7-unknown-linux-gnueabi.tar.xz]="ccd90d90ce14c157f92aedd1c6d6d90508c255eb26c278e77d8f56e857b28e61"
  [armv7-unknown-linux-gnueabihf.tar.xz]="692c8f7ff972ea8cee7808cb601a3a03640a089c9cef6ae0e34f567fc0c78862"
  [hppa-unknown-linux-gnu.tar.xz]="b839b738865c78abae151a3e6caf897fe13712a52ed2291c3be14e5386ae763d"
  [i486-unknown-linux-gnu.tar.xz]="ab7dda17fd494f2489ddf111e5745092374dbde102cbf0534526acbb4a170dea"
  [i586-unknown-linux-gnu.tar.xz]="da4b5c1c42c52815da8f27633bd9acacbd667465242754e4a01b4e0d2591d22b"
  [i686-unknown-linux-gnu.tar.xz]="fed4761aef586a4325e3c5246c51760cc6ef2f6e9697519174eee8fa87755260"
  [loongarch64-unknown-linux-gnu.tar.xz]="4859f59f3989ca1f064951f1364bfb95a8b8c2ab1c8ce365c51e50f2b773441d"
  [m68k-unknown-linux-gnu.tar.xz]="8ac7bf436d5a8881ea0039ee467bf5bb42eb926fe7be3a469ca398a889569a2d"
  [microblaze-xilinx-linux-gnu.tar.xz]="071f37c5e0ccc1797e0f27ec897f4410cba6bba79d21cf6561ef6c8f5826b1c6"
  [microblazeel-xilinx-linux-gnu.tar.xz]="3ed7b64580ca34a0e3ce1ec2336fdfe556f6098bd2c9d6369f9766dd9a612c39"
  [mips-unknown-linux-gnu.tar.xz]="be24512e228403d3382d68b15fb7bfb2e1d4e8319067bb9760174556b0b54202"
  [mips-unknown-linux-gnusf.tar.xz]="e0ddba8c8191641a835ed90874aacd969460ea1ad50a9691322af43d90dc9d56"
  [mips64-unknown-linux-gnu.tar.xz]="6cf35a9f73e0f316acab08bec05660044b1176b83a189e90cf38e096cea266a2"
  [mips64el-unknown-linux-gnu.tar.xz]="995bf64895af0d6869aea0a1a7f44c3c55f27d50c11c3a6cb3e7e92579616f93"
  [mipsel-unknown-linux-gnu.tar.xz]="8db13ce9351ac5b0529b43c076d4f6c09dd3d7aedf18bbe9bfda06de516e2eaa"
  [mipsel-unknown-linux-gnusf.tar.xz]="5be341ddc7bd8d7da35905b63fe2959f1b229d74f5c499030f6d04cfa495b9c9"
  [or1k-unknown-linux-gnu.tar.xz]="2d4f182c17d5d20aa0ce8ffdd471dd1b9344248a89af75e3d2b3d4dba0fb520b"
  [powerpc-unknown-linux-gnu.tar.xz]="46f9a2e2a13907f67eec3f4ad298d0f64e9d308044ae615f5ff3d77bc85cc122"
  [powerpc-unknown-linux-gnusf.tar.xz]="091da0d7307871afdccfaae172a31d838573d85afa938718d12d2c4dc72cbcd3"
  [powerpc64-unknown-linux-gnu.tar.xz]="0559bf575b8315490a10640a0cd6cdd8bd0d11346805c39cf305aedf64697b6d"
  [powerpc64le-unknown-linux-gnu.tar.xz]="b0b3368bef4e863215daa4de8ea1a02bf41413f9f62b9a314ce8201e59f4b694"
  [powerpcle-unknown-linux-gnu.tar.xz]="2fb30a7f9f21574e302f94d7e1eae706937e0a7bdf6ce0087bb6a3cc923807ea"
  [powerpcle-unknown-linux-gnusf.tar.xz]="5e1ef2181682a916811569c5a012060a6799feac40abea0c6fc7bffbc6866899"
  [riscv32-unknown-linux-gnu.tar.xz]="93a3ad6ad34c50c2fb5605b0cf2a9fbefa691bf1a623aed199da9c3b85c259d9"
  [riscv64-unknown-linux-gnu.tar.xz]="cd3fd552936cc375596f337500b46d9db63cb7108de780db577ecd217d0030b7"
  [s390-ibm-linux-gnu.tar.xz]="930fe10337158b32ca2e552b96eee4666358308097c5b466f512cae9729d31fc"
  [s390x-ibm-linux-gnu.tar.xz]="5ea54b1c1a42a04430e4204204c5eeee75ba1d76578d864ae7c4e9e360225b91"
  [sh4-multilib-linux-gnu.tar.xz]="802a39e2b6058ff56bb4eb508a79ceb72790dc1f14b1b94b432fc7d52d0f242f"
  [sparc-unknown-linux-gnu.tar.xz]="f8e5ed936885e415ee3f6f3974f7353ff48720a52a4fd9ffec8591bad638b2a1"
  [sparc64-unknown-linux-gnu.tar.xz]="442782f16f9aa60b90efe0d5f7d2f26595f84011b21ec303ac3b4a5c3fe30837"
  [x86_64-unknown-linux-gnu.tar.xz]="cec7532c973d2794e88e554e96993e3010c2c8629e18be659f06b8ffd702c35b"
)

declare -A HASHES_CLANG=(
  [aarch64-unknown-linux-musl.tar.xz]="51e57426b954e2dac61d04d273e2b49d3c87f4a25457dcac4de8e486eb4bcbf9"
  [aarch64_be-unknown-linux-musl.tar.xz]="d95c15491c9ece5a5b4c5019737ac77dce9e667f6c1aa6c6fc6cc4ae1edc27c7"
  [arm-unknown-linux-musleabi.tar.xz]="177d918913ea0f05e0d000face11f83737ab4e628d28a508ac2038935cff5b90"
  [arm-unknown-linux-musleabihf.tar.xz]="037027879f8648c0f6d03621a8c25b515ec098e509020a8dc9193eb1ec93fae1"
  [armv5-unknown-linux-musleabi.tar.xz]="3cf82c38bdd770ec991680ab83c9c7da58163b01808e07ef167ec77b6c7c3490"
  [armv6-unknown-linux-musleabi.tar.xz]="43efe570f6494709392a8bfcfe5b3ac0f37abbb2e5ae2757bfa3b83697554ce8"
  [armv6-unknown-linux-musleabihf.tar.xz]="57810f1fddfce8f0c379be61ba0b988a9790f135e8909a17d6f3126e379e9040"
  [armv7-unknown-linux-musleabi.tar.xz]="d70fed8df0917ab00e350721fc7b8a50972b778ed4b64cc7869c94b12148fbfa"
  [armv7-unknown-linux-musleabihf.tar.xz]="ecd16b521bf576a454988216fb2fe3b7aa9ea7404610f481b7ebb745448010e2"
  [i386-unknown-linux-musl.tar.xz]="88eacdd71dfc20e0de2f6dc8b4e973d0fcf6dead34a50730c1b67dd5e64c3816"
  [i486-unknown-linux-musl.tar.xz]="6fac3d9d204add6c22e93b9caeea09540550121168cfedf089d4ee6b0e61b879"
  [i586-unknown-linux-musl.tar.xz]="f81742db5e54c0bd179dc71e23fd5c17a4fd49f2f1a668336ae83f69a2b102f6"
  [i686-unknown-linux-musl.tar.xz]="0ae51145562c31df1e3ae3d8c2f5281e7a7e7f61137b6ac2f962d4ffe29ae25e"
  [loongarch64-unknown-linux-musl.tar.xz]="4125c1b10f1c50fe517cd11517d80d632c2f5f837740cbb18c43c8bf058e507f"
  [m68k-unknown-linux-musl.tar.xz]="ec8611eb9e64f04c0592d2e0bf54332976c73f12798a2c8059d244d266b23653"
  [microblaze-xilinx-linux-musl.tar.xz]="9eb6b68048c3524c8ef49cd0a16f4e319fb9b690cb54235d0c231bc8e57095a8"
  [microblazeel-xilinx-linux-musl.tar.xz]="2ca88d18caf60c07e36089c7f076e430f2c45612054ca0b7567a60ab3bf1c6de"
  [mips-unknown-linux-musl.tar.xz]="dd1cf8f9c6f8a77ad272becfdc9f06931e0bc8811724007fd333801ebd64cd10"
  [mips-unknown-linux-muslsf.tar.xz]="a7c55602907d53452175ccdc0720ee4e0a98ff277b2621504d0398e2f4dc4a34"
  [mips64-unknown-linux-musl.tar.xz]="6c6ffa373bc1f4377dcc12fc082623fd3442b2742626a83c78c97b24aa628f5b"
  [mips64el-unknown-linux-musl.tar.xz]="cb1ccee9045dcf3d25a535d07f272b6dda6c138325b9d764aa7c7f02678ef76f"
  [mipsel-unknown-linux-musl.tar.xz]="9951b0e4c407dd09c4a4dbe1b87ed950858e96432702b781024f487fd1214118"
  [mipsel-unknown-linux-muslsf.tar.xz]="9572a12464a86a63792d09b15e36c50c194c6ed06368c287dc0d239044e21291"
  [or1k-unknown-linux-musl.tar.xz]="79b36a9c3dc2e65d926c31c8f4f1a5bad0db26f009ec7f7b50b38dad0bd0f782"
  [powerpc-unknown-linux-musl.tar.xz]="1d2cf53223541c34e778b564adec4d9029a484c19aa4d9bb923518b2d04212fd"
  [powerpc-unknown-linux-muslsf.tar.xz]="81e8bbe27a10c8c10d0585d6acf5ef831a1556138a4a504d1a93c7dd9a37a599"
  [powerpc64-unknown-linux-musl.tar.xz]="0748e121e328ba0d5756f2a390d6c06b003181f73a7165e478a81b64a4182ace"
  [powerpc64le-unknown-linux-musl.tar.xz]="149ac2c05e5036441ba3840bbc7da84cc03c0cb7d798ea651a08313645b1ad97"
  [powerpcle-unknown-linux-musl.tar.xz]="1f8b41dd6e07e5831e9c46f1660981b7d13a0a27c8b88d5440f3b06f9fe8e3e0"
  [powerpcle-unknown-linux-muslsf.tar.xz]="6fb58859f7c6fd1ce09dbd20cf2215fa5d653f19a6a800f19e714b52d442f4be"
  [riscv32-unknown-linux-musl.tar.xz]="82592790232c23d6f013ab259a204518a73829bce9bedbee2eeeceec6e764c52"
  [riscv64-unknown-linux-musl.tar.xz]="3276344faeaae05f3ac85a1b2548a157cb27881a4c6a0119c0cd22a99253b101"
  [s390x-ibm-linux-musl.tar.xz]="bbda7dbf3dbb3f6d1b7df06721f765616fc9ee59ca17dfa5a1186abec078fd35"
  [sh4-multilib-linux-musl.tar.xz]="14cdd27dddf61802b2c11a1fbf4c02548a2ab982cb2b8df73e9f756371a5504f"
  [x86_64-unknown-linux-musl.tar.xz]="fe96e4ff5b8e52ea37fd3c4cc61356efda2d30569f9b61ef84126d606eb2107d"
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
GCC_RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/elevator"
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/marmalade"
GNU_RELEASE_BASE="https://github.com/gfunkmonk/gnu-cross/releases/download/whognu"
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
    local found=false
    for bin in "$OUTPUT_DIR"/*; do
        [[ -f "$bin" && -x "$bin" ]] || continue
        found=true
        if readelf -l "$bin" 2>/dev/null | grep -q "program interpreter"; then
            echo -e "${NEONRED}⚠️  Warning: $(basename "$bin") is dynamically linked!${NC}"
        fi
    done
    [[ "$found" == false ]] && echo -e "${SLATE}  (no binaries found in $OUTPUT_DIR to check)${NC}"
}
