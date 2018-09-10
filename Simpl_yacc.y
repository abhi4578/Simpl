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

stmt_list : stmt_list stmt {printf("stmt_list -> stmt_list stmt\n");}
	 | stmt      {printf("stmt_list-> stmt\n");}


stmt : assign_stmt {printf("stmt -> assign_stmt \n");}
     | print_stmt {printf("stmt ->  print_stmt\n");}
     | if_stmt {printf("stmt -> if_stmt \n");}

assign_stmt : ID '=' expr ';'  {printf("assign_stmt -> ID = expr \n");}

print_stmt : PRINT expr ';'   {printf("print_stmt -> PRINT expr ; \n");} 
	 | PRINT STRING ';'   {printf("print_stmt ->  PRINT STRING ; \n");} 
	 | PRINT NEWLINE ';'  {printf("print_stmt ->  PRINT NEWLINE ;\n");}

if_stmt : IF expr THEN stmt_list ENDIF {printf("if_stmt -> IF expr THEN stmt_list ENDIF \n");}
        | IF expr THEN stmt_list ELSE stmt_list ENDIF   {printf("if_stmt ->  IF expr THEN stmt_list ELSE stmt_list ENDIF \n");}


expr : expr eq Q { printf("expr -> expr == Q\n");}
     | expr neq Q { printf("expr ->expr != Q  \n");}
     | Q { printf("expr -> Q \n");}
       
Q : Q '<' exp {printf("Q -> Q < exp\n");}
   | Q '>' exp {printf("Q ->  Q  > exp \n");}
   | Q leq exp {printf("Q ->  Q <= exp\n");}
   | Q geq exp {printf("Q ->  Q >= exp \n");}
   | exp  {printf("Q -> exp   \n");}

exp : exp '+' T {printf("exp-> exp + T \n");}
    | exp '-' T { printf("exp -> exp - T\n");}
    | T {printf("exp -> T \n");}

T : T '*' W {printf("T -> T * W\n");}
  | T '/' W {printf("T -> T / W\n");} 
  | W	{printf("T -> W\n");}

W : '-'W 	     {printf("W -> -W\n");} 
  | S		     {printf("W -> S\n");}


S : '(' expr ')' {printf("S -> '(' expr ')' \n");}
  | INT {printf("S ->  INT \n");}
  | ID  {printf("S -> ID\n");}

  ;
%%
void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
int main()
{
return yyparse();
}

