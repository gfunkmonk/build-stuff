# UPX Cross-Compilation Build Script

This script cross-compiles [UPX (Ultimate Packer for eXecutables)](https://github.com/gfunkmonk/upx) using musl-cross toolchains from the [eastwood release](https://github.com/gfunkmonk/musl-cross/releases/tag/eastwood).

## Features

- **Automated toolchain download**: Downloads and extracts only the needed musl-cross toolchains
- **wget / curl support**: Uses `wget` if available, falls back to `curl` automatically
- **Static linking**: Produces fully static binaries that run on any Linux system
- **Multi-architecture support**: Easily build for multiple architectures in one run
- **Parallel builds**: Uses all available CPU cores
- **Incremental builds**: Reuses downloaded toolchains and source code
- **Resume support**: Skip already-built architectures with `--resume`
- **Architecture selection**: Pass specific architecture triples as arguments
- **Error handling**: Comprehensive error checking and reporting

## Requirements

- `git` - for cloning UPX source
- `cmake` 3.13+ - UPX build system
- `make` - GNU make
- `wget` or `curl` - for downloading toolchains
- `tar` - for extracting toolchains
- Linux host system (x86_64 recommended)

## Quick Start

```bash
# Make the script executable (if not already)
chmod +x build-upx.sh

# Build UPX for default architectures
./build-upx.sh
```

## Usage

```
Usage: build-upx.sh [OPTIONS] [ARCH_TRIPLE ...]

Options:
    --resume         Skip architectures that already have a built output binary
    --work-dir DIR   Override the work directory (default: ./upx-build)
    --help           Show this help message

Arguments:
    ARCH_TRIPLE      One or more architecture triples to build
                     (e.g. i686-unknown-linux-musl armv7-unknown-linux-musleabihf)
                     If none given, all enabled architectures in ARCHITECTURES[] are built.

Examples:
    ./build-upx.sh                                      # Build all enabled architectures
    ./build-upx.sh i686-unknown-linux-musl              # Build only i686
    ./build-upx.sh --resume                             # Build, skipping already-built targets
    ./build-upx.sh --work-dir /tmp/upx-build            # Use a custom work directory
```

## Default Architectures

By default, the script builds for these architectures:
- `i686-unknown-linux-musl` - 32-bit Intel/AMD
- `armv7-unknown-linux-musleabihf` - 32-bit ARM v7 with hard float
- `mips-unknown-linux-muslsf` - MIPS soft-float

To enable additional architectures, uncomment or add entries in the `ARCHITECTURES` array.

## Available Architectures

The eastwood release provides 32 different toolchains. Uncomment or add any of these to the `ARCHITECTURES` array:

```bash
# Intel/AMD
i386-unknown-linux-musl
i486-unknown-linux-musl
i586-unknown-linux-musl
i686-unknown-linux-musl
x86_64-unknown-linux-musl

# ARM
armv5-unknown-linux-musleabi
armv6-unknown-linux-musleabi
armv6-unknown-linux-musleabihf
armv7-unknown-linux-musleabi
armv7-unknown-linux-musleabihf
aarch64-unknown-linux-musl

# MIPS
mips-unknown-linux-musl
mips-unknown-linux-muslsf
mips64-unknown-linux-musl
mips64el-unknown-linux-musl
mipsel-unknown-linux-musl
mipsel-unknown-linux-muslsf

# PowerPC
powerpc-unknown-linux-musl
powerpc-unknown-linux-muslsf
powerpc64-unknown-linux-musl
powerpc64le-unknown-linux-musl
powerpcle-unknown-linux-musl
powerpcle-unknown-linux-muslsf

# RISC-V
riscv32-unknown-linux-musl
riscv64-unknown-linux-musl

# Other
loongarch64-unknown-linux-musl
m68k-unknown-linux-musl
microblaze-xilinx-linux-musl
microblazeel-xilinx-linux-musl
or1k-unknown-linux-musl
s390x-ibm-linux-musl
sh4-multilib-linux-musl
```

## Customization

### Change UPX Source

Edit these variables at the top of the script:

```bash
UPX_REPO="https://github.com/gfunkmonk/upx.git"
UPX_BRANCH="devel"
```

### Add/Remove Architectures

Edit the `ARCHITECTURES` array in the script. Format is `"triple:cmake_processor"`:

```bash
declare -a ARCHITECTURES=(
    "i686-unknown-linux-musl:i686"
    "aarch64-unknown-linux-musl:aarch64"
    # Add more here...
)
```

### Change Build Directory

```bash
WORK_DIR="${PWD}/upx-build"  # Change this to your preferred location
```

Or use the `--work-dir` option at runtime:
```bash
./build-upx.sh --work-dir /path/to/dir
```

### Optimization Flags

The script uses `-Os` (optimize for size) by default. To change this, edit the toolchain file generation:

```bash
# In the build_upx() function, change:
set(CMAKE_C_FLAGS "\${CMAKE_C_FLAGS} -O3")    # For speed
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -O3")
```

## Output

Built binaries are placed in `./upx-build/output/` with names like:
- `upx-i686-unknown-linux-musl`
- `upx-armv7-unknown-linux-musleabihf`
- etc.

All binaries are:
- Statically linked (no runtime dependencies)
- Stripped of debug symbols
- Ready to run on any Linux system of the target architecture

## Directory Structure

```
upx-build/
├── upx/              # Cloned UPX source
├── toolchains/       # Downloaded musl-cross toolchains
│   ├── i686-unknown-linux-musl/
│   ├── armv7-unknown-linux-musleabihf/
│   └── ...
├── builds/           # Build directories (one per arch)
│   ├── i686-unknown-linux-musl/
│   ├── armv7-unknown-linux-musleabihf/
│   └── ...
└── output/           # Final binaries
    ├── upx-i686-unknown-linux-musl
    ├── upx-armv7-unknown-linux-musleabihf
    └── ...
```

## Incremental Builds

The script is designed to be run multiple times efficiently:
- **UPX source**: Only cloned once, then updated with `git pull`
- **Toolchains**: Downloaded once per architecture, then reused
- **Builds**: Cleaned each time to ensure fresh builds

Use `--resume` to also skip architectures whose output binary already exists:
```bash
./build-upx.sh --resume
```

To force a clean start:
```bash
rm -rf upx-build/
./build-upx.sh
```

## Helper Script

`upx-helper.sh` provides convenience commands for managing builds:

```bash
./upx-helper.sh clean-builds    # Clean builds but keep source and toolchains
./upx-helper.sh clean-all       # Remove everything
./upx-helper.sh clean-output    # Remove only output binaries
./upx-helper.sh list-output     # Show what has been built
./upx-helper.sh verify-static   # Verify all binaries are statically linked
./upx-helper.sh package         # Create upx-binaries-<date>.tar.xz
./upx-helper.sh test-binary <name>  # Test a specific binary (requires qemu-user-static)
```

## Build Time

Build time depends on:
- Number of architectures
- CPU cores available
- Download speed

Approximate times on a modern 8-core system:
- Single architecture: 2-5 minutes (including download)
- Six architectures: 10-20 minutes

## Troubleshooting

### CMake version too old
```
Error: CMake 3.13+ required, found: 3.10
```
Solution: Install a newer CMake from https://cmake.org/

### Download failure
```
Failed to download armv7-unknown-linux-musleabihf.tar.xz
```
Solution: Check your internet connection and try again. The script will skip failed architectures and continue.

### Build failure
```
Build failed for riscv64-unknown-linux-musl
```
Check the error messages. Common issues:
- Incompatible C++ standard (GCC too old in toolchain)
- Missing submodules (script initializes them automatically)

### Binary not statically linked
```
Warning: may not be statically linked
```
This shouldn't happen with musl toolchains, but if it does:
1. Check the CMake toolchain file
2. Ensure `-static` flags are in `CMAKE_EXE_LINKER_FLAGS`

## Testing Binaries

On the target architecture:
```bash
# Copy the binary to target system
scp upx-build/output/upx-aarch64-unknown-linux-musl user@arm64-host:~/

# On the target
chmod +x ~/upx-aarch64-unknown-linux-musl
./upx-aarch64-unknown-linux-musl --version

# Test compression
./upx-aarch64-unknown-linux-musl --best /bin/ls -o ls-compressed
./ls-compressed --help
```

Or use the helper script with qemu-user-static:
```bash
sudo apt-get install qemu-user-static
./upx-helper.sh test-binary upx-aarch64-unknown-linux-musl
```

## License

This build script is provided as-is for convenience. UPX itself is licensed under GPL v2+. See the [UPX repository](https://github.com/gfunkmonk/upx) for details.

## Credits

- UPX: https://github.com/upx/upx
- musl-cross: https://github.com/gfunkmonk/musl-cross
- gfunkmonk's forks used in this script
