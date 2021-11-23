import BigNumber(BigNumber, somaBN, subBN, mulBN, divBN, safeDivBN)

-------------------------------- Fibonacci recursive version ------------------------------

fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec (n-1) + fibRec (n-2)

-------------------------------- Fibonacci dynamic version --------------------------------

fibLista :: (Integral a) => a -> a
fibLista n = fromIntegral (dynamicFibList !! (fromIntegral n))
           where dynamicFibList = 0:1:[ (dynamicFibList !! fromIntegral(x-1)) + (dynamicFibList !! fromIntegral(x-2)) | x <- [2..n]]

-------------------------------- Fibonacci infinite version -------------------------------

fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = fromIntegral ( infiniteFibList !! (fromIntegral n))
                   where infiniteFibList = 0 : 1 : zipWith (+) infiniteFibList (tail infiniteFibList)

-------------------------------- Fibonacci recursive version using BigNumber --------------

fibRecBN :: BigNumber -> BigNumber
fibRecBN (True, [0]) = (True, [0])
fibRecBN (True, [1]) = (True, [1])
fibRecBN (True, bn)  = somaBN (fibRecBN (subBN (True, bn) (True, [1])) ) (fibRecBN (subBN (True, bn) (True, [2])) )

-------------------------------- Fibonacci dynamic version using BigNumber ----------------

fibListaBN :: BigNumber -> BigNumber
fibListaBN n = select n dynamicFibListBN
            where dynamicFibListBN = (True, [0]) : (True, [1]) : [ somaBN (select (subBN x (True, [1])) dynamicFibListBN) (select (subBN x (True, [2])) dynamicFibListBN) | x <- rangeBN ]
                  rangeBN = iterateBN (somaBN (True, [1])) (True, [2]) (somaBN n (True, [1]))

-------------------------------- Fibonacci infinite version using BigNumber ---------------

fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN n = select n infiniteFibListBN
                     where infiniteFibListBN = (True, [0]) : (True, [1]) : zipWith (somaBN) infiniteFibListBN (tail infiniteFibListBN)

-------------------------------- Auxiliary functions --------------------------------------

-- Select a BigNumber from a list with index specified by the first argument
select :: BigNumber -> [BigNumber] -> BigNumber
select (True,[0]) xs = head xs
select bn (x:xs)     = select (subBN bn (True, [1])) xs

-- Apply a function to a BigNumber until a certain limit, returning the results in a list
iterateBN :: (BigNumber -> BigNumber) -> BigNumber -> BigNumber  -> [BigNumber]
iterateBN f a limit | a /= limit = a : iterateBN f (f a) limit
                    | otherwise = []
