% Includes
%:- [main].

welcome_menu_path(X):- X = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/menus/welcome_menu.txt'. 
instructions_path(X):- X = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/menus/instructions.txt'. 
difficulty_path(X):-   X = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/menus/difficulty.txt'. 

start:-
    clear_screen,
    welcome_menu_path(Path),
    read_from_file(Path),
    repeat,
    read_digit_between(1, 4, Value),
    read_specific_char('\n'),
    change_menu(Value, start).

instructions:-
    clear_screen,
    instructions_path(Path),
    read_from_file(Path),
    repeat,
    peek_code(Code), skip_line,
    change_menu(_, instructions).

difficulty:-
    clear_screen,
    difficulty_path(Path),
    read_from_file(Path),
    repeat,
    read_digit_between(1, 3, Value),
    read_specific_char('\n'),
    change_menu(Value, bot).

exit:-
    clear_screen.

% Change menus

% change_menu(1, start):- play_game.
change_menu(2, start):- difficulty.
change_menu(3, start):- instructions.
change_menu(4, start):- exit.

% change_menu(1, bot):- instructions.
% change_menu(2, bot):- instructions.
change_menu(3, bot):- start.

change_menu(_, instructions):- start.

% File operations

read_from_file(Path):-
    nl,
    open(Path, read, Stream),
    print_file(Stream),
    close(Stream),
    nl.

print_file(Stream):-
    peek_code(Stream,-1).

print_file(Stream):-
    get_char(Stream, Char),
    write(Char),
    print_file(Stream).

clear_screen:- write('\33\[2J').