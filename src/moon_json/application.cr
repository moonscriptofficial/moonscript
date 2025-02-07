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
      def parse_application : Application
        meta = {} of String => String
        orientation = ""
        theme_color = ""
        css_prefix = ""
        display = ""
        title = ""
        name = ""
        icon = ""
        head = ""

        @parser.read_object do |key|
          case key
          when "orientation"
            orientation = parse_application_orientation
          when "theme-color"
            theme_color = parse_application_theme_color
          when "css-prefix"
            css_prefix = parse_application_css_prefix
          when "display"
            display = parse_application_display
          when "title"
            title = parse_application_title
          when "head"
            head = parse_application_head
          when "icon"
            icon = parse_application_icon
          when "meta"
            meta = parse_application_meta
          when "name"
            name = parse_application_name
          else
            error! :application_invalid_key do
              block do
                text "The"
                bold "application object has an invalid key: "
              end

              snippet key
              snippet "It is here:", snippet_data
            end
          end
        end

        Application.new(
          theme_color: theme_color,
          orientation: orientation,
          css_prefix: css_prefix,
          display: display,
          title: title,
          meta: meta,
          icon: icon,
          head: head,
          name: name)
      rescue JSON::ParseException
        error! :application_invalid do
          block do
            text "The"
            bold "application field"
            text "should be an object"
          end

          snippet snippet_data
        end
      end
    end
  end
end
