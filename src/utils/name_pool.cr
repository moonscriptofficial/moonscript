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
  class NamePool(T, B)
    @cache = {} of Tuple(B, T) => String
    @current = {} of B => String

    def initialize(@initial = 'a'.pred.to_s)
    end

    def of(subject : T, base : B)
      @cache[{base, subject}] ||= next_name(subject, base)
    end

    def next_name(subject : T, base : B)
      name = @current[base] = (@current[base]? || @initial).succ

      if ["do", "if", "for", "catch", "in"].includes?(name)
        next_name(subject, base)
      else
        name
      end
    end
  end
end
