/* Lexer */
%lex
%%
\s+                   { /* skip whitespace */; }
\/\/.*    {/* skip comment */; }
[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)?    {return 'NUMBER'; }
[0-9]+                { return 'NUMBER';       }
"**"                  { return 'opow';           }
[-+]                { return 'opad';           }
[*/]                { return 'opmu';           }
<<EOF>>               { return 'EOF';          }
.                     { return 'INVALID';      }
/lex

/* Parser */
%start expressions
%token NUMBER
%%

expressions
    : expression EOF
        { return $expression; }
    ;

expression
    : expression opad multiplication
        { $$ = operate($opad, $expression, $multiplication); }
    | multiplication
        { $$ = $multiplication; }
    ;

multiplication
    : multiplication opmu potency
        { $$ = operate($opmu, $multiplication, $ potency); }
    | multiplication
        { $$ = $multiplication; }
    ;

potency
    : factor opow potency
        { $$ = operate($opow, $factor, $potency); }
    | factor
        { $$ = $factor; }
    :

factor
    : NUMBER
        { $$ = Number(yytext); }
    ;
%%

function operate(op, left, right) {
    switch (op) {
        case '+': return left + right;
        case '-': return left - right;
        case '*': return left * right;
        case '/': return left / right;
        case '**': return Math.pow(left, right);
    }
}
