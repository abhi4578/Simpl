#!/bin/bash
bison -y  Simpl_yacc.y
flex Simpl_lexical.l
gcc  y.tab.c -ll -ly -o Simpl