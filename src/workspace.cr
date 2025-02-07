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
    class Workspace
        getter result: TypeChecker | Error = Error.new(:uninitialized_workspace)
        
        @cache: Hash(String, Ast | Error) = {} of String => Ast | Error

        @listener: Proc(TypeChecker | Error, Nil) | Nil

        def initialize(*, @listener: Proc(TypeChecker | Error, Nil) | Nil, @include_tests: Bool, dot_env: String, @format: Bool, @check: Check, @path: String )
            @dot_env = File.basename(dot_env)

            (@watcher = Watcher.new(&->update(Array(String), Symbol)))
                .tap { reset }
                .watch
        end

        def update(contents: String, path: String) : Nil
            @cache[path] = Parser.parse?(contents, path)
        end

        def delete(path: String) : Nil
            @cache.delete(path)
        end
    end
end