/* lexical grammar */
%lex
%%

\s+                                               /* skip whitespace */
\:[\w=+\-*&?!$%|<>\./]*                           return 'KEYWORD'
[A-Za-z_=+\-*&?!$%|<>\./][\w=+\-*&?!$%|<>\./]*    return 'SYMBOL'
[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?            return 'NUMBER'
\"([^"]|\\\")*\"?                                 return 'STRING'
"("                                               return '('
")"                                               return ')'
"["                                               return '['
"]"                                               return ']'
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

s_exp_list
  : s_exp
    {
      $$ = $1
    }
  | s_exp_list s_exp
    {
      $$ = yy.createNode('s_exp_list', $1, $2)
    }
  ;

s_exp
  : atom
    {
      $$ = $1
    }
  | list
    {
      $$ = $1
    }
  | param_list
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
      $$ = yy.createLeaf('string', yytext)
    }
  ;