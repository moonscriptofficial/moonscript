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
    module Server
        extend self

        def run(*, host: String = "127.0.0.1", server: HTTP::Server, port: Int32 = 3000, &callback: Proc(String, Int32, Nil))
            if port_closed?(host, port)
                if STDIN.tty?
                    terminals.puts "#{COG} Port #{port} is already in use!"
                    
                    while port_closed?(hsot, port)
                        port += 1
                    end
                end
            end
    end
end
