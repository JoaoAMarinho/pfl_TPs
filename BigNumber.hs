import Data.Char

type BigNumber = (Bool,[Int])

scanner :: String -> BigNumber
scanner str | isDigit(head str) = (True, map digitToInt str)
            | head str == '+' = (True, map digitToInt (tail str))
            | head str == '-' = (False, map digitToInt (tail str))
            | otherwise = error "Invalid input"

output :: BigNumber -> String
output bn | fst bn = numbers
          | otherwise = '-' : numbers
          where numbers = map intToDigit (snd bn)

somaBN, subBN, mulBN :: BigNumber -> BigNumber -> BigNumber

somaBN bn1 bn2 | fst bn1 == fst bn2 = (fst bn1, reverse (auxSoma numbers1 numbers2 0))
               | otherwise = subBN bn1 (not (fst bn2), snd bn2)
               where numbers1 = reverse (snd bn1)
                     numbers2 = reverse (snd bn2)

subBN bn1 bn2 | numbers1 == numbers2 && fst bn1 == fst bn2 = (True, [0]) -- symmetric numbers
              | fst bn1 /= fst bn2 = somaBN bn1 (not (fst bn2), snd bn2)
              | maior (snd bn1) (snd bn2) = (fst bn1, reverse (auxSub numbers1 numbers2 0))
              | otherwise = (not (fst bn2), reverse (auxSub numbers2 numbers1 0))
              where numbers1 = reverse (snd bn1)
                    numbers2 = reverse (snd bn2)


mulBN bn1 bn2 | numbers1 == [0] || numbers2 == [0] = (True, [0])
              | fst bn1 == fst bn2 = (True, reverse (auxMul numbers1 numbers2))
              | otherwise = (False, reverse (auxMul numbers1 numbers2))
              where numbers1 = reverse (snd bn1)
                    numbers2 = reverse (snd bn2)

divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)

divBN bn1 (True, [1]) = (bn1, (True, [0]))
divBN bn1 bn2 | maior numbers1 numbers2 = ((True, fst res),(True, snd res))
              | otherwise = ((True, [0]), bn1)
                where numbers1 = (snd bn1)
                      numbers2 = (snd bn2)
                      res = auxDiv numbers1 numbers2 [] []


-------------------------------- Auxiliar functions --------------------------------

auxSoma :: [Int] -> [Int] -> Int -> [Int]
auxSoma [] [] carry = if carry == 0 then [] else [carry]
auxSoma (x:xs) [] carry = [mod (x + carry) 10] ++ auxSoma xs [] (div (x + carry) 10)
auxSoma [] (y:ys) carry = [mod (y + carry) 10] ++ auxSoma [] ys (div (y + carry) 10)
auxSoma (x:xs) (y:ys) carry | soma > 9 = [mod soma 10] ++ auxSoma xs ys newCarry
                            | otherwise = [soma] ++ auxSoma xs ys 0
                            where soma = x + y + carry
                                  newCarry = div soma 10


auxSub :: [Int] -> [Int] -> Int -> [Int]
auxSub [] [] _ = []
auxSub (x:[]) [] carry = if ((x - carry) == 0) then [] else [x - carry]
auxSub (x:[]) (y:[]) carry = if (x - (y + carry) == 0) then [] else [x - (y + carry)]
auxSub (x:xs) ys carry | soma > x = [x + 10 - soma] ++ auxSub xs ys_ 1
                       | otherwise = [x - soma] ++ auxSub xs ys_ 0
                       where soma = if (ys == []) then carry else (head ys + carry)
                             ys_ = if (ys == []) then [] else (tail ys)


-- multiplies every number in the BN by the given scalar
scaleBN :: Int -> [Int] -> Int -> [Int]
scaleBN s [] carry = if (carry == 0) then [] else [carry]
scaleBN s (x:xs) carry = [mul] ++ scaleBN s xs newCarry
                         where mul = mod (s * x + carry) 10
                               newCarry = div (s * x + carry) 10

auxMul :: [Int] -> [Int] -> [Int]
auxMul xs ys = foldl (\x (y,i) -> auxSoma x ((take i (repeat 0)) ++ y) 0) [] (zip [scaleBN x ys 0 | x <- xs] [0,1..])


-- true if the first BN is bigger than the second BN, false otherwise
maior :: [Int] -> [Int] -> Bool
maior [] [] = False
maior (x:xs) (y:ys) | length (x:xs) > length (y:ys) = True
                    | length (y:ys) > length (x:xs) = False
                    | x > y = True
                    | y > x = False
                    | otherwise = maior xs ys

auxDiv :: [Int] -> [Int] -> [Int] -> [Int] -> ([Int], [Int])
auxDiv [] _ resto quociente = (dropWhile (==0) quociente, resto)
auxDiv (x:xs) divisor dividendo q | newDividendo == divisor = auxDiv xs divisor [] (1:q)
                                  | maior newDividendo divisor = auxDiv xs divisor (fst divison) (q++[snd divison])
                                  | otherwise = auxDiv xs divisor newDividendo q
                                  where newDividendo = dividendo++[x]
                                        divison = subUntil newDividendo divisor 0

subUntil :: [Int] -> [Int] -> Int -> ([Int], Int)
subUntil dividendo divisor i | dividendo == divisor = ([0], i+1)
                             | maior dividendo divisor = subUntil (reverse (auxSub revDividendo revDivisor 0)) divisor (i + 1)
                             | otherwise = (dividendo, i)
                             where revDividendo = (reverse dividendo)
                                   revDivisor = (reverse divisor)
