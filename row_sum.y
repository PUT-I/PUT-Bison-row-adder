
%{
    #include "structs.hpp"
    #include <algorithm>
	#include <iostream>
    #include <iomanip>
    #include <sstream>
    #include <map>

    //---- Deklaracje funkcji do wykorzystania w pliku lex
	int yylex();
    int yywrap();
	int yyerror(const char*);

    //---- Stałe globalne
    const std::map<std::string, int8_t> typeGroups {
        {"NONE" , 0}, {"INTEGER", 1}, {"HEX", 1},
        {"FIXED", 2}, {"FLOAT"  , 3}
    }; //Używane przy sprawdzaniu spójności typów

    //---- Zmienne globalne
    unsigned int column = 1;
    unsigned int codeLine = 1;

    //---- Funkcje
    inline void sum_line(Line& line);
    inline int check_types(const std::vector<Number>& nums);
%}
%union {
    Line* line;
    std::vector<Number>* nums;
    std::string* str;
};

//---- Symbole nieterminalne
%start START
%type<line> LINE
%type<str> FIXED
%type<str> FLOAT
%type<nums> NUMBERS

//---- Symbole terminalne
%token ENDLINE
%token<str> LINE_NUM
%token<str> INT
%token<str> HEX
%token<str> FRACT
%token<str> EXP

%token UNK

%%

START : START LINE {
            std::cout << $2->lineNum << ' ';
            sum_line(*$2);
            std::cout << '\n';
            
            delete $2;
            codeLine++;
            column = 1;
        }
      | /*nic*/ {}
      ;

LINE : LINE_NUM NUMBERS ENDLINE {
            $$ = new Line();
            $$->lineNum = stoi(*$1);
            $$->numbers = *$2;
            delete $2;
            $2 = new std::vector<Number>;
        }
     ;

NUMBERS : NUMBERS INT {
            $$ = $1;
            $$->push_back(Number(*$2, "INTEGER"));
            delete $2;
            if(int result = check_types(*$$) != -1) { return result; }
        }
      | NUMBERS HEX {
            $$ = $1;
            $$->push_back(Number(*$2, "HEX"));
            delete $2;
            if(int result = check_types(*$$) != -1) { return result; }
        }
      | NUMBERS FIXED {
            $$ = $1;
            $$->push_back(Number(*$2, "FIXED"));
            delete $2;
            if(int result = check_types(*$$) != -1) { return result; }
        }
      | NUMBERS FLOAT {
            $$ = $1;
            $$->push_back(Number(*$2, "FLOAT"));
            delete $2;
            if(int result = check_types(*$$) != -1) { return result; }
        }
      | /*nic*/ { $$ = new std::vector<Number>; }
      ;

FIXED : INT '.' FRACT { *$$ = *$1 + "." + *$3; }
      | INT '.' INT   { *$$ = *$1 + "." + *$3; }
      ;

FLOAT : FIXED EXP { *$$ = *$1 + *$2; }
      ;
%%

int check_types(const std::vector<Number>& nums) {
    if(!nums.empty()) {
        int firstType = typeGroups.at((nums.end()-1)->type);
        for (int i = nums.size()-2; i >= 0; i--) {
            if(typeGroups.at(nums[i].type) != firstType){
                return yyerror("invalid row data");
            }
        }
    }
    return -1;
}

void deduct_type(Line& line){
    if(!line.numbers.empty()) {
        for (const Number& num : line.numbers) {
            if(!num.type.empty() && num.type != "INTEGER") {
                line.type = num.type;
                return;
            }
        }
        line.type = "INTEGER";
    }
}

void sum_line(Line& line) {
    deduct_type(line);

    if (line.type == "INTEGER") {
        unsigned int result = 0;
        for(const Number& number : line.numbers) {
            result += stoi(number.val);
        }
        
        std::cout << result;
    } //end INTEGER

    else if (line.type == "HEX") {
        unsigned int result = 0;

        for(const Number& number : line.numbers) {
            unsigned int temp;
            std::istringstream converter(number.val);
            converter >> std::hex >> temp;
            result += temp;
        }

        std::ios cout_state(nullptr);
        cout_state.copyfmt(std::cout);
        std::cout << std::hex << result;
        std::cout.copyfmt(cout_state);
    } //end HEX

    else if (line.type == "FIXED") {
        float result = 0;
        for(const Number& number : line.numbers) { result += stof(number.val); }

        std::cout << result;
    } //end FIXED
    
    else if (line.type == "FLOAT") {
        double result = 0;
        for(const Number& number : line.numbers) { result += stod(number.val); }

        std::ios cout_state(nullptr);
        cout_state.copyfmt(std::cout);
        std::cout << std::scientific << std::setprecision(15) << result;
        std::cout.copyfmt(cout_state);
    } //end FLOAT
}
