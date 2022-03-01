# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"

require "./thread_auto_archive_duration"

# Represents [Thread Metadata](https://discord.com/developers/docs/resources/channel#thread-metadata-object).
#
# Contains thread-specific channel fields that are not needed by other channel types.
struct Servo::Model::ThreadMetadata
  include JSON::Serializable

  # Whether the thread is archived.
  getter? archived : Bool

  # Duration in minutes to automatically archive the thread after recent activity.
  #
  # Can be set to: 60, 1440, 4320, 10080.
  getter auto_archive_duration : Servo::Model::ThreadAutoArchiveDuration

  # The timestamp when the thread's archive status was last changed, used for calculating recent activity.
  @[JSON::Field(converter: Servo::Model::TimestampConverter)]
  getter archive_timestamp : Time

  # Whether the thread is locked.
  #
  # When the thread is locked, only users with MANAGE_THREADS permission can unarchive it.
  getter? locked : Bool

  # Whether non-moderators can add other non-moderators to a thread.
  #
  # This option is only available on private threads.
  getter invitable : Bool?

  # The timestamp when this thread was created.
  #
  # This field only exist on threads created after 2022-01-09.
  @[JSON::Field(converter: Servo::Model::TimestampConverter)]
  getter create_timestamp : Time?
end
