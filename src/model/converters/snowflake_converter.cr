# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "../snowflake"

# JSON converter for serializing and deserializing a String snowflake
# representation to a UInt64.
module Servo::Model::SnowflakeConverter
  # Deserializes a snowflake string to a `Servo::Model::Snowflake`.
  def self.from_json(parser : JSON::PullParser)
    if snowflake = parser.read_string_or_null
      snowflake.to_u64
    end
  end

  # Serializes a `Servo::Model::Snowflake` into it's string representation.
  #
  # This string is null if the *value* was nil.
  def self.to_json(snowflake : Servo::Model::Snowflake?, builder : JSON::Builder)
    if snowflake
      builder.string(snowflake)
    else
      builder.null
    end
  end
end
