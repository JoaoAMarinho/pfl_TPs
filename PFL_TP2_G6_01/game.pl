:- [parser].
:- [board_view].
:- [movement].

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

/*
* Prints player turn message:
* print_turn(+Type).
*/
print_turn(samurai):- write('\nSamurais turn\n').
print_turn(ninja):- write('\nNinjas turn\n').
print_turn(bot):- write('\nBot turn\n').

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

/*
* Returns the new type of player after piece play: 
* change_type(+Type, +Mode, -NewType).
*/
change_type(samurai, pvp, ninja).
change_type(ninja, pvp, samurai).
change_type(bot, _, samurai).
change_type(samurai, _, bot).

/*
* Game handler:
* play_game(+playerTurn, +Board, +Player1Points, +Player2Points).
*/
play_game(_, _, Points1, _, _):- % check if game has ended
    Points1 == 4,
    write('\nSamurais WON!\n').

play_game(_, _, _, Points2, _):- % check if game has ended
    Points2 == 4,
    write('\nNinjas WON!\n').

play_game(Type, Board, Player1Points, Player2Points, Mode):- % play piece according to player turn
    print_board(Board),
    print_turn(Type),
    game_cyle(Mode, Type, Board, Player1Points, Player2Points).

/*
* Game cycle according to current mode:
* game_cyle(+Mode, +Type, +Board, +Player1Points, +Player2Points).
*/
game_cyle(pvp, Type, Board, Player1Points, Player2Points):-
    repeat,
    read_move(X, Y, Nx, Ny),
    piece_in_board(Board, Type, X, Y),
    valid_piece_move(Type, Board, X, Y, Nx, Ny, Piece),!,
    execute_play(Type, Piece, Board, X, Y, Nx, Ny, Player1Points, Player2Points, pvp).

# game_cyle(Difficulty, bot):-
#     find_best_move(),
#     execute_play().

execute_play(Type, Piece, Board, X, Y, Nx, Ny, Player1Points, Player2Points, Mode):-
    move_piece(Type, Piece, Board, X, Y, Nx, Ny, NewBoard),
    update_points(Type, Piece, Player1Points, Player2Points, NewPlayer1Points, NewPlayer2Points),
    change_type(Type, Mode, NewType),
    play_game(NewType, NewBoard, NewPlayer1Points, NewPlayer2Points, Mode).


/*
* Game starter:
* game(+Mode).
*/
game(Mode):- build_board(Board), play_game(samurai, Board, 0, 0, Mode).
