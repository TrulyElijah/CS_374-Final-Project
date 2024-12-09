%option noyywrap       
 
%{
#include <stdio.h>
 
#define YY_DECL int yylex()
 
#include "bool.tab.h"
 
%}
 
%%
 
[ \t]                        ; // ignore all whitespace
"TRUE"                                     {yylval.bval = 1; return T_BOOL;}
"FALSE"                                    {yylval.bval = 0; return T_BOOL;}
"AND"                              {return T_AND;}
"OR"                               {return T_OR;}
"NOT"                              {return T_NOT;}
"XOR"                              {return T_XOR;}
[a-zA-Z]+                                  {yylval.text = malloc(strlen(yytext)+1); strncpy(yylval.text, yytext, strlen(yytext)+1); return T_ID;}
"="                                {return T_ASSIGN;}
"("                                {return T_LEFT;}
")"                                {return T_RIGHT;}
"=="                               {return T_EQ;}
"!="                               {return T_NEQ;}





\n                      {return T_NEWLINE;}
 
%%
 
// https://github.com/meyerd/flex-bison-example
// noyywrap assumes that there are no additional files to be parsed
