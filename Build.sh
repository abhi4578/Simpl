#!/bin/bash
bison -yd  Simpl_yacc.y
flex Simpl_lexical.l
gcc lex.yy.c y.tab.c -o Simpl 