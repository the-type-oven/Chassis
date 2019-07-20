require "substitution.k"
require "chassis-syntax.k"

module CHASSIS-EXECUTION-SYNTAX
    imports CHASSIS-SYNTAX
endmodule

module CHASSIS-EXECUTION
    imports DOMAINS
    imports SUBSTITUTION
    imports CHASSIS-SYNTAX

    syntax KResult ::= Val

    configuration <T>
                    <k> $PGM:Program </k>
                  </T>

    rule (\X : T.Body) E => Body[E/X]

    rule if true then E1 else E2 => E1
    rule if false then E1 else E2 => E2

    rule split <V1:Val, V2:Val> as X,Y in E => E[V1/X][V2/Y]
endmodule

