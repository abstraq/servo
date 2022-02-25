# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"

require "../user"
require "../converters"
require "../identifiable"
require "../permissions"
require "./permission_overwrite"
require "./thread_member"
require "./thread_metadata"

# Represents a channel on discord.
struct Servo::Model::Channel
  include Servo::Model::Identifiable
  include JSON::Serializable

  @[JSON::Field(converter: Servo::Model::NilableSnowflakeConverter)]
  getter guild_id : Servo::Model::Snowflake?

  getter position : Int32?

  getter permission_overwrites : Array(Servo::Model::PermissionOverwrite)?

  getter name : String?

  getter topic : String?

  getter nsfw : Bool?

  @[JSON::Field(converter: Servo::Model::NilableSnowflakeConverter)]
  getter last_message_id : Servo::Model::Snowflake?

  getter bitrate : UInt32?

  getter rate_limit_per_user : UInt32?

  getter recipients : Array(Servo::Model::User)?

  getter icon : String?

  @[JSON::Field(converter: Servo::Model::NilableSnowflakeConverter)]
  getter owner_id : Servo::Model::Snowflake?

  @[JSON::Field(converter: Servo::Model::NilableSnowflakeConverter)]
  getter application_id : Servo::Model::Snowflake?

  @[JSON::Field(converter: Servo::Model::NilableSnowflakeConverter)]
  getter parent_id : Servo::Model::Snowflake?

  # TODO: Convert to `Time`
  getter last_pin_timestamp : String?

  getter rtc_region : String?

  getter video_quality_mode : VideoQualityMode?

  getter message_count : UInt8?

  getter member_count : UInt8?

  getter thread_metadata : Servo::Model::ThreadMetadata?

  getter member : Servo::Model::ThreadMember?

  getter default_auto_archive_duration : ThreadAutoArchiveDuration?

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

  enum ThreadAutoArchiveDuration : UInt32
    OneHour   =    60
    OneDay    =  1440
    ThreeDays =  4320
    OneWeek   = 10080

    def self.new(pull : JSON::PullParser)
      ThreadAutoArchiveDuration.new(pull.read_int.to_u32)
    end
  end
end
