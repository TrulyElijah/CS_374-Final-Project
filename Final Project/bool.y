%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);

struct symbol {
    char* name;
    int type;
    union {
        int bval;    // store boolean
    } value;
    struct symbol* next;
};


const int TYPE_BOOL = 0;
struct symbol* symboltable = NULL;

struct symbol* putsymbol(char* name, int type) {
    struct symbol* sym = (struct symbol *) malloc(sizeof(struct symbol));
    sym->type = type;
    sym->name = malloc(strlen(name) + 1);
    strncpy(sym->name, name, strlen(name) + 1);

   
    if (type == TYPE_BOOL) {
        sym->value.bval = 0; // initialize boolean to false
    }

    sym->next = symboltable;
    symboltable = sym;
    return sym;
}

struct symbol* getsymbol(char* name) {
    struct symbol* p = symboltable;
    while (p != NULL) {
        if (strcmp(p->name, name) == 0) {
            return p;
        }
        p = p->next;
    }
    return NULL;
}

%}

%union {
    int bval;
    char* text;
}


%token<bval> T_BOOL
%token<text> T_ID

%token T_EQ T_NEQ T_AND T_OR T_XOR T_NOT T_LEFT T_RIGHT T_NEWLINE T_ASSIGN

%type<bval> bool_expr
%start calc

%left T_OR T_AND
%left T_XOR
%right T_NOT
%left T_EQ T_NEQ

%%





calc:
    | calc line
;

line:
    T_NEWLINE
    | bool_expr T_NEWLINE { 
        if($1 == 1){
        printf("OUTPUT: TRUE\n");
        }
        else{
            printf("OUTPUT: FALSE\n");
        }
    }
    | T_ID T_ASSIGN bool_expr line {
        struct symbol* sym = getsymbol($1);
        if (sym == NULL) {
            sym = putsymbol($1, TYPE_BOOL);
        }
        sym->value.bval = $3;
    }
;

bool_expr:
    T_BOOL { $$ = $1; }
    | bool_expr T_AND bool_expr { $$ = $1 && $3; }
    | bool_expr T_OR bool_expr { $$ = $1 || $3; }
    | bool_expr T_XOR bool_expr { $$ = $1 ^ $3; }
    | bool_expr T_EQ bool_expr { $$ = $1 == $3; }
    | bool_expr T_NEQ bool_expr { $$ = $1 != $3; }
    | T_NOT bool_expr { $$ = !$2; }
    | T_LEFT bool_expr T_RIGHT { $$ = $2; }
    | T_ID {
        struct symbol* sym = getsymbol($1);
        if(sym == NULL){
            yyerror("Undefined Variable");
        }
        $$ = sym->value.bval;
    }
;

%%
 
int main() {
    yyin = stdin;
     
    do {
        yyparse();
    } while(!feof(yyin));
}
 
void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}
 
// https://github.com/meyerd/flex-bison-example
// the token types are as defined in the %union above
