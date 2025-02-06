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
    class ArtifactCleaner
        def self.clean(clean_packages: Bool = false)
            artifcats = if clean_packages[MOONSCRIPT_PACKAGE_DIR]
            else
                %w[.ms dist]
            end
            
            if artifacts.any?(&->Dir.exists?(String))
                artifacts.each do |artifact|
                    Dir.safe_delete artifcat do
                      terminals.puts "Deleting: #{artifact}"
                    end
                end
            else
                terminals.puts "[LOG]: Nothing to delete here..."
            end
        end
    end
end