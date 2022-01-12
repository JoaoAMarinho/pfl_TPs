:- [parser].
:- [board_view].
:- [movement].

/*
* Returns an 8x8 board with ninjas and samurais in the first and last rows, respectively: 
* build_board(+Size, -Board).
*/
build_board(Size, Board):-
    build_n_rows(1, Size, samurai, [], FinalRow),
    SizeMiddle is Size-2,
    build_n_rows(SizeMiddle, Size, empty, FinalRow, MiddleRows),
    build_n_rows(1, Size, ninja, MiddleRows, Board).

build_n_rows(0, _, _, Rows, Rows).
build_n_rows(NumRows, RowSize, Type, Rows, Res):-
    build_row(RowSize, Type, [], Row),
    NewNumRows is NumRows-1,
    build_n_rows(NewNumRows, RowSize, Type, [Row|Rows], Res).

build_row(0, _, Row, Row).
build_row(RowSize, Type, Row, Res):-
    NewRowSize is RowSize-1,
    build_row(NewRowSize, Type, [piece(Type)|Row], Res).


/*
* Prints player turn message:
* print_turn(+Type).
*/
print_turn(samurai):- write('\nSamurais turn\n').
print_turn(ninja):-   write('\nNinjas turn\n').

congratulate(samurai):- write('\nSamurais WON!\n').
congratulate(ninja):-   write('\nNinjas WON!\n').

display_game(Board-_-_-_-Type):-
    print_board(Board),
    print_turn(Type).
/*
* Validates if a piece is in the given board at the specified coords: 
* piece_in_board(+Board, +Type, +X, +Y).
*/
piece_in_board(Board, Type, X, Y):-
    nth1(Y, Board, Row),
    \+nth1(X, Row, piece(Type)), !,
    write('Incorrect position!\n'), fail.

piece_in_board(Board, Type, X, Y).

/*
* Updates points according to piece movement:
* update_points(+Type, +Piece, +Player1Points, +Player2Points, -NewPlayer1Points, -NewPlayer2Points).
*/
update_points(_, empty, Player1Points, Player2Points, Player1Points, Player2Points):- !.
update_points(samurai, _, Player1Points, Player2Points, NewPlayer1Points, Player2Points):-
    NewPlayer1Points is Player1Points+1,!.
update_points(_, _, Player1Points, Player2Points, Player1Points, NewPlayer2Points):-
    NewPlayer2Points is Player2Points+1,!.


game_over(_-Size-Points1-Points2-_, samurai):-
    FinalPoints is ceiling(Size/2),
    Points1 == FinalPoints, !.

game_over(_-Size-Points1-Points2-_, ninja):-
    FinalPoints is ceiling(Size/2),
    Points2 == FinalPoints, !.


game_cycle(GameState, _, _):-
    game_over(GameState, Winner), !,
    congratulate(Winner).

game_cycle(GameState, P1, P2):-
    choose_move(GameState, Player, Move), !,
    move(GameState, Move, NewGameState),
    display_game(GameState),
    game_cyle(NewGameState, P1, P2).

move(Board-Size-Points1-Points2-Type, Move, NewGameState):-
    move_piece(Type, Board, Move, NewBoard, Piece),
    update_points(Type, Piece, Points1, Points2, NewPoints1, NewPoints2),
    opponent(Type, Opponent),
    NewGameState = NewBoard-Size-NewPoints1-NewPoints2-Opponent.

/*
* Game starter:
* game(+P1, +P2, +Size).
*/
game(P1, P2, Size):- 
    initial_state(Size, GameState), 
    display_game(GameState),
    game_cycle(GameState, P1, P2).

/*
* Returns inital state according to board size:
* game(+P1, +P2, +Size).
*/
initial_state(Size, Board-Size-0-0-samurai):-
    build_board(Size, Board).

/*
* Game cycle according to current mode:
* game_cyle(+Mode, +Type, +Board, +Player1Points, +Player2Points).
*/
# game_cyle(pvp, Type, Board, Player1Points, Player2Points):-
#     repeat,
#     read_move(X, Y, Nx, Ny),
#     piece_in_board(Board, Type, X, Y),
#     valid_piece_move(Type, Board, X, Y, Nx, Ny, Piece),!,
#     execute_play(Type, Piece, Board, X, Y, Nx, Ny, Player1Points, Player2Points, pvp).