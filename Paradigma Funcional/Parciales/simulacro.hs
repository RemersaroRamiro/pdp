
----------------------------------------
--           EJERCICIO 1              --
----------------------------------------

-- Modelar el auto, teniendo en cuenta la información necesaria que lo representa. Modelar los ejemplos

data Auto = Auto {
  marca           :: String,
  modelo          :: String,
  desgaste        :: (Chasis, Ruedas),
  velocidadMaxima :: Float,
  tiempo          :: Float
}
type Ruedas = Float
type Chasis = Float

-- Auto Ferrari, modelo F50, sin desgaste en su chasis y ruedas, con una velocidad máxima de 65 m/s.

ferrari :: Auto
ferrari = Auto "Ferrari" "F50" (0,0) 65 0

-- Auto Lamborghini, modelo Diablo, con desgaste 7 de chasis y 4 de ruedas, con una velocidad máxima de 73 m/s.

lamborghini :: Auto
lamborghini = Auto "Lamborghini" "Diablo" (4,7) 73 0

-- Auto Fiat, modelo 600, con desgaste 33 de chasis y 27 de ruedas, con una velocidad máxima de 44 m/s.

fiat :: Auto
fiat = Auto "Fiat" "600" (27,33) 44 0

----------------------------------------
--           EJERCICIO 2              --
----------------------------------------

-- A. Saber si un auto está en buen estado, esto se da cuando el desgaste del chasis es menor a 40 y el de las ruedas es menor 60.

enBuenEstado :: Auto -> Bool
enBuenEstado auto = desgasteChasis auto < 40 && desgasteRuedas auto < 60

desgasteChasis :: Auto -> Float
desgasteChasis = fst . desgaste

desgasteRuedas :: Auto -> Float
desgasteRuedas = snd . desgaste

-- B. Saber si un auto no da más, esto ocurre si alguno de los valores de desgaste es mayor a 80.

noDaMas :: Auto -> Bool
noDaMas auto = any (>80) (desgaste auto)

----------------------------------------
--           EJERCICIO 3              --
----------------------------------------

-- Reparar un Auto: la reparación de un auto baja en un 85% el desgaste del chasis (es decir que si está en 50, lo baja a 7.5) y deja en 0 el desgaste de las ruedas.

reparar :: Auto -> Auto
reparar  = modificarChasis (0.15*).modificarRuedas (const 0)

modificarChasis :: (Float -> Float) -> Auto -> Auto
modificarChasis modificador auto = auto {desgaste = (modificador.desgasteChasis $ auto , desgasteRuedas auto)}

modificarRuedas :: (Float -> Float) -> Auto -> Auto
modificarRuedas modificador auto = auto {desgaste = (desgasteChasis auto, modificador.desgasteRuedas $ auto)}

----------------------------------------
--           EJERCICIO 4              --
----------------------------------------

-- Modelar las funciones para representar las distintas partes de una pista, teniendo en cuenta:

type Tramo = Auto -> Auto

{- A. La curva tiene dos datos relevantes: el ángulo y la longitud. Al atravesar una curva, el auto sufre un desgaste añadido al que tenía anteriormente en 
sus ruedas, que responde a la siguiente cuenta: 3 * longitud / ángulo. Además, suma un tiempo de longitud / ( velocidad máxima / 2 )
-}

curva :: Float -> Float -> Tramo
curva angulo longitud = modificarTiempo ((longitud / angulo)+) . modificarRuedas ((3 * longitud / angulo)+)

modificarTiempo :: (Float -> Float) -> Auto -> Auto
modificarTiempo modificador auto = auto {tiempo = modificador (tiempo auto)}

-- Modelar curvaPeligrosa, que es una curva de ángulo 60 y longitud de 300m

curvaPeligrosa :: Tramo
curvaPeligrosa = curva 60 300

--Modelar curvaTranca, que es una curva de ángulo 110 y longitud de 550m

curvaTranca :: Tramo
curvaTranca = curva 110 550

{- B. El tramo recto, debido a la alta velocidad se afecta el chasis del auto en una centésima parte de la longitud del tramo. 
Además suma un tiempo de longitud / velocidad máxima
-}

tramoRecto :: Float -> Tramo
tramoRecto longitud auto = modificarTiempo ((longitud / (velocidadMaxima auto / 2))+) . modificarChasis ((0.01*longitud)+) $ auto

-- Modelar tramoRectoClassic de 750m

tramoRectoClassic :: Tramo
tramoRectoClassic = tramoRecto 750

-- Modelar tramito de 280m

tramito :: Tramo
tramito = tramoRecto 280

{- C. Cuando pasa por un tramo Boxes, si está en buen estado, solo pasa por el tramo que compone Boxes, en el caso contrario se repara 
y suma 10 segundos de penalización al tiempo del tramo.-}

boxes :: Tramo -> Tramo
boxes tramo auto
  | enBuenEstado auto = tramo auto
  | not.enBuenEstado $ auto = tramo . modificarTiempo (10+) . reparar $ auto

-- D. Ya sea por limpieza o lluvia a veces hay una parte de la pista (cualquier parte) que está mojada. Suma la mitad de tiempo agregado por el tramo.

mojado :: Tramo -> Tramo
mojado tramo auto = modificarTiempo (tiempoMojado +) auto
  where tiempoMojado = (tiempo.tramo $ auto) / 2

{-E. Algunos tramos tienen ripio (sí... está un poco descuidada la pista) y produce el doble de efecto de un tramo normal equivalente, y se tarda el doble en atravesarlo también. 
  Nos aclaran que, por suerte, nunca hay boxes con ripio.-}

ripio :: Tramo -> Tramo
ripio tramo  = modificarTiempo (2*). dobleEfecto tramo

dobleEfecto :: Tramo -> Tramo
dobleEfecto tramo  = tramo . tramo

{-F. Los tramos que tienen alguna obstrucción, además, producen un desgaste en las ruedas de acuerdo a la porción de pista ocupada, 
  siendo 2 puntos de desgaste por cada metro de pista que esté ocupada, producto de la maniobra que se debe realizar al esquivar dicha obstrucción. -}

conObstruccion :: Float -> Tramo -> Tramo
conObstruccion longitud tramo  = modificarRuedas ((2*longitud)+)

----------------------------------------
--           EJERCICIO 5              --
----------------------------------------

-- Realizar la función pasarPorTramo/2 que, dado un tramo y un auto, hace que el auto atraviese el tramo, siempre y cuando no pase que no da más.

pasarPorTramo :: Tramo -> Auto -> Auto
pasarPorTramo tramo auto
  | noDaMas auto = auto
  | otherwise = tramo auto

----------------------------------------
--           EJERCICIO 6              --
----------------------------------------

-- A. Crear una Super Pista

type Pista = [Tramo]

superPista :: Pista
superPista = [tramoRectoClassic, curvaTranca, mojado tramito, tramito , conObstruccion 2 (curva 80 400), curva 115 650, tramoRecto 970, curvaPeligrosa, ripio tramito, boxes (ripio tramito)]

{-B. Hacer la función peganLaVuelta/2 que dada una pista y una lista de autos, hace que todos los autos den la vuelta (es decir, que avancen por todos los tramos), 
teniendo en cuenta que un auto que no da más “deja de avanzar”. -}

peganLaVuelta :: Pista -> [Auto] -> [Auto]
peganLaVuelta pista autos = filter (not . noDaMas) (map (pegaLaVuelta pista) autos)

pegaLaVuelta :: Pista -> Auto -> Auto
pegaLaVuelta pista auto = foldr pasarPorTramo auto pista

----------------------------------------
--           EJERCICIO 7              --
----------------------------------------

-- A. Modelar una carrera que está dada por una pista y un número de vueltas.

type Carrera = (Pista, Int)

-- B. Representar el tourBuenosAires, una carrera que se realiza en la superPista y tiene 20 vueltas.

tourBuenosAires :: Carrera
tourBuenosAires = (superPista, 20)

-- C. Hacer que una lista de autos juegue una carrera, teniendo los resultados parciales de cada vuelta, y la eliminación de los autos que no dan más en cada vuelta.


juegaCarrera :: Carrera -> [Auto] -> [[Auto]]
juegaCarrera (pista, vueltas)  = take vueltas.iterate (peganLaVuelta pista) 
