require "substitution.k"
require "chassis-syntax.k"

module CHASSIS-TYPING-SYNTAX
    imports CHASSIS-SYNTAX
endmodule

module CHASSIS-TYPING
    imports DOMAINS
    imports CHASSIS-SYNTAX

    syntax KResult ::= Type

    configuration <T>
                    <k> $PGM:Program </k>
                  </T>
endmodule

