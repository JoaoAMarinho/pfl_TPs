% Includes
%:- [main].
:- [parser].

welcomeMenuPath(X):- X = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/welcomeMenu.txt'. 

start:-
    welcomeMenuPath(Path),
    readFromFile(Path),
    read_number_between(1, 3, Value), write(Value).
    % draw inital menu
    % receive input and validate with current menu
    % handle input / change state/screen



% File operations

readFromFile(Path):-
    nl,
    open(Path, read, Stream),
    printFile(Stream),
    close(Stream),
    nl.

printFile(Stream):-
    peek_code(Stream,-1).

printFile(Stream):-
    get_char(Stream, Char),
    write(Char),
    printFile(Stream).