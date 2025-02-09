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
      def check(node : Ast::Connect) : Checkable
        store =
          ast.stores.find(&.name.value.==(node.store.value))
  
        error! :connect_not_found_store do
          block do
            text "looking for the store"
            bold node.store.value
            text "but could not find it."
          end
  
          snippet node.store
        end unless store
  
        resolve store
  
        node.keys.each do |key|
          error! :connect_not_found_member do
            block do
              text "The entity"
              bold %("#{key.name.value}")
              text "does not exists!"
            end
  
            snippet "The connect in question:", node
          end unless found = scope.resolve(key.name.value, store).try(&.node)
  
          cache[key] =
            resolve found
  
          lookups[key] =
            {found, store}
        end
  
        VOID
      end
    end
  end