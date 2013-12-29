/* lexical grammar */
%lex
%%

\s+                                               /* skip whitespace */
:[\w=+\-*&?!$%|<>\./]*                            return 'KEYWORD'
[A-Za-z_=+\-*&?!$%|<>\./][\w=+\-*&?!$%|<>\./]*    return 'SYMBOL'
[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?            return 'NUMBER'
"([^"]|\\")*"?                                    return 'STRING'
"("                                               return '('
")"                                               return ')'
<<EOF>>                                           return 'EOF'
.                                                 return 'INVALID'

/lex

%start lists

%% /* language grammar */

lists
  : list_list EOF
    {
      console.log($1)
      return $1
    }
  ;

list_list
  : list
  | list_list list
  ;

list
  : '(' ')'
  | '(' s_exp_list ')'
  | '(' s_exp_list s_exp ')'
  ;

s_exp_list
  : s_exp
  | s_exp_list s_exp
  ;

s_exp
  : atom
  | list
  ;

atom
  : KEYWORD
    {
      $$ = yytext
    }
  | SYMBOL
    {
      $$ = yytext
    }
  | NUMBER
    {
      $$ = Number(yytext)
    }
  | STRING
    {
      $$ = yytext
    }
  ;