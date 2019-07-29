require "substitution.k"
require "chassis-syntax.k"

module CHASSIS-TYPING-SYNTAX
    imports CHASSIS-SYNTAX
endmodule

module CHASSIS-TYPING
    imports DOMAINS
    imports SUBSTITUTION
    imports CHASSIS-SYNTAX

    syntax KResult ::= Type

    configuration <T>
                    <k> $PGM:Program </k>
                    <typeEnv> .Map </typeEnv>
                    <typeVars> .Set </typeVars>
                  </T>

    syntax Term ::= unify(Term, Term) [strict]
                  | setTEnv(Map)
                  | setTVars(Set)
                  | Type

    /*----------------------------------------------------------------------------------------------------------------------*/
    /* Unifcation */
    /*----------------------------------------------------------------------------------------------------------------------*/

    /* fully evaluated */
    rule E:void => void
    rule E:unit => unit
    rule E:bool => bool
    rule E:nat  => nat

    /* trivial */
    unify (void, void) => .
    unify (unit, unit) => .
    unify (bool, bool) => .
    unify (nat,  nat ) => .

    /* type variables */
    rule <k> unify(typeVar(X:Id), typeVar(X:Id)) => . ... </k>
         <typeVars> ... SetItem(X) ... </typeVars>

    /* constructions */
    rule unify(A -> B, C -> D)                      => unify(A, C) ~> unify(B, D)
    rule unify(prod(A, B), prod(C, D))              => unify(A, C) ~> unify(B, D)
    rule unify(sum(A, B), sum(C, D))                => unify(A, C) ~> unify(B, D)
    rule unify(forall X : A . B, forall Y : C . D)  => unify(B, D) ~> unify(A, C[X/Y])

    /* destructions */
    rule unify(T1 X, T2 Y) => . /* TODO */

    /*----------------------------------------------------------------------------------------------------------------------*/
    /* Constructions */
    /*----------------------------------------------------------------------------------------------------------------------*/

    rule <k> \ X:Id : A:Type . E:Expr => unify(E, ?B:Type) ~>
                                           A -> ?B ~>
                                           setTEnv(Tenv) ... </k>
         <typeEnv> TEnv => TEnv[X <- T] </typeEnv>

    rule <k> /\ A:Id . E:Expr => unify(E, ?B) ~>
                                 forall X . ?B ~>
                                 setTVars(TVars) ... </k>
         <typeVars> TVars => TVars SetItem(A) </typeVars>

    rule fix X:Expr => unify(X, ?A:Type -> ?A:Type) ~> ?A

    rule < X:Expr , Y:Expr > => prod(X, Y)

    rule inl X:Expr => sum(X, ?B:Type)
    rule inr Y:Expr => sum(?A:Type, Y)

    rule let X:Expr : T:Type := E1:Expr in E2:Expr => (\X : T . E2) E1 [structural]

    /*----------------------------------------------------------------------------------------------------------------------*/
    /* Destructions */
    /*----------------------------------------------------------------------------------------------------------------------*/

    rule X:Expr Y:Expr => unify(X, (?A:Type -> ?B:Type)) ~>
                          unify(Y, ?A) ~>
                          ?B

    rule X:Expr [A:Type] => unify(X, (/\ ?B:Type . E:Expr)) ~>
                            unify(A, ?B) ~>
                            ?E

    rule if X:Expr then Y:Expr else Z:Expr => unify(X, bool) ~>
                                              unify(Y, Z) ~>
                                              Z

    rule split P:Type as X:Id , Y:Id in Z:Expr => unify(P, < X , Y >) ~> . /* TODO */

    rule case S of inl X => E | inr Y => F ~> . /* TODO */

    /*----------------------------------------------------------------------------------------------------------------------*/
    /* Type Judgements */
    /*----------------------------------------------------------------------------------------------------------------------*/

    rule <k> X:Id => A:Type ... </k>
         <typeEnv> ... X |-> A ... </typeEnv>

   /*----------------------------------------------------------------------------------------------------------------------*/
   /* Terminations */
   /*----------------------------------------------------------------------------------------------------------------------*/

   rule <k> A:Type ~> (setTEnv(TEnv) => .) ... </k>
        <typeEnv> _ => TEnv </typeEnv>

   rule <k> A:Type ~> (setTVars(TVars) => .) ... </k>
        <typeVars> _ => TVars </typeVars>

endmodule
