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
      CSS_PROPERTY_NAMES =
        {{ read_file("#{__DIR__}/../assets/css_properties").strip.lines }}
  
      def check(node : Ast::CssDefinition) : Checkable
        node.value.each do |item|
          type =
            case item
            when Ast::Node
              resolve item
            else
              STRING
            end
  
          unless node.name.starts_with?('-')
            error! :css_definition_no_property do
              block do
                text "There is no CSS property with the name:"
                bold %("#{node.name}")
              end
  
              snippet node
            end unless CSS_PROPERTY_NAMES.includes?(node.name)
          end
  
          error! :css_definition_type_mismatch do
            block do
              text "The type of the value for the CSS property"
              bold %("#{node.name}")
              text "is invalid."
            end
  
            snippet "expecting one of these types:", "String\nNumber"
            snippet "Instead it is:", type
            snippet "The css definition in question is here:", node
          end unless Comparer.matches_any?(type, [STRING, NUMBER])
        end
  
        VOID
      end
    end
  end