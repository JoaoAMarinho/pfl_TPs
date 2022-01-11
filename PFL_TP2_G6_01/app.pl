:- [game].

/*
* Returns path to file according to Menu:
* menu_path(+Menu, -Path);
*/
menu_path(start, Path):-        Path = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/assets/menus/welcome_menu.txt'. 
menu_path(instructions, Path):- Path = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/assets/menus/instructions.txt'. 
menu_path(difficulty, Path):-   Path = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/assets/menus/difficulty.txt'. 

/*
* Main menu handlers:
* start.
* instructions.
* difficulty.
* exit.
*/ 
start:-
    menu_viewer(start),
    repeat,
    read_digit_between(1, 4, Value),
    read_specific_char('\n'),
    change_menu(Value, start).

instructions:-
    menu_viewer(instructions),
    repeat,
    peek_code(_), skip_line,
    change_menu(_, instructions).

difficulty:-
    menu_viewer(difficulty),
    repeat,
    read_digit_between(1, 3, Value),
    read_specific_char('\n'),
    change_menu(Value, bot).

exit:-
    clear_screen.

/*
* Display a certain Menu specified by its parameter:
* menu_viewer(+Menu).
*/ 
menu_viewer(Menu):-
    clear_screen,
    menu_path(Menu, Path),
    read_from_file(Path).

/*
* Handles menu transition depending on the option choosen and the source menu:
* change_menu(+Option, +From).
*/ 
change_menu(1, start):- game(pvp).
change_menu(2, start):- difficulty.
change_menu(3, start):- instructions.
change_menu(4, start):- exit.

change_menu(1, bot):- game(easy).
change_menu(2, bot):- game(hard).
change_menu(3, bot):- start.

change_menu(_, instructions):- start.