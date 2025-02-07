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
      def parse_name : String
        location =
          @parser.location

        name =
          @parser.read_string

        error! :name_empty do
          block do
            text "The"
            bold "name"
            text "field should not be empty!"
          end

          snippet snippet_data(location)
        end if name.empty?

        name
      rescue JSON::ParseException
        error! :name_invalid do
          block do
            text "The"
            bold "name"
            text "field should be a string"
          end

          snippet snippet_data
        end
      end
    end
  end
end
