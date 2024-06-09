import Data.List (genericLength)

----------------------------------------
--           EJERCICIO 1              --
----------------------------------------
-- Crear un modelo para los turistas

data Turista = Turista {
    cansancio :: Float,
    stress :: Float,
    viajaSolo :: Bool,
    idiomas :: [String]
}

-- Modelaje de ejemplos:
-- Ana: está acompañada, sin cansancio, tiene 21 de stress y habla español.

ana :: Turista
ana = Turista 0 21 False ["espanol"]

-- Beto y Cathi, que hablan alemán, viajan solos, y Cathi además habla catalán. Ambos tienen 15 unidades de cansancio y stress.

beto :: Turista
beto = Turista 15 15 True ["aleman"]
cathi :: Turista
cathi = Turista 15 15 True ["aleman"]

----------------------------------------
--           EJERCICIO 2              --
----------------------------------------
-- Modelar las excursiones anteriores de forma tal que para agregar una excursión al sistema no haga falta modificar las funciones existentes.

type Excursion = Turista -> Turista

-- Ir a la playa: si está viajando solo baja el cansancio en 5 unidades, si no baja el stress 1 unidad.

irPlaya :: Excursion
irPlaya turista
    | viajaSolo turista = modificarCansansio (flip (-) 5) turista
    | otherwise =  modificarStress (flip (-) 1) turista

modificarCansansio :: (Float -> Float) -> Turista -> Turista
modificarCansansio modificador turista = turista {cansancio = modificador (cansancio turista)}

modificarStress :: (Float -> Float) -> Turista -> Turista
modificarStress modificador turista = turista {stress = modificador (stress turista)}

-- Apreciar algún elemento del paisaje: reduce el stress en la cantidad de letras de lo que se aprecia. 
type Paisaje = String
apreciarPaisaje :: Paisaje -> Excursion
apreciarPaisaje paisaje = modificarStress (flip (-) . genericLength $ paisaje )

-- Salir a hablar un idioma específico: el turista termina aprendiendo dicho idioma y continúa el viaje acompañado.

hablarIdioma :: String -> Excursion
hablarIdioma idioma  = modificarIdioma (++ [idioma])

modificarIdioma :: ([String] -> [String]) -> Turista -> Turista
modificarIdioma modificador turista = turista {idiomas = modificador (idiomas turista)}

-- Caminar ciertos minutos: aumenta el cansancio pero reduce el stress según la intensidad de la caminad, ambos en la misma cantidad. 
-- El nivel de intensidad se calcula en 1 unidad cada 4 minutos que se caminen.

caminar :: Float -> Turista -> Turista
caminar tiempo  = modificarCansansio (+ cantidad) . modificarStress (+ cantidad)
    where cantidad = tiempo / 4

{-Paseo en barco: depende de cómo esté la marea
si está fuerte, aumenta el stress en 6 unidades y el cansancio en 10.
si está moderada, no pasa nada.
si está tranquila, el turista camina 10’ por la cubierta, aprecia la vista del “mar”, y sale a hablar con los tripulantes alemanes. -}

data Marea = Fuerte | Moderada | Tranquila

paseoEnBarco :: Marea -> Excursion
paseoEnBarco Fuerte = modificarStress (+ 6) . modificarCansansio (+ 10)
paseoEnBarco Moderada = id
paseoEnBarco Tranquila = caminar 10 . apreciarPaisaje "mar" . hablarIdioma "aleman"

-- A. Hacer que un turista haga una excursión. Al hacer una excursión, el turista además de sufrir los efectos propios de la excursión, reduce en un 10% su stress.

hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion excursion  = modificarStress (* 0.9) . excursion 

-- B.

deltaSegun :: (a -> Float) -> a -> a -> Float
deltaSegun f algo1 algo2 = f algo1 - f algo2

-- Definir la función deltaExcursionSegun que a partir de un índice, un turista y una excursión determine cuánto varió dicho índice después de que el 
-- turista haya hecho la excursión. Llamamos índice a cualquier función que devuelva un número a partir de un turista.

deltaExcursionSegun :: (Turista -> Float) -> Turista -> Excursion -> Float
deltaExcursionSegun indice turista excursion = deltaSegun indice (hacerExcursion excursion turista) turista

-- C. Usar la función anterior para resolver cada uno de estos puntos:
-- i. Saber si una excursión es educativa para un turista, que implica que termina aprendiendo algún idioma.

esEducativa :: Turista -> Excursion -> Bool
esEducativa turista excursion = deltaExcursionSegun cantidadIdiomas turista excursion > 0
    where cantidadIdiomas turista = genericLength (idiomas turista)

-- ii. Conocer las excursiones desestresantes para un turista. Estas son aquellas que le reducen al menos 3 unidades de stress al turista.

excursionesDesestresantes :: Turista -> [Excursion] -> [Excursion]
excursionesDesestresantes turista = filter (esDesestresante turista) 

esDesestresante :: Turista -> Excursion -> Bool
esDesestresante turista recursion = deltaExcursionSegun stress turista recursion < 3

----------------------------------------
--           EJERCICIO 3              --
----------------------------------------

-- Para mantener a los turistas ocupados todo el día, la empresa vende paquetes de excursiones llamados tours. Un tour se compone por una serie de excursiones.

type Tour = [Excursion]

-- Completo: Comienza con una caminata de 20 minutos para apreciar una "cascada", luego se camina 40 minutos hasta una playa, y finaliza con una salida con gente 
-- local que habla "melmacquiano".

completo :: Tour
completo = [caminar 20, apreciarPaisaje "cascada", caminar 40, irPlaya, hablarIdioma "melmacquiano"]

{-Lado B: Este tour consiste en ir al otro lado de la isla a hacer alguna excursión (de las existentes) que elija el turista. Primero se hace un paseo en barco por 
aguas tranquilas (cercanas a la costa) hasta la otra punta de la isla, luego realiza la excursión elegida y finalmente vuelve caminando hasta la otra punta, tardando 2 horas.-}

ladoB :: Excursion -> Tour
ladoB excursion = [paseoEnBarco Tranquila, excursion, caminar 120]

{-Isla Vecina: Se navega hacia una isla vecina para hacer una excursión. Esta excursión depende de cómo esté la marea al llegar a la otra isla: si está fuerte se aprecia 
  un "lago", sino se va a una playa. En resumen, este tour implica hacer un paseo en barco hasta la isla vecina, luego llevar a cabo dicha excursión, y finalmente volver 
  a hacer un paseo en barco de regreso. La marea es la misma en todo el camino. -}

islaVecina :: Marea -> Tour
islaVecina Fuerte = [paseoEnBarco Fuerte, apreciarPaisaje "lago", paseoEnBarco Fuerte]
islaVecina marea = [paseoEnBarco marea, irPlaya, paseoEnBarco marea]

{-A. Hacer que un turista haga un tour. Esto implica, primero un aumento del stress en tantas unidades como cantidad de excursiones tenga el tour, y luego realizar las 
excursiones en orden.-}

hacerTour :: Tour -> Turista -> Turista
hacerTour tour  = hacerExcursiones tour . modificarStress (+ cantidadExcursiones) 
    where cantidadExcursiones = genericLength tour

hacerExcursiones :: Tour -> Turista -> Turista
hacerExcursiones tour turista = foldr hacerExcursion turista tour

{-B. Dado un conjunto de tours, saber si existe alguno que sea convincente para un turista. Esto significa que el tour tiene alguna excursión desestresante la cual, 
además, deja al turista acompañado luego de realizarla.-}

tourConvincente :: Turista -> [Tour] -> Bool
tourConvincente turista  = any (esConvincente turista) 

esConvincente :: Turista -> Tour -> Bool
esConvincente turista tour = quedaAcompañado (hacerTour tour turista) && (not.null.excursionesDesestresantes turista) tour

quedaAcompañado :: Turista -> Bool
quedaAcompañado = not.viajaSolo

{-C. Saber la efectividad de un tour para un conjunto de turistas. Esto se calcula como la sumatoria de la espiritualidad recibida de cada turista a quienes les 
resultó convincente el tour. La espiritualidad que recibe un turista es la suma de las pérdidas de stress y cansancio tras el tour.-}

efectividad :: Tour -> [Turista] -> Float
efectividad tour turistas = sum (map ( espiritualidad tour ) turistas) 

espiritualidad :: Tour -> Turista -> Float
espiritualidad tour turista = perdidaStress tour turista + perdidaCansancio tour turista

perdidaStress :: Tour -> Turista -> Float
perdidaStress tour turista = deltaSegun stress (hacerTour tour turista) turista

perdidaCansancio :: Tour -> Turista -> Float
perdidaCansancio tour turista = deltaSegun cansancio (hacerTour tour turista) turista
