module MoonScript
  class TypeChecker
    def check(node : Ast::NumberLiteral) : Checkable
      NUMBER
    end
  end
end
