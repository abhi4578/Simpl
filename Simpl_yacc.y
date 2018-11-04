%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "Err.h"
#include<ctype.h>
char st[100][10];
int top=0;
int label[20];
int ltop=-1;
char i_[5];
int temp_num=0;
char temp[2]="t";
int flag=0;
char code[1000];
char buffer[2000];
int yylex(void);
void yyerror(char *s);
void binary_codegen();
void uminus_codegen();
void push();
void assign_codegen();
void print();
void eval();
void after_if(int n);
void after_else();
void addto_symboltable();
void lookup(char s[20]);
int pointer=0;
char data[1000];
char symbol_table[20][20];
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

program : stmt_list  eof {//char s[]="program -> stmt_list\n"; strcat(buffer,s); if(!flag) printf("%s",buffer); 
							if(!flag){printf("----------------------\n"); printf("Intermediate code\n"); printf("----------------------\n"); printf("Data:\n"); 
							printf("%s\n",data); printf("Code:\n"); printf("%s",code);}
							exit(0);}
       

stmt_list : stmt_list stmt {char s[]="stmt_list -> stmt_list stmt\n"; strcat(buffer,s);}
	 | stmt      {char s[]="stmt_list-> stmt\n"; strcat(buffer,s);}


stmt : assign_stmt {char s[]="stmt -> assign_stmt \n"; strcat(buffer,s);}
     | print_stmt {char s[]="stmt ->  print_stmt\n"; strcat(buffer,s);}
     | if_stmt {char s[]="stmt -> if_stmt \n"; strcat(buffer,s);}
     |error ';' {printf("invalid statement\n");}

assign_stmt : assign_b ';'  {addto_symboltable(st[top-2]); assign_codegen();char s[]="assign_stmt -> ID = expr \n"; strcat(buffer,s);}
            | assign_b error  {printf("';' missing\n");}
            
assign_b :ID{push();}'='{push();} expr

print_stmt : PRINT expr ';'   {print(); char s[]="print_stmt -> PRINT expr ; \n"; strcat(buffer,s);} 
	 | PRINT STRING {push(); }';'   {print(); char s[]="print_stmt ->  PRINT STRING ; \n"; strcat(buffer,s);} 
	 | PRINT NEWLINE {push(); }';'  {print(); char s[]="print_stmt ->  PRINT NEWLINE ;\n"; strcat(buffer,s);}
  	 | PRINT a {push();}error    {printf("';' missing\n");}
  //	 |PRINT error ';'    {printf("error after print\n");}
   
//a : STRING | NEWLINE | expr 

if_stmt : bif {after_if(0);}  ENDIF {char s[]=" if_stmt -> IF expr THEN stmt_list ENDIF \n"; strcat(buffer,s);}
        | bif_else ELSE  stmt_list  ENDIF {after_else();char s[]="if_stmt ->IF expr THEN stmt_list ELSE stmt_list ENDIF \n"; strcat(buffer,s);}
        //| bif  error                {printf("endif is missing \n");}
      	| bif_else ELSE stmt_list error {printf("endif is missing \n");}
		|IF expr {eval();} error b

bif		:  IF expr {eval();}  THEN stmt_list 
bif_else : bif {after_if(1);}
        
b	: ELSE stmt_list ENDIF {printf("'then' is missing\n");}
	| error                {printf("'then' and endif is missing \n");}
	| ELSE stmt_list error   {printf("'then' and endif is missing \n");}
	| ENDIF		       {printf("'then' is missing\n");}
	


expr : expr eq {push();} Q { binary_codegen(); char s[]="expr -> expr == Q\n"; strcat(buffer,s);}
     | expr neq {push();} Q { binary_codegen();char s[]="expr ->expr != Q  \n"; strcat(buffer,s);}
     | Q { char s[]="expr -> Q \n"; strcat(buffer,s);}
       
Q : Q '<'{push();} exp { binary_codegen();char s[]="Q -> Q < exp\n"; strcat(buffer,s);}
   | Q '>' {push();}exp {binary_codegen();char s[]="Q ->  Q  > exp \n"; strcat(buffer,s);}
   | Q leq {push();} exp {binary_codegen();char s[]="Q ->  Q <= exp\n"; strcat(buffer,s);}
   | Q geq {push();} exp {binary_codegen();char s[]="Q ->  Q >= exp \n"; strcat(buffer,s);}
   | exp  {char s[]="Q -> exp   \n"; strcat(buffer,s);}

exp : exp '+'{push();} T {binary_codegen(); char s[]="exp-> exp + T \n"; strcat(buffer,s);}
    | exp '-'{push();} T { binary_codegen();char s[]="exp -> exp - T\n"; strcat(buffer,s);}
    | T {char s[]="exp -> T \n"; strcat(buffer,s);}

T : T '*'{push();} W {binary_codegen(); char s[]="T -> T * W\n"; strcat(buffer,s);}
  | T '/'{push();} W {binary_codegen();  char s[]="T -> T / W\n"; strcat(buffer,s);} 
  | W	{char s[]="T -> W\n"; strcat(buffer,s);}

W : '-'{push();} W   {uminus_codegen();char s[]="W -> -W\n"; strcat(buffer,s);} 
  | S		     {char s[]="W -> S\n"; strcat(buffer,s);}


S : '(' expr ')' {char s[]="S -> '(' expr ')' \n"; strcat(buffer,s);}
  | INT {push();char s[]="S ->  INT \n"; strcat(buffer,s);}
  | ID  {push(); lookup(st[top]);char s[]="S -> ID\n"; strcat(buffer,s);}
  | '(' expr error {printf("')' missing\n");}
 |'(' error ')'{printf("error in expression\n");}
  ;
%%
void yyerror (char *s) {fprintf (stderr, "%s at line number %d ", s,count);flag=1;} 
#include "lex.yy.c"
int lnum=0;

int main()
{
printf("Enter the program : \n");
return yyparse();
}
void push()
{//printf("%s",yytext);	
strcpy(st[++top],yytext);
}

void binary_codegen()
{ char str_temp[20];
strcpy(temp,"t");
sprintf(i_,"%d",temp_num);
strcat(temp,i_);
sprintf(str_temp,"%s = %s %s %s\n",temp,st[top-2],st[top-1],st[top]);
top-=2;
strcpy(st[top],temp);
temp_num++;
strcat(code,str_temp);
}

void uminus_codegen()
 { char str_temp[20];
strcpy(temp,"t");
sprintf(i_,"%d",temp_num);
strcat(temp,i_);
sprintf(str_temp,"%s = -%s\n",temp,st[top]);
strcat(code,str_temp);
top--;
strcpy(st[top],temp);
temp_num++;
}

void assign_codegen()
{ char str_temp[20];
sprintf(str_temp,"%s = %s\n",st[top-2],st[top]);
top-=2;
strcat(code,str_temp);
}

void addto_symboltable(char s[20])

{
	for(int i=0;i<=pointer;i++)
	{ if (strcmp(symbol_table[i],s)==0)
		return;

	}

	strcpy(symbol_table[++pointer],s);
	strcat(data,"\t");
	strcat(data,s);

}

void eval()
{    char str_temp[20]; 
 	sprintf(str_temp,"if not %s \n",st[top]);
 	strcat(code,str_temp);
	top--;
   sprintf(str_temp,"goto L : %d \n",++lnum);
   label[++ltop]=lnum;
   strcat(code,str_temp);

}

void after_if(int n)
{ 	int x=label[ltop--];
	char str_temp[20];
	if(n==1) 
	{ 
	sprintf(str_temp,"goto L:%d \n",++lnum);
	strcat(code,str_temp);
	sprintf(str_temp,"L:%d\n",x);
	label[++ltop]=lnum;
	}
	else if(n==0)
	{
	sprintf(str_temp,"L: %d \n",x);
	}
	strcat(code,str_temp);
}

void after_else()
{ char str_temp[20];
  int x=label[ltop--];
  sprintf(str_temp,"L: %d \n",x);
  strcat(code,str_temp);
}

void print()
{    char str_temp[20];
	sprintf(str_temp,"print %s\n",st[top]);
	strcat(code,str_temp);
	top--;
}
void  lookup(char s[20])
{
 	for(int i=0;i<=pointer;i++)
	{ if (strcmp(symbol_table[i],s)==0)
		return ;

	}
	printf("%s variable undefined\n",s);
	exit(0);
	
}