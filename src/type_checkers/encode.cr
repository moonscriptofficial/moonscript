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
    def check(node : Ast::Encode) : Checkable
      expression =
        case item = node.expression
        when Ast::Record
          resolve item, true
        else
          resolve item
        end

      error! :encode_complex_type do
        snippet "This type cannot be automatically encoded:", expression

        block do
          text "Only these types and records containing them can"
          text "be automatically decoded:"
        end

        snippet <<-MOON
          Map(String, a)
          Array(a)
          Maybe(a)
          String
          Number
          Object
          Time
          Bool
        MOON

        snippet "The encode in question is here:", node
      end unless check_decode(expression)

      OBJECT
    end
  end
end