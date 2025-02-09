require "./spec_helper"

path = "./spec/examples/**/*"
example = nil

ENV["EXAMPLE"]?.try do |item|
  splitted = item.split(':', 2)
  path = splitted[0]
  example = splitted[1]?
end

Dir
  .glob(path)
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    # Read samples
    samples = [] of Tuple(String, String?)
    contents = File.read(file)
    name = File.basename(file)
    position = 0
    error = nil

    contents.scan(/^\-+([^-\n]+)?/m) do |match|
      subject = contents[position, match.begin - position]
      samples << {subject, error}
      position = match.end
      error = match[1]?
    end

    samples << {contents[position, contents.size - position], error}

    samples.reject(&.first?.blank?).each_with_index do |sample, index|
      next if example && example.to_i != index

      it "#{name} ##{index}" do
        source, error = sample

        if error
          begin
            ast = MoonScript::Parser.parse(source, file)

            type_checker = MoonScript::TypeChecker.new(ast)
            type_checker.check
          rescue exception : MoonScript::Error
            if exception.name.to_s != error
              fail exception.to_terminal.to_s
            end
          rescue exception
            fail source + '\n' + exception.to_s + '\n' + exception.backtrace.join('\n')
          end

          exception.should be_a(MoonScript::Error)
        else
          begin
            ast = MoonScript::Parser.parse(source, file)
            ast.class.should eq(MoonScript::Ast)

            type_checker = MoonScript::TypeChecker.new(ast)
            type_checker.check
          rescue exception : MoonScript::Error
            fail exception.to_terminal.to_s
          rescue exception
            fail source + '\n' + exception.to_s + '\n' + exception.backtrace.join('\n')
          end
        end
      end
    end
  end
