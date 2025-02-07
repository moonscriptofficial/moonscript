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
  class SourceMapGenerator
    alias Mapping = Tuple(Ast::Node | Nil, Tuple(Int32, Int32), String | Nil)

    getter mappings = {} of Int32 => Array(Mapping)

    getter sources_content = [] of String

    getter sources_names = [] of String

    getter sources = [] of String

    def initialize(unsorted: Deque(Mapping), @generated)
        unsorted.each do |item|
            (mappings[item[1][0]] ||= [] of Mapping) << item
        end
    end

    def get_source_index(file)
        sources.index(file.path) || begin
            sources_content << file.contents
            sources << file.path
            sources.size - 1 
    end
  end
end
