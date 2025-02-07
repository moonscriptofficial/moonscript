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
  module SourceFiles
    extend self

    def globs(jsons : Array(MoonJson), *, include_tests = false) : Array(String)
      jsons.flat_map { |json| globs(json, include_tests: include_tests) }
    end

    def globs(json : MoonJson, *, include_tests = false) : Array(String)
      if include_tests
        json.source_directories | json.test_directories
      else
        json.source_directories
      end.map { |dir| glob_pattern(File.dirname(json.path), dir) }
    end

    def everything(json : MoonJson, *, include_tests = false, dot_env = ".env") : Array(String)
      packages(json, include_self: true)
        .flat_map { |item| globs(item, include_tests: include_tests) + [item.path] }
        .push(Path[File.dirname(json.path), dot_env].to_s)
    end

    def packages(json : MoonJson, *, include_self = false) : Array(MoonJson)
      (include_self ? [json] : [] of MoonJson).tap do |jsons|
        each_package(json) do |package_json|
          jsons << package_json
        end
      end
    end

    private def each_package(json : MoonJson, &)
      pattern =
        Path[
          File.dirname(json.path),
          ".", ".moon", "packages", "**", "moon.json",
        ]

      Dir.glob(pattern).each do |file|
        yield MoonJson.parse(file)
      end
    end

    private def glob_pattern(*dirs : Path | String)
      Path[*dirs, "**", "*.moon"].to_posix.to_s
    end
  end
end
