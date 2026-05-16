/* Lexer */
%lex
%%
\s+                   { /* skip whitespace */; }
\/\/.*    {/* skip comment */; }
[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)?    {return 'NUMBER'; }
"("                   { return 'openbrack'; }
")"                   { return 'closebrack'; }
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
        { return $1; }
    ;

expression
    : expression opad multiplication
        { $$ = operate($2, $1, $3); }
    | multiplication
        { $$ = $1; }
    ;

multiplication
    : multiplication opmu potency
        { $$ = operate($2, $1, $3); }
    | potency
        { $$ = $1; }
    ;

potency
    : factor opow potency
        { $$ = operate($2, $1, $3); }
    | factor
        { $$ = $1; }
    ;

factor
    : NUMBER
        { $$ = Number(yytext); }
    | openbrack expression closebrack
        { $$ = $2; }
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
