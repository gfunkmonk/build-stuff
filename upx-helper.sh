#!/usr/bin/env bash
#
# Helper script for managing UPX cross-compilation builds
#

set -euo pipefail

WORK_DIR="${PWD}/upx-build"

usage() {
    cat << EOF
UPX Build Helper Script

Usage: $(basename "$0") <command>

Commands:
    clean-builds    Remove all build directories (keeps source & toolchains)
    clean-all       Remove everything (source, toolchains, builds, output)
    clean-output    Remove only output binaries
    clean-cache     Remove only downloaded toolchain tarballs
    list-output     List all built binaries with sizes
    test-binary     Test a specific binary (requires qemu-user-static)
    verify-static   Verify all binaries are statically linked
    package         Create a tarball of all built binaries
    help            Show this help message

Examples:
    $(basename "$0") clean-builds    # Clean builds but keep source
    $(basename "$0") list-output     # Show what's been built
    $(basename "$0") package         # Create upx-binaries.tar.xz

EOF
    exit 0
}

clean_builds() {
    if [[ -d "$WORK_DIR/builds" ]]; then
        echo "Removing build directories..."
        rm -rf "$WORK_DIR/builds"
        echo "Build directories cleaned."
    else
        echo "No build directories found."
    fi
}

clean_all() {
    if [[ -d "$WORK_DIR" ]]; then
        echo "Removing entire work directory: $WORK_DIR"
        read -rp "Are you sure? This will delete source, toolchains, and builds [y/N]: " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf "$WORK_DIR"
            echo "All cleaned."
        else
            echo "Cancelled."
        fi
    else
        echo "No work directory found."
    fi
}

clean_output() {
    if [[ -d "$WORK_DIR/output" ]]; then
        echo "Removing output binaries..."
        rm -rf "$WORK_DIR/output"
        echo "Output directory cleaned."
    else
        echo "No output directory found."
    fi
}

clean_cache() {
    if [[ -d "$WORK_DIR/toolchains" ]]; then
        echo "Removing downloaded toolchain tarballs..."
        find "$WORK_DIR/toolchains" -name "*.tar.xz" -delete
        echo "Cache cleaned."
    else
        echo "No cache found."
    fi
}

list_output() {
    if [[ ! -d "$WORK_DIR/output" ]]; then
        echo "No output directory found. Run build script first."
        exit 1
    fi

    local count=0
    local total_size
    local binary

    for binary in "$WORK_DIR/output"/upx-*; do
        [[ -f "$binary" ]] || continue
        count=$((count + 1))
    done

    if [[ $count -eq 0 ]]; then
        echo "No binaries found in output directory."
        exit 1
    fi

    echo "Built binaries ($count):"
    echo
    for binary in "$WORK_DIR/output"/upx-*; do
        [[ -f "$binary" ]] || continue
        local size
        size=$(du -h "$binary" | cut -f1)
        printf "%s\t%s\n" "$size" "$(basename "$binary")"
    done

    echo
    total_size=$(du -sh "$WORK_DIR/output" | cut -f1)
    echo "Total size: $total_size"
}

verify_static() {
    if ! command -v file &>/dev/null; then
        echo "Error: 'file' command not found"
        exit 1
    fi
    
    if [[ ! -d "$WORK_DIR/output" ]]; then
        echo "No output directory found. Run build script first."
        exit 1
    fi
    
    echo "Verifying static linking..."
    echo
    
    local all_static=true
    
    while IFS= read -r binary; do
        local name
        name=$(basename "$binary")
        local file_output
        file_output=$(file "$binary")
        
        if echo "$file_output" | grep -q "statically linked"; then
            echo "✓ $name - statically linked"
        else
            echo "✗ $name - NOT statically linked"
            all_static=false
        fi
    done < <(find "$WORK_DIR/output" -type f -name "upx-*")
    
    echo
    if $all_static; then
        echo "All binaries are statically linked."
    else
        echo "Warning: Some binaries are not statically linked!"
        exit 1
    fi
}

test_binary() {
    local binary_name=${1:-}

    if [[ -z "$binary_name" ]]; then
        echo "Usage: $0 test-binary <binary-name>"
        echo "Example: $0 test-binary upx-aarch64-unknown-linux-musl"
        exit 1
    fi

    local binary_path="$WORK_DIR/output/$binary_name"

    if [[ ! -f "$binary_path" ]]; then
        echo "Error: Binary not found: $binary_path"
        exit 1
    fi

    echo "Testing binary: $binary_name"
    echo

    # Try to determine architecture from filename and pick the right qemu binary
    local qemu_bin=""
    if   [[ "$binary_name" =~ aarch64 ]];           then qemu_bin="qemu-aarch64-static"
    elif [[ "$binary_name" =~ armv[5-7] ]];          then qemu_bin="qemu-arm-static"
    elif [[ "$binary_name" =~ riscv64 ]];            then qemu_bin="qemu-riscv64-static"
    elif [[ "$binary_name" =~ riscv32 ]];            then qemu_bin="qemu-riscv32-static"
    elif [[ "$binary_name" =~ mips64el ]];           then qemu_bin="qemu-mips64el-static"
    elif [[ "$binary_name" =~ mips64 ]];             then qemu_bin="qemu-mips64-static"
    elif [[ "$binary_name" =~ mipsel ]];             then qemu_bin="qemu-mipsel-static"
    elif [[ "$binary_name" =~ mips ]];               then qemu_bin="qemu-mips-static"
    elif [[ "$binary_name" =~ powerpc64le ]];        then qemu_bin="qemu-ppc64le-static"
    elif [[ "$binary_name" =~ powerpc64 ]];          then qemu_bin="qemu-ppc64-static"
    elif [[ "$binary_name" =~ powerpc ]];            then qemu_bin="qemu-ppc-static"
    elif [[ "$binary_name" =~ s390x ]];              then qemu_bin="qemu-s390x-static"
    elif [[ "$binary_name" =~ loongarch64 ]];        then qemu_bin="qemu-loongarch64-static"
    elif [[ "$binary_name" =~ m68k ]];               then qemu_bin="qemu-m68k-static"
    elif [[ "$binary_name" =~ microblazeel ]];       then qemu_bin="qemu-microblazeel-static"
    elif [[ "$binary_name" =~ microblaze ]];         then qemu_bin="qemu-microblaze-static"
    elif [[ "$binary_name" =~ or1k ]];               then qemu_bin="qemu-or1k-static"
    elif [[ "$binary_name" =~ sh4 ]];                then qemu_bin="qemu-sh4-static"
    fi

    if [[ -n "$qemu_bin" ]] && command -v "$qemu_bin" &>/dev/null; then
        echo "Using $qemu_bin for emulation"
        "$qemu_bin" "$binary_path" --version
    elif [[ -z "$qemu_bin" ]]; then
        # Native architecture (e.g. x86_64, i686) or unknown — try directly
        echo "Trying native execution..."
        "$binary_path" --version
    else
        echo "Warning: qemu emulator '$qemu_bin' not found for this architecture"
        echo "Install qemu-user-static to test cross-architecture binaries"
        echo "  e.g.: sudo apt-get install qemu-user-static"
        exit 1
    fi
}

package_binaries() {
    if [[ ! -d "$WORK_DIR/output" ]]; then
        echo "No output directory found. Run build script first."
        exit 1
    fi
    
    local count
    count=$(find "$WORK_DIR/output" -type f -name "upx-*" | wc -l)
    
    if [[ $count -eq 0 ]]; then
        echo "No binaries to package."
        exit 1
    fi
    
    local tarball
    tarball="upx-binaries-$(date +%Y%m%d).tar.xz"
    
    echo "Creating package: $tarball"
    echo "Including $count binaries..."
    
    tar -cJf "$tarball" -C "$WORK_DIR" output/
    
    local size
    size=$(du -h "$tarball" | cut -f1)
    echo "Package created: $tarball ($size)"
    echo "Extract with: tar -xJf $tarball"
}

main() {
    local cmd=${1:-}
    
    case "$cmd" in
        clean-builds)
            clean_builds
            ;;
        clean-all)
            clean_all
            ;;
        clean-output)
            clean_output
            ;;
        clean-cache)
            clean_cache
            ;;
        list-output|list)
            list_output
            ;;
        verify-static|verify)
            verify_static
            ;;
        test-binary|test)
            test_binary "${2:-}"
            ;;
        package)
            package_binaries
            ;;
        help|--help|-h|"")
            usage
            ;;
        *)
            echo "Error: Unknown command: $cmd"
            echo
            usage
            ;;
    esac
}

main "$@"