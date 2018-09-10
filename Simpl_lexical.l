letter [a-zA-Z] 
digit  [0-9]
%{
#include<stdio.h>
#include<stdlib.h>
#include "y.tab.h"
int yylex(void);
void yyerror(char *s);
%}
%%

[+-/*><=]        {//printf("Operator %c\n",yytext[0]);
		return yytext[0];}
"=="        {//printf("Operator %s\n",yytext);
		  return eq;}
"!="        {//printf("Operator %s\n",yytext);
		  return neq;}
"<="	    {//printf("Operator %s\n",yytext);
		  return leq;}

">=" 	    {//printf("Operator %s\n",yytext);
		  return geq;}

[();]		 {//printf("Miscellaneous %c\n",yytext[0]);
		  return yytext[0];}

"if"		{//printf("Keyword %s\n",yytext)
		return IF;}

"then"		{//printf("Keyword %s\n",yytext)
		return THEN;}

"else"		{//printf("Keyword %s\n",yytext)
		return ELSE;}

"print"		{//printf("Keyword %s\n",yytext)
		return PRINT;}

"endif"		{//printf("Keyword %s\n",yytext)
		return ENDIF;}

"newline" 	{//printf("Keyword %s\n",yytext)
		return NEWLINE;}

[1-9][0-9]*	{//int a=atoi(yytext); printf("Number =%d\n",a);
		 return INT;}//float

{letter}({letter}|{digit})* {//printf("identifier=%s\n",yytext);
			      return ID;}

["][^"]*["]	{//printf("string = %s\n",yytext);
		return STRING;}// ",'-not between string

[/][/][^\n]*		{//printf("Ignore comment\n");
			;} // ignore that line


[#]		{return yytext[0];}
[ \t\n]		{;}

.               {yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}
/*int main()
{
 yylex();
return 0;
}
*/ 
