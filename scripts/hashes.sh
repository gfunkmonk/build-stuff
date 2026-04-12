#!/bin/bash

LAVENDER="\033[38;2;152;115;172m"
HIGHLIGHTER="\033[38;2;248;255;15m"
NEONRED="\033[38;2;255;49;49m"
SKY="\033[38;2;4;218;255m"

if [[ ($@ == "--help") || $@ == "-h" ]]; then
	echo -e "${LAVENDER}Usage: ${NEONRED}$0 ${HIGHLIGHTER} gcc|clang ${SKY}<release>${NC}"
	exit 0
fi

if [ "$1" = "gcc" ]; then REPO="musl-cross"; elif [ "$1" = "clang" ]; then REPO="clang-cross"; fi

curl -s "https://api.github.com/repos/gfunkmonk/$REPO/releases/tags/$2" \
    | jq -r '.body' \
    | grep '\.tar\.xz' \
    | awk -F'|' '{gsub(/ /,"",$2); gsub(/ /,"",$3); print "  ["$2"]=\""$3"\""}'