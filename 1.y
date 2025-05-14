%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

int tempCount = 0;
char* newTemp() {
    char* t = (char*)malloc(10);
    sprintf(t, "t%d", tempCount++);
    return t;
}

FILE *output_file;
extern FILE *yyin;
%}

%union {
    int num;
    char* str;
    char* id;
    char* expr;
}

%token <num> NUMBER
%token <id> ID
%token <str> STRING
%token START END ASSIGN PRINT IF ELSE FOR REPEAT WHILE TO
%token ADD SUB MUL DIV LT GT EQ LE SEMICOLON

%type <expr> expr

%left ADD SUB
%left MUL DIV
%nonassoc LT GT EQ LE

%%

program: START stmt_list END 
         { printf("Program executed successfully.\n"); }
;

stmt_list: stmt stmt_list 
         | /* empty */
;

stmt: PRINT ID SEMICOLON
        { printf("print %s\n", $2); fprintf(output_file, "print %s\n", $2); free($2); }
     | PRINT STRING SEMICOLON
        { printf("print \"%s\"\n", $2); fprintf(output_file, "print \"%s\"\n", $2); free($2); }
     | ID ASSIGN expr SEMICOLON
        { printf("%s = %s\n", $1, $3); fprintf(output_file, "%s = %s\n", $1, $3); free($1); free($3); }
     | IF expr ':' stmt ELSE ':' stmt
        { 
            char* ltrue = newTemp();
            char* lfalse = newTemp();
            char* lend = newTemp();

            printf("if %s goto %s\n", $2, ltrue); fprintf(output_file, "if %s goto %s\n", $2, ltrue);
            printf("goto %s\n", lfalse); fprintf(output_file, "goto %s\n", lfalse);

            printf("%s:\n", ltrue); fprintf(output_file, "%s:\n", ltrue);
            // true stmt executes here
            printf("goto %s\n", lend); fprintf(output_file, "goto %s\n", lend);

            printf("%s:\n", lfalse); fprintf(output_file, "%s:\n", lfalse);
            // false stmt executes here

            printf("%s:\n", lend); fprintf(output_file, "%s:\n", lend);

            free($2); free(ltrue); free(lfalse); free(lend);
        }
     | WHILE '(' expr ')' '{' stmt_list '}'
        {
            char* loop = newTemp();
            char* end = newTemp();

            printf("%s:\n", loop); fprintf(output_file, "%s:\n", loop);
            printf("if !%s goto %s\n", $3, end); fprintf(output_file, "if !%s goto %s\n", $3, end);

            // body executes here
            printf("goto %s\n", loop); fprintf(output_file, "goto %s\n", loop);

            printf("%s:\n", end); fprintf(output_file, "%s:\n", end);

            free(loop); free(end); free($3);
        }
     | FOR ID ASSIGN expr TO expr ':' stmt_list REPEAT SEMICOLON
        {
            char* loop = newTemp();
            char* end = newTemp();

            printf("%s = %s\n", $2, $4); fprintf(output_file, "%s = %s\n", $2, $4);
            printf("%s:\n", loop); fprintf(output_file, "%s:\n", loop);

            printf("if %s > %s goto %s\n", $2, $6, end); fprintf(output_file, "if %s > %s goto %s\n", $2, $6, end);
            // body executes here
            printf("%s = %s + 1\n", $2, $2); fprintf(output_file, "%s = %s + 1\n", $2, $2);

            printf("goto %s\n", loop); fprintf(output_file, "goto %s\n", loop);
            printf("%s:\n", end); fprintf(output_file, "%s:\n", end);

            free($2); free($4); free($6); free(loop); free(end);
        }
     ;

expr: expr ADD expr       { $$ = (char*)malloc(20); sprintf($$, "%s + %s", $1, $3); free($1); free($3); }
    | expr SUB expr       { $$ = (char*)malloc(20); sprintf($$, "%s - %s", $1, $3); free($1); free($3); }
    | expr MUL expr       { $$ = (char*)malloc(20); sprintf($$, "%s * %s", $1, $3); free($1); free($3); }
    | expr DIV expr       { $$ = (char*)malloc(20); sprintf($$, "%s / %s", $1, $3); free($1); free($3); }
    | expr LT expr        { $$ = (char*)malloc(20); sprintf($$, "%s < %s", $1, $3); free($1); free($3); }
    | expr GT expr        { $$ = (char*)malloc(20); sprintf($$, "%s > %s", $1, $3); free($1); free($3); }
    | expr EQ expr        { $$ = (char*)malloc(20); sprintf($$, "%s == %s", $1, $3); free($1); free($3); }
    | expr LE expr        { $$ = (char*)malloc(20); sprintf($$, "%s <= %s", $1, $3); free($1); free($3); }
    | '(' expr ')'        { $$ = $2; }
    | NUMBER              { $$ = (char*)malloc(10); sprintf($$, "%d", $1); }
    | ID                  { $$ = strdup($1); }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    FILE *input_file = fopen("input.txt", "r");
    if (!input_file) {
        perror("Failed to open input.txt");
        exit(1);
    }
    output_file = fopen("output.tac", "w");
    if (!output_file) {
        perror("Failed to open output.tac");
        exit(1);
    }

    yyin = input_file;
    yyparse();
    fclose(input_file);
    fclose(output_file);
    return 0;
}
