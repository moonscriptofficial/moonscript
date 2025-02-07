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

class Array(T)
  def zip2(other : Array(T))
    map_with_index do |item, index|
      [item, other[index]?].compact
    end.flatten
  end

  def intersperse(separator : T)
    flat_map { |item| [item, separator] }.tap(&.pop?)
  end
end
