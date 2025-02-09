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
      def check_all(node : Ast::Component) : Checkable
        resolve node
  
        resolve node.constants
        resolve node.functions
        resolve node.gets
  
        VOID
      end
  
      def check(node : Ast::Component) : Checkable
        check_global_names node.name.value, node
  
        checked =
          {} of String => Ast::Node
  
        check_names(node.properties, "component", checked)
        check_names(node.functions, "component", checked)
        check_names(node.states, "component", checked)
        check_names(node.gets, "component", checked)
  
        if node.name.value == "Main" && (property = node.properties.first?)
          error! :component_main_properties do
            block do
              text "The"
              bold "Main"
              text "component cannot have properties."
            end
  
            snippet "A property is already defined here:", property
            snippet "The component in qa:", node
          end
        end
  
        node.refs.reduce({} of String => Ast::Node) do |memo, (variable, ref)|
          name = variable.value
          other = memo[name]?
  
          error! :component_reference_name_conflict do
            snippet "There are multiple references with the name:", name
            snippet "references:", variable
            snippet "references:", other
          end if other
  
          memo[name] = variable
          memo
        end
  
        node.styles.reduce({} of String => Ast::Node) do |memo, style|
          name = style.name.value
          other = memo[name]?
  
          error! :component_style_name_conflict do
            snippet "There are multiple styles with the name:", name
            snippet "references:", style
            snippet "references:", other
          end if other
  
          memo[name] = style
          memo
        end
  
        node.connects.each do |connect|
          other = (node.connects - [connect]).find(&.store.value.==(connect.store.value))
  
          return error! :component_multiple_stores do
            block do
              text "The component is connected to the store"
              bold %("#{connect.store.value}")
              text "multiple times."
            end
  
            snippet "references:", other
            snippet "references:", connect
          end if other
        end
  
        node.connects.each do |connect|
          connect.keys.each do |key|
            variable = key.target || key.name
            other = checked[variable.value]?
  
            error! :component_exposed_name_conflict do
              block do
                text "You cannot expose"
                bold %("#{variable.value}")
                text "from the store because the name is already taken."
              end
  
              snippet "The entity with the same name is here:", other
              snippet "the expose is here:", key
            end if other
          end
        end
  
        node.connects.reduce({} of String => Ast::Node) do |memo, connect|
          connect.keys.each do |key|
            variable = key.target || key.name
            other = memo[variable.value]?
  
            error! :component_multiple_exposed do
              block do
                text "The entity"
                bold %("#{variable.value}")
                text "from a store is exposed multiple times."
              end
  
              snippet "It is exposed here:", other
              snippet "", key
            end if other
  
            memo[variable.value] = key
          end
          memo
        end
  
        node.uses.each do |use|
          other = (node.uses - [use]).find(&.provider.value.==(use.provider.value))
  
          error! :component_multiple_providers do
            block do
              text "You are subcribing to the provider"
              bold %("#{other.provider.value}")
              text "in a component multiple times."
            end
  
            snippet "A subscription is here:", other
            snippet "subscription:", use
          end if other
        end
  
        resolve node.properties
        resolve node.connects
        resolve node.states
        resolve node.uses
  
        error! :component_no_render_function do
          block do
            text "A component must have a"
            bold "render function"
            text "This component does not have one:"
          end
  
          snippet node
        end unless node.functions.any?(&.name.value.==("render"))
  
        node.functions.each do |function|
          case function.name.value
          when "render"
            type =
              resolve function
  
            matches =
              [HTML, STRING, HTML_CHILDREN, TEXT_CHILDREN].any? do |item|
                Comparer.compare(type, Type.new("Function", [item] of Checkable))
              end
  
            error! :component_render_function_mismatch do
              block do
                text "expecting the type of the"
                bold "render"
                text "function to match one of types:"
              end
  
              snippet <<-PLAIN
                Function(Array(String))
                Function(Array(Html))
                Function(String)
                Function(Html)
                PLAIN
  
              snippet "Instead the type of the function is:", type.parameters.first
              snippet "function in question:", function
            end unless matches
          when "componentDidMount",
               "componentDidUpdate",
               "componentWillUnmount"
            type =
              resolve function
  
            error! :component_lifecycle_function_mismatch do
              block do
                text "The type of the function"
                bold %("#{function.name.value}")
                text "of a component must be:"
              end
  
              snippet VOID_FUNCTION
              snippet "Instead it is:", type
              snippet "function in question:", function
            end unless Comparer.compare(type, VOID_FUNCTION)
          end
        end
  
        VOID
      end
    end
  end