:-use_module(library(random)).

:- [parser].
:- [game_view].
:- [movement].

/*
* Returns an SizexSize board with ninjas and samurais in the first and last rows, respectively: 
* build_board(+Size, -Board).
*/
build_board(Size, Board):-
    build_n_rows(1, Size, samurai, [], FinalRow),
    SizeMiddle is Size-2,
    build_n_rows(SizeMiddle, Size, empty, FinalRow, MiddleRows),
    build_n_rows(1, Size, ninja, MiddleRows, Board).

/*
* Builds n rows of the board:
* build_n_rows(+NumRows, +Size, +Type, +Rows, -Rows)
*/
build_n_rows(0, _, _, Rows, Rows).
build_n_rows(NumRows, RowSize, Type, Rows, Res):-
    build_row(RowSize, Type, [], Row),
    NewNumRows is NumRows-1,
    build_n_rows(NewNumRows, RowSize, Type, [Row|Rows], Res).

/*
* Builds a row of the board:
* build_row(+RowSize, +Type, +Row, -Row)
*/
build_row(0, _, Row, Row).
build_row(RowSize, Type, Row, Res):-
    NewRowSize is RowSize-1,
    build_row(NewRowSize, Type, [piece(Type)|Row], Res).

/*
* Updates points according to piece movement:
* update_points(+Type, +Piece, +Points1, +Points2, -NewPoints1, -NewPoints2).
*/
update_points(_, piece(empty), Points1, Points2, Points1, Points2):- !.
update_points(samurai, _, Points1, Points2, NewPoints1, Points2):-
    NewPoints1 is Points1 + 1,!.
update_points(_, _, Points1, Points2, Points1, NewPoints2):-
    NewPoints2 is Points2 + 1,!.

/*
* Verifies if the game is over:
* game_over(+GameState, +Type).
* GameState = Board-Size-Points1-Points2-Type
*/
game_over(_-Size-Points1-_-_, samurai):-
    FinalPoints is ceiling(Size/2),
    Points1 == FinalPoints, !.

game_over(_-Size-_-Points2-_, ninja):-
    FinalPoints is ceiling(Size/2),
    Points2 == FinalPoints, !.

/*
* Game cycle according to current mode:
* game_cycle(+GameState, +Mode)
* GameState = Board-Size-Points1-Points2-Type
*/
game_cycle(Board-Size-P1-P2-Type, _):-
    game_over(Board-Size-P1-P2-Type, Winner), !,
    print_board(Board,Size),
    congratulate(Winner).

game_cycle(GameState, Mode):-
    display_game(GameState),
    get_player_by_type(GameState, Mode, Player),
    repeat,
    choose_move(GameState, Player, Move),
    move(GameState, Move, NewGameState), !,
    game_cycle(NewGameState, Mode).

/*
* Gets the player associated with the type Type:
* get_player_by_type(+GameState, +Mode, -P):- !.
* GameState = Board-Size-Points1-Points2-Type
*/
get_player_by_type(_-_-_-_-samurai, P1-_, P1):- !.
get_player_by_type(_-_-_-_-ninja, _-P2, P2).

/*
* Human interaction to select move:
* choose_move(+GameState, +Player, -Move)
* GameState = Board-Size-Points1-Points2-Type
*/
choose_move(_-Size-_-_-_, human, X-Y-Nx-Ny):-
    repeat,
    read_move(X, Y, Nx, Ny, Size), !.

/*
* Bot calculations to select move:
* choose_move()
* GameState = Board-Size-Points1-Points2-Type
*/

choose_move(GameState, computer-Level, Move):-
    valid_moves(GameState, Moves),
    choose_move(Level, GameState, Moves, Move).

choose_move(1, _GameState, Moves, Move):-
    random_select(Move, Moves, _Rest).

choose_move(2, GameState, Moves, Move):-
    setof(Value-Mv, (NewState, Player)^( member(Mv, Moves),
        move(GameState, Mv, NewState),
        value(NewState, Player, Value) ), [_V-Move|_]).
/*

* GameState = Board-Size-Points1-Points2-Type
*/
valid_moves(GameState, Moves):-
    findall(Move, move(GameState, Move, _), Moves), nl.

/*

* GameState = Board-Size-Points1-Points2-Type
*/
/*
evaluate_board(_-_-P1-P2-_, _-_-NP1-NP2-_, samurai, Value):-
    Delta is NP1-P1,
    Delta > 0,
    Value is Delta * (-2).

evaluate_board(_-_-P1-P2-_, _-_-NP1-NP2-_, samurai, Value):-
    value(_-_-P1-P2-_, samurai, Value).

value(Board-Size-_-_-_, samurai, Value):-
    can_attack(Board, samurai).
*/
value(_-_-P1-P2-_, samurai, Value):-
    Value is P2-P1.
value(_-_-P1-P2-_, ninja, Value):-
    Value is P1-P2.
/*
* Performs a move:
* move(+GameState, ?Move, -NewGameState)
* GameState = Board-Size-Points1-Points2-Type
*/
move(Board-Size-Points1-Points2-Type, X-Y-Nx-Ny, NewGameState):-
    piece_in_board(Board, Type, X, Y),
    valid_piece_move(Type, Board, Size, X-Y-Nx-Ny),
    move_piece(Type, Board, X-Y-Nx-Ny, NewBoard, Piece),
    update_points(Type, Piece, Points1, Points2, NewPoints1, NewPoints2),
    opponent(Type, Opponent),
    NewGameState = NewBoard-Size-NewPoints1-NewPoints2-Opponent.

/*
* Returns inital state according to board size:
* initial_state(+Size, -GameState)
* GameState = Board-Size-Points1-Points2-Type
*/
initial_state(Size, Board-Size-0-0-samurai):-
    build_board(Size, Board).

/*
* Game starter:
* game(+Mode, +Size).
*/
game(Mode, Size):- 
    initial_state(Size, GameState), !, 
    game_cycle(GameState, Mode).
