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
    class TypeChecker
      EXPOSED_BUILTINS = %w(
        decodeBoolean decodeNumber decodeString decodeArray decodeField decodeMaybe
        decodeTime locale normalizeEvent createPortal testContext testRender
        setLocale navigate compare nothing just err ok inspect)
  
      def check(node : Ast::Builtin) : Checkable
        error! :unkown_builtin do
          block do
            text "There is no builtin with the name:"
            bold node.value
          end
  
          snippet node
        end unless node.value.in?(EXPOSED_BUILTINS)
  
        VOID
      end
    end
  end