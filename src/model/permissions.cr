# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

# Permissions in Discord are a way to limit and grant certain abilities to users.
# See https://discord.com/developers/docs/topics/permissions#permissions-bitwise-permission-flags.
@[Flags]
enum Servo::Model::Permissions : UInt64
  CreateInstantInvite    = 1 << 0
  KickMembers            = 1 << 1
  BanMembers             = 1 << 2
  Administrator          = 1 << 3
  ManageChannels         = 1 << 4
  ManageGuild            = 1 << 5
  AddReactions           = 1 << 6
  ViewAuditLog           = 1 << 7
  PrioritySpeaker        = 1 << 8
  Stream                 = 1 << 9
  ReadMessages           = 1 << 10
  SendMessages           = 1 << 11
  SendTTSMessages        = 1 << 12
  ManageMessages         = 1 << 13
  EmbedLinks             = 1 << 14
  AttachFiles            = 1 << 15
  ReadMessageHistory     = 1 << 16
  MentionEveryone        = 1 << 17
  UseExternalEmojis      = 1 << 18
  Connect                = 1 << 20
  Speak                  = 1 << 21
  MuteMembers            = 1 << 22
  DeafenMembers          = 1 << 23
  MoveMembers            = 1 << 24
  UseVAD                 = 1 << 25
  ChangeNickname         = 1 << 26
  ManageNicknames        = 1 << 27
  ManageRoles            = 1 << 28
  ManageWebhooks         = 1 << 29
  ManageEmojis           = 1 << 30
  UseApplicationCommands = 1 << 31
  RequestToSpeak         = 1 << 32
  ManageThreads          = 1 << 34
  UsePrivateThreads      = 1 << 36

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
