require "./spec_helper"

Dir
  .glob("./spec/formatters/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      begin
        # Read and separate sample from expected
        sample, expected = File.read(file).split("-" * 80)

        # Parse sample
        ast = MoonScript::Parser.parse(sample, file)
        ast.class.should eq(MoonScript::Ast)

        begin
          # Type check
          type_checker = MoonScript::TypeChecker.new(ast)
          type_checker.check
        rescue error : MoonScript::Error
          fail error.to_terminal.to_s
        end

        formatter = MoonScript::Formatter.new(MoonScript::Formatter::Config.new)

        # Format and compare the results
        result = formatter.format(ast)

        begin
          result.should eq(expected.strip)
        rescue error
          fail diff(expected, result)
        end

        # Parse the result, format again and compare
        ast = MoonScript::Parser.parse(result, file)
        ast.class.should eq(MoonScript::Ast)

        result = formatter.format(ast)

        begin
          result.should eq(expected.strip)
        rescue error
          fail diff(expected, result)
        end
      rescue error : MoonScript::Error
        fail error.to_terminal.to_s
      end
    end
  end
