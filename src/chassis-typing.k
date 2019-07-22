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

    rule I:Int => int
    rule B:Bool => bool

    rule if Cond then E1 else E2 => unify(Cond, bool) ~> unify(E1, E2) ~> E1

    rule E1 + E2 => unify(E1, int) ~> unify(E2, int) ~> int
    rule E1 - E2 => unify(E1, int) ~> unify(E2, int) ~> int
    rule E1 * E2 => unify(E1, int) ~> unify(E2, int) ~> int
    rule E1 = E2 => unify(E1, int) ~> unify(E2, int) ~> bool
    rule E1 < E2 => unify(E1, int) ~> unify(E2, int) ~> bool

    rule <k> unify(typeVar(X:Id), typeVar(X:Id)) => . ... </k>
         <typeVars> ... SetItem(X) ... </typeVars>
    rule unify(bool, bool) => .
    rule unify(int, int) => .
    rule unify(T1 -> T2, T3 -> T4) => unify(T1, T3) ~> unify(T2, T4)
    rule unify(prod(T1, T2), prod(T3, T4)) => unify(T1, T3) ~> unify(T2, T4)
    rule unify(sum(T1, T2), sum(T3, T4)) => unify(T1, T3) ~> unify(T2, T4)
    rule unify(forall X . T1, forall Y . T2) => unify(T1, T2[X/Y])

    rule <k> \ X : T . E:Term => unify(E, ?TRet:Type) ~> T -> ?TRet ~> setTEnv(TEnv) ... </k>
         <typeEnv> TEnv => TEnv[X <- T] </typeEnv>

    rule <k> /\ X . E => unify(E, ?TOut) ~> forall X . ?TOut ~> setTVars(TVars) ... </k>
         <typeVars> TVars => TVars SetItem(X) </typeVars>

    rule <k> X:Id => T:Type ... </k>
         <typeEnv> ... X |-> T ... </typeEnv>

    rule E1 E2 => unify(E1, (?T1:Type -> ?T2:Type)) ~> unify(E2, ?T1) ~> ?T2

    rule fix Body => unify(Body, ?T1 -> ?T1) ~> ?T1

    rule <k> T:Type ~> (setTEnv(TEnv) => .) ...</k>
         <typeEnv> _ => TEnv </typeEnv>

    rule <k> T:Type ~> (setTVars(TVars) => .) ...</k>
         <typeVars> _ => TVars </typeVars>
endmodule

