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
            def parse : MoonJson
                dependencies = [] of Installer::Depdency
                formatter = Formatter::Config.new
                source_directories = %w[]
                test_directories = %w[]
                name = ""

                application = Application.new(meta: {} of String => String, orientation: "", theme_color: "", css_prefix: "", display: "", title: "", name: "", head: "", icon: "")

                @parser.read_object do |key|
                    case key
                    when "source-directories"
                        source_directories = parse_source_directories
                    when "test-directories"
                        test_directories = parse_test_directories
                    when "dependencies"
                        dependencies = parse_dependencies
                    when "application"
                        application = parse_application
                    when "formatter"
                        formatter = parse_formatter
                    when "moon-version"
                        parse_moon_version
                    when "name"
                        name = parse_name
                    else
                        error! :root_invalid_key do
                            snippet "The root object has an invalid key"
                        end
                    end
                end

            rescue JSON::ParseException 
                error! :root_invalid do
                    snippet "The root item should be an object"
                end
            end
        end
    end
end