%{
#include "1.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%option noyywrap

%%

"shuru"             { return START; }
"samaapt"           { return END; }
"karo"                { return ASSIGN; }
"chhapo"             { return PRINT; }  // or "chhapo"
"agar"              { return IF; }
"varna"             { return ELSE; }
"ke_liye"           { return FOR; }
"tak"               { return TO; }
"dohrao"           { return REPEAT; }
"jab_tak"           { return WHILE; }



"=="                { return EQ; }
"<="                { return LE; }
"<"                 { return LT; }
">"                 { return GT; }
"+"                 { return ADD; }
"-"                 { return SUB; }
"*"                 { return MUL; }
"/"                 { return DIV; }
"="                 { return ASSIGN; }

";"                 { return SEMICOLON; }
":"                 { return ':'; }
"("                 { return '('; }
")"                 { return ')'; }
"{"                 { return '{'; }
"}"                 { return '}'; }

\"([^\"]*)\"        { yylval.str = strdup(yytext + 1); yylval.str[strlen(yylval.str) - 1] = '\0'; return STRING; }

[0-9]+              { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.id = strdup(yytext); return ID; }

[ \t\r\n]+          { /* Ignore whitespace */ }

.                   { fprintf(stderr, "Error: Unknown character '%s'\n", yytext); exit(1); }

%%
