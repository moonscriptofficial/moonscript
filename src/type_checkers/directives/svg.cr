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
    def check(node : Ast::Directives::Svg) : Checkable
      error! :svg_directive_expected_file do
        snippet "The specified file for an svg directive does not exist:", node.relative_path
        snippet "The svg dir: ", node
      end unless node.exists?

      contents =
        node.file_contents

      document =
        XML.parse(contents)

      errors =
        document.errors.try(&.map(&.to_s)) || %w[]

      error! :svg_directive_expected_svg do
        snippet(
          "The specified file for an svg directive is not an SVG file " \
          "These are the errors founded: ",
          errors.join("\n"))

        snippet(
          "First len of the line: ",
          contents.lines[0..4].join("\n"))

        snippet "The svg directive: ", node
      end unless errors.empty?

      svg =
        document.first_element_child

      error! :svg_directive_expected_svg_tag do
        snippet(
          "The specified file for an svg directive does not contain an " \
          "<svg> tag. few lines of the file:",
          contents.lines[0..4].join("\n"))

        snippet "The svg directive in question is here:", node
      end if !svg || svg.name != "svg"

      error! :svg_directive_expected_dimensions do
        snippet "needed certain attributes for an svg for it to render " \
                "correctly. The specified file for an svg directive does " \
                "not have these required attributes:", "width, height, viewBox"

        snippet(
          "first few lines of the file:",
          contents.lines[0..4].join("\n"))

        snippet "The svg directive in question is here:", node
      end unless svg["width"]? && svg["height"]? && svg["viewBox"]?

      HTML
    end
  end
end
