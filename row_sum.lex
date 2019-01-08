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

%%
[0]|([1-9][0-9]*) {
	assign_yyval_str(yytext);
	if(newLine){ newLine = false; return LINE_NUM; }
	else { return INT; }
}
[0-9]+ { assign_yyval_str(yytext); return FRACT; }
[1-9A-F][0-9AF]* { assign_yyval_str(yytext); return HEX; }

[E]([-]|[+])[0-9]+ { assign_yyval_str(yytext); return EXP; }

\r\n|\n|\r { newLine = true; return ENDLINE; }
<<EOF>> { 
	if(!end) { end = true; return ENDLINE; }
	else {
		return 0;
	}
}

[.] { column++; return yytext[0]; }

[ \t] { column++; }

. { return UNK; }
%%

int main(void) { return yyparse(); }

int yyerror(const char* str) {
	std::cerr << codeLine << ':' << column << ": error: " << str << '\n';
	return 1;
}

int yywrap() { return 1; }

void assign_yyval_str(const char* text){
	yylval.str = new std::string(text);
	column += yylval.str->length();
}
