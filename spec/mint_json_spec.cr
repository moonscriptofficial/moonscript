require "./spec_helper"

Dir
  .glob("./spec/moonscript_json/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      source, expected =
        File.read(file).split("-" * 80)

      begin
        MoonScript::MoonJson.parse(contents: source, path: "spec/fixtures/moonscript.json")
      rescue error : MoonScript::Error
        result =
          error.to_terminal.to_s.uncolorize

        fail diff(expected, result) unless result == expected.strip
      end
    end
  end

it "non existent file" do
  begin
    MoonScript::MoonJson.parse("test.json")
  rescue error : MoonScript::Error
    error.to_terminal.to_s.uncolorize.should eq(<<-TEXT)
    ░ ERROR (MOON_JSON_INVALID) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

    There was a problem trying to open a moonscript.json file: test.json

      Error opening file with mode 'r': 'test.json': No such file or directory
    TEXT
  end
end

it "no moonscript.json in directory or parents" do
  begin
    MoonScript::MoonJson.parse("test.json", search: true)
  rescue error : MoonScript::Error
    error.to_terminal.to_s.uncolorize.should eq(<<-TEXT)
    ░ ERROR (MOON_JSON_NOT_FOUND) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

    I could not find a moonscript.json file in the path or any of its parent directories:

      test.json
    TEXT
  end
end
