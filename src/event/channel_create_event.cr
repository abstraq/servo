# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "athena-event_dispatcher"

require "../model/channel/channel"

# Event fired when a `Servo::Model::Channel` is created.
class Servo::Event::ChannelCreateEvent < AED::Event
  # The name of the gateway event.
  getter event_name : String

  # The data sent in the event.
  getter channel : Servo::Model::Channel

  def initialize(@event_name : String, payload : String)
    @channel = Servo::Model::Channel.from_json(payload)
  end
end
