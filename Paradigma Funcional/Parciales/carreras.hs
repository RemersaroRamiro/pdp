
----------------------------------------
--           EJERCICIO 1              --
----------------------------------------

--  Declarar los tipos Auto y Carrera como consideres convenientes para representar la información indicada 

data Auto = Auto {
    color               :: String,
    velocidad           :: Int,
    distanciaRecorrida  :: Int
} deriving (Show, Eq)

type Carrera = [Auto]

-- Definir funciones para resolver los siguientes problemas:
-- A. Saber si un auto está cerca de otro auto, que se cumple si son autos distintos y la distancia que hay entre ellos (en valor absoluto) es menor a 10.

estaCerca :: Auto -> Auto -> Bool
estaCerca auto1 auto2 = auto1 /= auto2 && distanciaEntre auto1 auto2 < 10

distanciaEntre :: Auto -> Auto -> Int
distanciaEntre auto1 auto2 = abs (distanciaRecorrida auto1 - distanciaRecorrida auto2)

-- B. Saber si un auto va tranquilo en una carrera, que se cumple si no tiene ningún auto cerca y les va ganando a todos (por haber recorrido más distancia que los otros).

vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo auto carrera = not (algunoCerca auto carrera) && vaGanando auto carrera

algunoCerca :: Auto -> Carrera -> Bool
algunoCerca auto  = any (estaCerca auto)

vaGanando :: Auto -> Carrera -> Bool
vaGanando auto = all ((> distanciaRecorrida auto) . distanciaRecorrida)

-- C. Conocer en qué puesto está un auto en una carrera, que es 1 + la cantidad de autos de la carrera que le van ganando.

conocerPuesto :: Auto -> Carrera -> Int
conocerPuesto auto carrera = 1 + autosDelante auto carrera

autosDelante :: Auto -> Carrera -> Int
autosDelante auto carrera = length (filter (leVaGanando auto) carrera)

leVaGanando :: Auto -> Auto -> Bool
leVaGanando ganador perdedor = distanciaRecorrida ganador > distanciaRecorrida perdedor

----------------------------------------
--           EJERCICIO 2              --
----------------------------------------

-- Desarrollar las funciones necesarias para manipular el estado de los autos para que sea posible:
{-
A. Hacer que un auto corra durante un determinado tiempo. Luego de correr la cantidad de tiempo indicada, la distancia recorrida 
por el auto debería ser equivalente a la distancia que llevaba recorrida + ese tiempo * la velocidad a la que estaba yendo.
-}

correr :: Int -> Auto -> Auto
correr tiempo auto = modificarDistancia (distanciaRecorrida auto + tiempo * velocidad auto) auto

modificarDistancia :: Int -> Auto -> Auto
modificarDistancia  nuevaDistancia auto = auto {distanciaRecorrida = nuevaDistancia}

{-
b.i) A partir de un modificador de tipo Int -> Int, queremos poder alterar la velocidad de un auto de modo que su velocidad final sea
    la resultante de usar dicho modificador con su velocidad actual.
-}

type Modificador = Int -> Int

alterarVelocidad :: Modificador -> Auto -> Auto
alterarVelocidad modificador auto = modificarVelocidad (modificador (velocidad auto)) auto

modificarVelocidad :: Int -> Auto -> Auto
modificarVelocidad nuevaVelocidad auto= auto {velocidad = nuevaVelocidad}

{-
b.ii) Usar la función del punto anterior para bajar la velocidad de un auto en una cantidad indicada de modo que se le reste a la velocidad 
actual la cantidad indicada, y como mínimo quede en 0, ya que no es válido que un auto quede con velocidad negativa.
-}

bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad cantidad  = alterarVelocidad (max 0 . flip (-) cantidad)

----------------------------------------
--           EJERCICIO 3              --
---------------------------------------- 

type PowerUps = Auto -> Carrera -> Carrera

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

-- Representar los siguientes PowerUps
-- A. Terremoto: luego de usar este poder, los autos que están cerca del que gatilló el power up bajan su velocidad en 50.

terremoto :: PowerUps
terremoto auto  = afectarALosQueCumplen (estaCerca auto) (bajarVelocidad mitad) 
    where mitad = round (0.5 * fromIntegral (velocidad auto))

-- B. miguelitos: este poder debe permitir configurarse con una cantidad que indica en cuánto deberán bajar la velocidad los autos 
--    que se vean afectados por su uso. Los autos a afectar son aquellos a los cuales el auto que gatilló el power up les vaya ganando.

miguelitos :: Int -> PowerUps
miguelitos reduccion auto  = afectarALosQueCumplen (leVaGanando auto) (bajarVelocidad reduccion) 

{-
C. jet pack: este poder debe afectar, dentro de la carrera, solamente al auto que gatilló el poder. El jet pack tiene un impacto que dura una cantidad limitada de tiempo, 
el cual se espera poder configurar. Cuando se activa el poder del jet pack, el auto afectado duplica su velocidad actual, luego corre durante el tiempo indicado y finalmente
su velocidad vuelve al valor que tenía antes de que se active el poder. Por simplicidad, no se espera que los demás autos que participan de la carrera también avancen en ese tiempo.
-}

jetPack :: Int -> PowerUps
jetPack tiempo auto carrera = (bajarVelocidad (velocidad auto) . correr tiempo . modificarVelocidad (2 * velocidad auto)  $ auto) : filter (/= auto) carrera 
    where velocidadAnterior = round (0.5 * fromIntegral (velocidad auto))
----------------------------------------
--           EJERCICIO 4              --
----------------------------------------

{-
A. Desarrollar la función:
simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, Color)]
que permita obtener la tabla de posiciones a partir del estado final de la carrera, el cual se obtiene produciendo cada evento uno detrás del otro, partiendo del estado de la carrera recibido.
-}
type Color = String
type Evento = Carrera -> Carrera

simularCarrera :: Carrera -> [Evento] -> [(Int, Color)]
simularCarrera carrera eventos = tablaDePosiciones .  aplicarEventos eventos  $ carrera

aplicarEventos :: [Evento] -> Carrera -> Carrera
aplicarEventos eventos carrera = foldr ($) carrera eventos -- ... $ event3 $ evento2 $ evento1 $ carrera

tablaDePosiciones :: Carrera ->  [(Int, Color)]
tablaDePosiciones carrera = zip (tablaPuestos carrera) (tablaColores carrera)

tablaPuestos :: Carrera -> [Int]
tablaPuestos carrera = map (flip conocerPuesto carrera) carrera

tablaColores :: Carrera -> [Color]
tablaColores  = map color 

-- B. Desarrollar las siguientes funciones de modo que puedan usarse para generar los eventos que se dan en una carrera:
-- i. correnTodos que hace que todos los autos que están participando de la carrera corran durante un tiempo indicado.

correnTodos :: Int -> Evento
correnTodos tiempo  = map (correr tiempo) 

-- ii. usaPowerUp que a partir de un power up y del color del auto que gatilló el poder en cuestión, encuentre el auto correspondiente dentro del estado actual 
--     de la carrera para usarlo y produzca los efectos esperados para ese power up.
    
usaPowerUp :: Color -> PowerUps -> Evento
usaPowerUp colorBuscado powerUp carrera = powerUp autoBuscado carrera 
    where autoBuscado = head (filter ((== colorBuscado).color) carrera)

-- El resto es mas teorico que otra cosa, y necesito practica mas que teoria
