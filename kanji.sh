#!/bin/bash
# Rebuilds backgrounds/1-arasaka-kanji.png: the 荒坂 / ARASAKA CORPORATION mark
# on Arasaka black, 3840x2160, no HUD. Colours and proportions follow unlock.png
# (kanji #E10600, rule #7A0008, text #D8D8DC). Needs Noto Sans CJK JP Black and
# JetBrainsMono Nerd Font Bold.
set -euo pipefail
cd "$(dirname "$0")"
CJK=$(fc-match -f '%{file}' "Noto Sans CJK JP:style=Black")
MONO=$(fc-list | grep -iE 'JetBrainsMono.*Nerd.*-Bold\.ttf' | grep -viE 'propo|mono-?nl' | head -1 | cut -d: -f1)
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
magick -background none -fill '#E10600' -font "$CJK" -pointsize 560 label:'荒坂' -trim +repage "$tmp/k.png"
magick -background none -fill '#D8D8DC' -font "$MONO" -pointsize 74 -kerning 30 label:'ARASAKA CORPORATION' -trim +repage "$tmp/t.png"
read -r kw kh < <(magick identify -format '%w %h\n' "$tmp/k.png")
lw=$(( kw * 92 / 100 )); g1=$(( kh * 28 / 100 )); g2=$(( kh * 17 / 100 ))
magick -background none "$tmp/k.png" '(' -size 1x$g1 xc:none ')' '(' -size ${lw}x8 xc:'#7A0008' ')' \
  '(' -size 1x$g2 xc:none ')' "$tmp/t.png" -gravity center -append +repage "$tmp/mark.png"
magick -size 3840x2160 xc:'#0a0a0c' "$tmp/mark.png" -gravity center -geometry +0-30 -composite backgrounds/1-arasaka-kanji.png
echo backgrounds/1-arasaka-kanji.png
