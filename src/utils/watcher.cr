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
  class Watcher
    @patterns : Array(String) = [] of String
    @state = Set(Tuple(String, Time)).new

    def initialize(&@listener : Proc(Array(String), Symbol, Nil))
    end

    def patterns=(@patterns : Array(String))
      @state.clear
      scan :reset
    end

    def scan(reason : Symbol)
      current =
        Dir.glob(@patterns)
          .map(&->info(String))
          .sort_by!(&.last)
          .to_set

      diff = @state ^ current

      @listener.call(diff.map(&.first).uniq!, reason) unless diff.empty?

      @state = current
    end

    def info(file : String)
      path =
        Path[file].normalize.expand.to_s

      {path, File.info(path).modification_time}
    end

    def watch
      spawn do
        loop do
          sleep 0.1.seconds
          scan :modified
        end
      end
    end
  end
end
