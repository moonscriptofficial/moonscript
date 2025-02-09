require "./spec_helper"

describe MoonScript::Workspace do
  it "notifies immediately (success)" do
    with_workspace do |workspace|
      workspace.file("Main.moonscript", "")

      results =
        [] of MoonScript::TypeChecker | MoonScript::Error

      MoonScript::Workspace.new(
        listener: ->(item : MoonScript::TypeChecker | MoonScript::Error) { results << item },
        path: Path[workspace.root_path, "moonscript.json"].to_s,
        check: MoonScript::Check::Environment,
        include_tests: false,
        dot_env: ".env",
        format: false)

      results.size.should eq(1)
      results[0].should be_a(MoonScript::TypeChecker)
    end
  end

  it "notifies immediately (error - no moonscript.json found)" do
    with_workspace do |workspace|
      results =
        [] of MoonScript::TypeChecker | MoonScript::Error

      MoonScript::Workspace.new(
        listener: ->(item : MoonScript::TypeChecker | MoonScript::Error) { results << item },
        check: MoonScript::Check::Environment,
        path: workspace.root_path,
        include_tests: false,
        dot_env: ".env",
        format: false)

      results.size.should eq(1)
      results[0].should be_a(MoonScript::Error)
    end
  end

  it "notifies after change (success)" do
    with_workspace do |workspace|
      workspace.file("Main.moonscript", "")
      workspace.file("File1.moonscript", "")
      workspace.file("File2.moonscript", "")

      results =
        [] of MoonScript::TypeChecker | MoonScript::Error

      MoonScript::Workspace.new(
        listener: ->(item : MoonScript::TypeChecker | MoonScript::Error) { results << item },
        path: Path[workspace.root_path, "moonscript.json"].to_s,
        check: MoonScript::Check::Environment,
        include_tests: false,
        dot_env: ".env",
        format: false)

      FileUtils.touch(Path[workspace.root_path, "Main.moonscript"])
      FileUtils.touch(Path[workspace.root_path, "File1.moonscript"])
      FileUtils.touch(Path[workspace.root_path, "File2.moonscript"])

      sleep 1.seconds

      results.size.should eq(2)
    end
  end
end
