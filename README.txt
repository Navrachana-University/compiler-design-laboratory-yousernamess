README.txt
==========

Project Title: Custom C-like Compiler with Three Address Code (TAC) Generation 

Description:
------------
This project implements a simplified compiler using Flex (Lex) and Bison (Yacc) tools. 
The compiler supports custom keywords and syntax for basic constructs like variable declarations, 
arithmetic expressions, conditional statements, loops (if, while, for), print statements, and return statements.

As input, it accepts code written using modified keywords such as:
- 'shuru' to start the compiler
- 'agar' instead of 'if'
- 'ke_liye' instead of 'for'
- 'samaapt' to indicate the end of compiler code
- 'chhapo' instead of 'printf'
and more.

The output generated is in the form of intermediate Three Address Code (TAC), which is useful for understanding the backend of a compiler.

Authors:
--------
Rahul Arora      | Enrollment ID: 22000822 


Instructions to Compile and Run:
--------------------------------
1. Make sure Flex, Bison, and GCC are installed on your system.
2. Open a terminal in the project directory and run the following commands:

   flex 1.l  
   bison -d 1.y  
   gcc lex.yy.c 1.tab.c -o a.exe  

3. A sample input file (`input.txt`) is provided in the repository.
   You can test the compiler using any of them:

   Example:
   ./a.exe < input.java

4. The Three Address Code (TAC) will be printed on the terminal.
