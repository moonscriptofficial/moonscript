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
    def check_arguments(arguments : Array(Ast::Argument))
      was_default = false

      arguments.each do |argument|
        name =
          argument.name.value

        other =
          (arguments - [argument]).find(&.name.value.==(name))

        error! :function_argument_must_have_a_default_value do
          block do
            text "The argument"
            bold %("#{name}")
            text "is declared."
          end

          block "Arguments that come after ones that have a default value must also have a default value."

          snippet "The argument in question is here:", argument
        end if was_default && !argument.default

        was_default = true if argument.default

        error! :function_argument_conflict do
          block do
            text "The argument"
            bold %("#{name}")
            text "is declared multiple times."
          end

          snippet "It is declared here:", other
          snippet "duplication is declared here:", argument
        end if other
      end
    end
  end
end