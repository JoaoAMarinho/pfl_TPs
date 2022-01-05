:-use_module(library(between)).

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