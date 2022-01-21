:- [game].
:-use_module(library(file_systems)).

/*
* Returns path to file according to Menu:
* menu_path(+Menu, -Path)
*/
menu_path(main, Path):-         Path = './assets/menus/welcome_menu.txt'. 
menu_path(instructions, Path):- Path = './assets/menus/instructions.txt'. 
menu_path(human_bot, Path):-    Path = './assets/menus/human_bot.txt'. 
menu_path(bot_bot, Path):-    Path = './assets/menus/bot_bot.txt'. 
menu_path(size, Path):-    Path = './assets/menus/size_menu.txt'. 

/*
* Main menu handlers:
*/
play:-
    current_directory(_, 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01'),
    main.

main:-
    display_menu(main),
    repeat,
    read_digit_between(1, 5, Value),
    read_specific_char('\n'),
    change_menu(Value, main).

instructions:-
    display_menu(instructions),
    repeat,
    peek_code(_), skip_line,
    change_menu(_, instructions).

human_bot:-
    display_menu(human_bot),
    repeat,
    read_digit_between(1, 3, Value),
    read_aux(Value, Res),
    change_menu(Res, human_bot).

bot_bot:-
    display_menu(bot_bot),
    repeat,
    read_digit_between(1, 3, Value),
    read_aux(Value, Res),
    change_menu(Res, bot_bot).

read_aux(3, 3):- read_specific_char('\n').
read_aux(V1, V1-V2):- 
    read_specific_char('-'),
    read_digit_between(1, 2, V2),
    read_specific_char('\n').

size(Mode, Back):-
    display_menu(size),
    repeat,
    read_digit_between(1, 4, Value),
    read_specific_char('\n'),
    start(Mode, Value, Back).

exit:- clear_screen.

/*
* Display a certain Menu specified by its parameter:
* display_menu(+Menu)
*/ 
display_menu(Menu):-
    clear_screen,
    menu_path(Menu, Path),
    read_from_file(Path).

/*
* Handles menu transition depending on the option choosen and the source menu:
* change_menu(+Option, +From)
*/
change_menu(1, main):- size(human-human, main).
change_menu(2, main):- human_bot.
change_menu(3, main):- bot_bot.
change_menu(4, main):- instructions.
change_menu(5, main):- exit.

change_menu(3, human_bot):- main.
change_menu(Level-1, human_bot):-  
    size(human-(computer-Level), human_bot).
change_menu(Level-2, human_bot):-  
    size((computer-Level)-human, human_bot).

change_menu(3, bot_bot):- main.
change_menu(Level1-Level2, bot_bot):-  
    size((computer-Level1)-(computer-Level2), bot_bot).


change_menu(_, instructions):- main.

/*
* Stars a game
* start(+Mode, +Size, _)
*/
start(_, 4, Back):- Back.
start(Mode, Size, _):- 
    RealSize is Size+5,
    game(Mode, RealSize). 

/*
* Prints the content of a file given by the Path:
* read_from_file(+Path)
*/
read_from_file(Path):-
    open(Path, read, Stream),
    print_file(Stream),
    close(Stream),
    nl.

/*
* Reads and prints the content of a stream until the end:
* read_from_file(+Path)
*/
print_file(Stream):-
    peek_code(Stream,-1).

print_file(Stream):-
    get_char(Stream, Char),
    write(Char),
    print_file(Stream).