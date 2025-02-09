require "./spec_helper"

Dir
  .glob("./spec/static_documentation_generators/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      begin
        # Read and separate sample from expected
        sample, expected = File.read(file).split("-" * 80)

        # Parse the sample
        ast = MoonScript::Parser.parse(sample, file)
        ast.class.should eq(MoonScript::Ast)

        begin
          MoonScript::TypeChecker.check(ast)

          # Compare results
          result =
            format_xml(
              MoonScript::StaticDocumentationGenerator.generate([ast])["/Test.html"].call
            ).sub("<?xml version=\"1.0\"?>\n", "").strip
        rescue error : MoonScript::Error
          fail error.to_terminal.to_s
        end

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
