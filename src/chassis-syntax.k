module CHASSIS-SYNTAX
    imports DOMAINS-SYNTAX

    syntax Type ::= Id
                  | Type "->" Type [right]
                  | "bool"
                  | "forall" Id "." Type [binder]
                  | Type "*" Type
                  | Type "+" Type
                  | "(" Type ")" [bracket]

    syntax Term ::= Val
                  | Var
                  | Term Term [left, strict(1)]
                  | "if" Term "then" Term "else" Term
                  | "fix" Id "." Term [binder]
                  | "let" Id ":" Type "=" Term "in" Term [binder]
                  | "split" Term "as" Id "," Id "in" Term [binder]
                  | "<" Term "," Term ">"
                  | "(" Term ")" [bracket]

    syntax Val ::= Bool
                 | "\\" Id ":" Type "." Term [binder]

    syntax Var ::= Id

    syntax KVariable ::= Var

    syntax Program ::= Term

    rule let X : T = E1 in E2 => (\X : T.E2) E1 [structural]
endmodule

