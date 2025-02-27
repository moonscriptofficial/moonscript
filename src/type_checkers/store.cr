module MoonScript
  class TypeChecker
    def check(node : Ast::Store) : Checkable
      # Checking for global naming conflict
      check_global_names node.name.value, node

      # Checking for naming conflicts
      checked =
        {} of String => Ast::Node

      check_names(node.functions, "store", checked)
      check_names(node.signals, "store", checked)
      check_names(node.states, "store", checked)
      check_names(node.gets, "store", checked)

      # Type checking the entities
      resolve node.constants
      resolve node.functions
      resolve node.signals
      resolve node.states
      resolve node.gets

      VOID
    end
  end
end
