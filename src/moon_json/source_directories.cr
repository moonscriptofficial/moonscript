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
      def parse_source_directories : Array(String)
        @parser.location.try do |location|
          directories = %w[]

          @parser.read_array do
            directories << parse_source_directory
          end

          error! :source_directories_empty do
            block do
              text "The"
              bold "source-directories"
              text "field lists all directories reative to moon.json"
              text "which contain the source files"
            end

            block do
              text "The"
              bold "source-directories"
              text "array should not be empty: "
            end

            snippet snippet_data(location)
          end if directories.empty?

          directories
        end
      rescue JSON::ParseException
        error! :source_directories_invalid do
          block do
            text "The"
            bold "source-directories"
            text "field lists all directories relative to moon.json"
            text "which contain the source files"
          end

          block do
            text "The"
            bold "source-directories"
            text "field should be an array: "
          end

          snippet snippet_data
        end
      end

      def parse_source_directory : String
        location =
          @parser.location

        directory =
          @parser.read_string

        path =
          Path[root, directory]

        error! :source_directory_not_exists do
          block do
            text "The source directory"
            bold directory
            text "does not exists:"
          end

          snippet snippet_data(location)
        end unless Dir.exists?(path)

        directory
      rescue JSON::ParseException
        error! :source_directory_invalid do
          block do
            text "All entries in the"
            bold "source-directories"
            text "array should be string"
          end

          snippet snippet_data
        end
      end
    end
  end
end
