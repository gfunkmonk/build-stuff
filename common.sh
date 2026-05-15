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
  [aarch64-unknown-linux-musl.tar.xz]="655c96e1e7b2217d95766f14b3732c060975bddfd1d7f15491b558a40f3e6cc4"
  [aarch64_be-unknown-linux-musl.tar.xz]="c0d29b9f35229d33d4464b5e2b03bedea791babef1721e4e01d3ce6920b4f85d"
  [arm-unknown-linux-musleabi.tar.xz]="8df29a9d3af9d22831561d547f92f8faf032937656f4ff9e8a4cbcae8570a0d6"
  [arm-unknown-linux-musleabihf.tar.xz]="b058cb62b517f801b1b3abf532d426de12be9fd936e276613b16ef6d2f0d4af4"
  [armv5-unknown-linux-musleabi.tar.xz]="301b12272e9042d7274414d42aa3d1c1a388af6ffa68b8e789b9bd2b727a8f09"
  [armv6-unknown-linux-musleabi.tar.xz]="0bb2c1e5510c2ff2ce96f4cfeafd9b7f2f808a1865b4f7a59c574b0b70bccb1f"
  [armv6-unknown-linux-musleabihf.tar.xz]="8d1b481aa5150354dae900e53e555d746086e13f2038394d19f012e978b03ecf"
  [armv7-unknown-linux-musleabi.tar.xz]="00aa251bfcdcd64d2a36f5c2f7b9194a82a0abcb4adf685caa7a4067d72d92e2"
  [armv7-unknown-linux-musleabihf.tar.xz]="e972ea67b4600e11d4cc4e10ad9fdf5434320087bf1e968c2337e798f6d9a53f"
  [i386-unknown-linux-musl.tar.xz]="fd16260557d7aab313165f9a3f288c54e7c5d8156f019c843b80cf77cff98e9b"
  [i486-unknown-linux-musl.tar.xz]="cf481c6d37040147491751bc36caccd2dbeb963084239de40674429ffebd0c88"
  [i586-unknown-linux-musl.tar.xz]="7bb0c29fa97b1c7f5c7eaa758f1fbb72b5ee9b9408a25513ab9346a8433ca7d7"
  [i686-unknown-linux-musl.tar.xz]="6be3494da81e868b91cd6e0bde7075a4c7536bcbf2e0e78788c7673686d52d47"
  [loongarch64-unknown-linux-musl.tar.xz]="436867d4afffbb492ef7aec404e02fb980254a53932fb94c499f862d7de46eef"
  [m68k-unknown-linux-musl.tar.xz]="3cffc48668f5e521b258e5bf4bd1ccc60eb112be701b05734dbfa9a8e5a1e0ba"
  [microblaze-xilinx-linux-musl.tar.xz]="29f268d65f7561018886f9c67d372143bb960c872e5b1df030302c16bf79e2a2"
  [microblazeel-xilinx-linux-musl.tar.xz]="d820a6643e8594e377d1834e4a2162d98b02006f144c85b2a49ae56ff3d2f7c7"
  [mips-unknown-linux-musl.tar.xz]="a0d05abdd4a30c4ab726f4657af12d4794b433d96bcad24b85e846df03bab22c"
  [mips-unknown-linux-muslsf.tar.xz]="977243f607fdcf29e826e4a9f93565502742cf5cc0b830ca378bb405c64a4de3"
  [mips64-unknown-linux-musl.tar.xz]="1120ba20722d8185d442e4edaab4c5857cf6b8ab1a8b46918b017a480fd11e38"
  [mips64el-unknown-linux-musl.tar.xz]="0e427becad3b1de9aa438846ff22e0cf95f57e5507d4f382d848ab9c18d45a28"
  [mipsel-unknown-linux-musl.tar.xz]="31a64f31d546c3d7f5b9cea09839a18a0530ea6dd622b1f3887b9098825f13d0"
  [mipsel-unknown-linux-muslsf.tar.xz]="7a393b58fea0638dc271caaccd859d04861f4723cf34e622a07d4b3084293a62"
  [or1k-unknown-linux-musl.tar.xz]="e74949a4a74ae91f2403076bd5b1c8a3f749ec87298db7f5ee72de0d76aeba6d"
  [powerpc-unknown-linux-musl.tar.xz]="27aca78ce3c5e1b24391ca843a4122711329758c7a6996637eb51a418ae91706"
  [powerpc-unknown-linux-muslsf.tar.xz]="e2b896d95862be5d65f18149411d22c827ed058803ffc95ea46f45aea4ab4aad"
  [powerpc64-unknown-linux-musl.tar.xz]="6f2a3bf7921e5e73edbbf234f91924eee2166c8478a59783313741f1d889f1e4"
  [powerpc64le-unknown-linux-musl.tar.xz]="ec93c592527d263df8c7bdb2b4a204bc8015ecddd19c0e76ceb80b33383deeaa"
  [powerpcle-unknown-linux-musl.tar.xz]="5d39839b91179b2ff479ddb749563d975ba07f3121d75319a2f1c149976fbfb6"
  [powerpcle-unknown-linux-muslsf.tar.xz]="21a8967172768feedc2bb648c95c0cb3a6f569b64ae7d3b76e04d1bf15476f7d"
  [riscv32-unknown-linux-musl.tar.xz]="54dab70b0b7dccc249e320271cd1fe1c550515b9686619901fcf03bcd52df133"
  [riscv64-unknown-linux-musl.tar.xz]="40b5c820b932dd8149df8548c62329e0b9dde4b7f0b977d30d060a467b90e8e8"
  [s390x-ibm-linux-musl.tar.xz]="846a5eccbe3a1b5ef1d990fa20ece787f3b62fb0cc866771d82386a22b6c11d3"
  [sh4-multilib-linux-musl.tar.xz]="ed4ccd166f45ed43aa7155a9f85e09a02627393b55146504932e3f8b035320f0"
  [x86_64-unknown-linux-musl.tar.xz]="7e311accd68ebf2c7be27752bc33f9976dd8baa4f8a14fd9232e2259f9b591c9"
)

declare -A HASHES_GNU=(
  [aarch64-unknown-linux-gnu.tar.xz]="bb70975694f0ca8cfe1839d76af58a61ee0f3c0745a5a785176866af83e5c14e"
  [aarch64_be-unknown-linux-gnu.tar.xz]="ccb6f13eac91518fd932330a42b2660e0d1c6846219ac9e02d128ba422bedd69"
  [alpha-unknown-linux-gnu.tar.xz]="994ad56126ad39547caa74bacf6085d0921b291cde05f81c8a3e30ce86216ad2"
  [arm-unknown-linux-gnueabi.tar.xz]="7fbf27ce387811b0736d037a4512cc6a25a2996f3499aaad981f16ec527d81d5"
  [arm-unknown-linux-gnueabihf.tar.xz]="779693df5e1fa27b23b2a896e2df873ddeb3e05a082452a5c67a5a45667e8719"
  [armv4t-unknown-linux-gnueabi.tar.xz]="ced45899dddd7cc610728139aab5d6b934638da01daea40a01b673bbd3b8aa99"
  [armv5-unknown-linux-gnueabi.tar.xz]="1d5dbc8d46c51e717fc80379523d523152ee8cfabc216f0baab267f17400230c"
  [armv6-unknown-linux-gnueabi.tar.xz]="17931189d4c59d30fdae92e4c8a20fb25596f541933101def60973604f60a8dd"
  [armv6-unknown-linux-gnueabihf.tar.xz]="9e15e10c8cf9d41c65b4ee45241f7f788a25c945334c10f535a70cfc316e0902"
  [armv7-unknown-linux-gnueabi.tar.xz]="bb729c7a4be35f8a3ddb96a17f44fca78e75c7942e55b16e7b2a0a9836848663"
  [armv7-unknown-linux-gnueabihf.tar.xz]="30c7519ca930924369613acf200de495039d619f8aaf44df3e0e3d29830e01de"
  [hppa-unknown-linux-gnu.tar.xz]="446bcd05e1c2cb3713c62643d729aa82c0e3a14696e1d914ac75646ea9c51fd6"
  [hppa64-unknown-linux-gnu.tar.xz]="3c67a610f117500c0ac254708dda98a230e5206711583f9b4472493fd6704731"
  [i486-unknown-linux-gnu.tar.xz]="a9883c907f08e904c7fd1317df8da205a2899fe1752b4ff5c26b89ee8e12dd67"
  [i586-unknown-linux-gnu.tar.xz]="9389c81ebd3385e133c92f54109e034dd109cb7705d893de7209aa07ca6708c5"
  [i686-unknown-linux-gnu.tar.xz]="c581f4176bc4a375ca81ad313d234c7c689663a54c044d2d7a3a1c5cd56e2d92"
  [loongarch64-unknown-linux-gnu.tar.xz]="f1477d2e4b76928036f9b0b1142cd9db7d6370e51979cc4ca5a230a663a849b8"
  [m68k-unknown-linux-gnu.tar.xz]="39122396b6e6d9548e157e7d55058c8c399a7ff8fdea211606497d7e2adfb383"
  [microblaze-xilinx-linux-gnu.tar.xz]="307cc9cf6ab77400c2237ba0c239fcab4095f198878efbbe3d9fbd6e6fddb9c0"
  [microblazeel-xilinx-linux-gnu.tar.xz]="4ef050b97a3494daad32f9e576ecba96ace4feb5ece4b117d4a6c937c5ccbcfe"
  [mips-unknown-linux-gnu.tar.xz]="9d4d6356ebf2864251a81eeab7f5f502e8e7333c8eb2e8a4894c4cd49720a4f4"
  [mips-unknown-linux-gnusf.tar.xz]="375dc18c1a5ccd8ec5378615d448e481b6b53a11676efeacae975324beceb542"
  [mips64-unknown-linux-gnu.tar.xz]="b98134f4767293eb37c666c850ff02f752de58e5c7c117c140057af8337d8087"
  [mips64el-unknown-linux-gnu.tar.xz]="535df001c4b50972662f94518e8f160b195c68df39b49cdeeb0f341bb672fcfe"
  [mipsel-unknown-linux-gnu.tar.xz]="bdde507af688262e1ccd6c8b87458185f3d948ca22a62ede83a708e6d14de619"
  [mipsel-unknown-linux-gnusf.tar.xz]="81b1b9fb94501d25594e95c93cfca07663f67476ff9bd25b882794155d42f8ca"
  [or1k-unknown-linux-gnu.tar.xz]="09116194e351fd33d114ac1b8e5561ebb54a85258d82833169f8faeea8f6fdb6"
  [powerpc-unknown-linux-gnu.tar.xz]="6041f3f37a6a239b405c405a0af6aaf0db6364fcda83b0f1159ffdc6642113cc"
  [powerpc-unknown-linux-gnusf.tar.xz]="2b75fef497a50ba4e47811a5a999db23c01437e89c12a1b231c11710c5465864"
  [powerpc64-unknown-linux-gnu.tar.xz]="eadaf5614eb55f5c3f5b8b0a4f782a157cc9e7440c65a0a93563459577b46350"
  [powerpc64le-unknown-linux-gnu.tar.xz]="1a87bf226993e204b12914e7895f332ea873805e30cba6da10d5fec904dc78ef"
  [powerpcle-unknown-linux-gnu.tar.xz]="ac7d0203fcd2e508c7963edebe35dd0f300b8413372c75e551cf4e5b41079443"
  [powerpcle-unknown-linux-gnusf.tar.xz]="c2eac195a90027f10f8112d575f90f1666e975efdeea0ee677f0c06e442c644d"
  [riscv32-unknown-linux-gnu.tar.xz]="785a51871c86f90bd5a3a9595ea0d03ce3dc960afbdcb7b4488c8b977214ee52"
  [riscv64-unknown-linux-gnu.tar.xz]="23cad6ea8052ce24f513bf414009bda2e7b077b50e7643565cc63cad27b08b7b"
  [s390-ibm-linux-gnu.tar.xz]="12cb08a24a08366d7638629d434816d46770779a16e02f56d465bc9de7186414"
  [s390x-ibm-linux-gnu.tar.xz]="30fda03ba20d805854d28ffdcc16bb83456f27b9d4396e7cf2e8431a0a71d147"
  [sh4-multilib-linux-gnu.tar.xz]="7a1224249fca585e95f815b8d89aee8ffb39c01ffb31bf53e12313bfb29ccc6c"
  [sparc-unknown-linux-gnu.tar.xz]="6cd5d959b5ae8129a244efe3c8b907a0aec8a3a954ffc552bbd8012a791f9fde"
  [sparc64-unknown-linux-gnu.tar.xz]="031a60215dab80db882257cea51b735a8d4638cc6eed323837dc9c9864fb0969"
  [x86_64-unknown-linux-gnu.tar.xz]="361ea63a0e32fac6a8ee46cb1be555f1af0d4a9b14113bfbc4f00633c74a96ba"
)

declare -A HASHES_CLANG=(
  [aarch64-unknown-linux-musl.tar.xz]="c38b7433b7ea4e348b91a103e8fc5f8f947c893f7f9814f8c7b87dd741175c15"
  [aarch64_be-unknown-linux-musl.tar.xz]="5060246b9bed259872476b6c8f785cc3a875db13b70ea598dbee89533e5bc6aa"
  [arm-unknown-linux-musleabi.tar.xz]="430d20cf69bfe9249b8e3451583b3a95ed12265cdb5275f1e78440aad7598870"
  [arm-unknown-linux-musleabihf.tar.xz]="5e7ad01c725b289818f6fdb7caf3c121ff95aa82d30c40b233e681bde657c6f1"
  [armv5-unknown-linux-musleabi.tar.xz]="047d3e78b57bf8eb6dcae7e556afe1565add242c41e3c32afc9550194f81f621"
  [armv6-unknown-linux-musleabi.tar.xz]="14e367979ffd7d34a503cea439608a941cb9e811768115e502ed0c7646c80128"
  [armv6-unknown-linux-musleabihf.tar.xz]="f8cd4eee3409d6b519ce9a4f6b0ae6f1eab70747e526f6bbbccb552c7203ac40"
  [armv7-unknown-linux-musleabi.tar.xz]="c875338770d6a1b38faf546b14e76e1ba3d0609d8b20d202ec9b7c9c85575c80"
  [armv7-unknown-linux-musleabihf.tar.xz]="3ab77246e854ca92146cb491413b22025632839582fce86d1119408d52470777"
  [i386-unknown-linux-musl.tar.xz]="1e1658e89dbe5085136b439f4e5647ceac24eeea0af60abc948b5e2f0308bd8a"
  [i486-unknown-linux-musl.tar.xz]="e1c0363acaabb7f9a5cd42847f52de50baa449843c8aeaf72040a8fefbad23be"
  [i586-unknown-linux-musl.tar.xz]="6e5ecad2c695590efa4b27b0a8870cbcc2e22a14b39b7d5e2278d63e6f2e6675"
  [i686-unknown-linux-musl.tar.xz]="cfdf9a756708ea89e6af83665f32a91c521d90a14c5193b6d68abaa2873bbbb9"
  [loongarch64-unknown-linux-musl.tar.xz]="c6f19c3bf1a524f5191fc2b180b8c9aad7467904a4e048fc415e1406010406c3"
  [m68k-unknown-linux-musl.tar.xz]="3f2d04cfcf8b6c620698e9bcf81f7994264366fa26a4ebdccf3552c3b5b753fa"
  [microblaze-xilinx-linux-musl.tar.xz]="10e120fd90affab03223202b76ce1a45ff09175959025438db7c4ebf76ba69a8"
  [microblazeel-xilinx-linux-musl.tar.xz]="41e66516d193c47f267bb21e7dbdbcaa7eb587b73176e2e016a3db835fe0346b"
  [mips-unknown-linux-musl.tar.xz]="0ffb8d593fa5a085a01bc84c2c09957cef293db234727ef25de656fcb0dd24f5"
  [mips-unknown-linux-muslsf.tar.xz]="1346bd957b55576a972d70351b8bf91b861108258d3ea49589ba9fab743834e8"
  [mips64-unknown-linux-musl.tar.xz]="87d12442d32791a1cfc7bb87c0f77e549b25bf5ce702b1d16faf503bfa6f0b5b"
  [mips64el-unknown-linux-musl.tar.xz]="429ff62e35e46fd7439d46b0bea1f522b3cfc479f1cd36a5e227b48ec2c86aff"
  [mipsel-unknown-linux-musl.tar.xz]="280b95679096acbcfee5ec8957f0e296d77679ed52e2e51a14e0dd16d289a45a"
  [mipsel-unknown-linux-muslsf.tar.xz]="e6083a46aabac2181cda029d7fcff40bb14d7c64fdcf091a16973e35b6f749a9"
  [or1k-unknown-linux-musl.tar.xz]="2eae046758f603641feb56e3cf31a9a60c5749b2c31d67fe8a25cc0b83a34db3"
  [powerpc-unknown-linux-musl.tar.xz]="6d67ee4ae4b9515e234a65f110080964389df2dc4cce9796e73be4145ad8f293"
  [powerpc-unknown-linux-muslsf.tar.xz]="a849bba814161fdf441f913df07542d8394026ddf54c357bd069e9c489ff5a70"
  [powerpc64-unknown-linux-musl.tar.xz]="7e1e357c6e4ac08194e24cc6fa6537439a5e730213481d68aafbce75e17b64c0"
  [powerpc64le-unknown-linux-musl.tar.xz]="25aa66393eff76a8f72b62b35f4b666d86b768e3d3b0b0758c3cdd8e9a260ba6"
  [powerpcle-unknown-linux-musl.tar.xz]="b4148b55ae476f4b023d4c9297b4bd6efe6c45573182f610ddf2c9451fbee9bd"
  [powerpcle-unknown-linux-muslsf.tar.xz]="dbcf12786a0a4ed12e47c218af04af0435d67657460898eb5af360b8255bddeb"
  [riscv32-unknown-linux-musl.tar.xz]="04eff3532b65ba2720b433acc62f3bc49723b7785a519e1290839ebde448b749"
  [riscv64-unknown-linux-musl.tar.xz]="1004009d7ac1139b5bf532d50cca3b10aec35606ec8160f15561220344594a6b"
  [s390x-ibm-linux-musl.tar.xz]="6fb31df86166d88c4cd027442080cba5d60cec722f35abcc8207e083a33087cf"
  [sh4-multilib-linux-musl.tar.xz]="07552dfb6b02098ec40bb75892767a5afe8d2af741f032f7085e3cd0bad63c98"
  [x86_64-unknown-linux-musl.tar.xz]="f3a7645600068a7e5a0ba87eaa37c79090466257ec067128a1dad89a554f3190"
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
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/garlicbread"
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