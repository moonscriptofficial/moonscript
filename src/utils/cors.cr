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

module MoonScript
  class CORS
    include HTTP::Handler

    def call(context)
      ## Response headers which supports the web type.
      context.response.headers["Access-Control-Max-Age"] = 1.day.total_seconds.to_i.to_s
      context.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH"
      context.response.headers["Access-Control-Allow-Headers"] = "Content-Type"
      context.response.headers["Access-Control-Allow-Credentials"] = "true"
      context.response.headers["Access-Control-Allow-Origin"] = "*"
      
      ## Case checking
      if context.request.method.upcase == "OPTIONS"
        context.response.content_type = "text/html; charset=utf-8"
        context.response.status = :ok
      else
        call_next context
      end

    end
  end
end
