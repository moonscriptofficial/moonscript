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
      def check(node : Ast::Call)
        function_type =
          resolve node.expression
  
        check_call(node, function_type)
      end
  
      def check_call(node, function_type) : Checkable
        return error! :call_not_a_function do
          snippet "The entity you called is not a function:", function_type
          snippet "The call in question:", node
        end unless function_type.name == "Function"
  
        argument_size =
          function_type.parameters.size - 1
  
        required_argument_size =
          case function_type
          when TypeChecker::Type
            argument_size - function_type.optional_count
          else
            argument_size
          end
  
        parameters =
          [] of Checkable
  
        error! :call_argument_size_mismatch do
          block do
            text "The function called"
            bold argument_size.to_s
            text "arguments, while you tried to call it with"
            bold "#{node.arguments.size}."
          end
  
          snippet "The type of the function is:", function_type
          snippet "The call in question is here:", node
        end if node.arguments.size > argument_size ||       
               node.arguments.size < required_argument_size 
  
        args =
          if node.arguments.all?(&.key.nil?)
            node.arguments
          elsif node.arguments.all?(&.key.!=(nil))
            node.arguments.sort_by do |argument|
              index =
                function_type
                  .parameters
                  .index { |param| param.label == argument.key.try(&.value) }
  
              error! :call_not_found_argument do
                snippet(
                  "looking for a named argument, can't find it:",
                  argument.key.try(&.value).to_s)
  
                snippet "The type of the function is:", function_type
                snippet "The call in question is here:", node
              end unless index
  
              index
            end
          else
            error! :call_with_mixed_arguments do
              block "A call cannot have named and unamed arguments at the same " \
                    "time because in specific cases I cannot pair the arguments " \
                    "with the values."
  
              snippet "The call in question is here:", node
            end
          end
  
        args.each_with_index do |argument, index|
          argument_type =
            resolve argument
  
          function_argument_type =
            function_type.parameters[index]
  
          error! :call_argument_type_mismatch do
            ordinal =
              ordinal(index + 1)
  
            block do
              text "The"
              bold "#{ordinal} argument"
              text "to a function is causing a mismatch."
            end
  
            snippet "The function is expecting the #{ordinal} argument to be:", function_argument_type
            snippet "Instead it is:", argument_type
            snippet "The call in question is here:", node
          end unless res = Comparer.compare(function_argument_type, argument_type)
  
          parameters << res
        end
  
        if (optional_param_count = argument_size - args.size) > 0
          parameters.concat(function_type.parameters[args.size, optional_param_count])
        end
  
        call_type =
          Type.new("Function", parameters + [function_type.parameters.last])
  
        result =
          Comparer.compare(function_type, call_type)
  
        error! :impossible_error do
          block "You have run into an impossible error. Please file an issue " \
                "with a reproducible example in the Github repository."
  
          snippet "Call type:", call_type
          snippet "Function type:", function_type
          snippet node
        end unless result
  
        final = resolve_type(result.parameters.last)
  
        if node.await && final.name == "Promise"
          final.parameters.first
        else
          final
        end
      end
    end
  end