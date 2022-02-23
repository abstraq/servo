# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"
require "athena-event_dispatcher"

# Event fired for all gateway messages.
class Servo::Event::GatewayMessageEvent < AED::Event
  # The name of the gateway event.
  getter event_name : String

  # The data sent in the event.
  getter payload : JSON::Any

  def initialize(@event_name : String, payload : String)
    @payload = JSON.parse(payload)
  end
end
