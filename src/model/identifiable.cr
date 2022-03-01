# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"

require "../util/snowflake_util"
require "./snowflake"
require "./converters/snowflake_converter"

# Represents a object that contains an id.
module Servo::Model::Identifiable
  # The id of this object.
  @[JSON::Field(converter: Servo::Model::SnowflakeConverter)]
  getter id : Servo::Model::Snowflake

  # The time this object was created.
  def created_at : Time
    Servo::Util::SnowflakeUtil.get_creation_time(@id)
  end
end
