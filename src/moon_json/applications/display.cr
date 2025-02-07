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
      DISPLAY_VALUES =
        %w[fullscreen standalone minimal-ui browser]

      def parse_application_display : String
        @parser.location.try do |location|
          @parser.read_string.tap do |value|
            error! :application_display_mismatch do
              block do
                text "The"
                bold "value"
                text "of the"
                bold "display field"
                text "should be one of > "
              end

              snippet DISPLAY_VALUES.join("\n")
              snippet "It is here:", snippet_data(location)
            end unless DISPLAY_VALUES.includes?(value)
          end
        end
      rescue JSON::ParseException
        error! :application_display_invalid do
          block do
            text "The"
            bold "display field"
            text "of the"
            bold "application object"
            text "should be a string"
          end

          snippet snippet_data
        end
      end
    end
  end
end
