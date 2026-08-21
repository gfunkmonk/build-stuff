%2#!/usr/bin/env bash

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
  [aarch64-unknown-linux-musl.tar.xz]="21c34d7676d81b294bd207d8d741fb4901e8a8e65ba80c1afaca94003b091421"
  [aarch64_be-unknown-linux-musl.tar.xz]="5de11569acfc7df8ad2a9ad7572bcf665d227df56e0c8c63183f78aea5bcf3d6"
  [arm-unknown-linux-musleabi.tar.xz]="05cf8034420321ae0daebb36b57464b84cd6d2e8d002efbe6899c17df2e3d737"
  [arm-unknown-linux-musleabihf.tar.xz]="3c87909196d56d01049ef408c0b9b446a869f529159328ddc8495ab82b41894f"
  [armv5-unknown-linux-musleabi.tar.xz]="0b3a694950b98eb5d116e451ca6ed99953be7ff1fd21f4594d1d85457f47c1b2"
  [armv6-unknown-linux-musleabi.tar.xz]="af91799d6a5adf6135820ff13e4f1ba02fe30a2ae8c4c4da62c3b966b0639227"
  [armv6-unknown-linux-musleabihf.tar.xz]="32b393585c787a1bc6e54b40b6524e7c8cf04857d076688248e4e5e532ddf149"
  [armv7-unknown-linux-musleabi.tar.xz]="caca1d75b8474a815392c4ad689ac30843662ff645255605da1a69826e0821b6"
  [armv7-unknown-linux-musleabihf.tar.xz]="8b9a8185ecf48420a8f9850b471cfe955eb5aad26cbafc320e9e15419a2aee8f"
  [i386-unknown-linux-musl.tar.xz]="23d70e29c86f3c9b1e41a870403226463183611aec4269afaef1e4c0fe784af8"
  [i486-unknown-linux-musl.tar.xz]="ae76a01ccdc295b988547fb710af7d35614c187428a9dbca9873468e9203a929"
  [i586-unknown-linux-musl.tar.xz]="a65895df8f6038c7d44e0b9b2b4fcb245a962f1dc42c9875f93693a64a38150a"
  [i686-unknown-linux-musl.tar.xz]="0a592bd7b736fa1109474f2a0f151efa136e6693d3e2ad6c035817bc4f2799b5"
  [loongarch64-unknown-linux-musl.tar.xz]="7b6bcfcfaf7a92ac06e4e71bcd612cb09705ecfa7a9de35767bd3873b4ca1934"
  [m68k-unknown-linux-musl.tar.xz]="770fb3c8b041794570a54a4fee0b62d04ac6322c015663d42ac7a95fd9162da5"
  [microblaze-xilinx-linux-musl.tar.xz]="8a4f08b2505192ca4005907af33902257c16a3cbb0d7ece72afbbe505c4c82f2"
  [microblazeel-xilinx-linux-musl.tar.xz]="e4a106d1eb3f826a8fd7aaf553d99e6c35380dba29edb1b2733a9cd1a9b8ca5b"
  [mips-unknown-linux-musl.tar.xz]="462f72a697f92a1ae5aa64b993f10b508d1529d9df96003a0d03780f8f7e1516"
  [mips-unknown-linux-muslsf.tar.xz]="58fea0b232aa31b3ecab2569819bf516ae83dbba7fde8892ad70a1955622205f"
  [mips64-unknown-linux-musl.tar.xz]="49a3689ffbd6d23152d6adf58bb34f138344d9f16105f58990abca63148a8967"
  [mips64el-unknown-linux-musl.tar.xz]="583bcd1e9d61cdffaa4e80082f277ad05ee908096f7b08050270226807ea97d3"
  [mipsel-unknown-linux-musl.tar.xz]="88d229a6cbd5c6061f3965295b868423f0e0d402d0e9ecc731f384deb581039d"
  [mipsel-unknown-linux-muslsf.tar.xz]="6093877ba85fc88f04801cc8021d4d5604b1abd2fa853155e4fe72c749bb69cb"
  [or1k-unknown-linux-musl.tar.xz]="86957da8f6e4b16ec2e6b48159d3285a921ed88bf2b73b2619365b588f1df535"
  [powerpc-unknown-linux-musl.tar.xz]="f715917a75c6946d9eef4c1e6a65eb43a96aa6d1ff1d4d2b6a534b41ac130052"
  [powerpc-unknown-linux-muslsf.tar.xz]="07261e9e9240ea225ccca160479837405b74cd9cd4239b5caa1fb176134ea926"
  [powerpc64-unknown-linux-musl.tar.xz]="5266bca88aedd6feca5b9fad78260c233a706eb4c4eac3220bac6174518448a2"
  [powerpc64le-unknown-linux-musl.tar.xz]="88ee38ea34d1cca85447f0b6d01002744fbeb5526149312e28eacf9775b77e8b"
  [powerpcle-unknown-linux-musl.tar.xz]="7150fc0b137e7d3700142f9c55553fb0c9584b3cc920898f4e49d90788dc0019"
  [powerpcle-unknown-linux-muslsf.tar.xz]="b7d93f9472d9577c1a80a863d73eb52029a35f944b22be592ab0045d4d0de713"
  [riscv32-unknown-linux-musl.tar.xz]="be9c5fa96851b4f966b9df6bf5adb5f07dcf05abb7f001ac36c55a19aafd82a1"
  [riscv64-unknown-linux-musl.tar.xz]="361592696908ea639c3937bebe5f5f5cb3ccee586a9fca6ad767d9ed94b7ac39"
  [s390x-ibm-linux-musl.tar.xz]="56fcd24732e0ca32718700747683b8de3cbac7bb6498267ae3d5963e88c3d945"
  [sh4-multilib-linux-musl.tar.xz]="e24f96b1f418cf97ddffd84083bfdc09e57cf507c1fa9a528de1dc1e270c00e6"
  [x86_64-unknown-linux-musl.tar.xz]="fcee2e1d4080e28017f57dcebe5d07505d6cf5119e607c12c9814d34e57c9bbc"
)
declare -A HASHES_GNU=(
  [aarch64-unknown-linux-gnu.tar.xz]="9a10a1c053f38c7b6a7da1ba7709c298c5a093c8fa2516026bc85fad603a1b87"
  [aarch64_be-unknown-linux-gnu.tar.xz]="442e8274bf2b7b7c68bc5fb54644a6b04f410ea6da981b28d9dab69b7b5b68d3"
  [alpha-unknown-linux-gnu.tar.xz]="94f8caef8505fd461ef292a933dfc46ee1f2033ab02ddf58409664a782eac6d0"
  [arm-unknown-linux-gnueabi.tar.xz]="09abaeb6ecd47feec5894ed963e8e6d1aa7f3219e3d3c2bfca7252edfe797e55"
  [arm-unknown-linux-gnueabihf.tar.xz]="384723c1f94cf16f472c65e9a683d0e97878ae89892f13540eeec04044214162"
  [armv4t-unknown-linux-gnueabi.tar.xz]="31cbedeea3b314a8e6b7c3652ef0b15455e66ce8d9740c1cf8146dfc0b22beb3"
  [armv5-unknown-linux-gnueabi.tar.xz]="d39a2ec73c3256f79ccdcb410c9a75c10488dd4b3cf64be2798b1f678a19f725"
  [armv6-unknown-linux-gnueabi.tar.xz]="184ea5cd7adc8aafbcb82cc2d300ae65aa7de2c67213c96aecbbd4f08e599b5a"
  [armv6-unknown-linux-gnueabihf.tar.xz]="1713176ce52d9e5a86e1069e1f7de1af2d6cbc08cab61dff2aaac0a954a1be98"
  [armv7-unknown-linux-gnueabi.tar.xz]="c9b925f3094bf6909e609b969fb857bceada58fb9d44a2031ed06c37a642be54"
  [armv7-unknown-linux-gnueabihf.tar.xz]="b98d62ab43dbcfba48b16a6edbe37a344b98bb01ed0375978756d44f277a5e90"
  [hppa-unknown-linux-gnu.tar.xz]="2f01c9600946ff661bc83e88ba329008c562200ced5d895c4f1f574d3dbce36c"
  [i486-unknown-linux-gnu.tar.xz]="ce45b98505b232ab9d5725b95dabeceb0e4cbb705d04143837d6c2084e220e78"
  [i586-unknown-linux-gnu.tar.xz]="845eb244533c9598b162cab93e34c4112e54dffe1300618b9dedc681d7325fe1"
  [i686-unknown-linux-gnu.tar.xz]="1d8a3f53ad15296bd63c7c78543de0ccbec1aeb52264ea907a3848f0417e95ff"
  [loongarch64-unknown-linux-gnu.tar.xz]="cfcfe2050adb76952283c9edc01809e1734919de9930b57cbcba8ddf29c34c3b"
  [m68k-unknown-linux-gnu.tar.xz]="bdf770b5fa16140bad308532cdf1b4d2dc8588f5a32133c6800a1d0bf211b769"
  [microblaze-xilinx-linux-gnu.tar.xz]="0e327b9490c971756bc07411022be4656cdd96726f9abe2374ba5d9447dab7f3"
  [microblazeel-xilinx-linux-gnu.tar.xz]="fa6f78c3d7c13fe548e1a2f6a804627dfd2398191522d60bed0c8c2d075f244e"
  [mips-unknown-linux-gnu.tar.xz]="02a936bad9f03f2027cdb1ae0349f7a063a408887e72eb53c98f848a5443104c"
  [mips-unknown-linux-gnusf.tar.xz]="6e62f8c2deeffb7f6a5df46128d457edf8b4014bde4d3c736cdcf7b1583d1e96"
  [mips64-unknown-linux-gnu.tar.xz]="78d6af3e442fe90c8174abd7900a875764128f144a7ebf3e860931ac10971105"
  [mips64el-unknown-linux-gnu.tar.xz]="8fa0af7e85b477d8a6c33d5e40048358190d674f2660511a66ba2446a321322d"
  [mipsel-unknown-linux-gnu.tar.xz]="aaed55450706ac5017d3b80c5a649c26f4493cfcb81d82b768b9a749967683aa"
  [mipsel-unknown-linux-gnusf.tar.xz]="ff181da61a8999b562bbf0ca2da8b4090a093fdf62bf2b84e33d7bdebb2b98c8"
  [or1k-unknown-linux-gnu.tar.xz]="a495aa95064dcff0fe7176f64996df11d89924990804b42de67e08eeadc7c92a"
  [powerpc-unknown-linux-gnu.tar.xz]="0b7259a6a9044024755fb05d6522142d1b1439571a7975c1648bba1522bc9273"
  [powerpc-unknown-linux-gnusf.tar.xz]="83e3cf3b5164d2edccbca2a6573c623cc48d41ad3f49c155f99a72aee87cdeb2"
  [powerpc64-unknown-linux-gnu.tar.xz]="67ec3078d826d38accfcdf903a2032523fdf2f2393bf336c5464864dd7c59022"
  [powerpc64le-unknown-linux-gnu.tar.xz]="9ba2d99cec1f27c395b0d61b0a2eff6576e01dd5fe26f695c1b3c535e1eb97f1"
  [powerpcle-unknown-linux-gnu.tar.xz]="ec012646634706426872eaca74b00f281dcfb85ed639cdce5e8d7eb2a61c2f9e"
  [powerpcle-unknown-linux-gnusf.tar.xz]="79e2f7ce3c361c90f2c0356931ce18d6bbf6452255091e2abe4b7c617405977a"
  [riscv32-unknown-linux-gnu.tar.xz]="1b3c4559f88bab8691f4e7a8b79c861a055fdcdd9d2c3da137d61be507edc024"
  [riscv64-unknown-linux-gnu.tar.xz]="1e3ad5a22b5335665f64e0f672747e2e974552e144ad036d14c7f7c95e5929fb"
  [s390-ibm-linux-gnu.tar.xz]="c8fc7a917ad8f0fed2ea78ee0dc190f91b55114be19a4b8abf0b428ab43870d1"
  [s390x-ibm-linux-gnu.tar.xz]="9d74d4993cc356ac0b4cea5ee16446a119098db9ed774930d8e59ed7feb46390"
  [sh4-multilib-linux-gnu.tar.xz]="d8327f42010375c16535575bfc5c492ef40f304286041e3be9a375977f72b155"
  [sparc-unknown-linux-gnu.tar.xz]="80c0fcc0c550cd1a5b5e5ba24c0f8e61e62b17879d4e7d20f48819146b509d7e"
  [sparc64-unknown-linux-gnu.tar.xz]="78b933f9e16f9e426d06b0a327cc8144c5a10040ba98af02e297c7a2b1140026"
  [x86_64-unknown-linux-gnu.tar.xz]="cccff3ca6feaa8906fd1d56e37bad56e5beaf5b0e1e176a46b560b6e4a7779ea"
)
declare -A HASHES_CLANG=(
  [aarch64-unknown-linux-musl.tar.xz]="5f18c23842191cd8bdac0ce42efaf791193933832b8376e27feddd7397047d50"
  [aarch64_be-unknown-linux-musl.tar.xz]="be5aa72689102a5a28ea24aa105878f49f5dc7fc21402d74c38e053cb2841a64"
  [arm-unknown-linux-musleabi.tar.xz]="fffcd9f38c49e39e94fa91cabb5ef46b7c53088f60d13e4763fdaba579bade0e"
  [arm-unknown-linux-musleabihf.tar.xz]="1c7aec274fc8dcf39429fd2e39aa9c35594538ba21016032b188deb49bebe27a"
  [armv5-unknown-linux-musleabi.tar.xz]="b7adfd64b976424f0ac7156c040fd3182c2c0770029923d1e7d14971f8cd5031"
  [armv6-unknown-linux-musleabi.tar.xz]="824ac0a902da664467747b94002ba78d91279a743df02b0376f16aedbcf95f38"
  [armv6-unknown-linux-musleabihf.tar.xz]="89b8d2735fdd411ae69b660af704cbcafb6b7da6dc128e494c9841116c609c41"
  [armv7-unknown-linux-musleabi.tar.xz]="7d93615d14bc98ef27c702afc8ad8bfc6588cb1fe5616f1cd70682d6dd8ef47d"
  [armv7-unknown-linux-musleabihf.tar.xz]="4551c12cf89686929d5fde03764ddc97c9abb2ca60bfcda81ab404738f8c87e2"
  [i386-unknown-linux-musl.tar.xz]="86c31644b3be077ca0f66aec7e751140d93a27fa5fa59d5f72362f5434704bdf"
  [i486-unknown-linux-musl.tar.xz]="7e6c04299aa3b4546a35709e22879cf452f94792076d2589087eda65d55e5c02"
  [i586-unknown-linux-musl.tar.xz]="c26d13c001e24f85d4ebdfdfc9e248b5601f992199c0f7ebf5210d56549709f7"
  [i686-unknown-linux-musl.tar.xz]="a4e91bb4852db553cbc055a93e4a392b68860fe6378c138ee21384faa75c8a2c"
  [loongarch64-unknown-linux-musl.tar.xz]="c58667318fdb7a126e5e196ef3421b5f196bc3c03a9e0c7811d10a66c877ace0"
  [m68k-unknown-linux-musl.tar.xz]="1bbb76a3da8847cb1cf95ddd19a60d25372fd656dcede7ebd60fc0e62499f717"
  [microblaze-xilinx-linux-musl.tar.xz]="f71e51697daa351c9b83a2eb4407aac14a5dedf839d8231c3c040dec9d379e7e"
  [microblazeel-xilinx-linux-musl.tar.xz]="b9f40839f90e08398a1b17f4fbe4abdab8175dfb231770973e6febc2bfa97880"
  [mips-unknown-linux-musl.tar.xz]="b969b55ab07d6fdc564a130253a2df3d85457f90599a6819721e7f4a8c22aa33"
  [mips-unknown-linux-muslsf.tar.xz]="aba78a36f9275346aca9a31df2285463a53d09232a15f2db8bfb797079216aed"
  [mips64-unknown-linux-musl.tar.xz]="de669b77655375c6c25ad02c4499b25102fd35b30ffe091b0ad57d40cd6b4bcb"
  [mips64el-unknown-linux-musl.tar.xz]="2b1525017afaa925e21c74029bafb61d30b9ce0439d9f382efef8c93e6509254"
  [mipsel-unknown-linux-musl.tar.xz]="dce14d3b7f64b87e659d48ecdf0b384e59b2f1f79d7224c9b7a42d3c7461606c"
  [mipsel-unknown-linux-muslsf.tar.xz]="7c1f47bf47069a485acf923d4738c7beab11d09807212561f254eddc53340b64"
  [or1k-unknown-linux-musl.tar.xz]="faa6dfcf25dbf84fd1869f92bab7cab63f9eb533dae6b1a4cfff21186679fa41"
  [powerpc-unknown-linux-musl.tar.xz]="1620897a721bf9daa55d6c19ac6bd53be1f52c893a909c9f82ed95046c9ccbd3"
  [powerpc-unknown-linux-muslsf.tar.xz]="3a6c7a866b713812f0c5b1ec624fd18485fea5ccfca23623eaad6369e9786652"
  [powerpc64-unknown-linux-musl.tar.xz]="73b1952d1738a1ef27c1b1da4a7b2e33f17d5d463425deb0318421929f91434c"
  [powerpc64le-unknown-linux-musl.tar.xz]="4eafd82fd04dc2341b64892f172a99476342d04b78e5b7f38d5f27c1a54b8a78"
  [powerpcle-unknown-linux-musl.tar.xz]="3d4fc22bbfd1aa7a027d7d3c70e0c04cc5b29b85f20052f0d35a6249100e5a06"
  [powerpcle-unknown-linux-muslsf.tar.xz]="281fffa8c7b98bdea0ef9b531b4476a4111c2b5dbdcea00a3c4f946e148dc880"
  [riscv32-unknown-linux-musl.tar.xz]="3f91026c854d66599c2b33298d41fa9920c96cdc43f5fec7225e4642e34ec4a9"
  [riscv64-unknown-linux-musl.tar.xz]="f154041051651bd54cb8ac698bc60af32b9ba1088d16da4a8649b1f8c20d84c0"
  [s390x-ibm-linux-musl.tar.xz]="677bf8a88ff7e1f5a8471b3e92d46cf91a1d4edd16e9509434c40b226b317a82"
  [sh4-multilib-linux-musl.tar.xz]="9e20988374b6795fc92986b531a0a73728e9406792d115c7c72bf252861d0d7f"
  [x86_64-unknown-linux-musl.tar.xz]="1d5e83800a1033a9c367489fa4e4fe964fc3d431e7081b1c45f5b38eeb9b611d"
)
declare -A HASHES_UCLIBC=(
  [aarch64-unknown-linux-uclibc.tar.xz]="1e592523d6250d92dcbe00f0bf1067aa89925792e6dcd6fb7ebe7b808dd1b895"
  [aarch64_be-unknown-linux-uclibc.tar.xz]="c298f0e6e6c57d09aefce9ccbb5df1975cdee51f5a338c641b7bac7f6476cea6"
  [arm-unknown-linux-uclibcgnueabi.tar.xz]="5647d6e535457d738b47a674d5a41290f3a61fcbe3485a050162ffdbc4af96c3"
  [arm-unknown-linux-uclibcgnueabihf.tar.xz]="e1d9477877302fd9e958f57576e82ee0f4bd5b48215be35677a3e36dd9aa62f1"
  [armv4t-unknown-linux-uclibcgnueabi.tar.xz]="ecb833ab7a50ebfb5909af34cce0302bc225078aaa91ee763a8804e4d8b0f27f"
  [armv5-unknown-linux-uclibcgnueabi.tar.xz]="e351e74ae559662fbe55f8dafdbef2e492bafc28de8a4a41934c311fb96af5b1"
  [armv6-unknown-linux-uclibcgnueabi.tar.xz]="09af450ac0b45b70f8316a802b7e633f9365f46479ed9e66e6d646011cc2f4fc"
  [armv6-unknown-linux-uclibcgnueabihf.tar.xz]="605139a22840a3d9cf98def80adfe89a14d6e0747c09aa25254f9b44af85426d"
  [armv7-unknown-linux-uclibcgnueabi.tar.xz]="eeff291527e3a7deff537449752a1b9fec51df93e948e1ff9bec6a0d76e640f9"
  [armv7-unknown-linux-uclibcgnueabihf.tar.xz]="2793a1e7410ca13de2c982937676d502957cbb4ad34fcef2c146733a115ecffd"
  [hppa-unknown-linux-uclibc.tar.xz]="493626cd0c4e88aec065fa090817172182eb03a11a227bdba1967b3b76b6176a"
  [i486-unknown-linux-uclibc.tar.xz]="db927e88572c6435c69f44af6165bae885ae7d9c0c7e3612ec5d96a8755f75d1"
  [i586-unknown-linux-uclibc.tar.xz]="5c27b65a545095f942d54509a723d80c0989ae5be74868f6d58487dd2eb9e8d4"
  [i686-unknown-linux-uclibc.tar.xz]="466957ea259026441357163e6bbfd1d58a8f10b1d1a9b065ee0b8abbbfc26ba6"
  [m68k-unknown-linux-uclibc.tar.xz]="bfda7d39f6c3584f471f4592c807014b8952988f1ffc8b907c274a0d65245880"
  [microblaze-xilinx-linux-uclibc.tar.xz]="331debd746efa3429401c080320c8a19720fd6ceda4d2900420c9070ff7537ef"
  [microblazeel-xilinx-linux-uclibc.tar.xz]="9ddb20a203b7f63641e2c968b95b220da07e734178fab65ccd3c929231f0296a"
  [mips-unknown-linux-uclibc.tar.xz]="733caab3c418056968ef256d7396c9a00587cbe403ddcfeaa0e8eed71e0747bb"
  [mips-unknown-linux-uclibcsf.tar.xz]="f0a84e00f83bd6bbd5c209dcc45cfc4884ff35d32aabc07ba21a324d454b0c42"
  [mips64-unknown-linux-uclibc.tar.xz]="26327a8cefe3b7c489768387d33229bed21751f833e75ed5a0a9698866dec7dd"
  [mips64el-unknown-linux-uclibc.tar.xz]="eee53b6386cedd9b70bdb363ede047319112f67445785de5ff5eea9096e60106"
  [mipsel-unknown-linux-uclibc.tar.xz]="80c856265c3c47bc96d5abbeca12706df9ff3370d5f537e0b1b41b445943ad8a"
  [mipsel-unknown-linux-uclibcsf.tar.xz]="f5e2da7352206b7d4f1005f7d7fdaa063639b0151bcafd1d12861a319f5f1ee9"
  [or1k-unknown-linux-uclibc.tar.xz]="041ad9c4140ae64ffe42555828fe09754304d22685aa07847f00915c93f8c224"
  [powerpc-unknown-linux-uclibc.tar.xz]="42cc7376153967fdd0500f148b70f91a217272c22718d32a7dbf4b67c7755d4c"
  [powerpc-unknown-linux-uclibcsf.tar.xz]="c036b24edeec505c7e0f7bfb96fe94de44e39b4e3b522cbb634505a210859168"
  [powerpcle-unknown-linux-uclibc.tar.xz]="3325a7860f069957b873c94bfd4f4869854e8e6e9aa77c765a816a0b1ed08eaa"
  [powerpcle-unknown-linux-uclibcsf.tar.xz]="627f4afb14d9e905440e0a79c5f8c35cc0c92485db20548cb816bec647cb2105"
  [riscv32-unknown-linux-uclibc.tar.xz]="ca732f08cf4837ee017df369e6b3170b78e80032601317e4e642a988efd5047f"
  [riscv64-unknown-linux-uclibc.tar.xz]="1076658898d423e803b8ac1967c75f77df7250b5721e153c81dd428dfdd5195a"
  [sh4-multilib-linux-uclibc.tar.xz]="576ee4c4f50619dd3037bbb7cb65e71653869b23810f00190f039b80210229fd"
  [sparc-unknown-linux-uclibc.tar.xz]="b1b57fe0c3074b5d1b147fc48b6ed95a5ce265f38c98b2c0a5680c1803fd17bd"
  [x86_64-unknown-linux-uclibc.tar.xz]="246ffb705094007ddcbb6949a2cf2ca4021f69d9f040133e316c8996ba6335b3"
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
GCC_RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/stompers"
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/cigarettes"
GNU_RELEASE_BASE="https://github.com/gfunkmonk/gnu-cross/releases/download/church"
UCLIBC_RELEASE_BASE="https://github.com/gfunkmonk/uclibc-cross/releases/download/bathroom"
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
