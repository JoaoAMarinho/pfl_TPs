:-use_module(library(lists)).

/*
* Indicates the opponent of a piece: 
* opponent(?Piece1, ?Piece2).
*/
opponent(samurai, ninja).
opponent(ninja, samurai).

/*
* Indicates possible piece movement vectors: 
* piece_directions(-Vectors).
*/
piece_directions(Vectors) :- Vectors = [(-1,-1),(-1,0),(0,-1),(-1,1),(1,-1),(0,1),(1,0),(1,1)].

/*
* Validates if a certain move is possible: 
* valid_piece_move(+Type, +Board, +X, +Y, +Nx, +Ny).
*/
valid_piece_move(Type, Board, X, Y, Nx, Ny):-
    piece_directions(Vectors),
    get_positions(Type, Board, X, Y, Vectors, [], Positions),
    \+member((Nx,Ny), Positions), !,
    write('Invalid move!\n'), fail.

valid_piece_move(Type, Board, X, Y, Nx, Ny).

/*
* Returns a list with possible board positions for piece:
* get_positions(+Type, +Board, +X, +Y, +Vectors, +InitialPositions, -Result).
*/
get_positions(Type, Board, X, Y, [Vector], Positions, NewPositions) :-
    get_positions_for_vector(Type, Board, X, Y, Vector, [], Result),
    append(Result, Positions, NewPositions).

get_positions(Type, Board, X, Y, [Vector|List], Positions, NewPositions):-
    get_positions_for_vector(Type, Board, X, Y, Vector, [], Result),
    append(Result, Positions, CurrPositions),
    get_positions(Type, Board, X, Y, List, CurrPositions, NewPositions).

/*
* Returns a list with possible board positions by following a given vector:
* get_positions_for_vector(+Type, +Board, +X, +Y, +Vector, +CurrentsPositions, -Result).
*/
get_positions_for_vector(Type, Board, X, Y, (Vx, Vy), Positions, Result):-     % find empty space, continue search
    Nx is X+Vx,
    Ny is Y+Vy,
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(empty)),!,
    append([(Nx, Ny)], Positions, NewPositions),
    get_positions_for_vector(Type, Board, Nx, Ny, (Vx,Vy), NewPositions, Result).

get_positions_for_vector(_, _, X, Y, (Vx,Vy), Positions, Positions):-          % handle out of board
    Nx is X+Vx,
    Ny is Y+Vy,
    out_of_bounds(Nx,Ny), !.

get_positions_for_vector(Type, Board, X, Y, (Vx, Vy), Positions, Positions):-  % find opponent piece, stop search
    Nx is X+Vx,
    Ny is Y+Vy,
    opponent(Type, Opponent),
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(Opponent)), !.

get_positions_for_vector(Type, Board, X, Y, (Vx, Vy), Positions, Result):-     % find friendly piece, continue search until opponent piece
    Nx is X+Vx,
    Ny is Y+Vy,
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(Type)),
    get_opponent_piece(Type, Board, Nx, Ny, (Vx,Vy), Positions, Result).

/*
* Returns a position by following a vector if it finds an opponent piece:
* get_opponent_piece(+Type, +Board, +X, +Y, +Vector, +CurrentPositions, -Result).
*/
get_opponent_piece(Type, Board, X, Y, (Vx, Vy), Positions, Result):-          % find empty space, continue search
    Nx is X+Vx,
    Ny is Y+Vy,
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(empty)),!,
    get_opponent_piece(Type, Board, Nx, Ny, (Vx,Vy), Positions, Result).

get_opponent_piece(_, _, X, Y, (Vx,Vy), Positions, Positions):-               % handle out of board
    Nx is X+Vx,
    Ny is Y+Vy,
    out_of_bounds(Nx,Ny),!.

get_opponent_piece(Type, Board, X, Y, (Vx, Vy), Positions, Positions):-       % find friendly piece, stop search
    Nx is X+Vx,
    Ny is Y+Vy,
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(Type)),!.

get_opponent_piece(Type, Board, X, Y, (Vx, Vy), Positions, Result):-          % find opponent piece, add position and stop search
    Nx is X+Vx,
    Ny is Y+Vy,
    opponent(Type, Opponent),
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(Opponent)),
    append([(Nx, Ny)], Positions, Result).

/*
* Performs a piece movement and updates the score accordingly:
* move_piece(+Type, +Board, +X, +Y, +Nx, +Ny, -NewBoard, +PlayerPoints, -NewPlayerPoints).
*/
move_piece(Type, Board, X, Y, Nx, Ny, NewBoard, PlayerPoints, NewPlayerPoints):- % attack move
    nth1(Y, Board, Row1),
    replace(X, piece(empty), Row1, NewRow1),
    replace(Y, NewRow1, Board, MiddleBoard),
    opponent(Type, Opponent),
    nth1(Ny, MiddleBoard, Row2),
    nth1(Nx, Row2, piece(Opponent)),!,
    replace(Nx, piece(Type), Row2, NewRow2),
    replace(Ny, NewRow2, MiddleBoard, NewBoard),
    NewPlayerPoints is PlayerPoints+1.

move_piece(Type, Board, X, Y, Nx, Ny, NewBoard, Player1Points, Player1Points):- % simple move
    nth1(Y, Board, Row1),
    replace(X, piece(empty), Row1, NewRow1),
    replace(Y, NewRow1, Board, MiddleBoard),
    nth1(Ny, MiddleBoard, Row2),
    replace(Nx, piece(Type), Row2, NewRow2),
    replace(Ny, NewRow2, MiddleBoard, NewBoard).

/*
* Replaces the Element in the list based on the Index:
* replace(+Index, +Element, +List, -ResultingList).
*/    
replace(_, _, [], []).
replace(1, R, [H|T], [R|T]).
replace(I, R, [H1|T1], [H1|T2]) :-
    NewI is I-1,
    replace(NewI, R, T1, T2).

/*
* Checks if position is out of bounds:
* replace(+Index, +Element, +List, -ResultingList).
*/  
out_of_bounds(X, Y):-
    \+between(1, 8, X);
    \+between(1, 8, Y).