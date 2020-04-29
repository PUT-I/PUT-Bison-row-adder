# Bison row adder
Simple program which checks rows data type coherency, sums them and displays result in correct format.

## Capabilities and limitations
  - deducing row's type (integer, hexadecimal, decimal fraction, scientific),
  - row summing and displaying results in correct format (based on type),
  - can't recognize rows of hexadecimals with no letters correctly (recognized as integer rows),
  - limited precision (15 decimal places),
  - error detection (invalid row data),
  - line and column tracking (used in error detection).

## Example Data
```
1 34 891 2
2 23 7A1 C45 91
3 34.9 1.001 0.2567
4 23.4E+20 0.1E-3 1.4E+15
5 1 2 3 4 5
```

## Requirements
To compile this program you need:
  - C++ compiler
  - Flex binaries
  - Bison binaries (may require additional binaries)
  
### Software used for this project
  - [MinGW - Minimalist GNU for Windows](https://sourceforge.net/projects/mingw-w64/)
  - [Flex for Windows](http://gnuwin32.sourceforge.net/packages/flex.htm)
  - [Bison for Windows](http://gnuwin32.sourceforge.net/packages/bison.htm)
  - [Visual Studio Code](https://code.visualstudio.com/) with [Lex Flex Yacc Bison plugin](https://marketplace.visualstudio.com/items?itemName=faustinoaq.lex-flex-yacc-bison)
  
### Console commands (used by me on Windows)
  1. bison.exe -dy interpreter.y
  2. flex.exe interpreter.lex
  3. g++.exe y.tab.c lex.yy.c -o "your_exe_name.exe"
