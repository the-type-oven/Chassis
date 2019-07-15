require "substitution.k"

module CHASSIS-SYNTAX
    imports DOMAINS-SYNTAX

    syntax Term ::= Val
                  | Var
                  | Term Term [left, strict(1)]
                  | "if" Term "then" Term "else" Term
                  | "fix" Var "." Term [binder]

    syntax Val ::= Bool
                 | "\\" Id "." Term
endmodule

