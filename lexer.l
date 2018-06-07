%{
  #include <stdlib.h>
  extern void yyerror(char *);
  #include "calc.h"
  #include "y.tab.h"
%}

%%

[a-zA-Z_][a-zA-Z_\d]* {
                        yylval.string = strdup(yytext);
                        return VARIABLE;
                     }//变量名

([1-9][0-9]+|[0-9])?\.[0-9]+ {
                              yylval.num = NEW_DECIMAL(strtod(yytext, NULL));
                              return DECIMAL;
                             }//数字

([1-9][0-9]+|[0-9]) {
                        yylval.num = NEW_INTEGER(strtol(yytext, NULL, 10));
                        return INTEGER;
                    } //整数

[-+()=/*\n^]              { return *yytext; } //普通字符直接返回

[ \t]                     { }; //空白

.                         yyerror("非法字符");

%%

int yywrap(void) {
  return 1;
}
