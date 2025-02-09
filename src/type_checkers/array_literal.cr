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
      def check(node : Ast::ArrayLiteral) : Checkable
        defined_type =
          node.type.try do |type|
            Type.new("Array", [resolve(type).as(Checkable)])
          end
  
        if node.items.empty?
          defined_type || Type.new("Array", [Variable.new("a").as(Checkable)])
        else
          first =
            resolve node.items.first
  
          rest =
            node.items[1..node.items.size]
  
          rest.each_with_index do |item, index|
            type = resolve item
  
            return error! :array_not_matches do
              block do
                text "The"
                bold "#{ordinal(index + 2)} item"
                text "of an array does not match the type of the 1st item."
              end
  
              snippet "I was expecting the type of the 1st item:", first
              snippet "Instead it is:", type
              snippet "The item in question is here:", item
            end unless Comparer.compare(type, first)
          end
  
          inferred_type =
            Comparer.normalize(Type.new("Array", [first]))
  
          if defined_type
            final_type =
              Comparer.compare(inferred_type, defined_type)
  
            error! :array_not_matches_defined_type do
              block do
                text "The"
                bold "defined type"
                text "of an array does not matches"
              end
  
              expected defined_type, inferred_type
              snippet "The array in question is here:", node.type.not_nil!
            end unless final_type
  
            final_type
          else
            inferred_type
          end
        end
      end
    end
  end