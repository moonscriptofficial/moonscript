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
      def parse_application_icon : String
        location =
          @parser.location

        icon =
          @parser.read_string

        path =
          Path[root, icon].to_s

        error! :application_icon_not_exists do
          block do
            text "The"
            bold "icon"
            text "field of"
            text "points to a file that does not exists."
          end

          block do
            text "It should point to an image which will be used to generate"
          end

          snippet snippet_data(location)
        end unless File.exists?(path)

        icon
      rescue JSON::ParseException
        error! :application_icon_invalid do
          block do
            text "The"
            bold "icon"
            text "field"
            text "should be a string, but it's not:"
          end

          snippet snippet_data
        end
      end
    end
  end
end
