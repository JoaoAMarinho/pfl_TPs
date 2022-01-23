:-use_module(library(random)).
:-use_module(library(system)).

:- [parser].
:- [game_view].
:- [movement].

/*
* Returns an Size x Size board with ninjas and samurais in the first and last rows, respectively: 
* build_board(+Size, -Board)
*/
build_board(Size, Board):-
    build_n_rows(1, Size, samurai, [], FinalRow),
    SizeMiddle is Size-2,
    build_n_rows(SizeMiddle, Size, empty, FinalRow, MiddleRows),
    build_n_rows(1, Size, ninja, MiddleRows, Board).

/*
* Builds n rows of the board:
* build_n_rows(+NumRows, +Size, +Type, +Rows, -Result)
*/
build_n_rows(0, _, _, Rows, Rows).
build_n_rows(NumRows, RowSize, Type, Rows, Res):-
    build_row(RowSize, Type, [], Row),
    NewNumRows is NumRows-1,
    build_n_rows(NewNumRows, RowSize, Type, [Row|Rows], Res).

/*
* Builds a row of the board:
* build_row(+RowSize, +Type, +Row, -Result)
*/
build_row(0, _, Row, Row).
build_row(RowSize, Type, Row, Res):-
    NewRowSize is RowSize-1,
    build_row(NewRowSize, Type, [piece(Type)|Row], Res).

/*
* Updates points according to piece movement:
* update_points(+Type, +Piece, +Points1, +Points2, -NewPoints1, -NewPoints2)
*/
update_points(_, piece(empty), Points1, Points2, Points1, Points2):- !.
update_points(samurai, _, Points1, Points2, NewPoints1, Points2):-
    NewPoints1 is Points1 + 1,!.
update_points(_, _, Points1, Points2, Points1, NewPoints2):-
    NewPoints2 is Points2 + 1,!.

/*
* Verifies if the game is over:
* game_over(+GameState, +Type)
* GameState = Board-Size-Points1-Points2-Type
*/
game_over(_-Size-Points1-_-_, samurai):-
    FinalPoints is ceiling(Size/2),
    Points1 == FinalPoints, !.

game_over(_-Size-_-Points2-_, ninja):-
    FinalPoints is ceiling(Size/2),
    Points2 == FinalPoints, !.

/*
* Game cycle according to mode:
* game_cycle(+GameState, +Mode)
* GameState = Board-Size-Points1-Points2-Type
*/
game_cycle(Board-Size-P1-P2-Type, _):-
    game_over(Board-Size-P1-P2-Type, Winner), !,
    print_board(Board,Size),
    congratulate(Winner),
    peek_code(_), skip_line.

game_cycle(GameState, Mode):-
    display_game(GameState),
    get_player_by_type(GameState, Mode, Player),
    repeat,
    choose_move(GameState, Player, Move),
    move(GameState, Move, NewGameState), !,
    game_cycle(NewGameState, Mode).

/*
* Returns the player associated with the type Type:
* get_player_by_type(+GameState, +Mode, -Player)
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
* choose_move(+GameState, +Player, -Move)
* GameState = Board-Size-Points1-Points2-Type
*/
choose_move(GameState, computer-Level, Move):-
    write('\nThe bot is thinking...\n'),
    sleep(1),
    valid_moves(GameState, Moves),
    choose_move(Level, GameState, Moves, Move).

/*
* Bot calculations to select move from Moves:
* choose_move(+Level, +GameState, +Moves, -Move)
* GameState = Board-Size-Points1-Points2-Type
*/
choose_move(1, _GameState, Moves, Move):-
    random_select(Move, Moves, _Rest).

choose_move(2, GameState, Moves, Move):-
    setof(Value-Mv, (NewState)^( member(Mv, Moves),
        move(GameState, Mv, NewState),
        evaluate_board(GameState, NewState, Value)), [Best|List]),
    get_same_values(Best, List, Res),
    random_select(Move, Res, _).

/*
* Returns a list with all moves that have the same value according to the evalution done previously:
* get_same_values(+MoveSet, +MoveSetList, -Result)
* MoveSet = Value-Move
*/
get_same_values(_-Move, [], [Move]).
get_same_values(Value-Move, [V-Mv|List], [Mv|Res]):-
    Value = V,
    get_same_values(Value-Move, List, Res).
get_same_values(_-Move, _, [Move]).

/*
* Generates all valid moves for the board in the given state:
* valid_moves(+GameState, -Moves)
* GameState = Board-Size-Points1-Points2-Type
*/
valid_moves(GameState, Moves):-
    findall(Move, move(GameState, Move, _), Moves), nl.

/*
* Evaluates a board for a move considering the current game state and the state that results from its execution:
* evaluate_board(+GameState, +NewGameState, -Value)
* GameState = Board-Size-Points1-Points2-Type
* NewGameState = NewBoard-Size-NewPoints1-NewPoints2-NewType
*/
evaluate_board(Board-Size-P1-P2-Player, NewGameState, Value):-
    evaluate_board(Board-Size-P1-P2-Player, NewGameState, Player, Value).

evaluate_board(_-_-P1-_-_, _-_-NP1-_-_, samurai, Value):-
    Delta is NP1-P1,
    Delta > 0,
    Value = -10.

evaluate_board(_-_-_-P2-_, _-_-_-NP2-_, ninja, Value):-
    Delta is NP2-P2,
    Delta > 0,
    Value = -10.

evaluate_board(_, NewGameState, Player, Value):-
    value(NewGameState, Player, Value).

/*
* Calculates the value (worth) of the given game state, in the Player prespective, taking some heuristics into consideration:
* value(+GameState, +Player, -Value)
* GameState = Board-Size-Points1-Points2-Type
*/
value(GameState, Player, Value):-
    opponent(Player, Opponent),
    can_attack(GameState, Opponent),!, 
    Value = 10.

value(GameState, Player, Value):-
    can_attack(GameState, Player),
    Value = -5.

value(_, _, 0).

/*
* Determines if the given player can perform an attack based on the given game state:
* can_attack(+GameState, +Player)
* GameState = Board-Size-Points1-Points2-Type
*/
can_attack(Board-Size-_-_-_, Player):-
    piece_in_board(Board, Player, X, Y),
    valid_piece_move(Player, Board, Size, X-Y-Nx-Ny),
    move_piece(Player, Board, X-Y-Nx-Ny, _, piece(Piece)),
    opponent(Player, Piece).

/*
* Performs a move, returning the new game state:
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
* Returns the inital state according to board size:
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
