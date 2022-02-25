# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"

require "./identifiable"

# Represents a User on Discord.
# See https://discord.com/developers/docs/resources/user#user-object-user-structure.
struct Servo::Model::User
  include Servo::Model::Identifiable
  include JSON::Serializable

  getter username : String

  getter discriminator : String

  getter avatar : String?

  getter bot : Bool?

  getter system : Bool?

  getter mfa_enabled : Bool?

  getter banner : String?

  getter accent_color : UInt32?

  getter locale : String?

  getter verified : Bool?

  getter email : String?

  getter flags : UserFlags?

  getter premium_type : PremiumType?

  getter public_flags : UserFlags?

  # The flags on a user's account.
  # See https://discord.com/developers/docs/resources/user#user-object-user-flags.
  @[Flags]
  enum UserFlags : UInt32
    # Discord Employee
    Staff = 1 << 0

    # Partnered Server Owner
    Partner = 1 << 1

    # HypeSquad Events Coordinator
    Hypesquad = 1 << 2

    # Bug Hunter Level 1
    BugHunterLevel1 = 1 << 3

    # House Bravery Member
    HypeSquadOnlineHouse1 = 1 << 6

    # House Brilliance Member
    HypeSquadOnlineHouse2 = 1 << 7

    # House Balance Member
    HypeSquadOnlineHouse3 = 1 << 8

    # Early Nitro Supporter
    PremiumEarlySupporter = 1 << 9

    # User is a [Team](https://discord.com/developers/docs/topics/teams).
    TeamPseudoUser = 1 << 10

    # Bug Hunter Level 2
    BugHunterLevel2 = 1 << 14

    # Verified Bot
    VerifiedBot = 1 << 16

    # Early Verified Bot Developer
    VerifiedDeveloper = 1 << 17

    # Discord Certified Moderator
    CertifiedModerator = 1 << 18

    # Bot uses only [HTTP interactions](https://discord.com/developers/docs/interactions/receiving-and-responding#receiving-an-interaction)
    # and is shown in the online member list.
    BotHTTPInteractions = 1 << 19

    # User has been identified as spammer
    Spammer = 1 << 20

    def self.new(pull : JSON::PullParser)
      UserFlags.new(pull.read_int.to_u32)
    end
  end

  # The type of nitro subscription on a user's account.
  # See https://discord.com/developers/docs/resources/user#user-object-premium-types.
  enum PremiumType : UInt8
    None         = 0
    NitroClassic = 1
    Nitro        = 2

    def self.new(pull : JSON::PullParser)
      PremiumType.new(pull.read_int.to_u8)
    end
  end
end
