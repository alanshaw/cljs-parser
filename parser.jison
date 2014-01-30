/* lexical grammar */
%lex
%%

[\s,]+                                            /* skip whitespace */
\;[^\n]*                                          /* skip line comment */
\:[\w=+\-*&?!$%|<>\./]*                           return 'KEYWORD'
[A-Za-z_=+\-*&?!$%|<>\./][\w=+\-*&?!$%|<>\./]*    return 'SYMBOL'
[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?            return 'NUMBER'
\"([^"]|\\\")*\"?                                 return 'STRING'
"("                                               return '('
")"                                               return ')'
"["                                               return '['
"]"                                               return ']'
"{"                                               return '{'
"}"                                               return '}'
"'"                                               return "'"
"`"                                               return '`'
"@"                                               return '@'
"^"                                               return '^'
"#"                                               return '#'
<<EOF>>                                           return 'EOF'
.                                                 return 'INVALID'

/lex

%start lists

%% /* language grammar */

lists
  : list_list EOF
    {
      return $1
    }
  ;

list_list
  : list
    {
      $$ = $1
    }
  | list_list list
    {
      $$ = yy.createNode('list_list', $1, $2)
    }
  ;

list
  : '(' ')'
    {
      $$ = yy.createNode('list')
    }
  | '(' s_exp_list ')'
    {
      $$ = yy.createNode('list', $2)
    }
  ;

param_list
  : '[' ']'
    {
      $$ = yy.createNode('param_list')
    }
  | '[' s_exp_list ']'
    {
      $$ = yy.createNode('param_list', $2)
    }
  ;

map_list
  : '{' '}'
    {
      $$ = yy.createNode('map_list')
    }
  | '{' s_exp_list '}'
    {
      $$ = yy.createNode('map_list', $2)
    }
  ;

s_exp_list
  : s_exp
    {
      $$ = $1
    }
  | s_exp s_exp_list
    {
      $$ = yy.createNode('s_exp_list', $1, $2)
    }
  ;

s_exp
  : atom
    {
      $$ = $1
    }
  | macro atom
    {
      $$ = yy.createNode('macro', $1, $2)
    }
  | list
    {
      $$ = $1
    }
  | macro list
    {
      $$ = yy.createNode('macro', $1, $2)
    }
  | param_list
    {
      $$ = $1
    }
  | macro param_list
    {
      $$ = yy.createNode('macro', $1, $2)
    }
  | map_list
    {
      $$ = $1
    }
  | macro map_list
    {
      $$ = yy.createNode('macro', $1, $2)
    }
  ;

macro
  : "'"
    {
      $$ = yy.createLeaf('quote', yytext)
    }
  | '`'
    {
      $$ = yy.createLeaf('syntax_quote', yytext)
    }
  | '@'
    {
      $$ = yy.createLeaf('deref', yytext)
    }
  | '^'
    {
      $$ = yy.createLeaf('metadata', yytext)
    }
  | '#'
    {
      $$ = yy.createLeaf('dispatch', yytext)
    }
  ;

atom
  : KEYWORD
    {
      $$ = yy.createLeaf('keyword', yytext)
    }
  | SYMBOL
    {
      $$ = yy.createLeaf('symbol', yytext)
    }
  | NUMBER
    {
      $$ = yy.createLeaf('number', Number(yytext))
    }
  | STRING
    {
      $$ = yy.createLeaf('string', yytext.replace(/^"|"$/g, ''))
    }
  ;