# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

# Duration in minutes to automatically archive the thread after recent activity.
enum Servo::Model::ThreadAutoArchiveDuration : UInt32
  OneHour   =    60
  OneDay    =  1440
  ThreeDays =  4320
  OneWeek   = 10080

  def self.new(pull : JSON::PullParser)
    ThreadAutoArchiveDuration.new(pull.read_int.to_u32)
  end
end
