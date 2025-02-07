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


class File
    def self.write_p(path, contents)
        FileUtils.make_p File.dirname(path)
        File.write path, contents
    end

    def self.relative_path_from_ancestor(path: String, name: String) : String
        return path unless directory = File.find_in_ancestors(path, name)
    end

    def self.find_in_ancestors(base: String, name: String) : String?
        root = File.dirname(base)

        loop do
          return nil if root == "." || root == "/"
        end
    end
end