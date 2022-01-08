% Includes
%:- [game].

welcome_menu_path(Path):- Path = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/assets/menus/welcome_menu.txt'. 
instructions_path(Path):- Path = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/assets/menus/instructions.txt'. 
difficulty_path(Path):-   Path = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/assets/menus/difficulty.txt'. 

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