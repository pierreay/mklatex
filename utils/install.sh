#!/usr/bin/env bash

if [[ ! -d "mklatex" ]]; then
    echo "[+] Clone mklatex submodule..."
    git submodule add https://github.com/pierreay/mklatex mklatex
else
    echo "[+] mklatex detected!"
fi
