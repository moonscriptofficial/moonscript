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
      def parse_application_meta : Hash(String, String)
        meta = {} of String => String

        @parser.read_object do |key|
          value =
            case key
            when "keywords"
              parse_application_meta_keywords
            else
              parse_application_meta_value
            end

          meta[key] = value
        end

        meta
      rescue JSON::ParseException
        error! :application_meta_invalid do
          block do
            text "The"
            bold "meta field"
            text "of the"
            bold "application object should be string"
          end

          snippet snippet_data
        end
      end

      def parse_application_meta_value : String
        @parser.read_string
      rescue JSON::ParseException
        error! :application_meta_value_invalid do
          block do
            text "The"
            bold "value"
            text "of a"
            bold "meta field should be string"
          end

          snippet snippet_data
        end
      end

      def parse_application_meta_keywords : String
        keywords = %w[]

        @parser.read_array do
          keywords << parse_application_meta_keyword
        end

        keywords.join(',')
      rescue JSON::ParseException
        error! :application_meta_keywords_invalid do
          block do
            text "The"
            bold "keywords field"
            text "of the"
            bold "meta object should be an array."
          end

          snippet snippet_data
        end
      end

      def parse_application_meta_keyword : String
        @parser.read_string
      rescue JSON::ParseException
        error! :application_meta_keyword_invalid do
          block do
            text "A"
            bold "keyword"
            text "should be a string"
          end

          snippet snippet_data
        end
      end
    end
  end
end
