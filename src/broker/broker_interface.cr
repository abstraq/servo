# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "msgpack"

# Interface for Servo brokers.
#
# A broker is the middle-man between the gateway and your application.
# Spectacles currently offers two brokers : Redis and AMQP. Servo
# only implements a redis broker however an AMQP broker can be implemented
# by including this interface and implementing the abstract methods.
module Servo::Broker::BrokerInterface
  # Publishes data to the broker.
  abstract def publish(event_name : String, data : Hash(String, String)) : Nil

  # Subscribes the broker to an event.
  abstract def subscribe(event_name : String) : Nil

  # Subscribes the broker to multiple events.
  def subscribe(event_names : Array(String)) : Nil
    event_names.each do |name|
      self.subscribe(name)
    end
  end

  # Decodes MessagePack encoded JSON string.
  #
  # For events, Spectacle gateway sends data as JSON strings encoded with
  # MessagePack. This method takes the encoded *data* string and decodes
  # it to a JSON string for use with a deserializer.
  protected def decode(data : String) : String
    String.from_msgpack(data)
  end
end
