import BigNumber(BigNumber, somaBN, subBN, mulBN, divBN, safeDivBN)
-------------------------------- Fibonacci recursive version --------------------------------
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec (n-1) + fibRec (n-2)


-------------------------------- Fibonacci dynamic version --------------------------------
dynamicFibList = 0:1:[ n | x <- [2..], let n = ((dynamicFibList !! (x-1)) + (dynamicFibList !! (x-2)))]

fibLista :: (Integral a) => a -> a
fibLista n = fromIntegral ((!!) dynamicFibList (fromIntegral n))

-- fibLista i = (!!) (0 : 1 : [ 10 | v<-[2..i]]) (fromIntegral i)


-------------------------------- Fibonacci infinite version --------------------------------
infiniteFibList = 0 : 1 : zipWith (+) infiniteFibList (tail infiniteFibList)

fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = fromIntegral ( infiniteFibList !! (fromIntegral n))


----------------------------------- BigNumber Version ------------------------------------

fibRecBN :: BigNumber -> BigNumber
fibRecBN (True, [0]) = (True, [0])
fibRecBN (True, [1]) = (True, [1])
fibRecBN (True, bn)  = somaBN (fibRecBN (subBN (True, bn) (True, [1])) ) (fibRecBN (subBN (True, bn) (True, [2])) )

--

-- dynamicFibListBN = (True, [0]) : (True, [1]) : [ n | x <- [2..], let n = ((dynamicFibListBN !! (x-1)) + (dynamicFibListBN !! (x-2)))]
--
-- fibListaBN :: BigNumber -> BigNumber
-- fibListaBN n = select n dynamicFibListBN

--
infiniteFibListBN = (True, [0]) : (True, [1]) : zipWith (somaBN) infiniteFibListBN (tail infiniteFibListBN)

fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN n = select n infiniteFibListBN

-- Aux functions
select :: BigNumber -> [BigNumber] -> BigNumber
select (True,[0]) xs = head xs
select bn (x:xs)     = select (subBN bn (True, [1])) xs
