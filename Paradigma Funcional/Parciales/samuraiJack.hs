import Text.Show.Functions()
----------------------------------------

data Elemento = Elemento {
    tipo :: String,
    ataque :: Ataque,
    defensa :: Defensa
} deriving (Show)
type Ataque = Personaje -> Personaje
type Defensa = Personaje -> Personaje


data Personaje = Personaje {
    salud :: Float,
    elementos :: [Elemento],
    anioPresente :: Int
} deriving (Show)

----------------------------------------
--           EJERCICIO 1              --
----------------------------------------

--A. mandarAlAnio: lleva al personaje al año indicado.

mandarAlAnio :: Int -> Personaje -> Personaje
mandarAlAnio anio personaje = personaje {anioPresente = anio}

-- meditar: le agrega la mitad del valor que tiene a la salud del personaje.

meditar :: Personaje -> Personaje
meditar personaje = modificarSalud (+ salud personaje / 2) personaje

modificarSalud :: (Float -> Float) -> Personaje -> Personaje
modificarSalud modificador personaje = personaje {salud = max 0 (modificador (salud personaje))}

-- causarDanio: le baja a un personaje una cantidad de salud dada. Hay que tener en cuenta al modificar la salud de un personaje que ésta nunca puede quedar menor a 0.

causarDanio :: Float -> Personaje -> Personaje
causarDanio danio  = modificarSalud (flip (-) danio)

----------------------------------------
--           EJERCICIO 2              --
----------------------------------------

--esMalvado, que retorna verdadero si alguno de los elementos que tiene el personaje en cuestión es de tipo “Maldad”.

esMalvado :: Personaje -> Bool
esMalvado personaje = any ((== "Maldad").tipo) (elementos personaje)

-- danioQueProduce :: Personaje -> Elemento -> Float, que retorne la diferencia entre la salud inicial del personaje y la salud del personaje 
-- luego de usar el ataque del elemento sobre él.

danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce personaje elemento = salud personaje - salud (personajeAtacado elemento)
    where personajeAtacado elemento = (ataque elemento) personaje

-- enemigosMortales que dado un personaje y una lista de enemigos, devuelve la lista de los enemigos que pueden llegar a matarlo con un solo elemento. 
-- Esto sucede si luego de aplicar el efecto de ataque del elemento, el personaje queda con salud igual a 0.
type Enemigos = [Personaje]

enemigosMortales :: Personaje -> Enemigos -> Enemigos
enemigosMortales personaje  = filter (matanPersonajeDeUna personaje)

matanPersonajeDeUna :: Personaje -> Personaje -> Bool
matanPersonajeDeUna personaje enemigo = any (mata personaje) (elementos enemigo)

mata :: Personaje -> Elemento -> Bool
mata personaje elemento = danioQueProduce personaje elemento == salud personaje -- Quiere decir que Vida Inicial - Vida PostAtaque = Vida inicial por lo que Vida PostAtacaque = 0

----------------------------------------
--           EJERCICIO 3              --
----------------------------------------

{-  Definir concentracion de modo que se pueda obtener un elemento cuyo efecto defensivo sea aplicar meditar tantas veces como el nivel de concentración indicado 
    y cuyo tipo sea "Magia". -}

concentracion :: Int -> Elemento
concentracion nivel = Elemento "Magia" id (meditarMucho nivel)

meditarMucho :: Int -> Personaje -> Personaje
meditarMucho nivel = foldr (.) id (replicate nivel meditar)

{-Definir esbirrosMalvados que recibe una cantidad y retorna una lista con esa cantidad de esbirros (que son elementos de tipo “Maldad” cuyo efecto ofensivo es causar 
un punto de daño).-}

esbirrosMalvados :: Int -> [Elemento]
esbirrosMalvados cantidad = replicate cantidad (Elemento "Maldad" (causarDanio 1) id)

{-Definir jack de modo que permita obtener un personaje que tiene 300 de salud, que tiene como elementos concentración nivel 3 y una katana mágica 
(de tipo "Magia" cuyo efecto ofensivo es causar 1000 puntos de daño) y vive en el año 200.-}

jack :: Personaje
jack = Personaje 300 [concentracion 3, katanaMagica] 200

katanaMagica :: Elemento
katanaMagica = Elemento "Magia" (causarDanio 1000) id

{-Definir aku :: Int -> Float -> Personaje que recibe el año en el que vive y la cantidad de salud con la que debe ser construido. Los elementos que tiene 
dependerán en parte de dicho año. Los mismos incluyen:
Concentración nivel 4
Tantos esbirros malvados como 100 veces el año en el que se encuentra.
Un portal al futuro, de tipo “Magia” cuyo ataque es enviar al personaje al futuro (donde el futuro es 2800 años después del año indicado para aku), 
y su defensa genera un nuevo aku para el año futuro correspondiente que mantenga la salud que tenga el personaje al usar el portal. -}

aku :: Int -> Float -> Personaje
aku anio salud = Personaje salud ([concentracion 4] ++ esbirrosMalvados (100 * anio) ++ [portalMagico 2800 salud]) anio

portalMagico :: Int -> Float -> Elemento
portalMagico anio salud = Elemento "Magia" (mandarAlAnio anio) (generarAku anio salud)

generarAku :: Int -> Float -> Personaje -> Personaje
generarAku anio salud personaje = aku (anio + 2800) salud 

----------------------------------------
--           EJERCICIO 4              --
----------------------------------------

{-Finalmente queremos saber cómo puede concluir la lucha entre Jack y Aku. Para ello hay que definir la función luchar :: Personaje -> Personaje -> (Personaje, Personaje) 
donde se espera que si el primer personaje (el atacante) está muerto, retorne la tupla con el defensor primero y el atacante después, en caso contrario la lucha continuará 
invirtiéndose los papeles (el atacante será el próximo defensor) luego de que ambos personajes se vean afectados por el uso de todos los elementos del atacante.
O sea que si luchan Jack y Aku siendo Jack el primer atacante, Jack se verá afectado por el poder defensivo de la concentración y Aku se verá afectado por el poder ofensivo 
de la katana mágica, y la lucha continuará con Aku (luego del ataque) como atacante y con Jack (luego de la defensa) como defensor.-}

luchar :: Personaje -> Personaje -> (Personaje, Personaje)
luchar atacante defensor
    | estaMuerto atacante = (defensor, atacante)
    | otherwise = luchar (recibirAtaques atacante defensor) (recibirDefensas defensor atacante)

estaMuerto :: Personaje -> Bool  
estaMuerto personaje = salud personaje == 0

recibirAtaques :: Personaje -> Personaje -> Personaje
recibirAtaques atacante defensor = foldr ataque defensor (elementos atacante)

recibirDefensas :: Personaje -> Personaje -> Personaje
recibirDefensas defensor atacante = foldr defensa atacante (elementos defensor)

----------------------------------------
--           EJERCICIO 5              --
----------------------------------------

{-Inferir el tipo de la siguiente función:
f x y z
    | y 0 == z = map (fst.x z)
    | otherwise = map (snd.x (y 0))

En ambos casos se utiliza un map funcion, por lo tanto tambien hay una lista [a], En ambas guardas se utiliza funciones de tuplas,
por lo tanto el resultado de aplicar x a un elemento "a" con z o (y 0) devuelve una tupla.
En la primer guarda sabemos que y 0 es el mismo tipo que z. Siendo y : b -> c y z : c. 
Sabemos que la funcion devuelve siempre una lista transformada del valor que retorna su funcion.
Hasta ahora tenemos:
x -> (b -> c) -> c -> [a] -> [d]
El map recibe la lista [a] y como el tipo de map es: (a -> b) -> [a] -> [b], tenemos que 
x: c -> e -> (d, d), ambos valores de la tupla iguales ya que en las guardas devuelven de fst y snd
por lo tanto queda en:
(c -> e -> (d,d)) -> (b -> c) -> c -> [a] -> [d]
Siendo que c se compara, Eq c y ya que y recibe 0, Num b
Entonces (Eq c, Num b) => (c -> e -> (d,d)) -> (b -> c) -> c -> [a] -> [d]
-}
