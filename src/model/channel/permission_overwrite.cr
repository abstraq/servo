# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"

require "../snowflake"
require "../converters"
require "../permissions"

struct Servo::Model::PermissionOverwrite
  include JSON::Serializable

  @[JSON::Field(converter: Servo::Model::SnowflakeConverter)]
  getter id : Servo::Model::Snowflake

  getter type : OverwriteType

  getter allow : Servo::Model::Permissions

  getter deny : Servo::Model::Permissions

  enum OverwriteType : UInt8
    Role   = 0
    Member = 1

    def self.new(pull : JSON::PullParser)
      OverwriteType.new(pull.read_int.to_u8)
    end
  end
end
