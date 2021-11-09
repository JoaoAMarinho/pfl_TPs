-- Fibonacci recursive version
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec (n-1) + fibRec (n-2)

-- Fibonacci dynamic version
fibLista :: (Integral a) => a -> a
fibLista i = (!!) (0 : 1 : [ 10 | v<-[2..i]]) (fromIntegral i)

-- Fibonacci infinite version
infiniteFibList = 0 : 1 : zipWith (+) infiniteFibList (tail infiniteFibList)

fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita n = (!!) infiniteFibList (fromInt n)
