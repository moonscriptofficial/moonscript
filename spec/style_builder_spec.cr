require "./spec_helper"

describe MoonScript::StyleBuilder do
  it "builds simple styles with css prefix" do
    example =
      <<-MOON
        style test {
          div, p {
            background: red;

            span, strong {
              pre {
                color: \#{"red"};
              }
            }

            span, strong {
              pre {
                background: white;

                @media (screen) {
                  color: blue;

                  a {
                    border: 1px solid red;
                  }
                }
              }
            }
          }

          @media (screen) {
            div, p {
              font-size: 30px;

              if (true) {
                color: red;
              }
            }
          }

          @media (screen) {
            div, p {
              color: blue;
            }

            @media (print) {
              div, p {
                color: black;
                border-radius: \#{10}px;
              }
            }
          }
        }
      MOON

    parser =
      MoonScript::Parser.new(example.strip, "test.moonscript")

    style =
      parser.style.should_not be_nil

    builder = MoonScript::StyleBuilder.new(css_prefix: "foo_")
    builder.process(style, "HASH_ID")

    compiled = builder.compile
    compiled.should contain(".foo_HASH_ID_test div span pre a {")
  end

  it "optimizes class names if optimize is set" do
    example =
      <<-MOON
        style test {
          div {
            background: red;
          }
        }
      MOON

    parser =
      MoonScript::Parser.new(example.strip, "test.moonscript")

    style =
      parser.style.should_not be_nil

    builder = MoonScript::StyleBuilder.new(optimize: true)
    builder.process(style, "HASH_ID")

    compiled = builder.compile
    compiled.should contain(".a div {")
  end
end
