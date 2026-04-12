#!/usr/bin/env bash

set -euo pipefail

COMMON_SH="$(dirname "$0")/../common.sh"
GCC_REPO="gfunkmonk/musl-cross"
CLANG_REPO="gfunkmonk/clang-cross"

fetch_hashes() {
    local repo="$1"
    local tag="$2"

    curl -s "https://api.github.com/repos/${repo}/releases/tags/${tag}" \
        | jq -r '.body' \
        | grep '\.tar\.xz' \
        | awk -F'|' '{
            gsub(/ /,"",$2);
            gsub(/ /,"",$3);
            if ($2 ~ /\.tar\.xz$/ && length($3) == 64)
                print "  ["$2"]=\""$3"\""
          }'
}

build_table() {
    local var_name="$1"
    local repo="$2"
    local tag="$3"

    echo "declare -A ${var_name}=("
    fetch_hashes "$repo" "$tag"
    echo ")"
}

replace_table() {
    local var_name="$1"
    local new_block="$2"
    local file="$3"

    # Write new block to a temp file
    local tmp
    tmp=$(mktemp)
    echo "$new_block" > "$tmp"

    # Replace everything from "declare -A VAR=(" up to and including the closing ")"
    perl -i -0pe "s|declare -A ${var_name}=\(.*?\)|\$(cat $tmp)|se" "$file"
    rm -f "$tmp"
}

usage() {
    echo "Usage: $0 --gcc-tag <tag> --clang-tag <tag>"
    echo "Example: $0 --gcc-tag ladder --clang-tag magazine"
    exit 1
}

GCC_TAG=""
CLANG_TAG=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --gcc-tag)   GCC_TAG="$2";   shift 2 ;;
        --clang-tag) CLANG_TAG="$2"; shift 2 ;;
        *) usage ;;
    esac
done

[[ -z "$GCC_TAG" || -z "$CLANG_TAG" ]] && usage

echo "Fetching GCC hashes from release: $GCC_TAG"
GCC_BLOCK=$(build_table "HASHES_GCC" "$GCC_REPO" "$GCC_TAG")
echo "Fetching Clang hashes from release: $CLANG_TAG"
CLANG_BLOCK=$(build_table "HASHES_CLANG" "$CLANG_REPO" "$CLANG_TAG")

echo "Updating $COMMON_SH..."
replace_table "HASHES_GCC"   "$GCC_BLOCK"   "$COMMON_SH"
replace_table "HASHES_CLANG" "$CLANG_BLOCK" "$COMMON_SH"

echo "Done. Verify with: grep -A2 'declare -A HASHES' $COMMON_SH"