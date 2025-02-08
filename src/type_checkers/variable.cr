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
    RESERVED =
      %w(break case class const continue debugger default do else
        export extends for if import in instanceof new return super
        switch throw typeof var while yield)

    def check(node : Ast::Variable) : Checkable
      if node.value == "void"
        VOID
      else
        error! :variable_reserved do
          snippet "This name for a variable is a reserved: ", node
        end if RESERVED.includes?(node.value)

        item = lookup_with_level(node)

        error! :variable_missing do
          snippet "can't find the entity with the name:", node.value
          snippet "Here is where it is referenced:", node
        end unless item

        variables[node] = item

        case
        when node.value == "subscriptions" && item[1].is_a?(Ast::Provider)
          subscription =
            records.find(&.name.==(item[1].as(Ast::Provider).subscription.value))

          case subscription
          when Record
            Type.new("Array", [subscription] of Checkable)
          else
            raise "Cannot happen!"
          end
        when item[0].is_a?(Ast::HtmlElement) &&
          (item[1].is_a?(Ast::Component) || item[1].is_a?(Ast::Test))
          Type.new("Maybe", [Type.new("Dom.Element")] of Checkable)
        when item[0].is_a?(Ast::Component) &&
          (item[1].is_a?(Ast::Component) || item[1].is_a?(Ast::Test))
          components_touched.add(item[0].as(Ast::Component))
          Type.new("Maybe", [component_records[item[0]]] of Checkable)
        else
          case value = item[0]
          when Ast::Statement
            resolve value
          when Tuple(Ast::Node, Int32 | Array(Int32))
            item = value[0]

            type =
              resolve item

            case item
            when Ast::Statement
              case item.target
              when Ast::TupleDestructuring
                case val = value[1]
                in Int32
                  type.parameters[val]
                in Array(Int32)
                  val.reduce(type) { |curr_type, curr_val| curr_type.parameters[curr_val] }
                end
              else
                type
              end
            else
              type
            end
          when Ast::Node
            resolve value
          when Checkable
            value
          else
            VOID
          end
        end
      end
    end
  end
end
