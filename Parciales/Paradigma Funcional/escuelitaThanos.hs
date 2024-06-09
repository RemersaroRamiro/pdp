import Text.Show.Functions ()

----------------------------------------
--           Parte UNO                --
----------------------------------------
--           EJERCICIO 1              --
----------------------------------------

-- Modelar Personaje, Guantelete y Universo como tipos de dato e implementar el chasquido de un universo.

data Personaje = Personaje {
    nombre :: String,
    edad :: Int,
    energia :: Int,
    habilidades :: [Habilidad],
    planeta :: Planeta
} deriving (Show, Eq)

drStrange :: Personaje
drStrange = Personaje "Dr. Strange" 45 100 ["Telepatia", "Telequinesis"] "Tatooine"

type Habilidad = String
type Planeta = String

type Gema = Personaje -> Personaje

type Material = String
type Gemas = [Gema]

data Guantelete = Guantelete{
    material :: Material,
    gemas :: Gemas
}

type Universo = [Personaje]

chasquidoUniverso :: Universo -> Universo
chasquidoUniverso universo = take mitad universo
  where mitad = div (length universo) 2

----------------------------------------
--           EJERCICIO 2              --
----------------------------------------

-- A. Saber si un universo es apto para péndex, que ocurre si alguno de los personajes que lo integran tienen menos de 45 años.

esApto :: Universo -> Bool
esApto  = all ((>= 45) . edad)

-- B. Saber la energía total de un universo que es la sumatoria de todas las energías de sus integrantes que tienen más de una habilidad

energiaDelUniverso :: Universo -> Int
energiaDelUniverso   = sum . map energia . filter ((>1).cantidadHabilidades)

cantidadHabilidades :: Personaje -> Int
cantidadHabilidades personaje = length (habilidades personaje)

----------------------------------------
--           Parte DOS                --
----------------------------------------
--           EJERCICIO 3              --
----------------------------------------

-- Implementar las gemas del infinito, evitando lógica duplicada. 

-- La mente que tiene la habilidad de debilitar la energía de un usuario en un valor dado.

gemaDeLaMente :: Int -> Gema
gemaDeLaMente valor  = modificarEnergia (flip (-) valor)

modificarEnergia :: (Int -> Int) -> Personaje -> Personaje
modificarEnergia modificador personaje = personaje {energia = modificador (energia personaje)}

-- El alma puede controlar el alma de nuestro oponente permitiéndole eliminar una habilidad en particular si es que la posee. Además le quita 10 puntos de energía. 

gemaDelAlma :: Habilidad -> Gema
gemaDelAlma habilidad  = modificarEnergia (flip (-) 10) . modificarHabilidades (filter (/= habilidad))

modificarHabilidades :: ([Habilidad] -> [Habilidad]) -> Personaje -> Personaje
modificarHabilidades modificador personaje = personaje {habilidades = modificador (habilidades personaje)}

-- El espacio que permite transportar al rival al planeta x (el que usted decida) y resta 20 puntos de energía.

gemaDelEspacio :: Planeta -> Gema
gemaDelEspacio planeta  = modificarEnergia (flip (-) 20) . modificarPlaneta planeta

modificarPlaneta :: Planeta -> Personaje -> Personaje
modificarPlaneta nuevoPlaneta personaje = personaje { planeta = nuevoPlaneta}

-- El poder deja sin energía al rival y si tiene 2 habilidades o menos se las quita (en caso contrario no le saca ninguna habilidad).

gemaDelPoder :: Gema
gemaDelPoder = modificarEnergia (* 0) . eliminarUltimasHabilidades 2


eliminarUltimasHabilidades :: Int -> Personaje -> Personaje
eliminarUltimasHabilidades cantidad personaje
    | cantidadHabilidades personaje > cantidad = personaje
    | otherwise = modificarHabilidades (take cantidad) personaje

{-El tiempo que reduce a la mitad la edad de su oponente pero como no está permitido pelear con menores, no puede dejar la edad del oponente con menos de 18 años. 
Considerar la mitad entera, por ej: si el oponente tiene 50 años, le quedarán 25. Si tiene 45, le quedarán 22 (por división entera). Si tiene 30 años, le deben 
quedar 18 en lugar de 15. También resta 50 puntos de energía -}

gemaDelTiempo :: Gema
gemaDelTiempo  = modificarEnergia (flip (-) 50) . modificarEdad (flip div 2)

modificarEdad :: (Int -> Int) -> Personaje -> Personaje
modificarEdad modificador personaje = personaje {edad = max 18 . modificador . edad $ personaje}

-- La gema loca que permite manipular el poder de una gema y la ejecuta 2 veces contra un rival.

gemaLoca :: Gema -> Gema
gemaLoca gema = gema . gema

----------------------------------------
--           EJERCICIO 4              --
----------------------------------------

{-Dar un ejemplo de un guantelete de goma con las gemas tiempo, alma que quita la habilidad de “usar Mjolnir” y la gema loca que manipula el poder del alma 
  tratando de eliminar la “programación en Haskell”. -}

guanteleteGoma :: Guantelete
guanteleteGoma =  Guantelete "Goma" [gemaDelTiempo, gemaDelAlma "usar Mjolnir", gemaLoca (gemaDelAlma "programación en Haskell")]

----------------------------------------
--           EJERCICIO 5              --
----------------------------------------

{-No se puede utilizar recursividad. Generar la función utilizar  que dado una lista de gemas y un enemigo ejecuta el poder de cada una de las gemas que lo 
componen contra el personaje dado. Indicar cómo se produce el “efecto de lado” sobre la víctima. -}
type Enemigo = Personaje

utilizar :: Gemas -> Enemigo -> Enemigo
utilizar gemas enemigo  = foldr ($) enemigo gemas

----------------------------------------
--           EJERCICIO 6              --
----------------------------------------

{-Resolver utilizando recursividad. Definir la función gemaMasPoderosa que dado un guantelete y una persona obtiene la gema del infinito que produce la pérdida 
  más grande de energía sobre la víctima. -}

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa guantelete  = quitaMasEnergia gemasGuantelete
  where gemasGuantelete = gemas guantelete

quitaMasEnergia :: Gemas -> Personaje -> Gema
quitaMasEnergia [gema] _ = gema
quitaMasEnergia (gema1 : gema2 : gemas) personaje
    | (energia.gema1) personaje < (energia.gema2) personaje = quitaMasEnergia (gema1 : gemas) personaje
    | otherwise = quitaMasEnergia (gema2 : gemas) personaje

----------------------------------------
--           EJERCICIO 7              --
----------------------------------------

-- Punto 7: (1 punto) Dada la función generadora de gemas y un guantelete de locos:
infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema : infinitasGemas gema

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = Guantelete "vesconite" (infinitasGemas gemaDelTiempo)

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas  = utilizar . take 3. gemas

--Justifique si se puede ejecutar, relacionándolo con conceptos vistos en la cursada:
-- gemaMasPoderosa punisher guanteleteDeLocos
-- No se puede porque el guantelete tiene infinitas gemas, haciendo imposible que se evalue cada posibilidad de la energia perdida por gema.
-- usoLasTresPrimerasGemas guanteleteDeLocos punisher
-- Si se puede, esto ya que haskell tiene una lazy evaluation haciendo que al solo tener que evaluar los tres primeros elementos de una lista infinita,
-- no le preste atencion al resto, asi logrando no quedar tildada evaluando infinitas posiblidades