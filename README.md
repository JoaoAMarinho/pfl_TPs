# Fibonacci

## Recursão

## Programação dinâmica

## Lista por compreensão

# BigNumber

## scanner e output



## somaBN

Esta função começa por fazer uma verificação dos parâmetros recebidos.

No caso de ambos os BNs serem positivos, é invocada a função auxiliar, `auxSoma`. Caso contrário, lida-se com a soma como se fosse uma subtração.

A função `auxSoma` recebe os dois BNs sobre os quais incidirá a operação e um parâmetro destinado a guardar o _carry_ resultante da soma da iteração atual.

## subBN

Esta função, à semelhança da `somaBN`, começa também por fazer uma verificação inicial dos parâmetros.

As seguintes condições foram tidas em conta:

- no caso dos números serem simétricos, a sua subtração resulta no BN correspondente a 0;

- se os BNs tiverem sinais opostos, a operação resume-se a uma soma, trocando o sinal do segundo parâmetro;

- se o primeiro BN for maior do que o segundo, então conseguimos garantir que o sinal do BN resultante será o mesmo que o do primeiro e é chamada a função auxiliar `auxSub` para efetivar o cálculo;

- caso contrário, o sinal do BN resultante será o contrário do do segundo e é chamada a função auxiliar `auxSub` para efetivar o cálculo;

## mulBN

Na função de multiplicação, as seguintes condições foram tidas em conta:

- se um dos parâmetros for o elemento absorvente da multiplicação, ou seja, 0, não é efetuada qualquer tipo de operação dado que o resultado é, garantidamente, 0;

- para além disso, é ainda efetuada uma verificação do sinal dos parâmetros - multiplicação de dois BNs com sinal igual resultará num BN com sinal positivo e multiplicação de dois BNs com sinal diferente resultará num BN com sinal negativo.

Também para efetuar a divisão recorremos às funções auxiliares `auxDiv` e `subUntil`.

## divBN

Na função de multiplicação, as seguintes condições foram tidas em conta:

- divisão pelo BN correspondente a 1 resulta no mesmo BN;

- se o dividendo for maior que o divisor, então é efetivada a operação;

- se, pelo contrário, o dividendo for menor que o divisor, o resultado da operação é o BN correspondente a 0 e o resto da divisão é o próprio dividendo.
