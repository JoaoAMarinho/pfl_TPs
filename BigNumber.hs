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

somaBN, subBN :: BigNumber -> BigNumber -> BigNumber

somaBN bn1 bn2 | fst bn1 == fst bn2 = (fst bn1, auxSoma numbers1 numbers2 0)
               | otherwise = subBN bn1 bn2
               where numbers1 = snd bn1 ++ repeat 0
                     numbers2 = snd bn2 ++ repeat 0

auxSoma :: [Int] -> [Int] -> Int -> [Int]
auxSoma (0:xs) (0:ys) 0 = []
auxSoma (0:xs) (0:ys) carry = [carry]
auxSoma (x:xs) (y:ys) carry | soma > 9 = [mod soma 10] ++ auxSoma xs ys newCarry
                            | otherwise = [soma] ++ auxSoma xs ys 0
                            where soma = x + y + carry
                                  newCarry = div soma 10

subBN bn1 bn2 | fst bn1 /= fst bn2 = somaBN bn1 (not (fst bn2), snd bn2)
							| numbers1==numbers2 = (True, [0])
							| length numbers1 > length numbers2 = auxSub bn1 bn2
							| length numbers2 > length numbers1 = auxSub bn2 bn1
							| maior numbers1 numbers2 = auxSub bn1 bn2
							| otherwise = auxSub bn2 bn1
							where numbers1 = snd bn1
							      numbers2 = snd bn2

maior :: [Int] -> [Int] -> [Int]
maior [] [] = False
maior (x:xs) (y:ys) | x>y = True
							      | otherwise maior xs ys

-- mulBN :: BigNumber -> BigNumber -> BigNumber

-- divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)


-- multiplica por um escalar
-- auxMult :: Int -> [Int] -> [Int]
-- auxMult s [] = []
-- auxMult s (x:xs) = somaBN (toBN (s*x)) (0 : auxMult s xs)
--
-- multBN :: [Int] -> [Int] -> [Int]
-- multBN [] _ = []
-- multBN (x:xs) ys = somaBN (auxMult x ys) (0: multBN xs ys)
