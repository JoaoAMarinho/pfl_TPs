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
* Validates if a piece is in the given board at the specified coords: 
* piece_in_board(+Board, +Type, +X, +Y).
*/
piece_in_board(Board, Type, X, Y):-
    nth1(Y, Board, Row),
    \+nth1(X, Row, piece(Type)), !,
    write('Incorrect position!\n'), fail.

piece_in_board(Board, Type, X, Y).

/*
* Returns the new turn after the samurais play, according to the current mode: 
* change_turn(+Mode, -NewTurn).
*/
change_turn(pvp,  ninja).
change_turn(easy, bot).
change_turn(hard, bot).

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

play_game(samurai, Board, Player1Points, Player2Points, Mode):- % play piece according to player turn
    print_board(Board),
    write('\nSamurais turn\n'),
    repeat,
    read_move(X, Y, Nx, Ny),
    piece_in_board(Board, samurai, X, Y),
    valid_piece_move(samurai, Board, X, Y, Nx, Ny),!,
    move_piece(samurai, Board, X, Y, Nx, Ny, NewBoard, Player1Points, NewPlayer1Points),
    change_turn(Mode, NewTurn),
    play_game(NewTurn, NewBoard, NewPlayer1Points, Player2Points, Mode).

play_game(ninja, Board, Player1Points, Player2Points, Mode):- % play piece according to player turn
    print_board(Board),
    write('\nNinjas turn\n'),
    repeat,
    read_move(X, Y, Nx, Ny),
    piece_in_board(Board, ninja, X, Y),
    valid_piece_move(ninja, Board, X, Y, Nx, Ny),!,
    move_piece(ninja, Board, X, Y, Nx, Ny, NewBoard, Player2Points, NewPlayer2Points),
    play_game(samurai, NewBoard, Player1Points, NewPlayer2Points, Mode).

play_game(bot, Board, Player1Points, Player2Points, Mode):- % play piece according to player turn
    print_board(Board),
    write('\Bot turn\n'),
    repeat,
    read_move(X, Y, Nx, Ny),
    piece_in_board(Board, ninja, X, Y),
    valid_piece_move(ninja, Board, X, Y, Nx, Ny),!,
    move_piece(ninja, Board, X, Y, Nx, Ny, NewBoard, Player2Points, NewPlayer2Points),
    play_game(samurai, NewBoard, Player1Points, NewPlayer2Points, Mode).

/*
* Game starter:
* game(+Mode).
*/
game(Mode):- build_board(Board), play_game(samurai, Board, 0, 0, Mode).
