module CHASSIS-SYNTAX
    imports DOMAINS-SYNTAX

    syntax Type    ::= TypeVar | TypeCon
    syntax TypeVar ::= typeVar(Id)
    syntax TypeCon ::= Type "->" Type [right]
                     | "bool" | "int"
                     | "forall" Id "." Type [binder]
                     | prod(Type, Type)
                     | sum(Type, Type)
                     | "(" Type ")" [bracket]

    syntax Term ::= Val
                  | Var
                  | Term Term [left, strict(1)]
                  | Term "[" Type "]"
                  | "if" Term "then" Term "else" Term [strict(1)]
                  /* | "fix" Term */
                  | "let" Id ":" Type "=" Term "in" Term [binder]
                  | "split" Term "as" Id "," Id "in" Term [binder]
                  | "<" Term "," Term ">"
                  | "inl" Term
                  | "inr" Term
                  | "case" Term "of" "inl" Id "=>" Term "|" "inr" Id "=>" Term [binder]
                  | "(" Term ")" [bracket]
                  | Term "*" Term [strict, left]
                  > Term "+" Term [strict, left]
                  | Term "-" Term [strict]
                  > Term "=" Term [strict]
                  | Term "<" Term [strict]

    syntax Val ::= Bool | Int
                 | "λ" Id ":" Type "." Term [binder]
                 | "\\" Id ":" Type "." Term [binder]
                 | "Λ" Id "." Term [binder]
                 | "/\\" Id "." Term [binder]

    syntax Var ::= Id

    syntax KVariable ::= Var

    syntax Program ::= Term

    rule let X : T = E1 in E2 => (\X : T.E2) E1 [structural]
    rule λ X : T . E => \ X : T . E             [structural]
    rule Λ X . E => /\ X . E                    [structural]
endmodule

