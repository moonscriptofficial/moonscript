require "./spec_helper"

describe MoonScript::NamePool do
  it "returns next name" do
    pool = MoonScript::NamePool(String, MoonScript::StyleBuilder::Selector).new
    object = MoonScript::StyleBuilder::Selector.new

    pool.of("a", object).should eq("a")
    pool.of("a", object).should eq("a")
    pool.of("b", object).should eq("b")
    pool.of("c", object).should eq("c")
  end
end
