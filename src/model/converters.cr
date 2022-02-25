# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

module Servo::Model
  # JSON converter for serializing and deserializing a String snowflake
  # representation to a UInt64.
  module SnowflakeConverter
    def self.from_json(parser : JSON::PullParser)
      snowflake_str = parser.read_string
      snowflake_str.to_u64
    end

    def self.to_json(snowflake : Snowflake, builder : JSON::Builder)
      snowflake_str = snowflake.to_s
      snowflake_str.to_json(builder)
    end
  end

  # JSON converter for serializing and deserializing a String snowflake
  # representation to a UInt64. This converter is for snowflakes that can be nil.
  module NilableSnowflakeConverter
    def self.from_json(parser : JSON::PullParser)
      if parser.kind.null?
        parser.read_null
        return nil
      end
      SnowflakeConverter.from_json(parser)
    end

    def self.to_json(snowflake : Snowflake?, builder : JSON::Builder)
      if snowflake
        SnowflakeConverter.to_json(snowflake, builder)
      else
        builder.null
      end
    end
  end
end
