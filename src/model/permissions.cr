# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

# [Permissions](https://discord.com/developers/docs/topics/permissions#permissions-bitwise-permission-flags)
# in Discord are a way to limit and grant certain abilities to users.
@[Flags]
enum Servo::Model::Permissions : UInt64
  # Allows creation of instant invites.
  CreateInstantInvite = 1 << 0

  # Allows kicking members.
  KickMembers = 1 << 1

  # Allows banning members.
  BanMembers = 1 << 2

  # Allows all permissions and bypasses channel permission overwrites.
  Administrator = 1 << 3

  # Allows management and editing of channels.
  ManageChannels = 1 << 4

  # Allows management and editing of the guild.
  ManageGuild = 1 << 5

  # Allows for the addition of reactions to messages.
  AddReactions = 1 << 6

  # Allows for viewing of audit logs.
  ViewAuditLog = 1 << 7

  # Allows for using priority speaker in a voice channel.
  PrioritySpeaker = 1 << 8

  # Allows the user to go live.
  Stream = 1 << 9

  # Allows guild members to view a channel, which includes reading messages in text channels and joining voice channels.
  ReadMessages = 1 << 10

  # Allows for sending messages in a channel (does not allow sending messages in threads).
  SendMessages = 1 << 11

  # Allows for sending of /tts messages.
  SendTTSMessages = 1 << 12

  # Allows for deletion of other users messages.
  ManageMessages = 1 << 13

  # Links sent by users with this permission will be auto-embedded.
  EmbedLinks = 1 << 14

  # Allows for uploading images and files.
  AttachFiles = 1 << 15

  # Allows for reading of message history.
  ReadMessageHistory = 1 << 16

  # Allows for using the @everyone tag to notify all users in a channel, and the @here tag to notify all online users in a channel.
  MentionEveryone = 1 << 17

  # Allows the usage of custom emojis from other servers.
  UseExternalEmojis = 1 << 18

  # Allows for viewing guild insights.
  ViewGuildInsights = 1 << 19

  # Allows for joining of a voice channel.
  Connect = 1 << 20

  # Allows for speaking in a voice channel.
  Speak = 1 << 21

  # Allows for muting members in a voice channel.
  MuteMembers = 1 << 22

  # Allows for deafening of members in a voice channel.
  DeafenMembers = 1 << 23

  # Allows for moving of members between voice channels.
  MoveMembers = 1 << 24

  # Allows for using voice-activity-detection in a voice channel.
  UseVAD = 1 << 25

  # Allows for modification of own nickname.
  ChangeNickname = 1 << 26

  # Allows for modification of other users nicknames.
  ManageNicknames = 1 << 27

  # Allows management and editing of roles.
  ManageRoles = 1 << 28

  # Allows management and editing of webhooks.
  ManageWebhooks = 1 << 29

  # Allows management and editing of emojis and stickers.
  ManageEmojisAndStickers = 1 << 30

  # Allows members to use application commands, including slash commands and context menu commands.
  UseApplicationCommands = 1 << 31

  # Allows for requesting to speak in stage channels. (This permission is under active development and may be changed or removed.)
  RequestToSpeak = 1 << 32

  # Allows for creating, editing, and deleting scheduled events	.
  ManageEvents = 1 << 33

  # Allows for deleting and archiving threads, and viewing all private threads.
  ManageThreads = 1 << 34

  # Allows for creating public and announcement threads.
  CreatePublicThreads = 1 << 35

  # Allows for creating private threads.
  CreatePrivateThreads = 1 << 36

  # Allows the usage of custom stickers from other servers.
  UseExternalStickers = 1 << 37

  # Allows for sending messages in threads.
  SendMessagesInThreads = 1 << 38

  # Allows for launching activities (applications with the EMBEDDED flag) in a voice channel.
  StartEmbededActivities = 1 << 39

  # Allows for timing out users to prevent them from sending or reacting to messages
  # in chat and threads, and from speaking in voice and stage channels.
  ModerateMembers = 1 << 40

  def self.new(pull : JSON::PullParser)
    Permissions.new(pull.read_string.to_u64)
  end

  def to_json(json : JSON::Builder)
    json.string(value)
  end
end
