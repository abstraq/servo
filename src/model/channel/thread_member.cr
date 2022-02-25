# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"

require "../snowflake"
require "../converters"

struct Servo::Model::ThreadMember
  include JSON::Serializable

  @[JSON::Field(converter: Servo::Model::NilableSnowflakeConverter)]
  getter id : Servo::Model::Snowflake?

  @[JSON::Field(converter: Servo::Model::NilableSnowflakeConverter)]
  getter user_id : Servo::Model::Snowflake?

  getter join_timestamp : String

  getter flags : UInt8
end
