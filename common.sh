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
  [aarch64-unknown-linux-musl.tar.xz]="dcc1c5dffde8c9817152cd02cbc101dc75dc915fc2c212457d0450ce0952bad6"
  [aarch64_be-unknown-linux-musl.tar.xz]="a8016b8dba5ed33d75807747f3fa29e8a934dbad8852a557bf65c36eff38d4b0"
  [arm-unknown-linux-musleabi.tar.xz]="6837d708dce7ff6b9d351f733eeb3550f5aff6bc383afc31e0a05e25f6c63a42"
  [arm-unknown-linux-musleabihf.tar.xz]="9018706fa44e96ce93631b3763d92c8e282c422b83d1f207f6e94e544c35f021"
  [armv5-unknown-linux-musleabi.tar.xz]="10b47c12ce77c4bf58fcd181df0626fafebdb22a9a9578d847432d0833e1aa26"
  [armv6-unknown-linux-musleabi.tar.xz]="c8f2cb02c80f864c766784c69c69406531cd0ebd262f9d51598dfb818c75c8c1"
  [armv6-unknown-linux-musleabihf.tar.xz]="a3a2296614c0ce3a4c662ed8adeac1a80bb6de0dca32c3fb445d5fbeb840ddb0"
  [armv7-unknown-linux-musleabi.tar.xz]="bf84a416b19de9ffe743d935ef2add6fec9e714b6110f978aacc544397cf04bc"
  [armv7-unknown-linux-musleabihf.tar.xz]="cb9eb003ae2395981293cfc849af826c3d467e359e52f8ac1d858625032a10d9"
  [i386-unknown-linux-musl.tar.xz]="2764cd053f0cdf3faf0ee9125975f6ddc94799032920c53b7c4e1fa0edc2f76a"
  [i486-unknown-linux-musl.tar.xz]="4400d1af54716ed69fae3de49f14f1c8ecef6f1424d3cc64c7dcc0ccb49b25e0"
  [i586-unknown-linux-musl.tar.xz]="875187947b4fee50db8c5f5bee025a42b3648855a5144b1c57251a36b7dbaed4"
  [i686-unknown-linux-musl.tar.xz]="d8b28b91e114b7291942dd7d3149ec2ce68e205f0017cfce483ddf98aca8cc92"
  [loongarch64-unknown-linux-musl.tar.xz]="336d7e218f26126d66e4fb633b046fb07d5b500a20ab01fa87ced0b093b012cc"
  [m68k-unknown-linux-musl.tar.xz]="46c560b7bf7592408c08d9e8b123f789f6eea62f7a207445c5f547efefcbda01"
  [microblaze-xilinx-linux-musl.tar.xz]="a4e4d7feacc4a4842539819795dd8b76f401bfd40bab0333d59af6e722151213"
  [microblazeel-xilinx-linux-musl.tar.xz]="0240bab34f72857d1331274c5d8c942e5f66f87d51cacd3ad9486ff68dbf23fe"
  [mips-unknown-linux-musl.tar.xz]="ec458d6967ffb7f026332e5167417fc37fdf919f198f05ff89c5106b65eebb2e"
  [mips-unknown-linux-muslsf.tar.xz]="ff2a304e03f08d9eb43ec44647f7160b2f948040781505aa972bacff521860a5"
  [mips64-unknown-linux-musl.tar.xz]="16b582cc08f6fc6a87a5fc74136f2a1358ac2bf7bd195b2c3f268173cac69651"
  [mips64el-unknown-linux-musl.tar.xz]="a97937255148a0cf0dbdc3666f20c49228743959508ffc2eb1308cdd129c460b"
  [mipsel-unknown-linux-musl.tar.xz]="236f3a7efe2de1e741cb574ec4514495ee879d5227f000c18fa35f6c51c8656e"
  [mipsel-unknown-linux-muslsf.tar.xz]="fb48d47e1304dd657a14582eed707768c5da9cadbab0e87affb6c30ea1a3e830"
  [or1k-unknown-linux-musl.tar.xz]="8ad09f843ed9e89111a2a02abe2f6e1a77f29952c2c111c441a1061aa1334155"
  [powerpc-unknown-linux-musl.tar.xz]="0fcb730fd75f610ed70f9fbee097ca1e68502274c3961a7c779f1cb9e9b192ca"
  [powerpc-unknown-linux-muslsf.tar.xz]="e3021549529c89eb4293f7b8404d47b9374761368d0ce3e167d644cf1c19458b"
  [powerpc64-unknown-linux-musl.tar.xz]="5e09adb2bc28897b01525e04fa86115768d57620d95383e6f19ae723e4af0fd1"
  [powerpc64le-unknown-linux-musl.tar.xz]="7f7fe1a28a3d2ecd5616b16f67cbbdb7324005c6c267fddf7f80747f185d0915"
  [powerpcle-unknown-linux-musl.tar.xz]="5fc53668298634863e560b3060d35bf7e55ae2af18f6863c98524c8b27b5a205"
  [powerpcle-unknown-linux-muslsf.tar.xz]="cf1e27a9d7442a56b2af59ab4cf0a47289e8e8d00ff8445bc067774a795bf0a7"
  [riscv32-unknown-linux-musl.tar.xz]="e890eaec858e9da0c1b656374f0e92cbc368d15ba871c047487c5071e33cd2b4"
  [riscv64-unknown-linux-musl.tar.xz]="2c0f261e0e8d944195275bb4a8fe82ab31279b09d1c0b49891742e9921650792"
  [s390x-ibm-linux-musl.tar.xz]="36f75b48d59e361128af7d76ade6d735bcf7593d9f58276695c8c70bfc4b68a6"
  [sh4-multilib-linux-musl.tar.xz]="ce6b6ee1bc1c9fc1b5f49ee179ebecf1787b543da9464831d986738147e22c37"
  [x86_64-unknown-linux-musl.tar.xz]="15d52b926f472af0f950322f43bcb2e4d8a41c079ed322acb13dc8a75d0f8b0d"
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
  [aarch64-unknown-linux-musl.tar.xz]="88ac8f4aa6402217f9fe34da5fe8c5d5a35b71b7e57990d4d074c067c3854d26"
  [aarch64_be-unknown-linux-musl.tar.xz]="476cac867abb602ff444f204895499e101a1d69c24183f8614f7efc5bf4c724b"
  [arm-unknown-linux-musleabi.tar.xz]="4ea6ff2637f6d2e72b6e370e6dd6f9563768c22ac49c29b69fe1d57f953fe624"
  [arm-unknown-linux-musleabihf.tar.xz]="8e89e397d680655d18c293dc83988fbdd6d06dc2304d6ee96cf46f98d9dda53b"
  [armv5-unknown-linux-musleabi.tar.xz]="c5857d7990c31db701ce0ed54be593275b9115c912dc9cafe6cb439e89510045"
  [armv6-unknown-linux-musleabi.tar.xz]="9ee47f5624008c0051f350da670915a1e1e5b671a2187794b19c01b40665ba14"
  [armv6-unknown-linux-musleabihf.tar.xz]="594a028f1f870ea17c883ccf9a1ac7fc7d757fe3d6b41d6f07eb59c4e07980b4"
  [armv7-unknown-linux-musleabi.tar.xz]="ad0b91f8065990189374a00ee02573487a0a3fa10bb43fcec3b59ed3a568ef6b"
  [armv7-unknown-linux-musleabihf.tar.xz]="8bebca8c11cb9c2c9f540dfedf992452cac6631be39ea7fc9452e746aa6765dc"
  [i386-unknown-linux-musl.tar.xz]="c3cfba1045a2f48af45938c825843f8d094ab079e0975e755f21df8b2d019c92"
  [i486-unknown-linux-musl.tar.xz]="cc27db31953a306148b5e3de7e1ca862d2d961717933c593a98ee45503babd5b"
  [i586-unknown-linux-musl.tar.xz]="8549c0890a9ca568a4a55efa1c25e4aecf47fc136c91ce93462eb429fb06436a"
  [i686-unknown-linux-musl.tar.xz]="06c442d9cc8bc4704f65d4f04427b001bf78e732291c9a760635643f1c738df7"
  [loongarch64-unknown-linux-musl.tar.xz]="8a3d5f17a948537a3e7e00764ecd4c79601686dfd3cea96ce0a1e42590d7ffc3"
  [m68k-unknown-linux-musl.tar.xz]="df905028d73cfd863b88107ca6f6ca3d5aac3f565f64e4280a831e8f3b2dad76"
  [microblaze-xilinx-linux-musl.tar.xz]="d758bbd0e6d010b0a0256473be203ab3b667653ef003ceeb23910683c8cccdda"
  [microblazeel-xilinx-linux-musl.tar.xz]="540c3553b64dc752a5f7aa72e8ae69e878cec6fa0f65f820a60e9d3d7d73fae9"
  [mips-unknown-linux-musl.tar.xz]="02f4260d3807eb17c49fd6ea75637b143d01e94914752a235a72976376c650e9"
  [mips-unknown-linux-muslsf.tar.xz]="616e23a1339a5b22bec6aef673dd01edb3c184294ce89fdca119f38611a49d0a"
  [mips64-unknown-linux-musl.tar.xz]="ce72b3f5c8f8c7991bc3f3bb31b4e13c01d2de6fdccd38cb1bbff5fed9a95391"
  [mips64el-unknown-linux-musl.tar.xz]="111adcb7bc6e6da0f0d384fb2d31740a040d111040c1b4e7c4bf8a44cf1d4c9a"
  [mipsel-unknown-linux-musl.tar.xz]="ca64bc4d154a2b8108c69386035e37e2280415c6d2df75a289bf83321b8889a6"
  [mipsel-unknown-linux-muslsf.tar.xz]="e9d41f1d7cf7874c31e7c24d3272f97bc87ff2c2187f951dd2c82617b95fbb20"
  [or1k-unknown-linux-musl.tar.xz]="420b4d70a056fa2af4ca235c7e0d570f3644b8b2b2aa3d011b354e17774db902"
  [powerpc-unknown-linux-musl.tar.xz]="11756c6ec91a1ad3e12b49e6dd5be28c9e7b77d38ac522109fac79b29decd703"
  [powerpc-unknown-linux-muslsf.tar.xz]="43cf3699d3957a61457143723f7bd7e5866268e1cded161d3e10610d9714547e"
  [powerpc64-unknown-linux-musl.tar.xz]="38f96dff26a3d494a3b3d5cc2f7314ec428ff2018d04a0e2ca12c00ae19b0f29"
  [powerpc64le-unknown-linux-musl.tar.xz]="f9679340016d38afe284b5344ec1b5c3855a71ca52b31524c81501dfb84ff3a7"
  [powerpcle-unknown-linux-musl.tar.xz]="0c7b4c7ab0ac832befd79fef71bcce59148fa1dae826cdbe4ba439f544f9bc9d"
  [powerpcle-unknown-linux-muslsf.tar.xz]="49f4a40ee64a00cfe72b6917a749bbdff182d62de55c0ada948f6f51b9d48e2f"
  [riscv32-unknown-linux-musl.tar.xz]="7877fb2311ec66012ea8f6c8d041bb419687bc0146531fa93558c7d52359efc6"
  [riscv64-unknown-linux-musl.tar.xz]="93df877420a552c857fbaca0705d567d2df941a96af5981e360a8be8ec1c4c98"
  [s390x-ibm-linux-musl.tar.xz]="4c8df6712c0dbc67824925a4dd52e3da0472356e885b5c5f2639753a4b87ff86"
  [sh4-multilib-linux-musl.tar.xz]="52a4a567fe349268cfdd7a5306f818c2507d1209de2d894199ced8ef55150eda"
  [x86_64-unknown-linux-musl.tar.xz]="e31d6cee094bd2c7cb7d8707e0c27fb89fecd2ccbc29c28d09c1dacac011d8b1"
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
GCC_RELEASE_BASE="https://github.com/gfunkmonk/musl-cross/releases/download/garbage"
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