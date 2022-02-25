# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "redis"
require "redis/streaming"
require "athena-event_dispatcher"

require "../event/*"
require "./broker_interface"

# Implementation of `Servo::Broker::BrokerInterface` for [Redis](https://redis.io/).
#
# Uses [Redis 5 streams](https://redis.io/topics/streams-intro) for communicating with the gateway.
struct Servo::Broker::RedisBroker
  include Servo::Broker::BrokerInterface
  # The `AED::EventDispatcher` instnance this broker should
  # dispatch events to.
  getter dispatcher : AED::EventDispatcherInterface

  # The name of the group to consumes streams on. The name
  # should match the broker group specified on the gateway client.
  getter group : String

  # The base `Redis::Client` instance.
  getter redis : Redis::Client

  # The unique identifier for this broker consumer.
  getter consumer_name : String

  def initialize(@dispatcher : AED::EventDispatcherInterface, uri : String, @consumer_name : String, @group : String = "gateway")
    @redis = Redis::Client.new URI.parse(uri)
    @subscribed_events = Set(String).new
    @auto_claimed_events = Set(String).new
    Servo::Log.info { "Successfully connected to the redis server running at #{uri}!" }
    Servo::Log.info { "Using the consumer name #{@consumer_name} to consume streams." }
  end

  # :inherit:
  #
  # If the stream at the key *event_name* does not exist the key will
  # be created with a stream.
  def publish(event_name : String, data : Hash(String, String)) : Nil
    id = @redis.xadd(event_name, "*", data)
    Servo::Log.debug { "Published message #{id} on stream #{event_name}." }
  end

  # :inherit:
  #
  # This method only tells the broker to listen for incoming messages.
  # If you want to autoclaim unacknowledged messages for a stream you
  # should use `#auto_claim`.
  def subscribe(event_name : String) : Nil
    if @subscribed_events.includes? event_name
      Servo::Log.error { "You are already subscribed to the '#{event_name}' stream." }
      return
    end

    # Create a consumer group for the event.
    # Will fetch the entire stream from the beginning.
    @redis.xgroup_create(event_name, @group, id: "0", mkstream: true) rescue nil
    @subscribed_events.add event_name
    Servo::Log.info { "You will now recieve elements from the '#{event_name}' stream in group #{@group}." }
  end

  # Tells the broker to auto claim messages for the *event_name* stream.
  def auto_claim(event_name : String) : Nil
    if @auto_claimed_events.includes? event_name
      Servo::Log.error { "You are already auto claiming elements for the '#{event_name}' stream." }
      return
    end

    @auto_claimed_events.add event_name
    Servo::Log.info { "You will now auto claim elements for the '#{event_name}' stream in group #{@group}." }
  end

  # Starts the autoclaim listener and incoming message listener with
  # sensible defaults.
  #
  # Before calling this method you should subscribe and autoclaim events
  # with `#subscribe` and `#auto_claim`.
  #
  # If you wish to change the options for the incoming listener or the
  # autoclaim listener you should call `#listen_for_incoming` and
  # `#listen_for_pending` seperately and pass the options into each method.
  #
  # These methods are blocking so you should run them in seperate fibers.
  #
  # Example:
  # ```
  # broker = Servo::Broker::RedisBroker.new
  # # Starts the auto claim listener on a new fiber that will claim messages
  # # that haven't been claimed for 30 seconds.
  # spawn do
  #   broker.listen_for_pending(timeout: 30.seconds)
  # end
  # # Starts the incoming message listener on the main fiber
  # # recieving 30 elements and blocking for 8 seconds.
  # broker.listen_for_incoming(30, 8.seconds)
  # ```
  def listen : Nil
    # Dont start the auto claim listener if no events are autoclaimed.
    unless @auto_claimed_events.empty?
      spawn do
        listen_for_pending
      end
    end
    listen_for_incoming
  end

  # Listens for incoming messages.
  #
  # Uses redis [XREADGROUP](https://redis.io/commands/xreadgroup) command to listen
  # for incoming data and dispatch it to its respective listener.
  #
  # The method takes two parameters, *count* is the amount of elements to return per
  # stream and *block_for* which is the amount of time to block the client for if there
  # is no data.
  def listen_for_incoming(count : UInt32 = 10, block_for : Time::Span = 5.seconds) : Nil
    Servo::Log.info { "Started listening for incoming messages. Will recieve #{count} elements per stream and block for #{block_for.seconds} seconds." }
    loop do
      streams = Hash.zip(@subscribed_events.to_a, Array.new(@subscribed_events.size, ">"))
      if response = @redis.xreadgroup(@group, @consumer_name, count, block_for, streams: streams)
        response = Redis::Streaming::XReadGroupResponse.new(response)

        response.results.each do |result|
          event_name = result.key
          Servo::Log.debug { "Recieved incoming message on stream #{event_name}." }
          result.messages.each do |message|
            dispatch_event(event_name, message)
          end
        end
      end
    end
  end

  # Uses redis XAUTOCLAIM command to claim messages that have not been acknowledged
  # after *timeout* and dispatch it to its respective listener if the broker was told
  # to autoclaim it with `#auto_claim`.
  #
  # If *count* is specified it will change the upper limit of messages to claim. It
  # is set to 10 by by default.
  def listen_for_pending(count : UInt32 = 10, start : String = "0-0", timeout : Time::Span = 10.seconds)
    Servo::Log.info { "Started listening for pending messages. Will recieve #{count} elements per stream and idle for 10 seconds." }
    loop do
      @auto_claimed_events.each do |event_name|
        response = Redis::Streaming::XAutoClaimResponse.new(@redis.xautoclaim(event_name, @group, @consumer_name, min_idle_time: timeout, start: start, count: count))
        Servo::Log.debug { "Recieved pending message on stream #{event_name}." }
        response.messages.each do |message|
          dispatch_event(event_name, message)
        end

        sleep timeout if response.messages.empty?
      end
    end
  end

  # Handles dispatching converting a redis message to its respective event instance and
  # dispatching it.
  def dispatch_event(event_name : String, message : Redis::Streaming::Message)
    Servo::Log.debug { "Dispatching events for #{event_name} data stream." }
    payload = decode message.values["data"]
    # Dispatch gateway message event no matter what.
    @dispatcher.dispatch Servo::Event::GatewayMessageEvent.new(event_name, payload)
    case event_name
    # Add a match for each event name here.
    when "CHANNEL_CREATE" then @dispatcher.dispatch Servo::Event::ChannelCreateEvent.new(event_name, payload)
    when "CHANNEL_UPDATE" then @dispatcher.dispatch Servo::Event::ChannelUpdateEvent.new(event_name, payload)
    when "CHANNEL_DELETE" then @dispatcher.dispatch Servo::Event::ChannelDeleteEvent.new(event_name, payload)
    end
    # Acknowledges reciept of the message.
    @redis.xack(event_name, @group, message.id)
  end
end
