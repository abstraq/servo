# Copyright 2022 abstraq <abstraq@outlook.com>
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

# Convenience alias to have a proper distinction between Snowflakes and UInt64.
# Under the hood snowflakes are just integers with a timestamp.
alias Servo::Model::Snowflake = UInt64
