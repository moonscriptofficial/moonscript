module MoonScript
  class TypeChecker
    def check(node : Ast::Emit) : Checkable
      error! :emit_no_signal do
        snippet "Emit cannot be used outside of signals:", node
      end unless signal = node.signal

      type =
        resolve node.expression

      signal_type =
        resolve signal.type

      error! :emit_type_mismatch do
        snippet "The emitted values type is different from the signals type:",
          signal_type

        snippet "The type of the emitted value is:", type
        snippet "The emit in question is here:", node
      end unless Comparer.compare(type, signal_type)

      VOID
    end
  end
end
