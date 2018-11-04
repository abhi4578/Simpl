letter [a-zA-Z] 
digit  [0-9]
%{
#include<stdio.h>
#include<stdlib.h>

#include "Err.h"
int count=1;
char s[]="unexpected character " ;
int yylex(void);
void yyerror(char *s);
%}
%%

[+-/*><=]        {return yytext[0];}
"=="        {return eq;}
"!="        {return neq;}
"<="	    {
		  return leq;}

">=" 	    {
		  return geq;}

[();]		 {
		  return yytext[0];}

"if"		{
		return IF;}

"then"		{
		return THEN;}

"else"		{
		return ELSE;}

"print"		{
		return PRINT;}

"endif"		{
		return ENDIF;}

"newline" 	{
		return NEWLINE;}


[0-9][0-9]*	{
		 return INT;}


{letter}({letter}|{digit})* {
			      return ID;}

["][^"]*["]	{
		return STRING;}

[/][/][^\n]*		{;} 


<<EOF>>	 {return eof;}
[\n]	{count++;}
[ \t]		{;}

.               {yyerror (strcat(s,yytext));}

%%
int yywrap (void) {return 1;}
/*int main()
{
 yylex();
return 0;
}
*/ 
