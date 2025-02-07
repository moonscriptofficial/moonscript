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
  class Workspace
    getter result : TypeChecker | Error = Error.new(:unitialized_workspace)

    @cache : Hash(String, Ast | Error) = {} of String => Ast | Error
    @listener : Proc(TypeChecker | Error, Nil) | Nil

    def initialize(
      *,
      @listener : Proc(TypeChecker | Error, Nil) | Nil,
      @include_tests : Bool,
      dot_env : String,
      @format : Bool,
      @check : Check,
      @path : String,
    )
      @dot_env =
        File.basename(dot_env)

      (@watcher = Watcher.new(&->update(Array(String), Symbol)))
        .tap { reset }
        .watch
    end

    def update(contents : String, path : String) : Nil
      @cache[path] = Parser.parse?(contents, path)
    end

    def delete(path : String) : Nil
      @cache.delete(path)
    end

    def artifacts : TypeChecker::Artifacts | Error
      map_error(result, &.artifacts)
    end

    def ast(path : String) : Ast | Error | Nil
      @cache[path]?
    end

    def ast : Ast | Error
      map_error(artifacts, &.ast)
    end

    def unchecked_ast
      @cache
        .values
        .select(Ast)
        .reduce(Ast.new) { |memo, item| memo.merge item }
        .tap do |item|
          unless item.type_definitions.index(&.name.==("Maybe"))
            item.merge(Core.ast)
          end
        end
        .normalize
    end

    def nodes_at_cursor(
      *,
      column : Int64,
      path : String,
      line : Int64,
    ) : Array(Ast::Node) | Error
      map_error(ast, &.nodes_at_cursor(
        line: line, column: column, path: path))
    end

    def nodes_at_path(path : String)
      map_error(ast, &.nodes_at_path(path))
    end

    def formatter_config
      MoonJson.parse?(@path, search: true).try(&.formatter) ||
        Formatter::Config.new
    end

    def format(node : Ast::Node | Nil) : String | Nil
      Formatter.new(formatter_config).format!(node)
    end

    def format(path : String) : String | Error | Nil
      case item = ast(path)
      in Ast
        Formatter.new(formatter_config).format(item)
      in Error, Nil
        item
      end
    end

    def reset
      @cache.clear
      @watcher.patterns =
        SourceFiles.everything(
          MoonJson.parse(@path, search: true),
          include_tests: @include_tests,
          dot_env: @dot_env)
    rescue error : Error
      set(error)
    end

    def check
      Logger.log "Type Checking" do
        if error = @cache.values.select(Error).first?
          error
        else
          TypeChecker.new(
            check_everything: @check.unreachable?,
            check_env: @check.environment?,
            ast: unchecked_ast
          ).tap(&.check)
        end
      end
    rescue error : Error
      error
    end

    def update(files : Array(String), reason : Symbol)
      actions = [] of Symbol

      Logger.log "Parsing files" do
        files.each do |file|
          if File.extname(file) == ".moon"
            if File.exists?(file)
              contents = File.read(file)
              update(contents, file)

              if @format
                case ast = ast(file)
                when Ast
                  formatted =
                    Formatter.new(formatter_config).format(ast) + "\n"

                  if formatted != contents
                    File.write(file, formatted)
                  end
                end
              end
            else
              delete(file)
            end

            actions << :compile
          else
            case File.basename(file)
            when @dot_env
              Env.init(file)
            end

            actions << :reset
          end
        end
      end

      if actions.includes?(:reset) && reason == :modified
        reset
      elsif actions.includes?(:compile)
        set(check)
      end
    end

    private def set(value : TypeChecker | Error) : Nil
      @result = value
      @listener.try(&.call(value))
    end

    private def map_error(item : T | Error, & : T -> R) : R | Error forall T, R
      case item
      in Error
        item
      in T
        yield item
      end
    end
  end
end
