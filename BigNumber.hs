-- ainda não está de acordo com as regras do enunciado, foi só um rascunho

toBN :: Int -> [Int]
toBN n = if n < 10 then [n]
		 else [mod n 10] ++ toBN (div n 10)  
 
auxSum :: [Int] -> [Int] -> [Int]
auxSum [] [] = []
auxSum (x:xs) [] = x:xs
auxSum [] (y:ys) = y:ys
auxSum (x:xs) (y:ys) = (x+y) : auxSum xs ys

sumBN :: [Int] -> [Int] -> [Int]
sumBN [] [] = []
sumBN (x:xs) [] = x:xs
sumBN [] (y:ys) = y:ys
sumBN (x:xs) (y:ys) = auxSum (toBN (x+y)) (0 : (sumBN xs ys))

{- 
	[3, 2, 1]
  + [8, 9]
  ____________
    [1, 1]       | (3+8=11 -> [1,1])
	[0, 1, 1]    | (2+9=11 -> [1,1] e acrescentamos um 0 à esquerda porque estamos nas dezenas - na verdade estamos a somar 90+20) 
  + [0, 0, 1]    | (1+0=1 -> [1] e acrescentamos mais um 0 à esquerda porque estamos nas centenas - na verdade estamos a somar 100+0)
  ____________
	[1, 2, 2]    | resultado de somar as várias parcelas obtidas - aqui já não vai haver overflow de unidades para dezenas e dezenas para centenas, daí a função auxiliar

	há maneira de simplificar??
 -}