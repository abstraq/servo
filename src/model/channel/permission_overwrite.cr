# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"

require "../snowflake"
require "../permissions"
require "../converters/snowflake_converter"

# Represents a [Overwrite](https://discord.com/developers/docs/resources/channel#overwrite-object).
#
# Overwrites override role or user permissions on a channel level.
struct Servo::Model::PermissionOverwrite
  include JSON::Serializable

  # Role or user id.
  @[JSON::Field(converter: Servo::Model::SnowflakeConverter)]
  getter id : Servo::Model::Snowflake

  # The type of overwrite.
  getter type : OverwriteType

  # Permission bit set to allow.
  getter allow : Servo::Model::Permissions

  # Permission bit set to deny.
  getter deny : Servo::Model::Permissions

  enum OverwriteType : UInt8
    Role   = 0
    Member = 1

    def self.new(pull : JSON::PullParser)
      OverwriteType.new(pull.read_int.to_u8)
    end
  end
end
