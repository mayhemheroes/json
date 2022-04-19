#!/bin/sh

mkdir -p "fuzz_targets"

for src in .code-intelligence/fuzz_targets/*.cpp; do
    clang++ -DFUZZ=LLVMFuzzerTestOneInput -Iinclude/ -Iexternal/PEGTL/include -std=c++17 -fsanitize=fuzzer -o "fuzz_targets/$(basename "$src" .cpp)" "$src"
done
