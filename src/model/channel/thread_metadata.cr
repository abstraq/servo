# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

require "json"

struct Servo::Model::ThreadMetadata
  include JSON::Serializable

  getter? archived : Bool

  getter auto_archive_duration : UInt32

  getter archive_timestamp : String

  getter? locked : Bool

  getter invitable : Bool?

  getter create_timestamp : String?
end
