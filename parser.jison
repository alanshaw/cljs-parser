/* lexical grammar */
%lex
%%

[\s,]+                                            /* skip whitespace */
\;[^\n]*                                          /* skip line comment */
true|false                                        return 'BOOLEAN'
[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?            return 'NUMBER'
\"([^"]|\\\")*\"?                                 return 'STRING'
\:[\w=+\-*&?!$%|<>\./]*                           return 'KEYWORD'
[A-Za-z_=+\-*&?!$%|<>\./][\w=+\-*&?!$%|<>\./]*    return 'SYMBOL'
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
"#'"                                              return "#'"
"#_"                                              return '#_'
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

vector
  : '[' ']'
    {
      $$ = yy.createNode('vector')
    }
  | '[' s_exp_list ']'
    {
      $$ = yy.createNode('vector', $2)
    }
  ;

map
  : '{' '}'
    {
      $$ = yy.createNode('map')
    }
  | '{' s_exp_list '}'
    {
      $$ = yy.createNode('map', $2)
    }
  ;

s_exp_list
  : s_exp
    {
      $$ = yy.createNode('s_exp_list', $1)
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
  | vector
    {
      $$ = $1
    }
  | macro vector
    {
      $$ = yy.createNode('macro', $1, $2)
    }
  | map
    {
      $$ = $1
    }
  | macro map
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
  | "#'"
    {
      $$ = yy.createLeaf('dispatch', yytext)
    }
  | '#_'
    {
      $$ = yy.createLeaf('dispatch', yytext)
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
  | BOOLEAN
    {
      $$ = yy.createLeaf('boolean', (yytext == "true" ? true : false))
    }
  ;