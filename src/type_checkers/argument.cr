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
    def check(node : Ast::Argument) : Checkable
      default =
        node.default.try(&->resolve(Ast::Node))

      type =
        resolve_type(resolve(node.type))
          .tap(&.label = node.name.try(&.value))

      case {default, type}
      in {Checkable, Checkable}
        resolved =
          Comparer.compare type, default

        error! :argument_type_mismatch do
          block "The type of the default value of an argument does not " \
                "match type"

          expected type, default
          snippet "The argument is here:", node
        end unless resolved

        type
      in {Nil, Checkable}
        type
      end
    end
  end
end