#! /usr/bin/env bash

(
    set -e
    cd -- "$1"
    if [[ "$2" == "c++" ]]; then
        clang++ main.cpp -std=c++23 -stdlib=libc++ -o main.bin
        ./main.bin
    elif [[ "$2" == "nim" ]]; then
        nim c main.nim
        ./main
    elif [[ "$2" == "cl" ]]; then
        sbcl --script main.lsp
    fi
)
