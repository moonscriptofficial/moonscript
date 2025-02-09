require "./spec_helper"

Dir
  .glob("./spec/compilers/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      begin
        # Read and separate sample from expected
        sample, expected = File.read(file).split("-" * 80)

        # Parse the sample
        ast = MoonScript::Parser.parse(sample, File.dirname(__FILE__) + file.lchop("./spec"))
        ast.class.should eq(MoonScript::Ast)

        artifacts =
          MoonScript::TypeChecker.check(ast)

        test_information =
          if File.basename(file).starts_with?("test")
            {url: "", id: "", glob: "**"}
          end

        config =
          MoonScript::Bundler::Config.new(
            json: MoonScript::MoonJson.parse("{}", "moonscript.json"),
            generate_source_maps: false,
            generate_manifest: false,
            include_program: false,
            test: test_information,
            live_reload: false,
            runtime_path: nil,
            skip_icons: false,
            hash_assets: true,
            optimize: false)

        files =
          MoonScript::Bundler.new(
            artifacts: artifacts,
            config: config,
          ).bundle.map do |path, contents|
            {path, case contents
            in Proc(String)
              contents.call
            in String
              contents
            end}
          end.to_h
            .reject { |_, contents| contents.blank? }
            .reject { |key, _| key.in?("/__moonscript__/runtime.js", "/index.html") }

        result =
          case files.size
          when 1
            files.first[1]
          else
            files
              .map { |path, contents| "---=== #{path} ===---\n#{contents}" }
              .join("\n\n").strip
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
