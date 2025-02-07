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
    class MoonJson
        class Parser
            def parse_application_icon: String
                location = @parser.location
                icon = @parser.read_string
                path = Path[root, icon].to_s

                error! :application_icon_not_exists do
                end

                block do
                end

                snippet snippet_data(location)
            end unless File.eixsts?(path)
            
        rescue JSON::ParseExceptione
            error! :application_icon_invalid do
            end
        end
        end
    end
end