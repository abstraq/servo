# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "../model/snowflake"

# Utility methods for interacting with a `Servo::Model::Snowflake`.
module Servo::Util::SnowflakeUtil
  # The discord epoch used to determine the creation time of a `Snowflake`.
  # This is the first second of 2015.
  DISCORD_EPOCH = 1420070400000_u64

  # Helper method for retrieving the time a `Snowflake` was created.
  def self.get_creation_time(snowflake : Servo::Model::Snowflake) : Time
    ms = (snowflake >> 22) + DISCORD_EPOCH
    Time.unix_ms(ms)
  end
end
