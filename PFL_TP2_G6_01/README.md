# Shi

## Instalação e execução

## Descrição

Em japonês, a palavra "shi" pode significar, dependendo do contexto, o número 4 ou a palavra "morte". Daí, no Japão, o número 4 ser considerado o número azarento.

Shi trata-se, portanto, de um jogo de tabuleiro, com dimensões de 8x8, no qual samurais, que começam primeiro, enfretam ninjas.

As peças distribuem-se pela primeira fila de cada lado do tabuleiro, ou seja, cada jogador dispõem de 8 peças. Estas podem mover-se tal como a rainha no xadrez, isto é, vertical, horizontal ou diagonalmente, um número de casas arbitrário (desde que livres).

O objetivo do jogo é tentar capturar 4 peças do adversário ou, por outras palavras, este perde quando é reduzido a 4 peças.

As capturas são feitas com _jump attacks_, que consistem em saltar por cima de uma, e uma só, peça "amiga", finalizando o salto em cima da casa do adversário. Podem existir 0 ou mais casas entre a peça sobre a qual ocorre o salto e a peça capturada (este tipo de ataque é muito semelhante ao do canhão no xadrez chinês).

## Regras

- tabuleiro com dimensões 8x8
- jogadores do tipo ninja ou samurai
- samurais começam primeiro a jogar
- cada jogador dispõe de 8 peças
- as peças de cada jogador distribuem-se pela primeira fila do seu lado do tabuleiro
- as peças podem mover-se vertical, horizontal ou diagonalmente
- as peças podem mover-se um número arbitrário de casas, desde que esse caminho não esteja obstruído
- os ataques consistem em saltar por cima de uma, e uma só, peça do próprio tipo, aterrando em cima da casa do adversário
- podem existir 0 ou mais casas entre a peça capturada e a peça sobre a qual ocorre o salto
- um jogador perde quando reduzido a 4 peças

## Lógica do Jogo

### Representação interna do estado do jogo

O estado do jogo é representado por uma variável composta com a seguinte estrutura: `Board-Size-Points1-Points2-Type`

`Board` - lista de listas, com átomos do tipo `piece(empty)`, `piece(samurai)` ou `piece(ninja)`, que representam, intuitiva e respetivamente, uma peça vazia, uma peça samurai e uma peça ninja;

`Size` - tamanho do tabuleiro, escolhido pelo o utilizador;

`Points1` - pontos do primeiro jogador, no estado atual;

`Points2` - pontos do segundo jogador, no estado atual;

`Type` - tipo de peça, `piece(samurai)` ou `piece(ninja)`, a ser jogada pelo jogador que tem a vez de jogar no estado atual.

### Visualização do estado de jogo

#### MENUS

A interação programa - utilizador inicia-se nos menus, nos quais vai sendo pedida ao utilizador que selecione um conjunto de informação necessária à inicialização do estado do jogo.

A transição entre menus é feita com recurso ao predicado `change_menu`, que implementa uma máquina de estados tal que, em função da opção selecionada pelo utilizador e do menu onde este se encontra no momento dessa seleção, sabe qual o menu que se segue.

Nos menus, a interação com o utilizador começa com o predicado `display_menu`, que recebe um menu como parâmetro e sabe qual o ficheiro que há a ser lido para efetuar o respetivo display. No que toca a validação de _inputs_, dado que o conceito de _input_ válido varia conforme o menu em questão, os predicados que implementam esta funcionalidade são chamados, da forma adequada, no predicado de cada menu em específico.

Por exemplo, no menu `main`, o utlizador apenas tem que introduzir um dígito, de 1 a 5 - `read_digit_between(1, 5, Value)` e pressionar _enter_ - `read_specific_char('\n')`.

```
main:-
    display_menu(main),
    repeat,
    read_digit_between(1, 5, Value),
    read_specific_char('\n'),
    change_menu(Value, main).
```

Já no menu `bot-bot`, o utlizador tem que introduzir um dígito, de 1 a 3 - `read_digit_between(1, 3, Value)`, correspondente à dificuldade ou, no caso do 3, à opção de voltar atrás, e um '-', seguido de um dígito de 1 a 2, para indicar qual será o primeiro jogador a jogar e pressionar enter - `read_aux(Value, Res)`. Este último predicado foi implementado para lidar com o facto de existirem, neste menu e não só, dois cenários válidos de _input_ - aquele em que o utilizador pretende voltar para trás e, como tal, apenas introduz a entrada do menu correspondente e pressiona _enter_ e aquele em que o utilizador seleciona o nível e o primeiro jogador, separados pelo caracter referido, e pressiona
para confirmar a sua escolha.

```
bot_bot:-
    display_menu(bot_bot),
    repeat,
    read_digit_between(1, 3, Value),
    read_aux(Value, Res),
    change_menu(Res, bot_bot).
```

#### TABULEIRO

Em situação de jogo, a interação com o utlizador, se aplicável, é feita com recurso ao predicado `choose_move(GameState, Player, Move)`, que recebe o atual estado do jogo - `GameState`, o jogador com a vez de jogar - `Player` e retorna em `Move` o _move_ selecionado pelo utilizador, no formato `[coordenada x de origem]-[coordenada y de origem]/[coordenada x de destino]-[coordenada y de destino]`. A validação do _input_ de jogada, apenas no que toca ao formato e à verificação de se as coordenadas se encontram dentro dos limites do tabuleiro, é feita pelo predicado `read_move(X, Y, Nx, Ny, Size)`, cujo funcionamento é muito semelhante ao já explicado para os menus.

Já a validação da jogada, no que toca a se esta pode ser levada a cabo ou não, e a sua efetivação são feitas pelo predicado `move(GameState, Move, NewGameState)`, o qual será explicado com mais detalhe na secção abaixo.

Por último, o predicado de visualização geral do jogo é o `display_game(GameState)`, que recebe o estado atual do jogo para dar _display_. Este predicado divide essa tarefa por outros dois predicados, `print_turn(Board, Size)` e `print_turn(Type)`, que fazem, respetivamente, o _display_ do tabuleiro e o _display_ de uma mensagem indicativa do jogador que tem a vez de jogar.

### Execução de Jogadas

A validação e execução de uma jogada, obtendo o novo estado do jogo, está a cargo do predicado `move(GameState, Move, NewGameState)`.

Este predicado está estruturado na chamada aos seguintes predicados:

- `piece_in_board(Board, Type, X, Y)`, que verifica se nas coordenadas X e Y de origem se encontra efetivamente uma peça pertencente ao jogador;

- `valid_piece_move(Type, Board, Size, Move)`, que faz a validação da jogada, verificando se o _move_ requerido é um dos _moves_ permitidos para as coordenadas de origem selecionadas (o funcionamento deste predicado será explicado com mais detalhe na secção **Lista de Jogadas Válidas**);

- `move_piece(Type, Board, Move, NewBoard, Piece)`, que efetiva a execução da jogada, retornando em `Piece` a peça que estava nas coordenadas de destino para as quais o jogador moveu uma das suas peças;

- `update_points(Type, Piece, Points1, Points2, NewPoints1, NewPoints2)`, que atualiza os pontos de cada um dos jogadores, valores esses que são retornados em `NewPoints1` e `NewPoints2`, correspondentes, respetivamente, aos pontos do primeiro jogador e do segundo jogador.

### Final do Jogo

A terminação do jogo é verificada a cada iteração do seu ciclo, com recurso ao predicado `game_over(GameState, Winner)`, que recebe o estado atual do jogo e retorna, se aplicável, em `Winner`, o vencedor.

Dado que os pontos de cada um dos jogadores fazem parte da própria variável `GameState` e, como tal, estão sempre atualizados de acordo com a jogada acaba de executar, esta avaliação reduz-se a verificar se os pontos de qualquer um dos jogadores é o `ceiling` do tamanho, `Size`, do tabuleiro a dividir por 2 - por exemplo, um jogo num tabuleiro 8x8 termina quando um dos jogadores for reduzido a 4 peças.

```
game_over(_-Size-Points1-_-_, samurai):-
    FinalPoints is ceiling(Size/2),
    Points1 == FinalPoints, !.

game_over(_-Size-_-Points2-_, ninja):-
    FinalPoints is ceiling(Size/2),
    Points2 == FinalPoints, !.
```

No caso de se tratar do final do jogo, é mostrado uma última vez o tabuleiro e uma mensagem a indicar quem foi o vencedor.

### Lista de Jogadas Válidas

### Avaliação do Estado do Jogo

### Jogada do Computador

## Conclusões

## Bibliografia

## Trabalho realizado por:

- João Marinho (up201905952) - 55%

- Margarida Vieira (up201907907) - 45%
