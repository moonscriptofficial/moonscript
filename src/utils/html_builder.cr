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
  class HtmlBuilder
    def self.build(*, optimize : Bool, doctype : Bool = true, &)
      html =
        XML.build_fragment(indent: optimize ? nil : "  ") do |xml|
          builder = new(xml)

          with builder yield builder
        end

      header =
        if doctype
          "<!DOCTYPE html>#{optimize ? "" : "\n"}"
        end

      "#{header}#{html}"
    end

    def initialize(@xml : XML::Builder)
    end

    def tag(tag, attributes, &)
      @xml.element(tag, attributes) { with self yield }
    end

    def script(**attributes, &)
      @xml.element("script", **attributes) { with self yield }
    end

    def script(**attributes)
      script(**attributes) { text("") }
    end

    def a(**attributes, &)
      @xml.element("a", **attributes) { with self yield }
    end

    def a(**attributes)
      a(**attributes) { text("") }
    end

    def text(contents)
      @xml.text(contents)
    end

    def raw(contents)
      @xml.raw(contents)
    end

    {% for tag in %w(html head body meta link pre code noscript div span h1 h2
                    h3 title aside article nav strong) %}
        def {{tag.id}}(**attributes)
          @xml.element("{{tag.id}}", **attributes)
        end
  
        def {{tag.id}}(**attributes)
          @xml.element("{{tag.id}}", **attributes) do
            with self yield
          end
        end
      {% end %}
  end
end
