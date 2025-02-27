# -----------------------------------------------------------------------
# This file is part of MoonScript
#
# MoonSript is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# MoonSript is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MoonSript.  If not, see <https://www.gnu.org/licenses/>.
#
# Copyright (C) 2025 Krisna Pranav, MoonScript Developers
# -----------------------------------------------------------------------

module MoonScript
  module VLQ
    VLQ_BASE_SHIFT = 5

    VLQ_BASE = 1 << VLQ_BASE_SHIFT

    VLQ_BASE_MASK = VLQ_BASE - 1

    VLQ_CONTINUATION_BIT = VLQ_BASE

    BASE64_DIGITS =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".chars

    def self.encode(int)
      vlq = to_vlq_signed(int)
      encoded = ""
      cond = true

      while cond
        digit = vlq & VLQ_BASE_MASK
        vlq >>= VLQ_BASE_SHIFT
        digit |= VLQ_CONTINUATION_BIT if vlq > 0
        encoded += base64_encode(digit)
        cond = vlq > 0
      end

      encoded
    end

    private def self.base64_encode(int)
      BASE64_DIGITS[int]? || raise ArgumentError.new "#{int} is not a valid base64 digit"
    end

    private def self.to_vlq_signed(int)
      if int < 0
        ((-int) << 1) + 1
      else
        int << 1
      end
    end
  end
end
