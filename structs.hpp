#ifndef STRUCTS_HPP
#define STRUCTS_HPP

#include <string>
#include <vector>

//------ BJ HARD -------

//---- Definicje struktur
struct Number {
	std::string val;
	std::string type = "NONE";

	Number(const std::string val_, const char* type_) : val(val_), type(type_) {}
};

struct Line {
	unsigned int lineNum = -1;
	std::vector<Number> numbers;
	std::string type = "NONE";
};

//------ INTERPRETER ------

enum OPERATIONS { ASSIGNMENT_, PRINT_, IF_, WHILE_ };

//---- Definicje struktur
struct Element {
	double val = 0;
	std::string var;
	std::string operation;

	Element() {}
	Element(const double& val_) : val(val_) {}
};

struct Instruction {
	enum OPERATIONS type;
	std::string var;
	std::string comparator;
	std::vector<std::vector<Element>> elements;
	unsigned int instructions_inside = 1;
};

#endif
