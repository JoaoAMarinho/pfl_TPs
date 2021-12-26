:-use_module(library(lists)).

% builds the board with the pieces in the correct places
buildBoard(B) :- B = [
    [piece(samurai,1,1),piece(samurai,1,2),piece(samurai,1,3),piece(samurai,1,4),piece(samurai,1,5),piece(samurai,1,6),piece(samurai,1,7),piece(samurai,1,8)],
    [piece(empty,2,1),piece(empty,2,2),piece(empty,2,3),piece(empty,2,4),piece(empty,2,5),piece(empty,2,6),piece(empty,2,7),piece(empty,2,8)],
    [piece(empty,3,1),piece(empty,3,2),piece(empty,3,3),piece(empty,3,4),piece(empty,3,5),piece(empty,3,6),piece(empty,3,7),piece(empty,3,8)],
    [piece(empty,4,1),piece(empty,4,2),piece(empty,4,3),piece(empty,4,4),piece(empty,4,5),piece(empty,4,6),piece(empty,4,7),piece(empty,4,8)],
    [piece(empty,5,1),piece(empty,5,2),piece(empty,5,3),piece(empty,5,4),piece(empty,5,5),piece(empty,5,6),piece(empty,5,7),piece(empty,5,8)],
    [piece(empty,6,1),piece(empty,6,2),piece(empty,6,3),piece(empty,6,4),piece(empty,6,5),piece(empty,6,6),piece(empty,6,7),piece(empty,6,8)],
    [piece(empty,7,1),piece(empty,7,2),piece(empty,7,3),piece(empty,7,4),piece(empty,7,5),piece(empty,7,6),piece(empty,7,7),piece(empty,7,8)],
    [piece(ninja,8,1),piece(ninja,8,2),piece(ninja,8,3),piece(ninja,8,4),piece(ninja,8,5),piece(ninja,8,6),piece(ninja,8,7),piece(ninja,8,8)] ].

% letter(?Type, ?Char)
letter(samurai, 's').
letter(ninja,   'n').
letter(empty,   '_').

% playGame(playerTurn, Board, player1Points, player2Points).
playGame(_, _, Points1, _):-
    Points1 == 4,
    write('\nSamurais WON!\n').

playGame(_, _, _, Points2):-
    Points2 == 4,
    write('\nNinjas WON!\n').

start :- playGame(samurai, Board, 0, 0).