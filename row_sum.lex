%option noyywrap

%{
#include "structs.hpp"
#include <iostream>

#include "y.tab.h"

int yyparse();

//---- Zmienne globalne
bool end = false;
bool newLine = true;
extern unsigned int codeLine;
extern unsigned int column;

//---- Funkcje
inline void assign_yyval_str(const char* text);
%}

fixed ([0]|[1-9][0-9]*)[.][0-9]+
float ([0]|[1-9][0-9]*)[.][0-9]+[E]([+]|[-])[0-9]+
int [0]|[1-9][0-9]*
hex [1-9A-Fa-f][0-9A-Fa-f]*

%%
\r\n|\n|\r { newLine = true; return ENDLINE; }
[ ]  { column++; }
[\t] { column += 5; }

{fixed} { assign_yyval_str(yytext); return FIXED; }

{float} { assign_yyval_str(yytext); return FLOAT; }

{int} {
	assign_yyval_str(yytext);
	if(newLine){ newLine = false; return LINE_NUM; }
	else { return INT; }
}

{hex} {  assign_yyval_str(yytext); return HEX; }


<<EOF>> { 
	if(!end) { end = true; return ENDLINE; }
	else { return 0; }
}

. { return UNK; }
%%

int main(void) { return yyparse(); }

int yyerror(const char* str) {
	std::cerr << codeLine << ':' << column << ": error: " << str << '\n';
	return 1;
}

void assign_yyval_str(const char* text){
	yylval.str = new std::string(text);
	column += yylval.str->length();
}
