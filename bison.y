%{
#include <stdio.h>
#include <math.h>
double total = 0;
double memory = 0;
void yyerror(const char* msg);
extern int yylineno;
extern int yylex();
%}

%union {
    double fVal;
}

%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token INT
%type<fVal> INT

%%

program:            statement_list
       ;
statement_list:     statement
              |     statement statement_list
              ;
statement:          POINT INT INT                { point($2, $3); 
if(($2 || $3) < 0){yyerror("x & y point value too low");}
}
         |          LINE  INT INT INT INT        { line($2, $3, $4, $5);
if(($2 || $3 || $4 || $5) < 0){yyerror("x & y point value too low");}
}
         |          CIRCLE INT INT INT           { circle($2, $3, $4); 
if(($2 || $3 || $4) < 0){yyerror("x & y & R point value too low");}
}
         |          RECTANGLE INT INT INT INT    { rectangle($2, $3, $4, $5) 
if(($2 || $3 || $4 || $5) < 0){yyerror("x & y point value too low");}
}
         |          SET_COLOR INT INT INT        { set_color($2, $3, $4); 
if(($2 || $3 || $4) < 0){yyerror("x & y & R point value too low");}
}
|          	    END		         { finish(); }

;

%%

void yyerror(const char* msg) {
    fprintf(stderr, "Error on line %d.\n%s\n", yylineno, msg);
}

int main(int argc, char** argv) {
    yyparse();
}
