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
  class MoonJson
    class Parser
      def parse_formatter : Formatter::Config
        indent_size = 2

        @parser.read_object do |key|
          case key
          when "indent-size"
            indent_size = parse_formatter_indent_size
          else
            error! :formatter_invalid_key do
              block do
                text "The"
                bold "formatter"
                text "object has an invalid key:"
              end

              snippet key
              snippet "expected:", snippet_data
            end
          end
        end

        Formatter::Config.new(indent_size: indent_size)
      rescue JSON::ParseException
        error! :formatter_invalid do
          block do
            text "The"
            bold "formatter"
            text "field should be an object: "
          end

          snippet snippet_data
        end
      end

      def parse_formatter_indent_size : Int32
        @parser.read_int.clamp(0, 100).to_i
      rescue JSON::ParseException
        error! :formatter_indent_size_invalid do
          block do
            text "The"
            bold "indent-size"
            text "field of the formatter configuration must be a number: "
          end

          snippet snippet_data
        end
      end
    end
  end
end
