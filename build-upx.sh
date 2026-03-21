#!/usr/bin/env bash
#
# Cross-compile UPX using musl-cross toolchains from gfunkmonk/musl-cross
# Source: https://github.com/gfunkmonk/upx
# Toolchains: https://github.com/gfunkmonk/musl-cross/releases/tag/eastwood
#

set -euo pipefail

# Configuration
UPX_REPO="https://github.com/gfunkmonk/upx.git"
UPX_BRANCH="devel"
TOOLCHAIN_BASE_URL="https://github.com/gfunkmonk/musl-cross/releases/download/eastwood"
WORK_DIR="${PWD}/upx-build"
TOOLCHAIN_DIR="${WORK_DIR}/toolchains"
SOURCE_DIR="${WORK_DIR}/upx"
BUILD_BASE="${WORK_DIR}/builds"
OUTPUT_DIR="${WORK_DIR}/output"

# Architectures to build (add/remove as needed)
# Format: "triple:cmake_system_processor"
#
# Uncomment to add more architectures
declare -a ARCHITECTURES=(
#    "i386-unknown-linux-musl:i386"
#    "i486-unknown-linux-musl:i486"
#    "i586-unknown-linux-musl:i586"
    "i686-unknown-linux-musl:i686"
#    "x86_64-unknown-linux-musl:x86_64"
#    "armv5-unknown-linux-musleabi:armv5"
#    "armv6-unknown-linux-musleabi:armv6"
#    "armv6-unknown-linux-musleabihf:armv6"
#    "armv7-unknown-linux-musleabi:armv7"
    "armv7-unknown-linux-musleabihf:armv7"
#    "aarch64-unknown-linux-musl:aarch64"
#    "mips-unknown-linux-musl:mips"
    "mips-unknown-linux-muslsf:mips"
#    "mips64-unknown-linux-musl:mips64"
#    "mips64el-unknown-linux-musl:mips64el"
#    "mipsel-unknown-linux-musl:mipsel"
#    "mipsel-unknown-linux-muslsf:mipsel"
#    "powerpc-unknown-linux-musl:powerpc"
#    "powerpc-unknown-linux-muslsf:powerpc"
#    "powerpc64-unknown-linux-musl:ppc64"
#    "powerpc64le-unknown-linux-musl:ppc64le"
#    "powerpcle-unknown-linux-musl:powerpcle"
#    "powerpcle-unknown-linux-muslsf:powerpcle"
#    "riscv32-unknown-linux-musl:riscv32"
#    "riscv64-unknown-linux-musl:riscv64"
#    "loongarch64-unknown-linux-musl:loongarch64"
#    "m68k-unknown-linux-musl:m68k"
#    "microblaze-xilinx-linux-musl:microblaze"
#    "microblazeel-xilinx-linux-musl:microblazeel"
#    "or1k-unknown-linux-musl:or1k"
#    "s390x-ibm-linux-musl:s390x"
#    "sh4-multilib-linux-musl:sh4"
)

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

die() {
    log_error "$@"
    exit 1
}

check_dependencies() {
    local missing=()

    for cmd in git cmake make wget tar xz; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        die "Missing dependencies: ${missing[*]}"
    fi

    # Check CMake version
    local cmake_version
    cmake_version=$(cmake --version | head -n1 | grep -oP '\d+\.\d+' || echo "0.0")
    if ! awk -v ver="$cmake_version" 'BEGIN { exit (ver < 3.13) }'; then
        die "CMake 3.13+ required, found: $cmake_version"
    fi
}

setup_directories() {
    log_info "Setting up directories..."
    mkdir -p "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR"
}

clone_upx() {
    if [[ -d "$SOURCE_DIR" ]]; then
        log_info "UPX source already exists, updating..."
        git -C "$SOURCE_DIR" fetch origin
        git -C "$SOURCE_DIR" checkout "$UPX_BRANCH"
        git -C "$SOURCE_DIR" pull
    else
        log_info "Cloning UPX repository..."
        git clone --branch "$UPX_BRANCH" "$UPX_REPO" "$SOURCE_DIR" --depth=1
    fi

    # Initialize submodules if any
    git -C "$SOURCE_DIR" submodule update --init --recursive
}

download_toolchain() {
    local triple=$1
    local tarball="${triple}.tar.xz"
    local toolchain_path="${TOOLCHAIN_DIR}/${triple}"

    if [[ -d "$toolchain_path" ]]; then
        log_info "Toolchain $triple already exists, skipping download"
        return 0
    fi

    log_info "Downloading toolchain: $triple"
    local url="${TOOLCHAIN_BASE_URL}/${tarball}"
    local tmpfile="${TOOLCHAIN_DIR}/${tarball}"

    if ! wget -q --show-progress -O "$tmpfile" "$url"; then
        log_error "Failed to download $tarball"
        rm -f "$tmpfile"
        return 1
    fi

    log_info "Extracting toolchain: $triple"
    mkdir -p "$toolchain_path"
    if ! tar -xJf "$tmpfile" -C "$toolchain_path" --strip-components=1; then
        log_error "Failed to extract $tarball"
        rm -rf "$toolchain_path" "$tmpfile"
        return 1
    fi

    rm -f "$tmpfile"
    log_info "Toolchain ready: $triple"
}

build_upx() {
    local arch_spec=$1
    local triple="${arch_spec%%:*}"
    local cmake_proc="${arch_spec##*:}"

    log_info "Building UPX for $triple"

    # Download toolchain
    if ! download_toolchain "$triple"; then
        log_warn "Skipping $triple due to toolchain download failure"
        return 1
    fi

    local toolchain_path="${TOOLCHAIN_DIR}/${triple}"
    local build_dir="${BUILD_BASE}/${triple}"
    local toolchain_file="${build_dir}/toolchain.cmake"

    # Clean previous build
    rm -rf "$build_dir"
    mkdir -p "$build_dir"

    # Generate CMake toolchain file
    log_info "Generating CMake toolchain file for $triple"
    cat > "$toolchain_file" << EOF
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ${cmake_proc})

set(CMAKE_C_COMPILER ${toolchain_path}/bin/${triple}-gcc)
set(CMAKE_CXX_COMPILER ${toolchain_path}/bin/${triple}-g++)
set(CMAKE_AR ${toolchain_path}/bin/${triple}-ar)
set(CMAKE_RANLIB ${toolchain_path}/bin/${triple}-ranlib)
set(CMAKE_STRIP ${toolchain_path}/bin/${triple}-strip)

set(CMAKE_FIND_ROOT_PATH ${toolchain_path}/${triple})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Static linking
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -static")
set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--gc-sections -static")

# Additional flags for musl
set(CMAKE_C_FLAGS "\${CMAKE_C_FLAGS} -Os -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-stack-protector")
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -Os -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-stack-protector")
EOF

    # Configure with CMake
    log_info "Configuring CMake for $triple"
    if ! cmake -S "$SOURCE_DIR" -B "$build_dir" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_TOOLCHAIN_FILE="$toolchain_file" \
        -DUPX_CONFIG_DISABLE_GITREV=ON \
        -DUPX_CONFIG_DISABLE_WSTRICT=ON \
        -DUSE_STRICT_DEFAULTS=OFF \
        -DUPX_CONFIG_REQUIRE_THREADS=ON \
        -DCMAKE_VERBOSE_MAKEFILE=OFF; then
        log_error "CMake configuration failed for $triple"
        return 1
    fi

    # Build
    log_info "Compiling UPX for $triple"
    if ! cmake --build "$build_dir" --parallel "$(nproc 2>/dev/null || echo 2)"; then
        log_error "Build failed for $triple"
        return 1
    fi

    # Find and copy the binary
    local upx_binary
    upx_binary=$(find "$build_dir" -name upx -type f -executable | head -n1)

    if [[ -z "$upx_binary" ]] || [[ ! -x "$upx_binary" ]]; then
        log_error "UPX binary not found for $triple"
        return 1
    fi

    # Copy to output
    local output_file="${OUTPUT_DIR}/upx-${triple}"
    cp "$upx_binary" "$output_file"

    # Strip the binary
    if [[ -x "${toolchain_path}/bin/${triple}-strip" ]]; then
        "${toolchain_path}/bin/${triple}-strip" "$output_file"
    fi

    # Show info
    local size
    size=$(du -h "$output_file" | cut -f1)
    log_info "Built $triple: $output_file ($size)"

    # Verify it's actually static
    if command -v file &>/dev/null; then
        file "$output_file" | grep -q "statically linked" && \
            log_info "Confirmed: statically linked" || \
            log_warn "Warning: may not be statically linked"
    fi

    return 0
}

main() {
    log_info "UPX Cross-Compilation Build Script"
    log_info "===================================="

    check_dependencies
    setup_directories
    clone_upx

    local success=0
    local failed=0
    local -a failed_archs=()

    for arch_spec in "${ARCHITECTURES[@]}"; do
        local triple="${arch_spec%%:*}"

        if build_upx "$arch_spec"; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
            failed_archs+=("$triple")
        fi
    done

    log_info "===================================="
    log_info "Build Summary:"
    log_info "  Successful: $success"
    log_info "  Failed: $failed"

    if [[ $failed -gt 0 ]]; then
        log_warn "Failed architectures: ${failed_archs[*]}"
    fi

    if [[ $success -gt 0 ]]; then
        log_info "Output directory: $OUTPUT_DIR"
        ls -lh "$OUTPUT_DIR"
    fi

    [[ $success -gt 0 ]] && exit 0 || exit 1
}
main "$@"