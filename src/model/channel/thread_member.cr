# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"

require "../snowflake"
require "../converters/*"

# Represents a [Thread Member](https://discord.com/developers/docs/resources/channel#thread-member-object).
#
# Used to indicate whether a user has joined a thread or not.
struct Servo::Model::ThreadMember
  include JSON::Serializable

  # The ID of the thread.
  #
  # This ID is not sent within each thread in the GUILD_CREATE event.
  @[JSON::Field(converter: Servo::Model::SnowflakeConverter)]
  getter id : Servo::Model::Snowflake?

  # The ID of the user.
  #
  # This ID is not sent within each thread in the GUILD_CREATE event.
  @[JSON::Field(converter: Servo::Model::SnowflakeConverter)]
  getter user_id : Servo::Model::Snowflake?

  # The time the user last joined the thread.
  @[JSON::Field(converter: Servo::Model::TimestampConverter)]
  getter join_timestamp : Time

  getter flags : UInt8
end
