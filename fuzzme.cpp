// Copyright (c) 2018-2022 Dr. Colin Hirsch and Daniel Frey
// Please see LICENSE for license or visit https://github.com/taocpp/json/

#include <iostream>

#include <tao/json.hpp>

extern "C"{
int LLVMFuzzerTestOneInput(char* data, size_t size) {
   try {
     const tao::json::value v = tao::json::from_string(std::string(data, size));
   } catch(std::exception &) {
   }
   return 0;
}
}
