----------------------------------------
--         Parcial: Golfito           --
----------------------------------------
{-
Enunciado: 
Lisa Simpson se propuso desarrollar un programa que le permita ayudar a su hermano a vencer a su vecino Todd en un torneo de minigolf. 
Para hacerlo más interesante, los padres de los niños hicieron una apuesta: el padre del niño que no gane deberá cortar el césped del 
otro usando un vestido de su esposa.
-}
data Jugador = UnJugador {
  nombre           :: String,
  padre            :: String,
  habilidad        :: Habilidad
} deriving (Eq, Show)
data Habilidad = Habilidad {
  fuerzaJugador    :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura    :: Int
} deriving (Eq, Show)

type Puntos = Int

between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

{- También necesitaremos modelar los palos de golf que pueden usarse y los obstáculos que deben enfrentar para ganar el juego. -}

----------------------------------------
--           EJERCICIO 1              --
----------------------------------------
{-
Sabemos que cada palo genera un efecto diferente, por lo tanto elegir el palo correcto puede ser la diferencia entre ganar o perder el torneo.
A. Modelar los palos usados en el juego que a partir de una determinada habilidad generan un tiro que se compone por velocidad, precisión y altura.
-}
{-
El putter genera un tiro con velocidad igual a 10, el doble de la precisión recibida y altura 0.
-}

type Palo = Habilidad -> Tiro

putter :: Palo
putter habilidad = UnTiro 10 (precisionJugador habilidad * 2) 0
{-
La madera genera uno de velocidad igual a 100, altura igual a 5 y la mitad de la precisión.
-}
madera :: Palo
madera habilidad = UnTiro 100 (precisionJugador habilidad `div` 2) 5

{-
Los hierros, que varían del 1 al 10 (número al que denominaremos n), generan un tiro de velocidad igual a la fuerza multiplicada por n, la precisión dividida por n 
y una altura de n-3 (con mínimo 0). Modelarlos de la forma más genérica posible.
-}

hierros :: Int -> Palo
hierros n habilidad = UnTiro (fuerzaJugador habilidad * n) (precisionJugador habilidad `div` n) (max 0 (n - 3))

{-
B. Definir una constante palos que sea una lista con todos los palos que se pueden usar en el juego.
-}

palos :: [Palo]
palos = [putter, madera] ++ map hierros [1..10]

----------------------------------------
--           EJERCICIO 2              --
----------------------------------------
{-
Definir la función golpe que dados una persona y un palo, obtiene el tiro resultante de usar ese palo con las habilidades de la persona.
Por ejemplo si Bart usa un putter, se genera un tiro de velocidad = 10, precisión = 120 y altura = 0.
-}

golpe :: Jugador -> Palo -> Tiro
golpe jugador palo = palo (habilidad jugador)

----------------------------------------
--           EJERCICIO 3              --
----------------------------------------
{-
Lo que nos interesa de los distintos obstáculos es si un tiro puede superarlo, y en el caso de poder superarlo, cómo se ve afectado dicho tiro por el obstáculo. 
Se desea saber cómo queda un tiro luego de intentar superar un obstáculo, teniendo en cuenta que en caso de no superarlo, se detiene, quedando con todos sus componentes en 0.
En principio necesitamos representar los siguientes obstáculos:
-}
{-
A. Un túnel con rampita sólo es superado si la precisión es mayor a 90 yendo al ras del suelo, independientemente de la velocidad del tiro. 
Al salir del túnel la velocidad del tiro se duplica, la precisión pasa a ser 100 y la altura 0.
-}

data Obstaculo = UnObstaculo {
  condicion :: Tiro -> Bool,
  efecto    :: Tiro -> Tiro
}

tunelConRampita :: Obstaculo
tunelConRampita = UnObstaculo superaRampa efectoRampa
    where superaRampa tiro = precision tiro > 90 && altura tiro == 0
          efectoRampa tiro = UnTiro (velocidad tiro * 2) 100 0

{-
B. Una laguna es superada si la velocidad del tiro es mayor a 80 y tiene una altura de entre 1 y 5 metros. Luego de superar una laguna el tiro llega con la misma velocidad 
y precisión, pero una altura equivalente a la altura original dividida por el largo de la laguna.
-}

laguna :: Int -> Obstaculo
laguna largo = UnObstaculo superaLaguna efectoLaguna
    where superaLaguna tiro = velocidad tiro > 80 && between 1 5 (altura tiro)
          efectoLaguna tiro = UnTiro (velocidad tiro) (precision tiro) (altura tiro `div` largo)

{-
Un hoyo se supera si la velocidad del tiro está entre 5 y 20 m/s yendo al ras del suelo con una precisión mayor a 95. Al superar el hoyo, el tiro se detiene, 
quedando con todos sus componentes en 0.
-}

hoyo :: Obstaculo
hoyo = UnObstaculo superaHoyo efectoHoyo
    where superaHoyo tiro = between 5 20 (velocidad tiro) && precision tiro > 95 && altura tiro == 0
          efectoHoyo _ = UnTiro 0 0 0

{-
----------------------------------------
--           EJERCICIO 4              --
----------------------------------------
-}

{-
A. Definir palosUtiles que dada una persona y un obstáculo, permita determinar qué palos le sirven para superarlo.
-}

palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugador obstaculo = filter (sirvePara obstaculo jugador) palos

sirvePara :: Obstaculo -> Jugador -> Palo -> Bool
sirvePara obstaculo jugador palo = condicion obstaculo (golpe jugador palo)

{-
Saber, a partir de un conjunto de obstáculos y un tiro, cuántos obstáculos consecutivos se pueden superar.
Por ejemplo, para un tiro de velocidad = 10, precisión = 95 y altura = 0, y una lista con dos túneles con rampita seguidos de un hoyo,
el resultado sería 2 ya que la velocidad al salir del segundo túnel es de 40, por ende no supera el hoyo.
BONUS: resolver este problema sin recursividad, teniendo en cuenta que existe una función takeWhile :: (a -> Bool) -> [a] -> [a] que podría ser de utilidad.
-}

superarObstaculos :: Tiro -> [Obstaculo] -> Int
superarObstaculos tiro obstaculos = length (takeWhile (superarObstaculo tiro) obstaculos)

superarObstaculo :: Tiro -> Obstaculo -> Bool
superarObstaculo tiro obstaculo = condicion obstaculo tiro

{-
C. Definir paloMasUtil que recibe una persona y una lista de obstáculos y determina cuál es el palo que le permite superar más obstáculos con un solo tiro
-}

paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil jugador obstaculos = maximoSegun (flip superarObstaculos obstaculos .  golpe jugador) palos

----------------------------------------
--           EJERCICIO 5              --
----------------------------------------
{-
Dada una lista de tipo [(Jugador, Puntos)] que tiene la información de cuántos puntos ganó cada niño al finalizar el torneo, se pide retornar la lista de padres que 
pierden la apuesta por ser el “padre del niño que no ganó”. Se dice que un niño ganó el torneo si tiene más puntos que los otros niños.
-}

padresPerdedores :: [(Jugador, Puntos)] -> [String]
padresPerdedores niños = map padre (niñosPerdedores niños)

niñosPerdedores :: [(Jugador, Puntos)] -> [Jugador]
niñosPerdedores niños = map fst (filter (not . gano niños) niños)

gano :: [(Jugador, Puntos)] -> (Jugador, Puntos) -> Bool
gano niños ganador = all (< puntos ganador) restoNiños
    where restoNiños = map puntos (filter (/= ganador) niños)

puntos :: (Jugador, Puntos) -> Puntos
puntos = snd
