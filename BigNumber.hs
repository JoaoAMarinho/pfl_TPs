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
somaCarry :: Int -> BigNumber -> BigNumber
somaCarry c [] = [c]
somaCarry c (x:xs) = (x+c):xs

somaBN :: [Int] -> [Int] -> [Int]
somaBN [] [] = []
somaBN (x:xs) [] = x:xs
somaBN [] (y:ys) = y:ys
somaBN (x:xs) (y:ys) = if (x+y) > 9 then [mod (x+y) 10] ++ somaBN xs ys_
                      else [x+y] ++ somaBN xs ys
                      where ys_ = somaCarry (div (x+y) 10) ys

-- multiplica por um escalar
auxMult :: Int -> [Int] -> [Int]
auxMult s [] = []
auxMult s (x:xs) = somaBN (toBN (s*x)) (0 : auxMult s xs)
                 
multBN :: [Int] -> [Int] -> [Int]
multBN [] _ = []
multBN (x:xs) ys = somaBN (auxMult x ys) (0: multBN xs ys)