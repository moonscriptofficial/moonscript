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
      def parse_moon_version : Nil
        location =
          @parser.location

        raw =
          @parser.read_string

        match =
          raw.match(/(\d+\.\d+\.\d+)\s*<=\s*v\s*<\s*(\d+\.\d+\.\d+)/)

        constraint =
          if match
            lower =
              Installer::Semver.parse?(match[1])

            upper =
              Installer::Semver.parse?(match[2])

            Installer::SimpleConstraint.new(lower, upper) if upper && lower
          end

        error! :moon_version_bad do
          block do
            text "The"
            bold "moon-version"
            text "constraint should be in this format:"
          end

          snippet "0.0.0 <= v < 1.0.0"
          snippet "It is here:", snippet_data(location)
        end unless constraint

        resolved =
          Installer::Semver.parse(Moon.version.rchop("-devel"))

        error! :moon_version_mismatch do
          block do
            text "The"
            bold "moon-version"
            text "field does not match this version of Moon."
          end

          snippet "Expected: ", constraint.to_s
          snippet "but found instead:", Moon.version

          snippet "already exists: ", snippet_data(location)
        end unless resolved < constraint.upper && resolved >= constraint.lower
      rescue JSON::ParseException
        error! :moon_version_invalid do
          block do
            text "The"
            bold "moon-version"
            text "field should be a string: "
          end

          snippet snippet_data
        end
      end
    end
  end
end
