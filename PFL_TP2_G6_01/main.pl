:-use_module(library(lists)).
:-use_module(library(between)).

% builds the board with the pieces in the correct places
buildBoard(B) :- B = [
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

% returns opponent type
opponent(samurai, ninja).
opponent(ninja, samurai).

% playGame(playerTurn, Board, Player1Points, Player2Points).

playGame(_, _, Points1, _):- % check if game has ended
    Points1 == 4,
    write('\nSamurais WON!\n').

playGame(_, _, _, Points2):- % check if game has ended
    Points2 == 4,
    write('\nNinjas WON!\n').

playGame(samurai, Board, Player1Points, Player2Points):- % play piece according to player turn
    printBoard(Board),
    write('\nSamurais turn\n'),
    repeat,
    receiveInput(X, Y, Nx, Ny),
    nth1(Y, Board, Row),
    nth1(X, Row, piece(samurai)), % pick correct piece
    validPieceMove(samurai, Board, X, Y, Nx, Ny),
    movePiece(samurai, Board, X, Y, Nx, Ny, NewBoard, Player1Points, NewPlayer1Points),
    playGame(ninja, NewBoard, NewPlayer1Points, Player2Points).

playGame(ninja, Board, Player1Points, Player2Points):- % play piece according to player turn
    printBoard(Board),
    write('\nNinjas turn\n'),
    repeat,
    receiveInput(X, Y, Nx, Ny),
    nth1(Y, Board, Row),
    nth1(X, Row, piece(ninja)), % pick correct piece
    validPieceMove(ninja, Board, X, Y, Nx, Ny),
    movePiece(ninja, Board, X, Y, Nx, Ny, NewBoard, Player2Points, NewPlayer2Points),
    playGame(samurai, NewBoard, Player1Points, NewPlayer2Points).

% receiveInput(CurrentX, CurrentY, NewX, NewY).
receiveInput(X,Y,Nx,Ny):-
    repeat,
    write('Enter current x position (1.):\n'),
    read(X),
    write('Enter current y position (1.):\n'),
    read(Y),
    write('Enter new x position (1.):\n'),
    read(Nx),
    write('Enter new y position (1.):\n'),
    read(Ny),
    \+verifyQuit(X,Y,Nx,Ny).

verifyQuit(A,B,C,D):-
    A = 'q',
    B = 'u',
    C = 'i',
    D = 't',
    write('\nBye Bro\n'), 
    halt.

% start game
start :- buildBoard(Board), playGame(samurai, Board, 0, 0).

% piece movement

% Possible piece movement vectors
pieceDirections(X) :- X = [(-1,-1),(-1,0),(0,-1),(-1,1),(1,-1),(0,1),(1,0),(1,1)].

% check if movement is valid
validPieceMove(Type, Board, X, Y, Nx, Ny):-
    pieceDirections(Vectors),
    getPositions(Type, Board, X, Y, Vectors, [], Positions),
    member((Nx,Ny), Positions).

% return a list with possible board positions for piece
getPositions(Type, Board, X, Y, [Vector], Positions, NewPositions) :-
    getPositionsForVector(Type, Board, X, Y, Vector, [], Result),
    append(Result, Positions, NewPositions).

getPositions(Type, Board, X, Y, [Vector|List], Positions, NewPositions):-
    getPositionsForVector(Type, Board, X, Y, Vector, [], Result),
    append(Result, Positions, CurrPositions),
    getPositions(Type, Board, X, Y, List, CurrPositions, NewPositions).

% return a list with possible board positions by following a given vector
getPositionsForVector(Type, Board, X, Y, (Vx, Vy), Positions, Result):-     % find empty space, continue search
    Nx is X+Vx,
    Ny is Y+Vy,
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(empty)),!,
    append([(Nx, Ny)], Positions, NewPositions),
    getPositionsForVector(Type, Board, Nx, Ny, (Vx,Vy), NewPositions, Result).

getPositionsForVector(_, _, X, Y, (Vx,Vy), Positions, Positions):-          % handle out of board
    Nx is X+Vx,
    Ny is Y+Vy,
    outOfBounds(Nx,Ny), !.

getPositionsForVector(Type, Board, X, Y, (Vx, Vy), Positions, Positions):-  % find opponent piece, stop search
    Nx is X+Vx,
    Ny is Y+Vy,
    opponent(Type, Opponent),
    nth1(Ny, Board, Row),
    nth1(Nx, Row, piece(Opponent)), !.

getPositionsForVector(Type, Board, X, Y, (Vx, Vy), Positions, Result):-     % find friendly piece, continue search until opponent piece
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
    outOfBounds(Nx,Ny),!.

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
movePiece(Type, Board, X, Y, Nx, Ny, NewBoard, Player1Points, NewPlayer1Points):- % attack move
    nth1(Y, Board, Row1),
    replace(X, piece(empty), Row1, NewRow1),
    replace(Y, NewRow1, Board, MiddleBoard),
    opponent(Type, Opponent),
    nth1(Ny, MiddleBoard, Row2),
    nth1(Nx, Row2, piece(Opponent)),!,
    replace(Nx, piece(Type), Row2, NewRow2),
    replace(Ny, NewRow2, MiddleBoard, NewBoard),
    NewPlayer1Points is Player1Points+1.

movePiece(Type, Board, X, Y, Nx, Ny, NewBoard, Player1Points, Player1Points):- % simple move
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
outOfBounds(X, Y):-
    \+between(1, 8, X);
    \+between(1, 8, Y).