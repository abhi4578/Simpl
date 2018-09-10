%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int yylex(void);
void yyerror(char *s);
%}
%start program
%token IF
%token THEN
%token ENDIF
%token ELSE
%token PRINT
%token STRING
%token NEWLINE
%token INT
%token ID
%token leq
%token geq
%token neq
%token eq


%%

program : stmt_list  '#'               {printf("program -> stmt_list\n"); exit(0);}

stmt_list : stmt_list stmt | stmt      {printf("stmt_list : stmt_list stmt | stmt\n");}


stmt : assign_stmt | print_stmt | if_stmt {printf("stmt -> assign_stmt | print_stmt | if_stmt \n");}

assign_stmt : ID '=' expr ';'  {printf("assign_stmt -> ID = expr \n");}

print_stmt : PRINT expr ';' | PRINT STRING ';' | PRINT NEWLINE ';'  {printf("print_stmt -> PRINT expr ; | PRINT STRING ; | PRINT NEWLINE ;\n");}

if_stmt : IF expr THEN stmt_list ENDIF 
        | IF expr THEN stmt_list ELSE stmt_list ENDIF   {printf("if_stmt -> IF expr THEN stmt_list ENDIF | IF expr THEN stmt_list ELSE stmt_list ENDIF \n");}


expr : expr eq Q | expr neq Q | Q { printf("expr : expr eq Q | expr neq Q | Q \n");}
       
Q : Q '<' exp | Q '>' exp | Q leq exp | Q geq exp | exp  {printf("Q : Q '<' exp | Q '>' exp | Q leq exp | Q geq exp | exp   \n");}

exp : exp '+' T | exp '-' T | T {printf("exp : exp '+' T | exp '-' T | T \n");}

T : T '*' W | T '/' W | W	{printf("T : T '*' W | T '/' W | W\n");}

W : '-'W | S		     {printf("W : '-'W | S\n");}


S : '(' expr ')' | INT | ID  {printf("S : '(' expr ')' | INT | ID\n");}

  ;
%%
void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
int main()
{
return yyparse();
}


