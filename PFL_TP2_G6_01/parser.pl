:-use_module(library(between)).

/*
* Tries to read a specific char: 
* read_specific_char(+Value).
*/
read_specific_char(Value):-
    get_char(Char),
    Value == Char, !.

read_specific_char(Value):-
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
get_x_cord(Value):-
    read_alpha_char_between(65, 72, Code),
    code_to_int(Code, Value).

/*
* Reads digit from input stream and
* validates if in bounds:
* get_y_cord(-Value).
*/
get_y_cord(Value):-
    read_digit_between(1, 8, Value).

/*
* Reads input move:
* read_move(-X, -Y, -Nx, -Ny).
*/
read_move(X, Y, Nx, Ny):-
    get_x_cord(X),
    get_y_cord(Y),
    read_specific_char('-'),
    get_x_cord(Nx),
    get_y_cord(Ny),
    read_specific_char('\n').
/*
* Validates if Value is in board bounds:
* in_bounds(+Value).
*/
in_bounds(Value):-
    between(1,8, Value).