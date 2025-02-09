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
      def check(node : Ast::Emit) : Checkable
        error! :emit_no_signal do
          snippet "Emit cannot be used outside of signals:", node
        end unless signal = node.signal
  
        type =
          resolve node.expression
  
        signal_type =
          resolve signal.type
  
        error! :emit_type_mismatch do
          snippet "The emitted values type is different from the signals type:",
            signal_type
  
          snippet "The type of the emitted value is:", type
        end unless Comparer.compare(type, signal_type)
  
        VOID
      end
    end
  end