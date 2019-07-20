// Copyright (c) 2019 Dr. Colin Hirsch and Daniel Frey
// Please see LICENSE for license or visit https://github.com/taocpp/json/

#ifndef TAO_JSON_EVENTS_INVALID_STRING_TO_HEX_HPP
#define TAO_JSON_EVENTS_INVALID_STRING_TO_HEX_HPP

#include "../internal/hexdump.hpp"
#include "../utf8.hpp"

namespace tao::json::events
{
   template< typename Consumer >
   struct invalid_string_to_hex
      : public Consumer
   {
      using Consumer::Consumer;

      void string( const std::string_view v )
      {
         if( internal::validate_utf8( v ) ) {
            Consumer::string( v );
         }
         else {
            Consumer::string( internal::hexdump( v ) );
         }
      }
   };

}  // namespace tao::json::events

#endif