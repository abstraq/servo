# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"

require "../user"
require "../converters/*"
require "../identifiable"
require "../permissions"
require "./*"

# Represents a [Channel](https://discord.com/developers/docs/resources/channel#channel-object).
struct Servo::Model::Channel
  include Servo::Model::Identifiable
  include JSON::Serializable

  # The type of this channel.
  getter type : ChannelType

  # The ID of the guild this channel is in if any.
  #
  # This may be missing for some channel objects recieved over gateway guild dispatches.
  @[JSON::Field(converter: Servo::Model::SnowflakeConverter)]
  getter guild_id : Servo::Model::Snowflake?

  # The sorting position of the channel.
  getter position : Int32?

  # Array of explicit `Servo::Model::PermissionOverwrite` for members and roles.
  getter permission_overwrites : Array(Servo::Model::PermissionOverwrite)?

  # The name of this channel.
  #
  # Must be 1-100 characters.
  getter name : String?

  # The channel topic.
  #
  # Must be 0-1024 characters.
  getter topic : String?

  # Whether the channel is NSFW.
  getter nsfw : Bool?

  # The ID of the last message sent in this channel.
  #
  # This may not point to an existing or valid message.
  @[JSON::Field(converter: Servo::Model::SnowflakeConverter)]
  getter last_message_id : Servo::Model::Snowflake?

  # The bitrate of the voice channel.
  getter bitrate : UInt32?

  # The user limit of the voice channel.
  getter user_limit : UInt32?

  # The amount of seconds a user has to wait before sending another message.
  #
  # This value must between 0 and 21600. Bots as well as users with MANAGE_MESSAGES,
  # or MANAGE_CHANNEL permissions are unnaffected.
  getter rate_limit_per_user : UInt32?

  # The recipients of the DM.
  getter recipients : Array(Servo::Model::User)?

  # The icon hash of the group DM.
  getter icon : String?

  # The id of the creator of the group DM or thread.
  @[JSON::Field(converter: Servo::Model::SnowflakeConverter)]
  getter owner_id : Servo::Model::Snowflake?

  # The application ID of the group DM creator if it is bot-created.
  @[JSON::Field(converter: Servo::Model::SnowflakeConverter)]
  getter application_id : Servo::Model::Snowflake?

  # The id of the parent category for a channel.
  #
  # If this channel is a thread it is the ID of the text channel this
  # thread was created in.
  @[JSON::Field(converter: Servo::Model::SnowflakeConverter)]
  getter parent_id : Servo::Model::Snowflake?

  # When the last pinned message was pinned.
  #
  # This may be nil in events such as GUILD_CREATE when a message
  # is not pinned.
  @[JSON::Field(converter: Servo::Model::TimestampConverter)]
  getter last_pin_timestamp : Time?

  # [Voice Region](https://discord.com/developers/docs/resources/voice#voice-region-object) ID for the voice channel.
  #
  # Automatic when set to nil.
  getter rtc_region : String?

  # The camera [video quality mode](https://discord.com/developers/docs/resources/channel#channel-object-video-quality-modes) of the voice channel.
  #
  # Automatic when set to nil.
  getter video_quality_mode : VideoQualityMode?

  # An approximate count of messages in a thread, stops at 50.
  getter message_count : UInt8?

  # An approximate count of users in a thread, stops at 50.
  getter member_count : UInt8?

  # Thread specific fields not needed by other channels.
  getter thread_metadata : Servo::Model::ThreadMetadata?

  # Thread member object for the current user, if they have joined the thread.
  getter member : Servo::Model::ThreadMember?

  #
  getter default_auto_archive_duration : Servo::Model::ThreadAutoArchiveDuration?

  getter permissions : Servo::Model::Permissions?

  enum ChannelType : UInt8
    GuildText          =  0
    DM                 =  1
    GuildVoice         =  2
    GroupDM            =  3
    GuildCategory      =  4
    GuildNews          =  5
    GuildStore         =  6
    GuildNewsThread    = 10
    GuildPublicThread  = 11
    GuildPrivateThread = 12
    GuildStageVoice    = 13

    def self.new(pull : JSON::PullParser)
      ChannelType.new(pull.read_int.to_u8)
    end
  end

  enum VideoQualityMode : UInt8
    Auto = 1
    Full = 2

    def self.new(pull : JSON::PullParser)
      VideoQualityMode.new(pull.read_int.to_u8)
    end
  end
end
