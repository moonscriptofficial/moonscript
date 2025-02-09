module MoonScript
  class TypeChecker
    def check(node : Ast::BoolLiteral) : Checkable
      BOOL
    end
  end
end
