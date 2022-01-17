:-use_module(library(between)).

/*
* Tries to read a specific char: 
* read_specific_char(+Value).
*/
read_specific_char(Value):-
    get_char(Char),
    Value == Char, !.

read_specific_char(_):-
    skip_line,
    write('Invalid input!\n'), fail.

/*
* Read digit between 2 values: 
* read_digit_between(+Min, +Max, -Value).
*/
read_digit_between(Min, Max, Value):-
    read_digit(X),
    between(Min, Max, X),!,
    Value is X.

read_digit_between(_, _, _):-
    skip_line, 
    write('Invalid input!\n'), fail.    
/*
* Read digit from input stream: 
* read_digit(-Value).
*/
read_digit(_):-
    peek_code(Value),
    \+between(48, 57, Value), !, fail.

read_digit(Value):-
    get_code(Ascii),
    char_code('0', AsciiZero),
    Value is Ascii - AsciiZero.

/*
* Read alphabetic char between 2 values: 
* read_alpha_char_between(+Min, +Max, -Value).
*/
read_alpha_char_between(Min, Max, Value):-
    read_alpha_char(X),
    between(Min, Max, X),!,
    Value is X.

read_alpha_char_between(_, _, _):-
    skip_line, 
    write('Invalid input!\n'), fail. 

/*
* Read alphabetic char from input stream (returns uppercase code value): 
* read_alpha_char(-Value).
*/
read_alpha_char(Value):- % Uppercase Character
    peek_code(Code),
    between(65, 90, Code), !,
    get_code(Value).

read_alpha_char(Value):- % Lowercase Character
    peek_code(CodePeek),
    between(97, 122, CodePeek), !,
    get_code(Code),
    Value is Code - 32.

/*
* Convert code to int starting from 'A': 
* code_to_int(+Code, -Int).
*/
code_to_int(Code, Int):-
    Int is Code-64.

/*
* Reads alphabetic char from input stream and
* converts to int and validates if in bounds:
* get_x_cord(-Value).
*/
get_x_cord(Value, Size):-
    LowerBound is 65,
    UpperBound is LowerBound + Size - 1,
    read_alpha_char_between(LowerBound, UpperBound, Code),
    code_to_int(Code, Value).

/*
* Reads digit from input stream and
* validates if in bounds:
* get_y_cord(-Value).
*/
get_y_cord(Value, Size):-
    LowerBound is 1,
    UpperBound is LowerBound + Size - 1,
    read_digit_between(LowerBound, UpperBound, Value).

/*
* Reads input move:
* read_move(-X, -Y, -Nx, -Ny).
*/
read_move(X, Y, Nx, Ny, Size):-
    get_x_cord(X, Size),
    get_y_cord(YRead, Size),
    Y is Size + 1 - YRead,
    read_specific_char('-'),
    get_x_cord(Nx, Size),
    get_y_cord(NyRead, Size),
    Ny is Size + 1 - NyRead,
    read_specific_char('\n').