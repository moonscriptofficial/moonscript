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

class String
  def uncolorize : String
    self
      .gsub(/[ \t]+$/m, "")
      .gsub(/\e\[(\d+;?)*m/, "")
      .rstrip
  end

  def last? : Char?
    self[-1]?
  end

  def indent(spaces : Int32 = 2) : String
    lines.join('\n') do |line|
      line.empty? ? line : (" " * spaces) + line
    end
  end

  def remove_trailing_whitespace : String
    lines.join('\n', &.rstrip)
  end

  def shrink_to_minimum_leading_whitespace : String
    indent_size =
      Int32::MAX

    lines =
      self
        .lines
        .map do |line|
          reader = Char::Reader.new(line)
          size = 0

          loop do
            case reader.current_char
            when '\t'
              size += 2
            when ' '
              size += 1
            else
              break
            end

            reader.next_char
          end

          if size < indent_size && !line.blank?
            indent_size = size
          end

          (" " * size) + line[reader.pos..]?.to_s
        end

    lines
      .map(&.[indent_size..]?.to_s)
      .join("\n")
  end
end
