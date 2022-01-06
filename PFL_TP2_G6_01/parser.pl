:-use_module(library(between)).

/*
* Tries to read a specific char: 
* read_specific_char(+Value).
*/
read_specific_char(Value):-
    get_char(Char),
    Value == Char.

read_specific_char(Value):-
    skip_line, write('Invalid input!\n'), fail.
/*
* Read number between 2 values: 
* read_number_between(+Min, +Max, -Value).
*/
read_number_between(Min, Max, Value):-
    read_number(Value),
    \+between(Min, Max, Value),
    write('Invalid number!\n'), fail.

read_number_between(Min, Max, Value):-
    repeat,
    read_number(Value),
    between(Min, Max, Value).

/*
* Read number from input stream: 
* read_number(-Value).
*/
read_number(Value):-read_number(Value, 0).

read_number(Value, Value):-
    peek_code(10),
    !,skip_line.

read_number(_, _):-
    peek_code(Value),
    \+between(48, 57, Value), !, skip_line,
    write('Invalid character!\n'), fail.

read_number(Value, Prev):-
    get_code(Ascii),
    between(48, 57, Ascii), !,
    char_code('0', AsciiZero),
    Num is Ascii - AsciiZero,
    Next is Prev * 10 + Num,
    read_number(Value, Next).

/*
* Read digit between 2 values: 
* read_digit_between(+Min, +Max, -Value).
*/
read_digit_between(Min, Max, Value):-
    read_digit(Value),
    \+between(Min, Max, Value),
    write('Invalid number!\n'), fail.

read_digit_between(Min, Max, Value):-
    repeat,
    read_digit(Value),
    between(Min, Max, Value).

/*
* Read digit from input stream: 
* read_digit(-Value).
*/
read_digit(_):-
    peek_code(Value),
    \+between(48, 57, Value), !, skip_line,
    write('Invalid character!\n'), fail.

read_digit(Value):-
    get_code(Ascii),
    between(48, 57, Ascii),
    char_code('0', AsciiZero),
    Value is Ascii - AsciiZero,
    peek_code(10),
    !,skip_line.

read_digit(Value):- skip_line, Value is -1.

/*
* Read alphabetic char from input stream (returns uppercase value): 
* read_alpha_char(-Value).
*/
read_alpha_char(Value):- % Uppercase Character
    peek_code(CodePeek),
    between(65, 90, CodePeek), !,
    get_code(Code),
    char_code(Value, Code).

read_alpha_char(Value):- % Lowercase Character
    peek_code(CodePeek),
    between(97, 122, CodePeek), !,
    get_code(Code),
    UppercaseCode is Code - 32,
    char_code(Value, UppercaseCode).

read_alpha_char(Value):-
    write('Invalid character!\n'),
    skip_line, fail.

/*
* Convert alphabetic char to int starting from 'A': 
* char_to_int(+Char, -Int).
*/
char_to_int(Char, Int):-
    char_code(Char, Code),
    Int is Code-64.

/*
* Reads alphabetic char from input stream and
* converts to int:
* getXCord(-Value).
*/
getXCord(Value):-
    read_alpha_char(Char),
    char_to_int(Char, Value).

/*
* Validates if Value is in board bounds:
* inBounds(+Value).
*/
inBounds(Value):-
    between(1,8, Value).

type_of_character(Ch, Type):-
    Ch >= 'a', Ch =< 'z',!,
    Type = lowercase.

type_of_character(Ch, Type):-
    Ch >= 'A', Ch =< 'Z',!,
    Type = uppercase.
    
type_of_character(Ch, Type):-
    Ch >= '0', Ch =< '9',!,
    Type = digit.

type_of_character(_Ch, Type):-
    Type = other.