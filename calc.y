%{
  #include <stdio.h>
  #include <string.h>
  #include <unistd.h>
  //这个库文件是用来生成hash值得，主要就是用来存放我们的符号表的内容 方便进行存取。
  #include "khash.h"
  #include "calc.h"

  #define BUFFER_SIZE 1024

  struct yy_buffer_state;
  typedef struct yy_buffer_state *YY_BUFFER_STATE;

  extern int yylex(void);
  extern YY_BUFFER_STATE yy_scan_string(const char *);
  extern void yy_delete_buffer(YY_BUFFER_STATE);

  void yyerror(char *);

  extern char* yytext;

  KHASH_MAP_INIT_STR(str, NUMBER);
  khash_t(str) *variables;
%}

%union {
  struct number num;
  char *string;
};

//三种终结符
%token <num> INTEGER
%token <num> DECIMAL
%token <string> VARIABLE
//非终结符
%type <num> expr

%right '='
%left '+' '-'
%left '*' '/'
%left UMINUS

%%

program:
        program expr '\n'      { PRINT_NUMBER($2); }
        |
        ;

expr:
        expr '+' expr             { $$ = ADD($1, $3); }
        | expr '-' expr             { $$ = SUBTRACT($1, $3); }
        | expr '*' expr             { $$ = MULTIPLY($1, $3); }
        | expr '/' expr             { $$ = DIVIDE($1, $3); }
        | '-' expr %prec UMINUS     { $$ = NEGATE($2); }
        | VARIABLE '=' expr         { $$ = set_var($1, $3); }
        | '(' expr ')'              { $$ = $2; }
        | VARIABLE                  { $$ = get_var($1); }
        | INTEGER
        | DECIMAL
        ;

%%

//获取某个属性的值，防止写很多的 struct.prop 就采用了函数的方式  
//直接放到了我们的符号表中，采用hash值做存取
struct number get_var(char *name) {
  khiter_t k;
  k = kh_get(str, variables, name);
  // no var set. maybe we should throw an error?
  if (k == kh_end(variables)) return NEW_INTEGER(0);
  return kh_value(variables, k);
}
//同上
struct number set_var(char *name, struct number value) {
  khiter_t k;
  int ret;
  k = kh_put(str, variables, name, &ret);
  kh_value(variables, k) = value;
  return value;
}

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
}

int main(int argc, const char *argv[]) {
  int from_stdin = FALSE;

  variables = kh_init(str);

  if (from_stdin) {
    yyparse();
  } else {
    char str[BUFFER_SIZE];
    YY_BUFFER_STATE buffer;

    while (TRUE) {
      printf(">> ");
      if (fgets(str, BUFFER_SIZE, stdin)) {
        printf("=> ");
        buffer = yy_scan_string(str);
        yyparse();
        yy_delete_buffer(buffer);
      }
    }
  }
  return 0;
}
