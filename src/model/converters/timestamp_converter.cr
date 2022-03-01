# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

# JSON converter for serializing and deserializing an ISO8601 timestamp into its
# `Time` representation.
module Servo::Model::TimestampConverter
  # Deserializes an ISO861 timestamp string to a `Time` object.
  def self.from_json(parser : JSON::PullParser) : Time?
    if time = parser.read_string_or_null
      begin
        Time::Format.new("%FT%T.%6N%:z").parse(time)
      rescue Time::Format::Error
        Time::Format.new("%FT%T%:z").parse(time)
      end
    end
  end

  # Serializes a `Time` object into an ISO861 timestamp string.
  #
  # This string is null if the *value* was nil.
  def self.to_json(value : Time?, builder : JSON::Builder) : String
    if value
      Time::Format.new("%FT%T.%6N%:z").to_json(value, builder)
    else
      builder.null
    end
  end
end
