#!/bin/sh

CFG="$HOME/.config/i3"
CFGD="$CFG/config.d"

find "$CFGD" -maxdepth 1 -type f -print0 | xargs -0n1 basename | sort -n | \
  while read C; do
    echo "# $C"
    cat "$CFGD/$C"
  done > "$CFG/config"
