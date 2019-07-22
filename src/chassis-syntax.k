module CHASSIS-SYNTAX
    imports DOMAINS-SYNTAX

    /*----------------------------------------------------------------------------------------------------------------------*/
    /* Types */
    /*----------------------------------------------------------------------------------------------------------------------*/

    syntax Type ::= TypeVar | TypeVal | TypeCon | TypeDes

    /* variables */
    syntax TypeVar ::= typeVar(Id)

    /* values */
    syntax TypeVal ::= "void" | "unit" | "bool" | "nat"

    /* constructors */
    syntax TypeCon ::= "(" Type ")" [bracket]
                     | Type "->" Type
                     | prod(Type, Type)
                     | sum(Type, Type)
                     | "forall" Id ":" Type "." Type [binder]

    syntax TypeDes ::= Type Id

   /*----------------------------------------------------------------------------------------------------------------------*/
   /* Expressions */
   /*----------------------------------------------------------------------------------------------------------------------*/

    syntax Expr ::= ExprVal | ExprVar | ExprCon | ExprDes

    /* values */
    syntax ExprVal ::= "()"
                     | "true" | "false"
                     | "O" | "S" Expr
                     | "\\" Id ":" Type "." Expr [binder]
                     | "/\\" Id "." Expr [binder]

    /* variables */
    syntax ExprVar ::= Id

    /* constructors */
    syntax ExprCon ::=
                     | "(" Expr ")" [bracket]
                     | "fix" Expr
                     | "<" Expr "," Expr ">"
                     | "inl" Expr
                     | "inr" Expr
                     | "let" Id ":" Type ":=" Expr "in" Expr [binder]

    /* destructors */
    syntax ExprDes ::=
                     | Expr Expr [left, strict(1)]
                     | Expr "[" Type "]"
                     | "if" Expr "then" Expr "else" Expr [strict(1)]
                     | "split" Expr "as" Id "," Id "in" Expr [binder]
                     | "case" Expr "of" "inl" Id "=>" Expr "|" "inr" Id "=>" Expr [binder]

   /*----------------------------------------------------------------------------------------------------------------------*/
   /* Reduction Rules */
   /*----------------------------------------------------------------------------------------------------------------------*/

   rule let X : T := E1 in E2 => (\X : T . E2) E1 [structural]

   /*----------------------------------------------------------------------------------------------------------------------*/
   /* K-specifics */
   /*----------------------------------------------------------------------------------------------------------------------*/

    syntax KVariable ::= ExprVar

    syntax Program ::= Expr

endmodule
