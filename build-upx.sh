#!/usr/bin/env bash
#
# Cross-compile UPX using musl-cross toolchains from gfunkmonk/musl-cross
# Source: https://github.com/gfunkmonk/upx
# Toolchains: https://github.com/gfunkmonk/musl-cross/releases/tag/eastwood
#
# Usage: ./build-upx.sh [OPTIONS] [ARCH_TRIPLE ...]

set -euo pipefail
shopt -s extglob

# =============================================================================
# CONFIGURATION
# =============================================================================

readonly UPX_REPO="https://github.com/gfunkmonk/upx.git"
readonly UPX_BRANCH="devel"
readonly TOOLCHAIN_BASE_URL="https://github.com/gfunkmonk/musl-cross/releases/download/eastwood"
readonly DEFAULT_WORK_DIR="./upx-build"

# Runtime configuration (updated by argument parsing)
WORK_DIR=""
TOOLCHAIN_DIR=""
SOURCE_DIR=""
BUILD_BASE=""
OUTPUT_DIR=""
RESUME=false
CLEAN=false
KEEP_TOOLCHAIN=false
PARALLEL_JOBS=""
DRY_RUN=false
VERBOSE=false

# Architectures to build (triple:cmake_system_processor)
#
# Uncomment to add more architectures
readonly -a ARCHITECTURES=(
    "i386-unknown-linux-musl:i386"
#    "i486-unknown-linux-musl:i486"
#    "i586-unknown-linux-musl:i586"
    "i686-unknown-linux-musl:i686"
    "x86_64-unknown-linux-musl:x86_64"
    "armv5-unknown-linux-musleabi:armv5"
    "armv6-unknown-linux-musleabi:armv6"
    "armv6-unknown-linux-musleabihf:armv6"
    "armv7-unknown-linux-musleabi:armv7"
    "armv7-unknown-linux-musleabihf:armv7"
    "aarch64-unknown-linux-musl:aarch64"
    "mips-unknown-linux-musl:mips"
    "mips-unknown-linux-muslsf:mips"
    "mips64-unknown-linux-musl:mips64"
    "mips64el-unknown-linux-musl:mips64el"
    "mipsel-unknown-linux-musl:mipsel"
    "mipsel-unknown-linux-muslsf:mipsel"
    "powerpc-unknown-linux-musl:powerpc"
    "powerpc-unknown-linux-muslsf:powerpc"
    "powerpc64-unknown-linux-musl:ppc64"
    "powerpc64le-unknown-linux-musl:ppc64le"
    "powerpcle-unknown-linux-musl:powerpcle"
    "powerpcle-unknown-linux-muslsf:powerpcle"
    "riscv32-unknown-linux-musl:riscv32"
    "riscv64-unknown-linux-musl:riscv64"
    "loongarch64-unknown-linux-musl:loongarch64"
    "m68k-unknown-linux-musl:m68k"
    "microblaze-xilinx-linux-musl:microblaze"
    "microblazeel-xilinx-linux-musl:microblazeel"
    "or1k-unknown-linux-musl:or1k"
    "s390x-ibm-linux-musl:s390x"
    "sh4-multilib-linux-musl:sh4"
)

# Color output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly NC='\033[0m'

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_debug() {
    if $VERBOSE; then
        echo -e "${BLUE}[DEBUG]${NC} $*"
    fi
}

log_dryrun() {
    echo -e "${MAGENTA}[DRYRUN]${NC} $*"
}

die() {
    log_error "$@"
    exit 1
}

get_nproc() {
    if command -v nproc >/dev/null 2>&1; then
        nproc 2>/dev/null || echo 2
    elif command -v sysctl >/dev/null 2>&1; then
        sysctl -n hw.ncpu 2>/dev/null || echo 2
    else
        echo 2
    fi
}

# Validate and sanitize path to prevent directory traversal
sanitize_path() {
    local path="$1"
    local base_dir="$2"
    
    # Remove any trailing slashes
    path="${path%/}"
    
    # Check for directory traversal attempts
    if [[ "$path" == *"/../"* ]] || [[ "$path" == "../"* ]]; then
        die "Invalid path (directory traversal detected): $path"
    fi
    
    # Ensure path is absolute or relative to base_dir
    [[ "$path" == /* ]] || path="$base_dir/$path"
    
    # Resolve to absolute path
    if command -v realpath >/dev/null 2>&1; then
        path=$(realpath -m "$path")
    else
        # Fallback: ensure we don't have double slashes
        path="${path//\/\//\/}"
    fi
    
    # Verify path is within base_dir
    if [[ "$path" != "$base_dir"* ]] && [[ "$base_dir" != "/"* ]]; then
        die "Path outside work directory: $path"
    fi
    
    echo "$path"
}

# Validate architecture triple format
validate_triple() {
    local triple="$1"
    
    # Basic triple format: arch-vendor-os-abi (e.g., x86_64-unknown-linux-musl)
    if [[ ! "$triple" =~ ^[a-zA-Z0-9_]+-[a-zA-Z0-9_]+-[a-zA-Z0-9_]+(-[a-zA-Z0-9_]+)?$ ]]; then
        die "Invalid architecture triple format: $triple"
    fi
}

# =============================================================================
# DEPENDENCY CHECKING
# =============================================================================

check_dependencies() {
    local missing=()
    
    if ! command -v git >/dev/null 2>&1; then missing+=("git"); fi
    if ! command -v cmake >/dev/null 2>&1; then missing+=("cmake"); fi
    if ! command -v make >/dev/null 2>&1; then missing+=("make"); fi
    if ! command -v tar >/dev/null 2>&1; then missing+=("tar"); fi
    if ! command -v wget >/dev/null 2>&1 && ! command -v curl >/dev/null 2>&1; then
        missing+=("wget or curl")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        die "Missing dependencies: ${missing[*]}. Please install them first."
    fi

    # Check CMake version
    local cmake_version cmake_major cmake_minor
    cmake_version=$(cmake --version 2>/dev/null | head -n1 | awk '{print $3}' || echo "0")
    cmake_major=$(echo "$cmake_version" | cut -d. -f1)
    cmake_minor=$(echo "$cmake_version" | cut -d. -f2)
    
    if [[ $cmake_major -lt 3 ]] || { [[ $cmake_major -eq 3 ]] && [[ ${cmake_minor:-0} -lt 13 ]]; }; then
        die "CMake 3.13+ required (found $cmake_version)"
    fi

    log_info "Dependencies OK (CMake $cmake_version)"
}

# =============================================================================
# DIRECTORY SETUP
# =============================================================================

setup_directories() {
    # Ensure work directory is absolute
    WORK_DIR=$(sanitize_path "$WORK_DIR" "$PWD")
    
    TOOLCHAIN_DIR="$WORK_DIR/toolchains"
    SOURCE_DIR="$WORK_DIR/upx"
    BUILD_BASE="$WORK_DIR/builds"
    OUTPUT_DIR="$WORK_DIR/output"
    
    # Secure directory creation with validation
    if $DRY_RUN; then
        log_dryrun "Would create directories: $WORK_DIR"
    else
        for dir in "$TOOLCHAIN_DIR" "$BUILD_BASE" "$OUTPUT_DIR"; do
            [[ -d "$dir" ]] || mkdir -p "$dir"
            if [[ ! -w "$dir" ]]; then
                die "Cannot write to directory: $dir"
            fi
        done
    fi
    
    log_info "Work directories:"
    log_debug "  Work dir: $WORK_DIR"
    log_debug "  Toolchains: $TOOLCHAIN_DIR"
    log_debug "  Source: $SOURCE_DIR"
    log_debug "  Builds: $BUILD_BASE"
    log_debug "  Output: $OUTPUT_DIR"
    
    if $CLEAN; then
        log_info "Cleaning build directories..."
        if $DRY_RUN; then
            log_dryrun "Would clean: ${BUILD_BASE}/* ${OUTPUT_DIR}/*"
        else
            rm -rf "${BUILD_BASE:?}"/* "${OUTPUT_DIR:?}"/*
        fi
    fi
}

# =============================================================================
# UPX SOURCE MANAGEMENT
# =============================================================================

clone_or_update_upx() {
    if [[ -d "$SOURCE_DIR/.git" ]]; then
        log_info "UPX source exists, updating..."
        if $DRY_RUN; then
            log_dryrun "Would update: $SOURCE_DIR"
            return 0
        fi
        
        pushd "$SOURCE_DIR" >/dev/null
        git fetch origin >/dev/null 2>&1 || log_warn "Failed to fetch updates"
        git checkout "$UPX_BRANCH" >/dev/null 2>&1
        git pull origin "$UPX_BRANCH" >/dev/null 2>&1 || log_warn "Pull failed, using existing source"
        popd >/dev/null
    else
        log_info "Cloning UPX repository..."
        if $DRY_RUN; then
            log_dryrun "Would clone: $UPX_REPO to $SOURCE_DIR"
            return 0
        fi
        
        if ! git clone --depth=1 --branch "$UPX_BRANCH" "$UPX_REPO" "$SOURCE_DIR"; then
            die "Failed to clone UPX repository"
        fi
    fi

    # Update submodules
    if [[ -f "$SOURCE_DIR/.gitmodules" ]]; then
        log_info "Updating submodules..."
        if ! $DRY_RUN; then
            pushd "$SOURCE_DIR" >/dev/null
            git submodule update --init --recursive >/dev/null 2>&1 || log_warn "Failed to update submodules"
            popd >/dev/null
        fi
    fi
    
    local commit_hash
    commit_hash=$(git -C "$SOURCE_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
    log_info "UPX source ready ($commit_hash)"
}

# =============================================================================
# TOOLCHAIN MANAGEMENT
# =============================================================================

download_toolchain() {
    local triple=$1
    validate_triple "$triple"
    
    local tarball="${triple}.tar.xz"
    local toolchain_path="$TOOLCHAIN_DIR/$triple"

    if [[ -d "$toolchain_path" && -x "$toolchain_path/bin/${triple}-gcc" ]]; then
        log_debug "Toolchain $triple already exists"
        return 0
    fi

    if $DRY_RUN; then
        log_dryrun "Would download: $triple"
        return 0
    fi

    log_info "Downloading toolchain: $triple"
    local url="$TOOLCHAIN_BASE_URL/$tarball"
    local tmpfile="$TOOLCHAIN_DIR/$tarball.partial"

    # Ensure parent directory exists
    mkdir -p "$(dirname "$tmpfile")"
    
    # Download with resume capability and timeout
    local download_success=false
    if command -v wget >/dev/null 2>&1; then
        if wget -q --timeout=300 --continue --show-progress -O "$tmpfile" "$url"; then
            download_success=true
        fi
    elif command -v curl >/dev/null 2>&1; then
        if curl -fL --max-time 300 --continue-at=- --progress-bar -o "$tmpfile" "$url"; then
            download_success=true
        fi
    fi
    
    if ! $download_success; then
        rm -f "$tmpfile"
        return 1
    fi

    log_info "Extracting toolchain: $triple"
    mkdir -p "$toolchain_path"
    
    # Verify tarball integrity before extraction
    if ! tar -tJf "$tmpfile" >/dev/null 2>&1; then
        log_error "Corrupted tarball for $triple"
        rm -f "$tmpfile"
        return 1
    fi
    
    if ! tar -xJf "$tmpfile" -C "$toolchain_path" --strip-components=1; then
        rm -rf "$toolchain_path" "$tmpfile"
        return 1
    fi

    if $KEEP_TOOLCHAIN; then
        mv "$tmpfile" "$TOOLCHAIN_DIR/$tarball"
    else
        rm -f "$tmpfile"
    fi
    log_info "✓ Toolchain $triple ready"
}

verify_toolchain() {
    local triple=$1
    validate_triple "$triple"
    
    local toolchain_path="$TOOLCHAIN_DIR/$triple"
    local gcc="$toolchain_path/bin/${triple}-gcc"

    if [[ ! -x "$gcc" ]]; then
        log_error "Compiler not found: $gcc"
        return 1
    fi

    # Quick compiler test with timeout
    if ! timeout 10 "$gcc" --version >/dev/null 2>&1; then
        log_error "Compiler test failed for $triple"
        return 1
    fi
    
    log_debug "✓ Toolchain $triple verified"
    return 0
}

# =============================================================================
# BUILD FUNCTIONS
# =============================================================================

should_skip_build() {
    local triple=$1
    [[ $RESUME == true && -f "$OUTPUT_DIR/upx-$triple" && -x "$OUTPUT_DIR/upx-$triple" ]]
}

build_upx() {
    local arch_spec=$1
    local triple=${arch_spec%%:*}
    local cmake_proc=${arch_spec##*:}
    
    validate_triple "$triple"

    echo
    log_info "🔨 Building UPX for $triple"
    echo "=========================================="

    if $DRY_RUN; then
        log_dryrun "Would build $triple"
        return 0
    fi

    # Setup
    if ! download_toolchain "$triple"; then
        return 1
    fi
    
    if ! verify_toolchain "$triple"; then
        return 1
    fi

    local toolchain_path="$TOOLCHAIN_DIR/$triple"
    local build_dir="$BUILD_BASE/$triple"
    local toolchain_file="$build_dir/toolchain.cmake"
    
    rm -rf "$build_dir"
    mkdir -p "$build_dir"

    # Generate toolchain file with secure permissions
    log_debug "Generating toolchain file..."
    cat > "$toolchain_file" << EOF
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR $cmake_proc)

set(CMAKE_C_COMPILER $toolchain_path/bin/${triple}-gcc)
set(CMAKE_CXX_COMPILER $toolchain_path/bin/${triple}-g++)
set(CMAKE_AR $toolchain_path/bin/${triple}-ar)
set(CMAKE_RANLIB $toolchain_path/bin/${triple}-ranlib)
set(CMAKE_STRIP $toolchain_path/bin/${triple}-strip)

set(CMAKE_FIND_ROOT_PATH $toolchain_path/${triple})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Static linking flags
set(CMAKE_EXE_LINKER_FLAGS "-static -Wl,--gc-sections")
set(CMAKE_SHARED_LINKER_FLAGS "-static -Wl,--gc-sections")

# Optimization flags
set(CMAKE_C_FLAGS "\${CMAKE_C_FLAGS} -Os -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-stack-protector -fno-plt")
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -Os -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-stack-protector -fno-plt")
EOF

    chmod 644 "$toolchain_file"

    # Configure with timeout to prevent hanging
    log_info "Configuring CMake..."
    if ! timeout 300 cmake -S "$SOURCE_DIR" -B "$build_dir" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_TOOLCHAIN_FILE="$toolchain_file" \
        -DUPX_CONFIG_DISABLE_GITREV=ON \
        -DUPX_CONFIG_DISABLE_WSTRICT=ON \
        -DUSE_STRICT_DEFAULTS=OFF \
        -DUPX_CONFIG_REQUIRE_THREADS=ON; then
        log_error "❌ CMake failed for $triple"
        return 1
    fi

    # Build with timeout
    local jobs=${PARALLEL_JOBS:-$(get_nproc)}
    log_info "Building ($jobs jobs)..."
    if ! timeout 1800 cmake --build "$build_dir" --parallel "$jobs"; then
        log_error "❌ Build failed for $triple"
        return 1
    fi

    # Find and install binary
    local upx_binary
    upx_binary=$(find "$build_dir" -name upx -type f -executable -print -quit 2>/dev/null)
    
    if [[ -z "$upx_binary" ]]; then
        log_error "❌ UPX binary not found"
        return 1
    fi

    local output_file="$OUTPUT_DIR/upx-$triple"
    cp "$upx_binary" "$output_file"
    chmod 755 "$output_file"
    
    # Strip
    if [[ -x "$toolchain_path/bin/${triple}-strip" ]]; then
        "$toolchain_path/bin/${triple}-strip" "$output_file" 2>/dev/null || true
    fi

    # Stats
    local size
    if stat -f%z "$output_file" >/dev/null 2>&1; then
        size=$(stat -f%z "$output_file")
    else
        size=$(stat -c%s "$output_file" 2>/dev/null || echo "0")
    fi
    
    if command -v numfmt >/dev/null 2>&1; then
        size=$(numfmt --to=iec-i --suffix=B --format="%.1f%s" "$size" 2>/dev/null || echo "${size}B")
    else
        size="${size}B"
    fi
    
    log_info "✅ SUCCESS: upx-$triple ($size)"
    
    # Verify static linking
    if command -v file >/dev/null 2>&1; then
        local file_info
        file_info=$(file "$output_file" 2>/dev/null || echo "unknown")
        if [[ "$file_info" =~ statically\ linked ]]; then
            log_debug "   ✓ Statically linked"
        else
            log_warn "   ⚠  Possibly not fully static: $file_info"
        fi
    fi
    
    # Quick test if possible
    if timeout 10 "$output_file" --version >/dev/null 2>&1; then
        log_debug "   ✓ Self-test passed"
    fi
    
    return 0
}

# =============================================================================
# ARGUMENT PARSING
# =============================================================================

show_usage() {
    cat << 'EOF'
UPX Cross-Compilation Build Script v2.0

USAGE:
    ./build-upx.sh [OPTIONS] [ARCH_TRIPLES...]

OPTIONS:
    --resume         Skip already-built architectures
    --clean          Clean all build artifacts before starting
    --work-dir DIR   Custom work directory (default: ./upx-build)
    --jobs N         Parallel jobs (default: auto-detect)
    --keep           Keep downloaded toolchain tarballs
    --dry-run        Show what would be done without doing it
    --verbose        Show debug output
    --list           List available architectures
    --help, -h       Show this help

EXAMPLES:
    ./build-upx.sh                    # Build enabled architectures
    ./build-upx.sh --resume           # Resume previous build
    ./build-upx.sh i686 armv7 mips    # Build specific arches
    ./build-upx.sh --clean --jobs 8   # Clean build with 8 jobs
    ./build-upx.sh --dry-run --list   # Show what would happen
EOF
    exit 0
}

parse_args() {
    local args=("$@")
    local i=0
    
    while [[ $i -lt ${#args[@]} ]]; do
        case "${args[$i]}" in
            --resume) RESUME=true; (( ++i )) ;;
            --clean) CLEAN=true; (( ++i )) ;;
            --keep) KEEP_TOOLCHAIN=true; (( ++i )) ;;
            --dry-run) DRY_RUN=true; VERBOSE=true; (( ++i )) ;;
            --verbose) VERBOSE=true; (( ++i )) ;;
            --work-dir)
                (( ++i ))
                [[ $i -lt ${#args[@]} ]] || die "--work-dir requires directory"
                WORK_DIR="${args[$i]}"; (( ++i ))
                ;;
            --jobs)
                (( ++i ))
                [[ $i -lt ${#args[@]} ]] || die "--jobs requires number"
                [[ "${args[$i]}" =~ ^[1-9][0-9]*$ ]] || die "--jobs requires a positive integer"
                PARALLEL_JOBS="${args[$i]}"; (( ++i ))
                ;;
            --list)
                echo "Available architectures:"
                for spec in "${ARCHITECTURES[@]}"; do
                    printf '  %-50s (%s)\n' "${spec%%:*}" "${spec##*:}"
                done
                exit 0
                ;;
            --help|-h) show_usage ;;
            -*)
                die "Unknown option: ${args[$i]} (use --help)"
                ;;
            *)
                # Architecture triples - collect all remaining positional args
                REQUESTED_TRIPLES+=("${args[@]:$i}")
                break
                ;;
        esac
    done

    WORK_DIR="${WORK_DIR:-$DEFAULT_WORK_DIR}"
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    local total_start
    total_start=$(date +%s)
    
    log_info "🚀 UPX Cross-Compiler $(date)"
    log_info "======================================"

    parse_args "$@"
    
    if $DRY_RUN; then
        log_info "🐱 Dry run mode enabled"
    fi
    
    check_dependencies
    
    # Validate work directory path before setup
    if [[ -n "$WORK_DIR" ]]; then
        WORK_DIR=$(sanitize_path "$WORK_DIR" "$PWD")
    fi
    
    setup_directories
    clone_or_update_upx

    # Determine build list
    local -a build_list=("${ARCHITECTURES[@]}")

    if [[ ${#REQUESTED_TRIPLES[@]} -gt 0 ]]; then
        log_info "Building requested: ${REQUESTED_TRIPLES[*]}"
        build_list=()
        for triple in "${REQUESTED_TRIPLES[@]}"; do
            # Validate triple format
            if [[ "$triple" =~ : ]]; then
                build_list+=("$triple")
            else
                # Try to find matching architecture
                local found=false
                for spec in "${ARCHITECTURES[@]}"; do
                    if [[ "${spec%%:*}" == "$triple" ]]; then
                        build_list+=("$spec")
                        found=true
                        break
                    fi
                done
                if ! $found; then
                    # Infer processor from triple
                    local inferred_cpu="${triple##*-}"
                    inferred_cpu="${inferred_cpu%%-*}"
                    build_list+=("$triple:$inferred_cpu")
                    log_warn "Inferring processor for $triple"
                fi
            fi
        done
    fi

    log_info "📋 Building ${#build_list[@]} architecture(s)"

    local success=0 failed=0 skipped=0
    local -a failed_list
    
    for arch_spec in "${build_list[@]}"; do
        local triple="${arch_spec%%:*}"
        if should_skip_build "$triple"; then
            log_info "⏭️  Skipping $triple (already built, --resume)"
            ((skipped++))
        elif build_upx "$arch_spec"; then
            ((success++))
        else
            ((failed++))
            failed_list+=("$triple")
        fi
    done

    local duration=$(( $(date +%s) - total_start ))
    log_info "======================================"
    printf '📊 SUMMARY: %d success, %d failed, %d skipped, %d total (%ds)\n' \
        "$success" "$failed" "$skipped" "$((success+failed+skipped))" "$duration"

    if [[ ${#failed_list[@]} -gt 0 ]]; then
        log_warn "❌ Failed: ${failed_list[*]}"
    fi
    
    if [[ $success -gt 0 ]]; then
        log_info "📁 Output: $OUTPUT_DIR/"
        if ! $DRY_RUN; then
            ls -lh "$OUTPUT_DIR/" 2>/dev/null || true
        fi
    fi

    [[ $failed -eq 0 ]] && exit 0 || exit 1
}

main "$@"