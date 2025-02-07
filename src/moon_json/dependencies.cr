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
      def parse_dependencies : Array(Installer::Dependency)
        @parser.location.try do |location|
          dependencies = [] of Installer::Dependency

          @parser.read_object do |key|
            dependencies << parse_dependency(key)
          end

          error! :dependencies_empty do
            block do
              text "The"
              bold "dependencies"
              text "field lists all the dependencies for the application."
            end

            block do
              text "The"
              bold "dependencies"
              text "object should not be empty! "
            end

            snippet snippet_data(location)
          end if dependencies.empty?

          dependencies
        end
      rescue JSON::ParseException
        error! :dependencies_invalid do
          block do
            text "The"
            bold "dependencies"
            text "field lists all the dependencies for the application."
          end

          snippet "It should be an object!", snippet_data
        end
      end

      def parse_dependency(package : String) : Installer::Dependency
        repository, constraint = nil, nil

        @parser.read_object do |key|
          case key
          when "repository"
            repository = parse_dependency_repository
          when "constraint"
            constraint = parse_dependency_constraint
          else
            error! :dependency_invalid_key do
              snippet "A dependency object has an invalid key:", key
              snippet "It is here:", snippet_data
            end
          end
        end

        error! :dependency_missing_repository do
          block do
            text "A"
            bold "dependency object"
            text "is missing the"
            bold "repository"
          end

          snippet snippet_data
        end unless repository

        error! :dependency_missing_constraint do
          block do
            text "A"
            bold "dependency object"
            text "is missing the"
            bold "constraint"
          end

          snippet snippet_data
        end unless constraint

        Installer::Dependency.new package, repository, constraint
      rescue JSON::ParseException
        error! :dependency_invalid do
          snippet "A dependency must be an object!", snippet_data
        end
      end

      def parse_dependency_repository : String
        @parser.read_string
      rescue JSON::ParseException
        error! :dependency_repository_invalid do
          block do
            text "The"
            bold "repository"
            text "field of a depencency must be an string!"
          end

          snippet snippet_data
        end
      end

      def parse_dependency_constraint : Installer::Constraint
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
          else
            match =
              raw.match(/(.*?):(\d+\.\d+\.\d+)/)

            if match
              version =
                Installer::Semver.parse?(match[2])

              target =
                match[1]

              Installer::FixedConstraint.new(version, target) if version
            end
          end

        error! :dependency_constraint_bad do
          block "The constraint of a dependency is either in this format:"
          snippet "0.0.0 <= v < 1.0.0"

          block "or a git tag / commit / branch followed by the version:"
          snippet "master:0.1.0"

          snippet "could not able to find either:", snippet_data(location)
        end unless constraint

        constraint
      rescue JSON::ParseException
        error! :dependency_constraint_invalid do
          block do
            text "The"
            bold "constraint"
            text "field of a depencency must be an string"
          end

          snippet snippet_data
        end
      end
    end
  end
end
