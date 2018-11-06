# Simpl
Generates parse tree for language called "Simpl".

# Language "Simpl"
 SimpL has following classes of tokens:
 
          Operators : (+ - * /  = > >=  < <= == != )
          Parenthesis and Semicolon :  ( ) ;
          Keywords : if, then, else, endif, print, newline
          Integers: Sequence of digits
          ID: starts with letter and any number of letter or digits
          Quoted Strings: “<string>”
          Comments : Line starting with //

Grammar is given below:

          program -> stmt_list 
          stmt_list -> stmt_list stmt  | stmt 
          stmt -> assign_stmt | print_stmt | if_stmt 
          assign_stmt -> ID = expr ;
          print_stmt -> PRINT expr ; | PRINT STRING ; | PRINT NEWLINE ; if_stmt -> IF expr THEN stmt_list ENDIF 
                     | IF expr THEN stmt_list ELSE stmt_list ENDIF 
          expr -> ( expr ) | expr + expr | expr - expr | expr * expr | expr / expr 
               | expr < expr | expr > expr | expr <= expr | expr >= expr | expr == expr
               | expr != expr | - expr | INT | ID 

 
 
# How to build and run
To build,execute the command in terminal
          
     bash Build.sh (it generates the executable file Simpl)

To test with Eg_test_case:
      
      ./Simpl < Eg_test_case 

