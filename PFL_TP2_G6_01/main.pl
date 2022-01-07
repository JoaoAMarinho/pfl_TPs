:-use_module(library(lists)).
:- [parser].

/*
* Returns an 8x8 board with ninjas and samurais in the first and last rows, respectively: 
* build_board(-Board).
*/
build_board(Board) :- Board = [
    [piece(ninja),piece(ninja),piece(ninja),piece(ninja),piece(ninja),piece(ninja),piece(ninja),piece(ninja)],
    [piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty)],
    [piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty)],
    [piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty)],
    [piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty)],
    [piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty)],
    [piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty),piece(empty)],
    [piece(samurai),piece(samurai),piece(samurai),piece(samurai),piece(samurai),piece(samurai),piece(samurai),piece(samurai)] ].

% print current board status
printBoard([Row]):-
    nl,
    printRow(Row),
    nl,!.
printBoard([Row|List]):-
    nl,
    printRow(Row),
    printBoard(List).

printRow([Piece]):-
    printPiece(Piece),!.

printRow([Piece|List]):-
    printPiece(Piece),
    write(' , '),
    printRow(List).

printPiece(piece(Type)):-
    letter(Type, Char),
    write(Char).

% letter(?Type, ?Char)
letter(samurai, 's').
letter(ninja,   'n').
letter(empty,   '_').

/*
* Indicates the opponent of a piece: 
* opponent(?Piece1, ?Piece2).
*/
opponent(samurai, ninja).
opponent(ninja, samurai).

/*
* Game handler 
* play_game(+playerTurn, +Board, +Player1Points, +Player2Points).
*/

play_game(_, _, Points1, _):- % check if game has ended
    Points1 == 4,
    write('\nSamurais WON!\n').

play_game(_, _, _, Points2):- % check if game has ended
    Points2 == 4,
    write('\nNinjas WON!\n').

play_game(samurai, Board, Player1Points, Player2Points):- % play piece according to player turn
    printBoard(Board),
    write('\nSamurais turn\n'),
    repeat,
    write('\nReceiving Input\n'),
    read_move(X, Y, Nx, Ny),
    nth1(Y, Board, Row),
    nth1(X, Row, piece(samurai)), % pick correct piece
    valid_piece_move(samurai, Board, X, Y, Nx, Ny),!,
    move_piece(samurai, Board, X, Y, Nx, Ny, NewBoard, Player1Points, NewPlayer1Points),
    play_game(ninja, NewBoard, NewPlayer1Points, Player2Points).

play_game(ninja, Board, Player1Points, Player2Points):- % play piece according to player turn
    printBoard(Board),
    write('\nNinjas turn\n'),
    repeat,
    read_move(X, Y, Nx, Ny),
    nth1(Y, Board, Row),
    nth1(X, Row, piece(ninja)), % pick correct piece
    valid_piece_move(ninja, Board, X, Y, Nx, Ny),!,
    move_piece(ninja, Board, X, Y, Nx, Ny, NewBoard, Player2Points, NewPlayer2Points),
    play_game(samurai, NewBoard, Player1Points, NewPlayer2Points).

% start game
start :- build_board(Board), play_game(samurai, Board, 0, 0).

% piece movement

% Possible piece movement vectors
piece_directions(X) :- X = [(-1,-1),(-1,0),(0,-1),(-1,1),(1,-1),(0,1),(1,0),(1,1)].

% check if movement is valid
valid_piece_move(Type, Board, X, Y, Nx, Ny):-
    piece_directions(Vectors),
    get_positions(Type, Board, X, Y, Vectors, [], Positions),
    member((Nx,Ny), Positions).

% return a list with possible board positions for piece
get_positions(Type, Board, X, Y, [Vector], Positions, NewPositions) :-
    get_positions_for_vector(Type, Board, X, Y, Vector, [], Result),
    append(Result, Positions, NewPositions).

get_positions(Type, Board, X, Y, [Vector|List], Positions, NewPositions):-
    get_positions_for_vector(Type, Board, X, Y, Vector, [], Result),
    append(Result, Positions, CurrPositions),
    get_positions(Type, Board, X, Y, List, CurrPositions, NewPositions).

% return a list with possible board positions by following a given vector
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
    getOpponentPiece(Type, Board, Nx, Ny, (Vx,Vy), Positions, Result).

% return position when found opponent piece
getOpponentPiece(Type, Board, X, Y, (Vx, Vy), Positions, Result):-          % find empty space, continue search
    Nx is X+Vx,
    Ny is Y+Vy,
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(empty)),!,
    getOpponentPiece(Type, Board, Nx, Ny, (Vx,Vy), Positions, Result).

getOpponentPiece(_, _, X, Y, (Vx,Vy), Positions, Positions):-               % handle out of board
    Nx is X+Vx,
    Ny is Y+Vy,
    out_of_bounds(Nx,Ny),!.

getOpponentPiece(Type, Board, X, Y, (Vx, Vy), Positions, Positions):-       % find friendly piece, stop search
    Nx is X+Vx,
    Ny is Y+Vy,
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(Type)),!.

getOpponentPiece(Type, Board, X, Y, (Vx, Vy), Positions, Result):-          % find opponent piece, add position and stop search
    Nx is X+Vx,
    Ny is Y+Vy,
    opponent(Type, Opponent),
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(Opponent)),
    append([(Nx, Ny)], Positions, Result).

% perform movement
move_piece(Type, Board, X, Y, Nx, Ny, NewBoard, Player1Points, NewPlayer1Points):- % attack move
    nth1(Y, Board, Row1),
    replace(X, piece(empty), Row1, NewRow1),
    replace(Y, NewRow1, Board, MiddleBoard),
    opponent(Type, Opponent),
    nth1(Ny, MiddleBoard, Row2),
    nth1(Nx, Row2, piece(Opponent)),!,
    replace(Nx, piece(Type), Row2, NewRow2),
    replace(Ny, NewRow2, MiddleBoard, NewBoard),
    NewPlayer1Points is Player1Points+1.

move_piece(Type, Board, X, Y, Nx, Ny, NewBoard, Player1Points, Player1Points):- % simple move
    nth1(Y, Board, Row1),
    replace(X, piece(empty), Row1, NewRow1),
    replace(Y, NewRow1, Board, MiddleBoard),
    nth1(Ny, MiddleBoard, Row2),
    replace(Nx, piece(Type), Row2, NewRow2),
    replace(Ny, NewRow2, MiddleBoard, NewBoard).

% replaces the Elem in the list based on the Index    
replace(_, _, [], []).
replace(1, R, [H|T], [R|T]).
replace(I, R, [H1|T1], [H1|T2]) :-
    NewI is I-1,
    replace(NewI, R, T1, T2).

% checks if position is out of bounds
out_of_bounds(X, Y):-
    \+between(1, 8, X);
    \+between(1, 8, Y).