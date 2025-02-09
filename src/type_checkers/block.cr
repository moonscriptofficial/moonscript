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
      def check(node : Ast::Block) : Checkable
        if node.expressions.all?(Ast::CssDefinition)
          resolve node.expressions
          VOID
        else
          expressions =
            node.expressions.select(Ast::Statement)
  
          error! :block_no_expressions do
            block "This block doesn't have any statements. It should have at least one."
            snippet node
          end if expressions.empty?
  
          expressions.dup.tap do |items|
            variables = [] of VariableScope
  
            while item = items.shift?
              variables.each do |var|
                scope.add(node, var[0], var[2])
              end
  
              # This is to allow recursion
              case target = item.target
              when Ast::Variable
                case value = item.expression
                when Ast::InlineFunction
                  cache[target] =
                    static_type_signature(value)
  
                  scope.add(item, target.value, target)
                end
              end
  
              type = resolve item
              variables = destructure(item.target, type)
            end
          end
  
          last =
            cache[expressions.last]
  
          error! :statement_last_target do
            block do
              text "The"
              bold "last statement"
              text "of a block cannot be an"
              bold "assignment:"
            end
  
            snippet node
          end if expressions.last.target
  
          node.expressions.select(Ast::Statement).each do |item|
            next unless return_value = item.return_value
  
            type =
              cache[return_value]
  
            error! :statement_return_type_mismatch do
              snippet "The type of a return call does not match the return " \
                      "block:", type
  
              snippet "I was expecting:", last
              snippet "It return call in question is here:", return_value
              snippet "The value of block:", expressions.last
            end unless Comparer.compare(last, type)
          end
  
          if async.includes?(node) && last.name != "Promise"
            Type.new("Promise", [last] of Checkable)
          else
            last
          end
        end
      end
    end
  end