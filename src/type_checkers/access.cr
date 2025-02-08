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
    def unwind_access(node : Ast::Access, stack = [] of Ast::Variable) : Array(Ast::Variable)
      case item = node.expression
      when Ast::Access
        stack.unshift(item.field)
        unwind_access(item, stack)
      when Ast::Variable
        stack.unshift(item)
      end

      stack
    end

    def to_function_type(node : Ast::TypeVariant, parent : Ast::TypeDefinition)
      parent_type =
        resolve parent

      option_type =
        resolve node

      if node.parameters.empty?
        parent_type
      else
        parameters =
          case fields = node.fields
          when Array(Ast::TypeDefinitionField)
            fields.map do |field|
              type =
                resolve field.type

              type.label = field.key.value
              type
            end
          else
            option_type.parameters.dup
          end

        parameters << parent_type.as(Checkable)
        Comparer.normalize(Type.new("Function", parameters))
      end
    end

    def check(node : Ast::Access) : Checkable
      possibility =
        case variable = node.expression
        when Ast::Access
          stack =
            unwind_access(node)

          if stack.empty?
            nil
          else
            stack.join(".", &.value)
          end
        when Ast::Variable
          variable.value
        end

      if possibility
        entity = scope.resolve(possibility, node).try(&.node)

        if parent = ast.type_definitions.find(&.name.value.==(possibility))
          case fields = parent.fields
          when Array(Ast::TypeVariant)
            if option = fields.find(&.value.value.==(node.field.value))
              variables[node] = {option, parent}
              variables[node.field] = {option, parent}
              variables[node.expression] = {parent, parent}
              resolve(parent)
              return to_function_type(option, parent)
            else
              error! :type_variant_missing do
                snippet "I was looking for a variant of a type:", node.field
                snippet "The type in question:", parent
              end unless entity
            end
          end
        end

        if entity
          if entity && possibility[0].ascii_uppercase?
            if target_node = scope.resolve(node.field.value, entity).try(&.node)
              variables[node.expression] = {entity, entity}
              check!(entity)
              variables[node] = {target_node, entity}
              variables[node.field] = {target_node, entity}
              return resolve target_node
            end
          end
        end
      end

      target =
        resolve node.expression

      error! :access_not_record do
        snippet "You are trying to access a field on an entity which is not " \
                "a record:", target
        snippet "The access in question is: ", node
      end unless target.is_a?(Record)

      new_target = target.fields[node.field.value]?

      error! :access_field_not_found do
        block do
          text "The accessed field"
          code node.field.value
          text "does not exists on the entity:"
        end

        snippet target
        snippet "The access in question is here:", node
      end unless new_target

      if item = component_records.find(&.last.==(target))
        component, _ = item

        refs =
          component.refs.reduce({} of String => Ast::Node) do |memo, (variable, ref)|
            case ref
            when Ast::HtmlComponent
              components_touched.add(component)
              component_records
                .find(&.first.name.value.==(ref.component.value))
                .try do |record|
                  memo[variable.value] = record.first
                end
            when Ast::HtmlElement
              lookups[node.field] = {variable, component}
              return Type.new("Maybe", [Type.new("Dom.Element")] of Checkable) if node.field.value == variable.value
            end

            memo
          end

        lookups[node.field] = {
          (component.gets.find(&.name.value.==(node.field.value)) ||
           component.functions.find(&.name.value.==(node.field.value)) ||
           component.properties.find(&.name.value.==(node.field.value)) ||
           refs[node.field.value]? ||
           component.states.find(&.name.value.==(node.field.value))).not_nil!,
          component,
        }

        resolve lookups[node.field][0]
      else
        record_field_lookup[node.field] = target.name
      end

      new_target
    end
  end
end
