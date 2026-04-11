#!/bin/bash

for built in 7zz curl uasm jq mold; do
  src="$built-build/output"
  upx --lzma $src/*
done

