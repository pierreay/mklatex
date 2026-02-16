#!/usr/bin/env bash

function install_file() {
    src="mklatex/etc/example/$1"
    dst="$2"
    echo "[+] Cat $src to $dst..."
    cat "$src" >> "$dst"
}

if [[ ! -d "mklatex" ]]; then
    echo "[+] Clone mklatex submodule..."
    git submodule add https://github.com/pierreay/mklatex mklatex
else
    echo "[+] mklatex detected!"
fi

echo "[+] Create directory hierarchy..."
mkdir -p src/tex
mkdir -p src/bib
mkdir -p src/gfx/inkscape
mkdir -p src/gfx/drawio
mkdir -p etc/tex
mkdir -p etc/make

echo "[+] Install local build files..."
install_file Makefile Makefile
install_file dot.env .env
install_file dot.env.private .env.private
install_file dot.exrc .exrc
install_file dot.gitignore .gitignore
install_file dot.gitlab-ci.yml .gitlab-ci.yml
install_file dot.mklatexrc .mklatexrc
install_file etc/tex/mklatex.sty etc/tex/mklatex.sty
install_file etc/make/common.mk etc/make/common.mk
install_file etc/make/private.mk etc/make/private.mk
