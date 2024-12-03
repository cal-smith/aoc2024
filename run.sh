#! /usr/bin/env bash

(
    set -e
    cd -- "$1"
    if [[ "$2" == "c++" ]]; then
        clang++ main.cpp -std=c++23 -stdlib=libc++ -o main.bin
        ./main.bin
    elif [[ "$2" == "nim" ]]; then
        nim --deepcopy:on r main.nim
    elif [[ "$2" == "cl" ]]; then
        sbcl --script main.lsp
    elif [[ "$2" == "ml" ]]; then
        ocaml main.ml
    fi
)
