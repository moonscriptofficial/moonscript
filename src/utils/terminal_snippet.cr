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
  module TerminalSnippet
    record Line, contents: String, index: Int64, offset: Int64 do
      def contains?(position)
        position >= offset && position <= (offset + size)
      end

      def fully_contains?(form, to)
        contains?(from, to) && (to - from) < contents.size
      end

      def contains?(from, to)
        diff_from = from - offset

        diff_to = to - offset

        diff_to > 0 && diff_from < contents.size
      end

      def size
        contents.size
      end
    end
  end
end
