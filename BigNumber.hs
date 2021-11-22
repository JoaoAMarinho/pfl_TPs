module BigNumber(BigNumber, somaBN, subBN, mulBN, divBN, safeDivBN) where
import Data.Char

--BigNumber definition
type BigNumber = (Bool,[Int])

scanner :: String -> BigNumber
scanner str | isDigit(head str) = (True, map digitToInt str)       -- String starts with digit
            | head str == '+' = (True, map digitToInt (tail str))  -- Strings starts with a '+' (positive number)
            | head str == '-' = (False, map digitToInt (tail str)) -- String starts with a '-' (negative number)
            | otherwise = error "Invalid input"                    -- Invalid input

output :: BigNumber -> String
output bn | fst bn = numbers          -- Positive number
          | otherwise = '-' : numbers -- Negative number
          where numbers = map intToDigit (snd bn)

somaBN, subBN, mulBN :: BigNumber -> BigNumber -> BigNumber

somaBN bn1 bn2 | fst bn1 == fst bn2 = (fst bn1, reverse (auxSoma numbers1 numbers2 0)) -- Same signal
               | otherwise = subBN bn1 (not (fst bn2), snd bn2)                        -- Different signals is basically a subtraction
               where numbers1 = reverse (snd bn1)
                     numbers2 = reverse (snd bn2)

subBN bn1 bn2 | numbers1 == numbers2 && fst bn1 == fst bn2 = (True, [0])                    -- Symmetric numbers
              | fst bn1 /= fst bn2 = somaBN bn1 (not (fst bn2), snd bn2)                    -- Different signals is basically a sum
              | maior (snd bn1) (snd bn2) = (fst bn1, reverse (auxSub numbers1 numbers2 0)) -- Same signal and bn1 greater than bn2
              | otherwise = (not (fst bn2), reverse (auxSub numbers2 numbers1 0))           -- bn2 greater or equal to bn1
              where numbers1 = reverse (snd bn1)
                    numbers2 = reverse (snd bn2)


mulBN bn1 bn2 | numbers1 == [0] || numbers2 == [0] = (True, [0])                -- Multiplication by zero
              | fst bn1 == fst bn2 = (True, reverse (auxMul numbers1 numbers2)) -- Same signal
              | otherwise = (False, reverse (auxMul numbers1 numbers2))         -- Different signals
              where numbers1 = reverse (snd bn1)
                    numbers2 = reverse (snd bn2)

divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)

divBN bn1 bn2 | bn2 == (True, [1]) = (bn1, (True, [0]))                     -- Divison by one
              | bn1 == bn2 = ((True, [1]), (True,[0]))                      -- Divison by itself
              | maior numbers1 numbers2 = ((True, fst res),(True, snd res)) -- bn1 greater than bn2
              | otherwise = ((True, [0]), bn1)                              -- bn2 greater than bn1 (quocient is 0 with bn1 as remainder)
                where numbers1 = (snd bn1)
                      numbers2 = (snd bn2)
                      res = auxDiv numbers1 numbers2 [] []

safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
safeDivBN bn1 (_, [0]) = Nothing           -- Divison by zero
safeDivBN bn1 bn2 =   Just (divBN bn1 bn2) -- Divison by a number not zero


-------------------------------- Auxiliary functions --------------------------------

-- Auxiliary function for sum
auxSoma :: [Int] -> [Int] -> Int -> [Int]
auxSoma [] [] carry = if carry == 0 then [] else [carry]
auxSoma (x:xs) [] carry = [mod (x + carry) 10] ++ auxSoma xs [] (div (x + carry) 10)
auxSoma [] (y:ys) carry = [mod (y + carry) 10] ++ auxSoma [] ys (div (y + carry) 10)
auxSoma (x:xs) (y:ys) carry | soma > 9 = [mod soma 10] ++ auxSoma xs ys newCarry
                            | otherwise = [soma] ++ auxSoma xs ys 0
                            where soma = x + y + carry
                                  newCarry = div soma 10

-- Auxiliary function for subtraction
auxSub :: [Int] -> [Int] -> Int -> [Int]
auxSub [] [] _ = []
auxSub (x:[]) [] carry = if ((x - carry) == 0) then [] else [x - carry]
auxSub (x:[]) (y:[]) carry = if (x - (y + carry) == 0) then [] else [x - (y + carry)]
auxSub (x:xs) ys carry | soma > x = [x + 10 - soma] ++ auxSub xs ys_ 1
                       | otherwise = [x - soma] ++ auxSub xs ys_ 0
                       where soma = if (ys == []) then carry else (head ys + carry)
                             ys_ = if (ys == []) then [] else (tail ys)

-- Auxiliary function for multiplication
auxMul :: [Int] -> [Int] -> [Int]
auxMul xs ys = foldl (\x (y,i) -> auxSoma x ((take i (repeat 0)) ++ y) 0) [] (zip [scaleBN x ys 0 | x <- xs] [0,1..])

-- Auxiliary function for division
auxDiv :: [Int] -> [Int] -> [Int] -> [Int] -> ([Int], [Int])
auxDiv [] _ resto quociente = (dropWhile (==0) quociente, resto)
auxDiv (x:xs) divisor dividendo q | newDividendo == divisor = auxDiv xs divisor [] (q++[1])
                                  | maior newDividendo divisor = auxDiv xs divisor (fst divison) (q++[snd divison])
                                  | otherwise = auxDiv xs divisor newDividendo (q++[0])
                                  where newDividendo =  (dropWhile (==0) dividendo)++[x]
                                        divison = subUntil newDividendo divisor 0

-- Subtract two lists representing a number, returning the remainder and the number of subtracions
subUntil :: [Int] -> [Int] -> Int -> ([Int], Int)
subUntil dividendo divisor i | dividendo == divisor = ([0], i+1)
                             | maior dividendo divisor = subUntil (reverse (auxSub revDividendo revDivisor 0)) divisor (i + 1)
                             | otherwise = (dividendo, i)
                             where revDividendo = (reverse dividendo)
                                   revDivisor = (reverse divisor)

-- Multiplies a list representing a number by a scalar
scaleBN :: Int -> [Int] -> Int -> [Int]
scaleBN s [] carry = if (carry == 0) then [] else [carry]
scaleBN s (x:xs) carry = [mul] ++ scaleBN s xs newCarry
                        where mul = mod (s * x + carry) 10
                              newCarry = div (s * x + carry) 10

-- Checks if the first list representing a number is bigger than the second
maior :: [Int] -> [Int] -> Bool
maior [] [] = False
maior (x:xs) (y:ys) | length (x:xs) > length (y:ys) = True
                   | length (y:ys) > length (x:xs) = False
                   | x > y = True
                   | y > x = False
                   | otherwise = maior xs ys
