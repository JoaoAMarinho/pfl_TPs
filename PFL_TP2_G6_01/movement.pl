:-use_module(library(lists)).

/*
* Indicates the opponent of a piece: 
* opponent(?Piece1, ?Piece2).
*/
opponent(samurai, ninja).
opponent(ninja, samurai).

/*
* Possible piece movement vectors: 
* piece_directions(-Vectors).
*/
piece_directions(Vectors) :- Vectors = [(-1,-1),(-1,0),(0,-1),(-1,1),(1,-1),(0,1),(1,0),(1,1)].

/*
* Validates if a piece is in the given board at the specified coordinates: 
* piece_in_board(+Board, +Type, ?X, ?Y).
*/
piece_in_board(Board, Type, X, Y):-
    nth1(Y, Board, Row),
    nth1(X, Row, piece(Type)).

piece_in_board(_, _, _, _):- !, fail.

/*
* Validates if a certain move is possible and valid:
* Move: X-Y-Nx-Ny, where X and Y are necessary, whereas Nx and Ny
* can be instanciated or not 
* valid_piece_move(+Type, +Board, +Size, ?Move).
*/
valid_piece_move(Type, Board, Size, X-Y-Nx-Ny):-
    piece_directions(Vectors),
    get_positions(Type, Board, Size, X, Y, Vectors, [], Positions),
    member((Nx,Ny), Positions).

valid_piece_move(_, _, _, _):- !, fail.

/*
* Returns a list with the possible board positions for a specific piece:
* get_positions(+Type, +Board, +Size, +X, +Y, +Vectors, +InitialPositions, -Result).
*/
get_positions(Type, Board, Size, X, Y, [Vector], Positions, NewPositions) :-
    get_positions_for_vector(Type, Board, Size, X, Y, Vector, [], Result),
    append(Result, Positions, NewPositions).

get_positions(Type, Board, Size, X, Y, [Vector|List], Positions, NewPositions):-
    get_positions_for_vector(Type, Board, Size, X, Y, Vector, [], Result),
    append(Result, Positions, CurrPositions),
    get_positions(Type, Board, Size, X, Y, List, CurrPositions, NewPositions).

/*
* Returns a list with the possible board positions by following a given vector:
* get_positions_for_vector(+Type, +Board, +Size, +X, +Y, +Vector, +CurrentPositions, -Result).
*/
get_positions_for_vector(_, _,Size, X, Y, (Vx,Vy), Positions, Positions):-         % handle out of board
    Nx is X+Vx,
    Ny is Y+Vy,
    out_of_bounds(Nx, Ny, Size), !.

get_positions_for_vector(Type, Board, Size, X, Y, Vector, Positions, Result):-     % find empty space, continue search
    verify_piece_in_new_position(X, Y, Vector, Board, empty, Nx, Ny), !,
    get_positions_for_vector(Type, Board, Size, Nx, Ny, Vector, [(Nx, Ny) | Positions], Result).

get_positions_for_vector(Type, Board, _, X, Y, Vector, Positions, Positions):-     % find opponent piece, stop search
    opponent(Type, Opponent),
    verify_piece_in_new_position(X, Y, Vector, Board, Opponent, _, _), !.

get_positions_for_vector(Type, Board, Size, X, Y, Vector, Positions, Result):-     % find friendly piece, continue search until opponent piece
    verify_piece_in_new_position(X, Y, Vector, Board, Type, Nx, Ny),
    get_opponent_piece(Type, Board, Size, Nx, Ny, Vector, Positions, Result).

/*
* Applies the vector to the given coordinates and verifies if the piece Type is in that board position:
* verify_piece_in_new_position(+X, +Y, +Vector, +Board, +Type, -Nx, -Ny).
*/
verify_piece_in_new_position(X, Y, (Vx, Vy), Board, Type, Nx, Ny):-
    Nx is X+Vx,
    Ny is Y+Vy,
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(Type)).

/*
* Returns a position by following a vector if it finds an opponent piece:
* get_opponent_piece(+Type, +Board, +X, +Y, +Vector, +CurrentPositions, -Result).
*/
get_opponent_piece(_, _, Size, X, Y, (Vx,Vy), Positions, Positions):-                    % handle out of board
    Nx is X+Vx,
    Ny is Y+Vy,
    out_of_bounds(Nx, Ny, Size),!.

get_opponent_piece(Type, Board, Size, X, Y, Vector, Positions, Result):-                 % find empty space, continue search
    verify_piece_in_new_position(X, Y, Vector, Board, empty, Nx, Ny), !,
    get_opponent_piece(Type, Board, Size, Nx, Ny, Vector, Positions, Result).


get_opponent_piece(Type, Board, _, X, Y, Vector, Positions, Positions):-                 % find friendly piece, stop search
    verify_piece_in_new_position(X, Y, Vector, Board, Type, _, _), !.

get_opponent_piece(Type, Board, _, X, Y, Vector, Positions, [(Nx, Ny) | Positions]):-    % find opponent piece, add position and stop search
    opponent(Type, Opponent),
    verify_piece_in_new_position(X, Y, Vector, Board, Opponent, Nx, Ny).
/*
* Performs a piece movement and returns the new board state and the piece that was on that position before the move was executed:
* move_piece(+Type, +Board, +Move, -NewBoard, -Piece).
*/
move_piece(Type, Board, X-Y-Nx-Ny, NewBoard, Piece):-
    nth1(Y, Board, Row1),
    replace(X, piece(empty), Row1, NewRow1),
    replace(Y, NewRow1, Board, MiddleBoard),
    nth1(Ny, MiddleBoard, Row2),
    nth1(Nx, Row2, Piece),
    replace(Nx, piece(Type), Row2, NewRow2),
    replace(Ny, NewRow2, MiddleBoard, NewBoard), !.

/*
* Replaces the Element in the list based on the Index:
* replace(+Index, +Element, +List, -ResultingList).
*/    
replace(_, _, [], []).
replace(1, R, [_|T], [R|T]).
replace(I, R, [H1|T1], [H1|T2]) :-
    NewI is I-1,
    replace(NewI, R, T1, T2).

/*
* Checks if position is out of board bounds:
* out_of_bounds(+x, +Y, +Size).
*/  
out_of_bounds(X, Y, Size):-
    \+between(1, Size, X);
    \+between(1, Size, Y).