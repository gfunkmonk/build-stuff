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
  [aarch64-unknown-linux-musl.tar.xz]="83b8a87e8acb9c641eb9bda5a50caaeb0b937d4e8188fa56c993b63c8de4ac20"
  [aarch64_be-unknown-linux-musl.tar.xz]="bcdb676dbabce5f8e7692b5a697cdc880817ce8de38a3dde3382f7ad64765b0b"
  [arm-unknown-linux-musleabi.tar.xz]="b467d6e136745c19d083cff6630d917945151c48c015d10f19a6030fbc3b59cf"
  [arm-unknown-linux-musleabihf.tar.xz]="f2f453b7ba31401ea80fcef4fd04437405649c586ad8d6828e0765c6531d0f4a"
  [armv5-unknown-linux-musleabi.tar.xz]="80a295335a0fd68f730d0b99d2cc895ef1c48bf87abae61d78046c0121fa41fc"
  [armv6-unknown-linux-musleabi.tar.xz]="4c5486d4e74b763af73219e68524bd2411284f7d4d60d2ab88e50d9a6ebc2a77"
  [armv6-unknown-linux-musleabihf.tar.xz]="816e432fa4dc79fe7f217c6448a01aa345124a69d2887ee49b5a785e96667482"
  [armv7-unknown-linux-musleabi.tar.xz]="ed2831b67683dd501c894e1859cc65e2039e570d5ac3283fbbdd485a2082c5ca"
  [armv7-unknown-linux-musleabihf.tar.xz]="37e048c0d7d4feb26ccddaa778ff9037fb3181d162d0369ced25e6004d0ed056"
  [i386-unknown-linux-musl.tar.xz]="c37d933f64caacbcec9f4e2194218b6e6fde5be06c639a6154783729cfdd0d2c"
  [i486-unknown-linux-musl.tar.xz]="4f8f8c72220579bb00bc5c13bdac92dd7dc8bb40826817afea73c0b90dd2c1d6"
  [i586-unknown-linux-musl.tar.xz]="36ca8a9b0687f3af5fd6ad2fda92f89af4ad299e252f3dc03354c1ec572602dd"
  [i686-unknown-linux-musl.tar.xz]="bab5cefb328085668d7a8c8ce2a5d5b094fc2efa1fba4940f932ec89cd463e07"
  [loongarch64-unknown-linux-musl.tar.xz]="ec7e94b2cd64ca470f837654e77de7de895acbe685900ca62706fb90d284d41d"
  [m68k-unknown-linux-musl.tar.xz]="2a0076fddba1280ac41185c2b1087a9dcd9360d0dacf2409ba864401a665aad0"
  [microblaze-xilinx-linux-musl.tar.xz]="d1176a9a91cef711eea9d21ae60c7d40cbeb21b051aed9a269792086fbe5612a"
  [microblazeel-xilinx-linux-musl.tar.xz]="97a7c5a5343658f741e95871a6bb33225ad306f9badb26d898b8ba2b13d04df9"
  [mips-unknown-linux-musl.tar.xz]="28a73c72dc21d065a74603ec1c5e9e8bd068471a5c39954b71bf2cb21b1c5848"
  [mips-unknown-linux-muslsf.tar.xz]="0fc9526d57b388af55e18ddbbe789d237d107a625aeedd33b7fe1eaac91b19e0"
  [mips64-unknown-linux-musl.tar.xz]="714c394e34216e4178f034233bc37b4ac47b9038c3fd7adfed883c25d2c28fc7"
  [mips64el-unknown-linux-musl.tar.xz]="17672a707eb4b92675e82650eb53ffade7f41a1c800224ca58a3b7a7c2db51d9"
  [mipsel-unknown-linux-musl.tar.xz]="736bf482708fa34e755b8cd52522ec903dc65123601949d7708f1eb2e6c2bae2"
  [mipsel-unknown-linux-muslsf.tar.xz]="9eb1066939ac2e1d6b6a88d7a584d159ac4050291f8c8afbed0e0418d62e3674"
  [or1k-unknown-linux-musl.tar.xz]="57f6024ca56662df138a65e7ab2cf16321b8b9948bdf5653e85b4b99aff66ab0"
  [powerpc-unknown-linux-musl.tar.xz]="ba1f1ef1a10f4e12623b87d05101857a47c0a93795c22fe4da9cc1ae92e23bba"
  [powerpc-unknown-linux-muslsf.tar.xz]="3d7636c91b7a41eb4b393202b2fadf6a4466190df6bbcaa50d595f07abcb3b6c"
  [powerpc64-unknown-linux-musl.tar.xz]="643f80bfc578fea8fc5a86292f610eba3f5315a651303270c33e12e2403d1910"
  [powerpc64le-unknown-linux-musl.tar.xz]="37efac6014836822fb1ba5d931d4770b2e34c843b97aec68c47026951d102fa3"
  [powerpcle-unknown-linux-musl.tar.xz]="889176b5d70296d2f21539cc6812bcad54b90b57db089858eb7dfbcc68622e35"
  [powerpcle-unknown-linux-muslsf.tar.xz]="7908b68b319ddbc04ad50624bb8ac72a2c0788c0c930de69fa0b0f1500524a11"
  [riscv32-unknown-linux-musl.tar.xz]="3f57227f991b69f55fb7239673149dd3eacd6a554758f32a6651eb1999edad77"
  [riscv64-unknown-linux-musl.tar.xz]="bb5d9a117d663a669b9e6796969d5ffcef0efcd75aa448116592555663a7f3d7"
  [s390x-ibm-linux-musl.tar.xz]="d1e5a3d7f7e7e897bdc3bed6b6b8fde3fcdcf3331c1e56f9b82d2103adaf47c3"
  [sh4-multilib-linux-musl.tar.xz]="1a0003f49fe28f800e825f04f027028bb1e6a61846fdbd52ea1eeeea14d8d8a9"
  [x86_64-unknown-linux-musl.tar.xz]="87ce4ec807ce3760cd92faf91d4da3cc92676fb754cb4526a7ebe4339f9645f1"
)
declare -A HASHES_GNU=(
  [aarch64-unknown-linux-gnu.tar.xz]="f5e019ef8594cc4183afefa2a927797e536bbb53391a83487529e2227585d838"
  [aarch64_be-unknown-linux-gnu.tar.xz]="790bc9ae99f768003dfc52065d81c2c49e5469b98be977218c20144e58244e80"
  [alpha-unknown-linux-gnu.tar.xz]="11f5863b9cb5993c215269e72ecb94e2bd836ab941c714937e7973d3c8a06969"
  [arm-unknown-linux-gnueabi.tar.xz]="f8c3abea55796f14f15b4b53da7b844b78156d79c10cd2627ede1506238ade25"
  [arm-unknown-linux-gnueabihf.tar.xz]="8244dce08c8fbdcd53ed2ba3c95814a5a5d3614da30114cde71930789d028dd1"
  [armv4t-unknown-linux-gnueabi.tar.xz]="3e2d418a54205364dbbb70c1c7236184bafe1570a200f127eec1abd99d2ad484"
  [armv5-unknown-linux-gnueabi.tar.xz]="999cf94deb87eae04769a6e782d8e2ab01613a4284f6d7b17e3971004ac46e45"
  [armv6-unknown-linux-gnueabi.tar.xz]="1dd783b256754ce1b18588a3567212f055e9fc47bb7d947104f883819a21fb83"
  [armv6-unknown-linux-gnueabihf.tar.xz]="3b496bf9e2b8330c3efd966ab9963cc229ef3ba911594d744fd2cb15d9aa4e65"
  [armv7-unknown-linux-gnueabi.tar.xz]="2694e5cbfcea52bd19ad8ae28a9375bd8cdcb969809dcc12f412a3e6b6a37cec"
  [armv7-unknown-linux-gnueabihf.tar.xz]="8cba4749fd24d1333f68ff4f3d17a693dab10efd717d2fc8a13ae1011d9285f4"
  [hppa-unknown-linux-gnu.tar.xz]="74c899c4b3785355544c4d40be4b6df6d7868d6d91633a281435a87c8eafbf1c"
  [i486-unknown-linux-gnu.tar.xz]="7e25e4ba27b7f6f4b30716184886d1aa61cc4620afe5eb9755696dbb95e76930"
  [i586-unknown-linux-gnu.tar.xz]="53f9d94abc969a613686856e79bdc9b732318efa931a9649175194de837398c6"
  [i686-unknown-linux-gnu.tar.xz]="1c01328ddace179743c489b148dd56cf521da637575173103e41415110704f00"
  [loongarch64-unknown-linux-gnu.tar.xz]="cdb47c99b99f68e5b90149152a828f639f231fc7c72f18681550e5e29cbd1f87"
  [m68k-unknown-linux-gnu.tar.xz]="72ce2cb8201c5f38c262aa7344e4d0d2c6c5fba53b9f0b6f90d41b57f8e60d9d"
  [microblaze-xilinx-linux-gnu.tar.xz]="5fc0cfd76122d6bd78a60037a39fad9a0c5694a5f90335f0474dbac2e422a72b"
  [microblazeel-xilinx-linux-gnu.tar.xz]="0863311b0e98616ec1a4e0448f77bd875c9a82d336c0ec28d01636f1ed4778d4"
  [mips-unknown-linux-gnu.tar.xz]="2b92b5e4e9fd490c3e7d963adf54187cfc1a7ff388703e192df955fe88f5c9d3"
  [mips-unknown-linux-gnusf.tar.xz]="bc0adc77b2354b20836c89cad64db2c5cb89d16e2066f8f03091ced63399e022"
  [mips64-unknown-linux-gnu.tar.xz]="47eefbe63c6f59e24ec31488452db395df8e8c5c1db5b9af55d37464a7891feb"
  [mips64el-unknown-linux-gnu.tar.xz]="435781f9219239c07d73ce51b858386cfce3302148b54670a4b6736d85a7b11a"
  [mipsel-unknown-linux-gnu.tar.xz]="97788146470110575d416a95562ecb6399938e2be82073f90db5865b6878235a"
  [mipsel-unknown-linux-gnusf.tar.xz]="feeb3179e23da42d71e58d5585731243f6c7f09a3419498d4fe23566f84da0e4"
  [or1k-unknown-linux-gnu.tar.xz]="bcabd209fe18826a828a0f6da168b3bed230c444ca50f841bf56ae6fd2efe41a"
  [powerpc-unknown-linux-gnu.tar.xz]="6fffa3a056555e682c19d8cfa917f59f82ced8a70766e0c32847697046e0f4dd"
  [powerpc-unknown-linux-gnusf.tar.xz]="e6b4cb3a1516986f58aa6c0eeecacd427e97d886b0699bc3c9c7371ed24eec1b"
  [powerpc64-unknown-linux-gnu.tar.xz]="cb62c65d9c63264bf8a2f6d7e388c2f6440c46b5c40a9e5bc60a0f73d0e405bc"
  [powerpc64le-unknown-linux-gnu.tar.xz]="7ec1dc868f854d5010069caad2f6ad007dae79c7ff6ed8639478e6fbf3e56f90"
  [powerpcle-unknown-linux-gnu.tar.xz]="aa5d1f928352d0f10694b4ba112f51ae4fd8f6ee072dbd3a8aae74ea06f3f515"
  [powerpcle-unknown-linux-gnusf.tar.xz]="69f86c35a21e1249c1f99498b2527893d3706504416ce73c4e448058229b8408"
  [riscv32-unknown-linux-gnu.tar.xz]="11fa165f6c2dc44416185e036751c859c0529063a02fc180e019f7ccfc80233f"
  [riscv64-unknown-linux-gnu.tar.xz]="0f52a656ad776ad32a21ce271aa84da4ce004401363215d43805b0e167589dca"
  [s390-ibm-linux-gnu.tar.xz]="763bd47faa5a2c2eb72a7d6dde021b73e7c45278165c2c9195a090b548507abb"
  [s390x-ibm-linux-gnu.tar.xz]="13dc4b91076dc1e6304d88ee280b86e53bf4f3a1a7386ece7896ffcefd11e72d"
  [sh4-multilib-linux-gnu.tar.xz]="07224613c2008dafbb3f7dc4cf255336dd64dd444ddb7a6984de2d4b99e03715"
  [sparc-unknown-linux-gnu.tar.xz]="15a575946fd27f5fcaa8c517993abd9bf0d8fa7ff09b2dc6caf118ce28fd8765"
  [sparc64-unknown-linux-gnu.tar.xz]="d55f22e880784b5f321ba1af2b9b16b93fbf78457b414e04724ea662d2c67efa"
  [x86_64-unknown-linux-gnu.tar.xz]="445ea531f9775faeb0f884fa5e10af2f4d39de04782b4507f1841a72a4c15f93"
)
declare -A HASHES_CLANG=(
  [aarch64-unknown-linux-musl.tar.xz]="a1d6c627640b73c5d8a117cefe66e59e55b08c45fee1be6948a27d6dbabfd495"
  [aarch64_be-unknown-linux-musl.tar.xz]="fef16858fbd5d926a00b972f9d4d19bbb89a59863eb782de1a15c2507908dc3e"
  [arm-unknown-linux-musleabi.tar.xz]="8bbfe8f47c5f5b18089ff125a81ee4944119b5bca4530bd5714357dda7e283f1"
  [arm-unknown-linux-musleabihf.tar.xz]="f37b3d64c34cbdb5f58128a140c16fda5c2273c2c76c5ee5a73048e97ecc6c2e"
  [armv5-unknown-linux-musleabi.tar.xz]="2be257056a3127b10c0df731073290eac72d6aa4cdfd615a9872fe6efc3512da"
  [armv6-unknown-linux-musleabi.tar.xz]="61e0fa10a2a642098005f22b40687367047b0f79fff350959a8774e4cbd43e30"
  [armv6-unknown-linux-musleabihf.tar.xz]="6a6a34926eef94cbacb993469052ecdaceed07422e0af21982d3ffbd92d55d72"
  [armv7-unknown-linux-musleabi.tar.xz]="0bbf7023357fd951176f184daab9f7f7fc37d4e4c2ad2b7ebac529414592c899"
  [armv7-unknown-linux-musleabihf.tar.xz]="e84d610adc936f4c9d71063ca9bf9e1a91ac407388471337a6ddf425face3950"
  [i386-unknown-linux-musl.tar.xz]="aad66a6cda9ee33d2e06ffb95a223c034af943a7d98e1a545d7b8c2992434ac9"
  [i486-unknown-linux-musl.tar.xz]="f5d46ccfb8554534f4f0df7d596d5b5c44fcf525821eb5bc64510e8573cb88b7"
  [i586-unknown-linux-musl.tar.xz]="b7d8056a9f719d819a2a3899ad2d0ee1b48fb5a6e37e08e9e3f71805dc2ae83b"
  [i686-unknown-linux-musl.tar.xz]="229eef8c4a700d9c20229e5b1cc0531974b5d7b864fcb6682e2c4f34b925baf0"
  [loongarch64-unknown-linux-musl.tar.xz]="f47a979c040a883f17516351d881f3b0eda93f810445ca53561892785327bfb0"
  [m68k-unknown-linux-musl.tar.xz]="1d60f5d1969716cb6a576f9edf50198bbe543275fde725c72a244615f23ad8ec"
  [microblaze-xilinx-linux-musl.tar.xz]="f1e279c3c2403cb64da13fd88a3ff50fcdd7c7d68b27cc1ec0487378456dbf64"
  [microblazeel-xilinx-linux-musl.tar.xz]="5162ccb5b3f660953d6e5214eeea1cc3f94d5b9d68ff00b62802dd4a848a6bca"
  [mips-unknown-linux-musl.tar.xz]="3880bf013ca78b59f49309d23a46639fb89b0f085653dacb398e8ad7cc5b97a0"
  [mips-unknown-linux-muslsf.tar.xz]="ec89915667d1a405fa244f171a433b7d83ca55b42d197d91bf99a96a18fc3087"
  [mips64-unknown-linux-musl.tar.xz]="7e30ab2edbd8fb12d70fccb2202ddb1539cbb3ddaa5db049f0b0110605f24783"
  [mips64el-unknown-linux-musl.tar.xz]="77485160b1a20af686c76ab151a7da58c18d68c58fa93aa8b484e67b71801b35"
  [mipsel-unknown-linux-musl.tar.xz]="2a20b71b18ee33ab46758bf306bc819b5457fa34dd62dbf4c73fee3f79776741"
  [mipsel-unknown-linux-muslsf.tar.xz]="9a9cb6146847d28134127cb6c6e87f8142688339c31da931593ce5d3651279fb"
  [or1k-unknown-linux-musl.tar.xz]="ab05114794e420119f9a4331aa8bff106f8d35bf8cc29abb6f9630b4202a917c"
  [powerpc-unknown-linux-musl.tar.xz]="e5bfe858007590c696f2da65f3741484b6f76e764c47ed3a1a5e8841ad34e4ba"
  [powerpc-unknown-linux-muslsf.tar.xz]="b1ff2c05ecdbcf50bbd9224d94f129e09d0b4e515d62ec6420ec138f18823974"
  [powerpc64-unknown-linux-musl.tar.xz]="0c4c8d52e71f1b221fd00c81234501e7da33e70da504d3e8befeb883dde728bf"
  [powerpc64le-unknown-linux-musl.tar.xz]="6d726a91c1ffe1bb079f333243e3a80045ef690bf06b97de08e948c26a134e6c"
  [powerpcle-unknown-linux-musl.tar.xz]="2c706ecd928db0e5cd965b61f17825f56e9ea888eb3253acd7734cfffdcfa43e"
  [powerpcle-unknown-linux-muslsf.tar.xz]="37411728965762c6ff5d122bc74def30cfbb094476fb20986fbfcedbc699093c"
  [riscv32-unknown-linux-musl.tar.xz]="85c1ace132f6a2ed73b5c8404a56b641ae7209cebc79319d36055f70b7936b56"
  [riscv64-unknown-linux-musl.tar.xz]="6ad9b5a58305b4869b3cce72fb2529bc448d7248850d2974485a374d4b3887ed"
  [s390x-ibm-linux-musl.tar.xz]="5c9800138c0f7763082d9558179cc43cba8e571535b373eb2ab34cb511e71f84"
  [sh4-multilib-linux-musl.tar.xz]="a5ec73e1becb01dd8ad1c5483af7d5e24be417fa9821efa28cd848a6b9facb38"
  [x86_64-unknown-linux-musl.tar.xz]="6dbf4c0aea19fa11a6a9bd381afc56387545b8aad4094f3fda0ad2a67834e0ce"
)
declare -A HASHES_UCLIBC=(
  [aarch64-unknown-linux-uclibc.tar.xz]="19ada2bbe8f0bc660aaa77eaef8e17ee7c5db3ee2b5df1c12a4c9879bbc45a91"
  [aarch64_be-unknown-linux-uclibc.tar.xz]="5b3542ae07d68da8ba9afe08fb12ad3df43699b66b0612f21695e5cd187ff0eb"
  [alpha-unknown-linux-uclibc.tar.xz]="39dbaaf1f0dc36efc1b2ff92a129338fb2d7778de57b214bd19175db08ee6f0b"
  [arm-unknown-linux-uclibcgnueabi.tar.xz]="f760bd03d25727ab4418b77effbb24fec1c3325129411a2644bf6e9db35f293f"
  [arm-unknown-linux-uclibcgnueabihf.tar.xz]="c584f87fdcdda62aa0145a8d0cfe247e7f4e1866756b1ff6059e55268e1a59cb"
  [armv4t-unknown-linux-uclibcgnueabi.tar.xz]="ba6f6e6d466b0c25492ff476dd945364b6a3cad18bd5248b9bbb43d66d9a90da"
  [armv5-unknown-linux-uclibcgnueabi.tar.xz]="9b0bba88f8206a5e4b3f3d5162f9ed836d1c0da2da459d2f6e85b1221cf624be"
  [armv6-unknown-linux-uclibcgnueabi.tar.xz]="0c5b90532d4de3fadb053c4480628f4c237be1412a11c16d83a4c0c230ea49b8"
  [armv6-unknown-linux-uclibcgnueabihf.tar.xz]="971fc89ab688f9162a47cfd289bd08cd9f868fa1d8dd4b298f23087684095df2"
  [armv7-unknown-linux-uclibcgnueabi.tar.xz]="97e32b51935d9a52c1b189bcd6325dc255b18e28fb40f142066a72c4c9626725"
  [armv7-unknown-linux-uclibcgnueabihf.tar.xz]="681f87109e01282c1da2d7b12f636bb2e1e47b5f8e8ba353f5a45f9cadc50a79"
  [hppa-unknown-linux-uclibc.tar.xz]="81f7a1b180c423f861feed97876a0a71f0747cb1b9fc83273e289ee37cab31c1"
  [i486-unknown-linux-uclibc.tar.xz]="862ac667e8cc93eeab69731c40bbc7dec969cc95e8bd85d59b65db3b4420aba7"
  [i586-unknown-linux-uclibc.tar.xz]="5cf3b26038d2ecddffc2776fe35736851c0d7fcabdeb9b0ef986b4571d405ea6"
  [i686-unknown-linux-uclibc.tar.xz]="019e34db1e79db61f1f62387a47464c441de08c90df5bb5fec607d94f4b19040"
  [m68k-unknown-linux-uclibc.tar.xz]="f25d765bf892328a7e42b97f2e3af2a1532e085b61b5672a3d7ff04a75549e59"
  [microblaze-xilinx-linux-uclibc.tar.xz]="8eb6ed069f20aada0bd3d3050a48b3dcd24ec742ce073d4ab4d58d16f5f77891"
  [microblazeel-xilinx-linux-uclibc.tar.xz]="84bacb532af1d708e50f5f14e9d57b17ebeff24a8e2a65f8da722f4672a232be"
  [mips-unknown-linux-uclibc.tar.xz]="489152b7889e3597ba5e6d6db01664c6b62cc68407c45fe3622f5280b4f779e4"
  [mips-unknown-linux-uclibcsf.tar.xz]="f469f9c000117e0d1fdcb1128f53ee3e50f507c1b82fbe40e3266d2588e0232a"
  [mips64-unknown-linux-uclibc.tar.xz]="3ca12402eb7b66c624763d476e751d01813b1711a0765e520dd8bc62445925f8"
  [mips64el-unknown-linux-uclibc.tar.xz]="f7a4efb3793a0fb64fbb10646d208946c8bed40423daee242b3e2385d80092eb"
  [mipsel-unknown-linux-uclibc.tar.xz]="fbfe36b6dc685ecd405510390b5c475bdb5f2bf846079f5048e23734c5250076"
  [mipsel-unknown-linux-uclibcsf.tar.xz]="ae0d04d52ba6819b69797ad9bb47fb781829f4093a0841a67da1b72ae2f303d8"
  [or1k-unknown-linux-uclibc.tar.xz]="337f38686f2b966c5c3458471e993ddae27b004ab1f53acc15d28579f5b32f73"
  [powerpc-unknown-linux-uclibc.tar.xz]="f69e9586448320cfa7fe6d2b9bd2cfcb07677f92fec86d36dae49c3d2bf43350"
  [powerpc-unknown-linux-uclibcsf.tar.xz]="5b4c1fa8aea992dd24b217feb0760fc1083be5dde14e72b5587a716eda53de37"
  [powerpcle-unknown-linux-uclibc.tar.xz]="11d72990861bad74c8a39f09ec6f7afc9ed7a23d30458c2810b42bbd6bb6c346"
  [powerpcle-unknown-linux-uclibcsf.tar.xz]="e46cff38dfe51834fd4f84cd8a0410194cdec1e25ff3106caa42e497546c5d3e"
  [riscv32-unknown-linux-uclibc.tar.xz]="b6da114df4e3ba1beb2b4ad115386db6f8394ee8800d50af355e73b05e1a887e"
  [riscv64-unknown-linux-uclibc.tar.xz]="67c21bff978b76d1d3d96874368474d017517bbe949826f0ca5706329eaceaff"
  [sh4-multilib-linux-uclibc.tar.xz]="22eba0333fb7e78edcf17120896dd65a0105cb9b0711dc12059c993b34610efe"
  [sparc-unknown-linux-uclibc.tar.xz]="7d6431cacc0445c7ff09c7fd72e2a1c144b2a2285b89f74a5983ffd4250650f3"
  [x86_64-unknown-linux-uclibc.tar.xz]="6cffc7db5d87d5631235199e9864f7ccba1d65895b98c7d2c46f146968c6aeb7"
)

declare -A HASHES_WIN=(
  [aarch64-w64-mingw32.tar.xz]="047ac3c19777c13d9023aad9414b1140067d309f98d59cab9c5e9e1eed1b02cb"
  [armv7-w64-mingw32.tar.xz]="4495e719dd2ef9f2e9d5e2e85c9778f814dc17bf1c44a25a9f9e54232d32665f"
  [i686-w64-mingw32.tar.xz]="01f51db17308988ce6aa994f7fb180ab573ea5fc74cf0afd05b53ddfd9fe02bb"
  [x86_64-w64-mingw32.tar.xz]="e4a5d08c7979d710399fe17f69c944b2f969fa7ca51758b763534ec32c525a63"
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
GCC_RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/emotion"
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/weakness"
GNU_RELEASE_BASE="https://github.com/gfunkmonk/gnu-cross/releases/download/pizza"
UCLIBC_RELEASE_BASE="https://github.com/gfunkmonk/uclibc-cross/releases/download/baseball"
WIN_RELEASE_BASE="https://github.com/gfunkmonk/win-cross/releases/download/Hydra"
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
    elif [[ "$COMPILER_TYPE" == "win" ]]; then
        RELEASE_BASE="$WIN_RELEASE_BASE"
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
        --gcc)       set_compiler gcc;    COMMON_SHIFT=1; return 0 ;;
        --clang)     set_compiler clang;  COMMON_SHIFT=1; return 0 ;;
        --gnu)       set_compiler gnu;    COMMON_SHIFT=1; return 0 ;;
        --uclibc)    set_compiler uclibc; COMMON_SHIFT=1; return 0 ;;
        --win)       set_compiler win;    COMMON_SHIFT=1; return 0 ;;
        -r|--resume) RESUME_MODE=true;    COMMON_SHIFT=1; return 0 ;;
        -j|--jobs)   JOBS="$2";           COMMON_SHIFT=2; return 0 ;;
        -a|--arch)   USER_ARCHS="$2";     COMMON_SHIFT=2; return 0 ;;
        -C|--clean)  clean_workspace;     COMMON_SHIFT=1; return 0 ;;
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
# Failures are collected and reported at the end; a non-zero exit is returned
# when any arch failed so the caller/CI sees the correct exit code without
# short-circuiting the remaining targets.
build_all_archs() {
    local failed_archs=()
    for arch in $ARCHS; do
        if [[ -z "${ARCH_INFO[$arch]:-}" ]]; then
            echo -e "${NEONRED}Skipping unknown architecture: $arch${NC}"
            continue
        fi
        build_arch "$arch" || {
            echo -e "${NEONRED}❌ Build FAILED for: $arch${NC}"
            failed_archs+=("$arch")
        }
    done

    if [[ ${#failed_archs[@]} -gt 0 ]]; then
        echo -e "\n${NEONRED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${NEONRED}❌ The following architectures FAILED:${NC}"
        for a in "${failed_archs[@]}"; do
            echo -e "  ${TOMATO}• $a${NC}"
        done
        echo -e "${NEONRED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
        return 1
    fi
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
    elif [[ "$COMPILER_TYPE" == "win" ]]; then
        expected="${HASHES_WIN[$tarball]}"
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
    if [[ "$COMPILER_TYPE" == "win" ]]; then
    local machine; machine=$(file "$bin" 2>/dev/null)
    case "$arch" in
        aarch64)       expected="PE32+ executable for MS Windows 5.02 (console), aarch64" ;;
        armv7)         expected="PE32+ executable for MS Windows 5.02 (console), armv7" ;;
        x86_64)        expected="PE32+ executable for MS Windows 5.02 (console), x86-64" ;;
        i686)          expected="PE32+ executable for MS Windows 5.02 (console), i686" ;;
        *)
            echo -e "${SLATE}  (no arch mapping for '$arch' — skipping verification)${NC}"
            return 0 ;;
    esac
    else
    case "$arch" in
        aarch64)               expected="AArch64" ;;
        armv[5-7]|arm)         expected="ARM" ;;
        x86_64)                expected="Advanced Micro Devices X86-64" ;;
        i[3-6]86)              expected="Intel 80386" ;;
        mips64*)               expected="MIPS R3000" ;;
        mips*)                 expected="MIPS R3000" ;;
        riscv64)               expected="RISC-V" ;;
        riscv32)               expected="RISC-V" ;;
        powerpc64le|powerpc64) expected="PowerPC64" ;;
        powerpc*|powerpcle)    expected="PowerPC" ;;
        s390x)                 expected="IBM S/390" ;;
        loongarch64)           expected="LoongArch" ;;
        m68k)                  expected="Motorola m68k" ;;
        sh4)                   expected="Renesas / SuperH SH" ;;
        or1k)                  expected="OpenRISC" ;;
        sparc)                 expected="Sparc v8" ;;
        sparc64)               expected="Sparc v9" ;;
        hppa)                  expected="HPPA" ;;
        alpha*)                expected="Alpha" ;;
        *)
            echo -e "${SLATE}  (no arch mapping for '$arch' — skipping verification)${NC}"
            return 0 ;;
    esac
    fi

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
    ls -F --color=auto "$OUTPUT_DIR" 2>/dev/null || echo -e "${SLATE}  (output directory is empty)${NC}"
}

check_static() {
    if ! command -v readelf &>/dev/null; then
        echo -e "${SLATE}  (readelf not found — skipping static check)${NC}"
        return 0
    fi
    local found=false
    for bin in "$OUTPUT_DIR"/*; do
        [[ -f "$bin" && -x "$bin" ]] || continue
        found=true
        if readelf -l "$bin" 2>/dev/null | grep -q "program interpreter"; then
            echo -e "${NEONRED}⚠️  Warning: $(basename "$bin") is dynamically linked!${NC}"
        fi
    done
    [[ "$found" == false ]] && echo -e "${SLATE}  (no binaries found in $OUTPUT_DIR to check)${NC}"
    return 0
}
