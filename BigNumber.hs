import Data.Char

type BigNumber = [Int] 

scanner :: String -> BigNumber
scanner [] = []
scanner (x:xs) = scanner xs ++ [digitToInt x]

output :: BigNumber -> String
output [] = []
output (x:xs) = output xs ++ [intToDigit x]

-- somaBN :: BigNumber -> BigNumber -> BigNumber

-- subBN :: BigNumber -> BigNumber -> BigNumber

-- mulBN :: BigNumber -> BigNumber -> BigNumber

-- divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)


--  só um rascunho

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



auxMult :: Int -> [Int] -> [Int]
auxMult s [] = []
auxMult s (x:xs) = sumBN (toBN (s*x)) (0 : auxMult s xs)
                 
multBN :: [Int] -> [Int] -> [Int]
multBN [] _ = []
multBN (x:xs) ys = sumBN (auxMult x ys) (0: multBN xs ys)