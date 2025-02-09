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
      def check(node : Ast::BracketAccess) : Checkable
        index, expression =
          node.index, node.expression
  
        type =
          resolve expression
  
        index_type =
          resolve index
  
        if type.name == "Tuple"
          case index
          when Ast::NumberLiteral
            error! :bracket_access_invalid_tuple_index do
              block "The index of an array access for a tuple is a float, " \
                    "it can be only integer."
              snippet "The access:", node
            end if index.float?
  
            parameter =
              type.parameters[index.value.to_i]?
  
            error! :bracket_access_invalid_tuple do
              snippet "The tuple has only #{type.parameters.size} members, but " \
                      "you wanted to access the #{ordinal(index.value.to_i + 1)}" \
                      ". The exact type of the tuple is:", type
              snippet "The tuple:", expression
            end unless parameter
  
            parameter
          else
            error! :bracket_access_invalid_tuple_access do
              snippet "Tuples do not support non integer access:", index
              snippet "The tuple:", expression
            end
          end
        elsif type.name == "Map" && type.parameters.size == 2
          error! :bracket_access_index_not_map_key do
            block "The type of the index of a bracket access does not match the type of the keys."
            expected type.parameters.first, type.parameters.first
            snippet "The index:", index
          end unless Comparer.compare(type.parameters.first, index_type)
  
          Type.new("Maybe", [type.parameters.last] of Checkable)
        elsif type.name == "Array" && type.parameters.size == 1
          error! :bracket_access_index_not_number do
            block "The type of the index of a bracket access is not a number."
            expected NUMBER, index_type
            snippet "The index:", index
          end unless Comparer.compare(index_type, NUMBER)
  
          Type.new("Maybe", [type.parameters.first] of Checkable)
        else
          error! :bracket_access_not_accessible do
            block "The entity you are trying to access an item from is not an " \
                  "array, map or a tuple."
            expected "Array(a), Map(a, b) or Tuple(...)", type
            snippet "The array:", expression
          end
        end
      end
    end
  end