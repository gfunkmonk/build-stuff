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
  [aarch64-unknown-linux-musl.tar.xz]="2c8c594922ce7d630d4fb4d4f0a6e42247cc4dec3f1b9896672e98d59bce0318"
  [aarch64_be-unknown-linux-musl.tar.xz]="71a8f439eb2eb67941fe42c62424232bf8904769854b1e9377b5e533aab3966e"
  [arm-unknown-linux-musleabi.tar.xz]="ff0992e48bbfc094b55a6a4c41f5616d10cb92f882f58e5ef81824a1b8623908"
  [arm-unknown-linux-musleabihf.tar.xz]="7435a9d047bb650834dcc45f3e3e46c39b4f8db12e9dfbe353b8e2d7ef649c11"
  [armv5-unknown-linux-musleabi.tar.xz]="06f269b63a5892016ede4fe69c430c05274a4754f3ceedde39dfe7967accf3e6"
  [armv6-unknown-linux-musleabi.tar.xz]="13a3cdd3a57a1634817ef376f5786a71647c59a757ae3bbcb5893b6cd4e9e581"
  [armv6-unknown-linux-musleabihf.tar.xz]="348aefd4eb772df1fdf8b1257e3b8c85e58998eb08937375b9d768d14dc7d19c"
  [armv7-unknown-linux-musleabi.tar.xz]="06cf705e4e14020489864c3de0ada44ab043171502e6f1f6be325a0b25039bf7"
  [armv7-unknown-linux-musleabihf.tar.xz]="177d185bd37efe499b066d811216fffe2baff61f5b7d592a3a276c70bb9c606e"
  [i386-unknown-linux-musl.tar.xz]="f665c1ecaa324dcf101293b5dd46486556655da22895d65f66cfe4eda6c6423f"
  [i486-unknown-linux-musl.tar.xz]="821c351a0a42f3f137d719fd61da90495c9509d34ec354f8a687dbfc504cc306"
  [i586-unknown-linux-musl.tar.xz]="ce0c75a671064311abfb26d17216e058ef345ef1ce90bbff6247a69d5759d192"
  [i686-unknown-linux-musl.tar.xz]="ef149128b0842ce2419fe3e9f45af0e3499687ca2149ca2faadeb161e0a077a7"
  [loongarch64-unknown-linux-musl.tar.xz]="927a18888626e2fb077d4ec4dcd9b8f4587a4f2729cde75267cef0344d69c135"
  [m68k-unknown-linux-musl.tar.xz]="c707dcf1c1be7b397969bcb52b46b738bf881acd77df830c72b6e6849a1d8da5"
  [microblaze-xilinx-linux-musl.tar.xz]="89c382255b6922cb20df25f0955454d14f862c1383280afd6800d5d5b80a6074"
  [microblazeel-xilinx-linux-musl.tar.xz]="a72b34af6a6c96888a18961d5ad22b4dc2f499e64a29d4248d751ec4c2e58db9"
  [mips-unknown-linux-musl.tar.xz]="3094eac074ffd0f1f7b7b07c8ab6b6c856d0a1d4b733c3202ed5defa8e08c51e"
  [mips-unknown-linux-muslsf.tar.xz]="0be00b8df17f92de36c59212b8344149157c33a08b50e86439f5286888a22326"
  [mips64-unknown-linux-musl.tar.xz]="eb2071eddb5fec8837212e549514154411ac3d7cd93927717c61cfdbf0955a87"
  [mips64el-unknown-linux-musl.tar.xz]="ca3f0008668a48d73fd97e39dcd164ee485299719930750cc4603d0f2d17f017"
  [mipsel-unknown-linux-musl.tar.xz]="131225878fee14e5a805067455d73d9fc288947ca3bbe206050f59c58ae2d7c0"
  [mipsel-unknown-linux-muslsf.tar.xz]="73d0f0baa88b3920b969a1b3c9136cb32f34a462ade38b2357e011298d7c860c"
  [or1k-unknown-linux-musl.tar.xz]="f826df9cd2112f4c7064dd8b05811cd0e680b9b8ef26f251b0cdd8e3de70d786"
  [powerpc-unknown-linux-musl.tar.xz]="96769261d2652604fade787d50e9c9bf42f9c5570aaf680d72473c2c03417bc1"
  [powerpc-unknown-linux-muslsf.tar.xz]="572ce27bd8efe5b38d7444900f19bc3042ef834d4116a853cb206ed0a238db60"
  [powerpc64-unknown-linux-musl.tar.xz]="2e933c39df050ff9097d5e061e806b1d50bdd3b68893e23c2730a494eda8001f"
  [powerpc64le-unknown-linux-musl.tar.xz]="1732adf64be850db8ae81d47a51473b0426d1298f2f0a9e6d4c86552e70644ae"
  [powerpcle-unknown-linux-musl.tar.xz]="4061219cbe7faa4339d772d7bc2029053e7244314c98ebc6d415d1b7d1d5fe0c"
  [powerpcle-unknown-linux-muslsf.tar.xz]="1232d70349ea5284f0a3fcc2eafdd372a91c86eceab94cf7f3664468a57ea12a"
  [riscv32-unknown-linux-musl.tar.xz]="4fed29f819471602ef59690b658a548a61de6edfb75d54bbba528c8cba791fc6"
  [riscv64-unknown-linux-musl.tar.xz]="8895a9aba3944643a794abcdd1bb462581b873a518343e37621bddd1c3076056"
  [s390x-ibm-linux-musl.tar.xz]="9f2d1c254035bb61f7525f53c3e994535720a3df042d7b05c02c89d0feb4441c"
  [sh4-multilib-linux-musl.tar.xz]="4e9d2a252a7c10d5c1fc747e1aa722c338adebf73a4ba220412d0a32a038cde0"
  [x86_64-unknown-linux-musl.tar.xz]="913fbea0f4839034d6258180c176928d545328bbeba44cc827a14252f077c954"
)

declare -A HASHES_GNU=(
  [aarch64-unknown-linux-gnu.tar.xz]="60a29d91c190474b1231d0cd53cbe16837c52767643e773a363f751ef111e8d0"
  [aarch64_be-unknown-linux-gnu.tar.xz]="f48bbc9e8fa282078a1378700cbe05567a7fbc9e13c530206425bbf6aa6a6830"
  [alpha-unknown-linux-gnu.tar.xz]="361802a1b1e1da20be9b660f57db81e224af65c362d9c59cddbfde7830511519"
  [arm-unknown-linux-gnueabi.tar.xz]="be9247d644dc0f720ef80cf81f1d8b2b871adf948b441a9966ae860a4a1211ff"
  [arm-unknown-linux-gnueabihf.tar.xz]="f893338b8b43c39da25a6c9c4221f97430de629a0c3ed785b969c2937d0d06e0"
  [armv4t-unknown-linux-gnueabi.tar.xz]="85f227650bc62f537313c37d59c3ccff3829dfe9ad56d7b295e21d931cac8a05"
  [armv5-unknown-linux-gnueabi.tar.xz]="4c1a170dea6a3e1f754c59c23e2ee9023b874cca5e5199b419b10e88b73e4561"
  [armv6-unknown-linux-gnueabi.tar.xz]="eddd364759e3e43f1d2368d1db8df01f6c01bcf73b06a7a232fff5e4b6b5ff84"
  [armv6-unknown-linux-gnueabihf.tar.xz]="c95c5c068fb9e1b15a7ce0613c9f3db905c0cc2910eca7ea33c3cfb28f6eb89b"
  [armv7-unknown-linux-gnueabi.tar.xz]="7b5f3c4de40acd50e83d88dba9e0844932cfe9b09fc9364a75108e2e68694efb"
  [armv7-unknown-linux-gnueabihf.tar.xz]="0210c4a4d6d26884b91b86d016316fe7ebecdc1e6304887860c5d1713448b8c8"
  [hppa-unknown-linux-gnu.tar.xz]="07a215b660fe12a628fa71b1a0aaa1cc39da95730a08d6a8645d495a84fb57a8"
  [i486-unknown-linux-gnu.tar.xz]="138aea5a414f251453872494d44372b64f65ec782ccc215ad706c395359fde2e"
  [i586-unknown-linux-gnu.tar.xz]="7c13a63c62d320e34c4fb5a2b61a5511cf5b1a8fe6b4ef2d9f66cce3c71e993b"
  [i686-unknown-linux-gnu.tar.xz]="b243d46d5ba7350fab077c4391bb411e5b8b79ab893863de0cad38e0ac74469d"
  [loongarch64-unknown-linux-gnu.tar.xz]="e29b2c8ae7bc6ff2274b462d55eab75758d69afce869f43c7f1827aa9af8e7ee"
  [m68k-unknown-linux-gnu.tar.xz]="90efa9d86bc19cfad0f9e228c8eae496b0083454f5a7a2b9c9967c357721f947"
  [microblaze-xilinx-linux-gnu.tar.xz]="0af24b8952ff54c5bf4d2903e0c303bb51b8a9c7cb39ce26d613923c852788e7"
  [microblazeel-xilinx-linux-gnu.tar.xz]="6bc882a001dfa11172791cd230103b7bc8448d6a79ed56e137c845821bc84915"
  [mips-unknown-linux-gnu.tar.xz]="5bc9223fad965e94082405826bc0873207f529e44a7843a85afe8489d530fdac"
  [mips-unknown-linux-gnusf.tar.xz]="368053521afebd05a0ce854aed25c86514e1f42e9be5490652f39c601c3844c8"
  [mips64-unknown-linux-gnu.tar.xz]="8c6f79b3df338da3344f0165306c89f09a766618dee002469d4e5cce5cee38f1"
  [mips64el-unknown-linux-gnu.tar.xz]="1e5028ec56e6bcea90b064ddf06f147ff8dd01e29af1fd12e93d4493b5aab22a"
  [mipsel-unknown-linux-gnu.tar.xz]="118333d5b8d8a3741cb0c511c9f5b28e4ce67d2f45b127e71f9b78a9f8a6f91c"
  [mipsel-unknown-linux-gnusf.tar.xz]="41bbeea7f6574e37f97a51ba1b196229efb132ae12c8f45a5326656741e53762"
  [or1k-unknown-linux-gnu.tar.xz]="a084ae8b50ffbd48e3a54c08560f128bb6c9c445277c3334e2ae31843130d55a"
  [powerpc-unknown-linux-gnu.tar.xz]="c0eef0c866939eaf4e2e1649ef9f45ffe89526e895a7d9e5e32615d8321ce4f1"
  [powerpc-unknown-linux-gnusf.tar.xz]="518d17291146b7e71067c4193685d7a0eded02b3d966b429ded972672e0c1d61"
  [powerpc64-unknown-linux-gnu.tar.xz]="6e8296248630b85270baa7c7402d1a72a35a89d1631a62bdfb9cf66463d723b1"
  [powerpc64le-unknown-linux-gnu.tar.xz]="c58b0f5e565f808620826855c015cd7777e770b437563bcfe5863b14c9acfec5"
  [powerpcle-unknown-linux-gnu.tar.xz]="ca3b8cb71c6eac9ba727a85cd0d3caa85936860f4f8c4fcc898c0ea3289f069f"
  [powerpcle-unknown-linux-gnusf.tar.xz]="0b2cd62d243fa43f6c1fee5bc87590a7087c4a2427c34db2caf7cd6953c9c9cf"
  [riscv32-unknown-linux-gnu.tar.xz]="adc71b483615267026d3e3411839121cdf965c81c36bea3a7f440ad99022e4a0"
  [riscv64-unknown-linux-gnu.tar.xz]="394a3dfe359ecb6b53951809459baee57a2c33ddae1ff1ed9a772849c846f44e"
  [s390-ibm-linux-gnu.tar.xz]="917f54e90392b1fec8c53bc08d80670b7e3505ceab8487c451ee19a4df327e88"
  [s390x-ibm-linux-gnu.tar.xz]="6b17dae9dfad28458f7c5364958287178b79e6cad0e5e3faf1f4c9b7adc9f862"
  [sh4-multilib-linux-gnu.tar.xz]="475445278b4ebc2b8f0a504e479739ff05b7b4eee351ed7a95bcf9f7f6b5f29b"
  [sparc-unknown-linux-gnu.tar.xz]="31a634b3b3607579d329298e7f3a842092ef86d3cc28aaf5b81c63d7fd279739"
  [sparc64-unknown-linux-gnu.tar.xz]="e86a420eb4ecaf54fb295cdde0351d5ab41d70451c702bd25144814d3b59b7c1"
  [x86_64-unknown-linux-gnu.tar.xz]="932cdf3ec93017ce2fe4b8a527eb5fcc907aa317cda99d604b949be074c0574f"
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
  [armv7-unknown-linux-musleabihf.tar.xz]="30d5518a6175a43aa4ce66ed6019a841f6d356010e28dcf7748bdf4a3b3677a8"
  [i386-unknown-linux-musl.tar.xz]="86c31644b3be077ca0f66aec7e751140d93a27fa5fa59d5f72362f5434704bdf"
  [i486-unknown-linux-musl.tar.xz]="7cb05b126ea18d47654ffddae8e2cc6e84c03ac12280c47d62ee70e8c7f39345"
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
  [powerpc-unknown-linux-musl.tar.xz]="f7586a9c18daccc6e72a28230691693499e95b829da80af83e2ddc62658c3d16"
  [powerpc-unknown-linux-muslsf.tar.xz]="2bcb69daa1f68951d4fb58d1feee0413715d250071bf96016a7b6dcd1767db94"
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
  [aarch64-unknown-linux-uclibc.tar.xz]="4424bfa9ef8e621845d3c27038883b84f8396d585180610827c711c209689306"
  [aarch64_be-unknown-linux-uclibc.tar.xz]="4199f90474a4a77260730624b5ad7731bb275ee66ddf06ba1718af899cfccc17"
  [arm-unknown-linux-uclibcgnueabi.tar.xz]="99a74a6bb554fd35aef59fc6234af2115e3f7e3d7edf87bbdac973b6f07995f1"
  [arm-unknown-linux-uclibcgnueabihf.tar.xz]="3a63b7e514a8cdaf2fc82800de225e379eafde60618f6bd202dd684627e866a4"
  [armv4t-unknown-linux-uclibcgnueabi.tar.xz]="8edad436413b488b808d7d13e15e987b3e7ffdd62dbaa607dddc4e1a7bfdd3ee"
  [armv5-unknown-linux-uclibcgnueabi.tar.xz]="0370a5fe082232bbc5e9522b0be8347895d8f9dbd63224c33311491e92d60f44"
  [armv6-unknown-linux-uclibcgnueabi.tar.xz]="e109be779d050af7590cb7dd1864751317cb34e0a051df8a2e3d0922b928a880"
  [armv6-unknown-linux-uclibcgnueabihf.tar.xz]="3475fc3256aa6fa14ea5d69f09b17fb317decc54aab505ef345b5a9766b7ae5a"
  [armv7-unknown-linux-uclibcgnueabi.tar.xz]="2d33a7fc54dfd71eb4f3762f17edebd9ce5cdb3fdb68c47b8c662e8b084bb19c"
  [armv7-unknown-linux-uclibcgnueabihf.tar.xz]="f4fbf68ac4697133a4079dc8b88e3c8f36b0b88cdc82171fa420fa881d6e4eb0"
  [hppa-unknown-linux-uclibc.tar.xz]="b32141b11a357794d3f536eeb753484d166e349d80e3f3a10abf23fd988cdd02"
  [i486-unknown-linux-uclibc.tar.xz]="c575b9bec78b8d09ffa67ab042f046637217a5c07dc720d9ffa994e2cae2cf32"
  [i586-unknown-linux-uclibc.tar.xz]="fa789fd31d4b10a4e0572c8a4d51557394d154730d3b1ddea11137b545ffc758"
  [i686-unknown-linux-uclibc.tar.xz]="4180fd6fa2f8091534562fd27785d25d33e17220c99a0e5e82a67a5dc8cb3dfb"
  [m68k-unknown-linux-uclibc.tar.xz]="74d52c1e6bc4a8ad6b40f92fe5257587925692b226aee2499a18393426436678"
  [microblaze-xilinx-linux-uclibc.tar.xz]="979544e5530b961d9f59e4fe666561d077355c52917996cd4cbaa3512de68e42"
  [microblazeel-xilinx-linux-uclibc.tar.xz]="88ef18a04deb99a2af95f2f877b684594a7272dceab95acfbe874bc86ef3ea1b"
  [mips-unknown-linux-uclibc.tar.xz]="3f2863f1947e12771e22899e5c8cc9e42e2cd7c3fe79f25a6d15bb746f261986"
  [mips-unknown-linux-uclibcsf.tar.xz]="10cfa2632980bb7773865f3fb920dca5921114e69ed0f6f85bc840e6305855c3"
  [mips64-unknown-linux-uclibc.tar.xz]="620b90700db961fd4b4589e63148adb724d718a0e564271293f7c0bbd6b1b16f"
  [mips64el-unknown-linux-uclibc.tar.xz]="962e2dbf7d88df51acea1a1af1f895bbc317308d34cba7d807f678758a9d3018"
  [mipsel-unknown-linux-uclibc.tar.xz]="8076d56d128dc44f66b39d75aed7976866dfdaa6ff1de71bda5856a12954c407"
  [mipsel-unknown-linux-uclibcsf.tar.xz]="95b2c2b426b33b95d424b6165f0ea61a163f028f896fc97d0f626bf6f4ffa1a8"
  [or1k-unknown-linux-uclibc.tar.xz]="ede63b60f6a0e218e59af1c80d8083dbea4d24ba7821cd7bee982541cb44502d"
  [powerpc-unknown-linux-uclibc.tar.xz]="40c8a19fdb2c0adf449bfc0c99eb4661f444ea9c80a27eeb5939ff69a03c5fa2"
  [powerpc-unknown-linux-uclibcsf.tar.xz]="d4bbbcfe9c8a8bd63820fee2dd0dca2819e5a00cf3f2f9415383567d41fbb45a"
  [powerpcle-unknown-linux-uclibc.tar.xz]="9af17cb407220688c3fe0f1de5122479e4e8e1e09c646d9ce523aa7d8a057d7c"
  [powerpcle-unknown-linux-uclibcsf.tar.xz]="387957f9c9d48d282a609b29adc9cfd5c5f061d9b8f01532bb2e6c725af232d6"
  [riscv32-unknown-linux-uclibc.tar.xz]="9ef2e45c6692e9276bfe6727fd209671ee07b56c84b5f92cf4021c233d4a3279"
  [riscv64-unknown-linux-uclibc.tar.xz]="6b660660373c9deeea394cc6f9febe68d86c9fd52f737a45d1ee234f4b8d8398"
  [sh4-multilib-linux-uclibc.tar.xz]="0771d35ae27e688a869ba80b01e60f485389917a06cabc1442508bacc856cd4d"
  [sparc-unknown-linux-uclibc.tar.xz]="8e7d3a0f03bc99c10c1498388604657549ae9d4ae9cfc4c34ff871eb3eab88f3"
  [x86_64-unknown-linux-uclibc.tar.xz]="c36407256b4db293f0022559c3d0951eb63c17ccaffa32fd960fccc4415e0bf3"
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
CLANG_RELEASE_BASE="https://github.com/gfunkmonk/clang-cross/releases/download/hacksaw"
GNU_RELEASE_BASE="https://github.com/gfunkmonk/gnu-cross/releases/download/church"
UCLIBC_RELEASE_BASE="https://github.com/gfunkmonk/uclibc-cross/releases/download/matchbox"
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
