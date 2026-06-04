#!/bin/bash -eu
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

INCLUDES="-I$SRC/json/include -I$SRC/json/external/PEGTL/include"

# parse_afl_fuzzer: fuzz JSON parsing
cat > /tmp/parse_afl_fuzzer.cpp << EOF
#include <cstdint>
#include <cstring>
#include <stdexcept>
#include <tao/json/from_string.hpp>
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    try {
        std::string s(reinterpret_cast<const char*>(data), size);
        tao::json::from_string(s);
    } catch (...) {}
    return 0;
}
EOF

# parse_cbor_fuzzer: fuzz CBOR parsing
cat > /tmp/parse_cbor_fuzzer.cpp << EOF
#include <cstdint>
#include <cstring>
#include <stdexcept>
#include <tao/json/cbor/from_string.hpp>
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    try {
        std::string s(reinterpret_cast<const char*>(data), size);
        tao::json::cbor::from_string(s);
    } catch (...) {}
    return 0;
}
EOF

# parse_msgpack_fuzzer: fuzz MessagePack parsing
cat > /tmp/parse_msgpack_fuzzer.cpp << EOF
#include <cstdint>
#include <cstring>
#include <stdexcept>
#include <tao/json/msgpack/from_string.hpp>
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    try {
        std::string s(reinterpret_cast<const char*>(data), size);
        tao::json::msgpack::from_string(s);
    } catch (...) {}
    return 0;
}
EOF

# parse_ubjson_fuzzer: fuzz UBJSON parsing
cat > /tmp/parse_ubjson_fuzzer.cpp << EOF
#include <cstdint>
#include <cstring>
#include <stdexcept>
#include <tao/json/ubjson/from_string.hpp>
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    try {
        std::string s(reinterpret_cast<const char*>(data), size);
        tao::json::ubjson::from_string(s);
    } catch (...) {}
    return 0;
}
EOF

# parse_bjdata_fuzzer: bjdata is a superset of ubjson, reuse ubjson parser
cat > /tmp/parse_bjdata_fuzzer.cpp << EOF
#include <cstdint>
#include <cstring>
#include <stdexcept>
#include <tao/json/ubjson/from_string.hpp>
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    try {
        std::string s(reinterpret_cast<const char*>(data), size);
        tao::json::ubjson::from_string(s);
    } catch (...) {}
    return 0;
}
EOF

# parse_bson_fuzzer: bson not natively supported; fuzz JSON as fallback
cat > /tmp/parse_bson_fuzzer.cpp << EOF
#include <cstdint>
#include <cstring>
#include <stdexcept>
#include <tao/json/from_string.hpp>
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    try {
        std::string s(reinterpret_cast<const char*>(data), size);
        tao::json::from_string(s);
    } catch (...) {}
    return 0;
}
EOF

# llvm-symbolizer: fuzz JSON parsing (same target, different binary name)
cat > /tmp/llvm_symbolizer.cpp << EOF
#include <cstdint>
#include <cstring>
#include <stdexcept>
#include <tao/json/from_string.hpp>
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    try {
        std::string s(reinterpret_cast<const char*>(data), size);
        tao::json::from_string(s);
    } catch (...) {}
    return 0;
}
EOF

for FUZZER in parse_afl_fuzzer parse_cbor_fuzzer parse_msgpack_fuzzer parse_ubjson_fuzzer parse_bjdata_fuzzer parse_bson_fuzzer; do
    $CXX $CXXFLAGS -std=c++17 $INCLUDES /tmp/${FUZZER}.cpp $LIB_FUZZING_ENGINE -o $OUT/${FUZZER}
    cp $SRC/fuzzer-parse.options $OUT/${FUZZER}.options
done

$CXX $CXXFLAGS -std=c++17 $INCLUDES /tmp/llvm_symbolizer.cpp $LIB_FUZZING_ENGINE -o $OUT/llvm-symbolizer

cp $SRC/parse_afl_fuzzer.dict $OUT/
