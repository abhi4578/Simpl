%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "Err.h"
int flag=0;
char buffer[1000];
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
%token eof
%token eq
%%

program : stmt_list  eof  {char s[]="program -> stmt_list\n"; strcat(buffer,s); if(!flag) printf("%s",buffer); exit(0);}
        |stmt_list error    {printf("eof is missing at the end of program\n"); exit(0);}        

stmt_list : stmt_list stmt {char s[]="stmt_list -> stmt_list stmt\n"; strcat(buffer,s);}
	 | stmt      {char s[]="stmt_list-> stmt\n"; strcat(buffer,s);}


stmt : assign_stmt {char s[]="stmt -> assign_stmt \n"; strcat(buffer,s);}
     | print_stmt {char s[]="stmt ->  print_stmt\n"; strcat(buffer,s);}
     | if_stmt {char s[]="stmt -> if_stmt \n"; strcat(buffer,s);}
     | error ';' {printf("invalid statement\n");}

assign_stmt : ID '=' expr ';'  {char s[]="assign_stmt -> ID = expr \n"; strcat(buffer,s);}
            | ID '=' expr error  {printf("';' missing\n");}
            


print_stmt : PRINT expr ';'   {char s[]="print_stmt -> PRINT expr ; \n"; strcat(buffer,s);} 
	 | PRINT STRING ';'   {char s[]="print_stmt ->  PRINT STRING ; \n"; strcat(buffer,s);} 
	 | PRINT NEWLINE ';'  {char s[]="print_stmt ->  PRINT NEWLINE ;\n"; strcat(buffer,s);}
   | PRINT a error    {printf("';' missing\n");}
   |PRINT error ';'    {printf("error after print\n");}
   
a : STRING | NEWLINE | expr 

if_stmt : IF expr THEN stmt_list ENDIF                {char s[]=" if_stmt -> IF expr THEN stmt_list ENDIF \n"; strcat(buffer,s);}
        | IF expr THEN stmt_list ELSE stmt_list ENDIF {char s[]="if_stmt ->IF expr THEN stmt_list ELSE stmt_list ENDIF \n"; strcat(buffer,s);}
        | IF expr THEN stmt_list error                {printf("endif is missing \n");}
        | IF expr THEN stmt_list ELSE stmt_list error {printf("endif is missing \n");}
        | IF expr  error                                {printf("then is missing \n");}

expr : expr eq Q { char s[]="expr -> expr == Q\n"; strcat(buffer,s);}
     | expr neq Q { char s[]="expr ->expr != Q  \n"; strcat(buffer,s);}
     | Q { char s[]="expr -> Q \n"; strcat(buffer,s);}
       
Q : Q '<' exp {char s[]="Q -> Q < exp\n"; strcat(buffer,s);}
   | Q '>' exp {char s[]="Q ->  Q  > exp \n"; strcat(buffer,s);}
   | Q leq exp {char s[]="Q ->  Q <= exp\n"; strcat(buffer,s);}
   | Q geq exp {char s[]="Q ->  Q >= exp \n"; strcat(buffer,s);}
   | exp  {char s[]="Q -> exp   \n"; strcat(buffer,s);}

exp : exp '+' T {char s[]="exp-> exp + T \n"; strcat(buffer,s);}
    | exp '-' T { char s[]="exp -> exp - T\n"; strcat(buffer,s);}
    | T {char s[]="exp -> T \n"; strcat(buffer,s);}

T : T '*' W {char s[]="T -> T * W\n"; strcat(buffer,s);}
  | T '/' W {char s[]="T -> T / W\n"; strcat(buffer,s);} 
  | W	{char s[]="T -> W\n"; strcat(buffer,s);}

W : '-'W 	     {char s[]="W -> -W\n"; strcat(buffer,s);} 
  | S		     {char s[]="W -> S\n"; strcat(buffer,s);}


S : '(' expr ')' {char s[]="S -> '(' expr ')' \n"; strcat(buffer,s);}
  | INT {char s[]="S ->  INT \n"; strcat(buffer,s);}
  | ID  {char s[]="S -> ID\n"; strcat(buffer,s);}
  | '(' expr error {printf("')' missing\n");}
  |'(' error ')'{printf("error in expression\n");}
  ;
%%
void yyerror (char *s) {fprintf (stderr, "%s at line number %d ", s,count);flag=1;} 
int main()
{
return yyparse();
}


