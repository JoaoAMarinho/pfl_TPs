import Data.Char

type BigNumber = (Bool,[Int])

scanner :: String -> BigNumber
scanner str | isDigit(head str) = ( True, map digitToInt (reverse str) )
            | head str == '+' = ( True, map digitToInt (reverse (tail str)) )
            | head str == '-' = ( False, map digitToInt (reverse (tail str)) )
            | otherwise = error "Invalid input"

output :: BigNumber -> String
output bn | fst bn = reverse numbers
          | not (fst bn) = '-' : reverse numbers
          where numbers = map intToDigit (snd bn)

somaBN, subBN, mulBN :: BigNumber -> BigNumber -> BigNumber

somaBN bn1 bn2 | fst bn1 == fst bn2 = (fst bn1, auxSoma numbers1 numbers2 0)
               | otherwise = subBN bn1 bn2
               where numbers1 = snd bn1 ++ repeat 0
                     numbers2 = snd bn2 ++ repeat 0

subBN bn1 bn2 | fst bn1 /= fst bn2 = somaBN bn1 (not (fst bn2), snd bn2)
							| numbers1 == numbers2 = (True, [0])
							| length numbers1 > length numbers2 = auxSub bn1 bn2
							| length numbers2 > length numbers1 = auxSub bn2 bn1
							| maior numbers1 numbers2 = auxSub bn1 bn2
							| otherwise = auxSub bn2 bn1
							where numbers1 = snd bn1
							      numbers2 = snd bn2

mulBN bn1 bn2 | fst bn1 == fst bn2 = (True, auxMul numbers1 numbers2)
              | otherwise = (False, auxMul numbers1 numbers2)
              where numbers1 = snd bn1
                    numbers2 = snd bn2

-- divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)


-------------------------------- Auxiliar functions --------------------------------

auxSoma :: [Int] -> [Int] -> Int -> [Int]
auxSoma (0:xs) (0:ys) 0 = []
auxSoma (0:xs) (0:ys) carry = [carry]
auxSoma (x:xs) (y:ys) carry | soma > 9 = [mod soma 10] ++ auxSoma xs ys newCarry
                            | otherwise = [soma] ++ auxSoma xs ys 0
                            where soma = x + y + carry
                                  newCarry = div soma 10


-- multiplies every number in the BN by the given scalar
scaleBN :: Int -> [Int] -> [Int]
scaleBN s [] = []
scaleBN s (x:xs) = somaBN mul (0 : scaleBN s xs) carry
                   where mul = mod (s * x) 10
                         carry = div (s * x) 10
          

auxMul :: [Int] -> [Int] -> [Int]
auxMul [] _ = []
auxMul (x:xs) ys = somaBN (scaleBN x ys) (0: auxMul xs ys) 0


-- true if the 1st BN is bigger than the 2nd BN, false otherwise
maior :: [Int] -> [Int] -> [Int]
maior [] [] = False
maior (x:xs) (y:ys) | x>y = True
							      | otherwise = maior xs ys