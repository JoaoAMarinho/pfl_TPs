
letters_path(Path):- Path = 'D:/Escola/Faculdade/3_Ano/1_Semestre/PFL/PFL_TPs_G6_01/PFL_TP2_G6_01/assets/board_letters.txt'. 

% print current board status
print_board(Board):-
    clear_screen,
    print_top_bar,
    print_rows(Board),
    print_letters.

/*
* Prints top bar (i.e. the first line) of the board:
* print_top_bar.
*/ 
print_top_bar:-
  print_n_times(' ', 11),
  print_n_times(' ___________ ', 8), nl.

/*
* Prints the X coords of the board:
* print_letters.
*/
print_letters:-
    letters_path(Path),
    read_from_file(Path).

/*
* Prints all rows from a board:
* print_rows(+Board).
*/
print_rows(Board):-
    print_rows(Board, 8).

print_row([Row], Index):-
    print_lines(Row, Index), !.

print_rows([Row|List], Index):-
    print_row(Row, Index),
    NextIndex is Index - 1,
    print_rows(List, NextIndex).
    
/*
* Prints all lines depending on the row:
* print_lines(+Row, +RowIndex).
*/
print_lines(Row, RowIndex):- 
    print_line(Row, RowIndex, 5), nl,
    print_line(Row, RowIndex, 4), nl,
    print_line(Row, RowIndex, 3), nl,
    print_line(Row, RowIndex, 2), nl,
    print_line(Row, RowIndex, 1), nl.

/*
* Prints a single line depending on the row and line index:
* print_line(+Row, +RowIndex, +LineIndex).
*/
print_line(Row, 8, 5):- write('      _    '), print_cols(Row, 8, 5), !. 
print_line(Row, 8, 4):- write('     (_)   '), print_cols(Row, 8, 4), !.
print_line(Row, 8, 3):- write('     (_)   '), print_cols(Row, 8, 3), !.
 
print_line(Row, 7, 5):- write('      __   '), print_cols(Row, 7, 5), !. 
print_line(Row, 7, 4):- write('       /   '), print_cols(Row, 7, 4), !.
print_line(Row, 7, 3):- write('      /    '), print_cols(Row, 7, 3), !. 

print_line(Row, 6, 4):- write('      /    '), print_cols(Row, 6, 4), !.
print_line(Row, 6, 3):- write('     (_)   '), print_cols(Row, 6, 3), !.

print_line(Row, 5, 5):- write('      _    '), print_cols(Row, 5, 5), !.
print_line(Row, 5, 4):- write('     |_    '), print_cols(Row, 5, 4), !.
print_line(Row, 5, 3):- write('      _)   '), print_cols(Row, 5, 3), !.

print_line(Row, 4, 5):- write('       .   '), print_cols(Row, 4, 5), !.
print_line(Row, 4, 4):- write('      /|   '), print_cols(Row, 4, 4), !.
print_line(Row, 4, 3):- write('     \'-|   '), print_cols(Row, 4, 3), !.

print_line(Row, 3, 5):- write('      _    '), print_cols(Row, 3, 5), !.
print_line(Row, 3, 4):- write('      _)   '), print_cols(Row, 3, 4), !.
print_line(Row, 3, 3):- write('      _)   '), print_cols(Row, 3, 3), !.

print_line(Row, 2, 5):- write('      _    '), print_cols(Row, 2, 5), !.
print_line(Row, 2, 4):- write('       )   '), print_cols(Row, 2, 4), !.
print_line(Row, 2, 3):- write('      /_   '), print_cols(Row, 2, 3), !.

print_line(Row, 1, 4):- write('      /|   '), print_cols(Row, 1, 4), !.
print_line(Row, 1, 3):- write('       |   '), print_cols(Row, 1, 3), !.

print_line(Row, 1, 1):- !.

print_line(Row, RowIndex, 1):- 
    print_n_times(' ', 11), 
    print_n_times('|-----------|', 8), !.

print_line(Row, RowIndex, LineIndex):-
    print_n_times(' ', 11),
    print_cols(Row, RowIndex, LineIndex), !.

/*
* Prints all 8 columns of a row:
* print_cols(+Pieces, +RowIndex, +LineIndex).
*/
print_cols([Piece], RowIndex, LineIndex):-
    print_col(Piece, RowIndex, LineIndex).
    
print_cols([Piece|Pieces], RowIndex, LineIndex):-
    print_col(Piece, RowIndex, LineIndex),
    print_cols(Pieces, RowIndex, LineIndex).

/*
* Prints a column depending on the current piece:
* print_col(+Piece, +RowIndex, +LineIndex).
*/
print_col(piece(empty), _, _):- write('|           |').

print_col(piece(samurai), _, 5):- write('|  /_\\      |').
print_col(piece(samurai), _, 4):- write('| [-_-]     |').
print_col(piece(samurai), _, 3):- write('| --|-ol==> |').
print_col(piece(samurai), 1, 2):- write('|__/ \\______|').
print_col(piece(samurai), _, 2):- write('|  / \\      |').

print_col(piece(ninja), _, 5):- write('|    //     |').
print_col(piece(ninja), _, 4):- write('|   [-*-]~  |').
print_col(piece(ninja), _, 3):- write('|  x--|--   |').
print_col(piece(ninja), 1, 2):- write('|____/ \\____|').
print_col(piece(ninja), _, 2):- write('|    / \\    |').

/*
* Prints a string/char n times to the output stream:
* print_n_times(+Value, +Count).
*/
print_n_times(_, 0).

print_n_times(Value, Count):-
    write(Value),
    NewCount is Count - 1,
    print_n_times(Value, NewCount).

/*
* Prints the content of a file given by the Path:
* read_from_file(+Path).
*/
read_from_file(Path):-
    nl,
    open(Path, read, Stream),
    print_file(Stream),
    close(Stream),
    nl.

/*
* Reads and prints the content of a stream until the end:
* read_from_file(+Path).
*/
print_file(Stream):-
    peek_code(Stream,-1).

print_file(Stream):-
    get_char(Stream, Char),
    write(Char),
    print_file(Stream).

/*
* Clears the screen:
* clear_screen.
*/
clear_screen:- write('\33\[2J').