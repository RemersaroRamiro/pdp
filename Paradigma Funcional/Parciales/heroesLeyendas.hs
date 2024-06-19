import Text.Show.Functions()

----------------------------------------
--           EJERCICIO 1              --
----------------------------------------

-- Modelar a los héroes

data Heroe = Heroe {
    epiteto         :: String,
    reconocimiento  :: Int,
    artefactos      :: [Artefacto],
    listaTareas     :: [Tarea]
} deriving (Show)

data Artefacto = Artefacto {
    nombreArtefacto :: String,
    rareza :: Int
} deriving (Show, Eq)

----------------------------------------
--           EJERCICIO 2              --
----------------------------------------

{-Hacer que un héroe pase a la historia. Esto varía según el índice de reconocimiento que tenga el héroe a la hora de su muerte:
    A. Si su reconocimiento es mayor a 1000, su epíteto pasa a ser "El mítico", y no obtiene ningún artefacto. ¿Qué artefacto podría desear tal espécimen?
    B. Si tiene un reconocimiento de al menos 500, su epíteto pasa a ser "El magnífico" y añade a sus artefactos la lanza del Olimpo (100 de rareza). 
    C. Si tiene menos de 500, pero más de 100, su epíteto pasa a ser "Hoplita" y añade a sus artefactos una Xiphos (50 de rareza).
    D. En cualquier otro caso, no pasa a la historia, es decir, no gana ningún epíteto o artefacto. -}
paseHistoria :: Heroe -> Heroe
paseHistoria heroe
    | masReconocimiento heroe 1000 = modificarEpiteto "El mititco"     heroe
    | masReconocimiento heroe  499  = modificarEpiteto "El magnifico" . añadirArtefacto lanzaOlimpo $ heroe
    | masReconocimiento heroe  100  = modificarEpiteto "Hoplita"      . añadirArtefacto xiphos $ heroe
    | otherwise = heroe

masReconocimiento :: Heroe -> Int -> Bool
masReconocimiento heroe valor = reconocimiento heroe > valor

modificarEpiteto :: String -> Heroe -> Heroe
modificarEpiteto nuevoEpiteto heroe = heroe {epiteto = nuevoEpiteto}

xiphos :: Artefacto
xiphos = Artefacto "Xiphos" 50

lanzaOlimpo :: Artefacto
lanzaOlimpo = Artefacto "Lanza del Olimpo" 100

añadirArtefacto :: Artefacto -> Heroe -> Heroe
añadirArtefacto nuevoArtefacto  = modificarArtefactos (nuevoArtefacto:)

modificarArtefactos :: ([Artefacto] -> [Artefacto]) -> Heroe -> Heroe
modificarArtefactos modificador heroe = heroe {artefactos = modificador (artefactos heroe)}

----------------------------------------
--           EJERCICIO 3              --
----------------------------------------

-- Modelar las tareas descritas, contemplando que en el futuro podría haber más.

type Tarea = Heroe -> Heroe

-- Encontrar un artefacto: el héroe gana tanto reconocimiento como rareza del artefacto, además de guardarlo entre los que lleva.

encontrarArtefacto :: Artefacto -> Tarea
encontrarArtefacto artefacto  = añadirArtefacto artefacto . modificarReconocimiento (+ rareza artefacto)

modificarReconocimiento :: (Int -> Int) -> Heroe -> Heroe
modificarReconocimiento modificador heroe = heroe {reconocimiento = modificador (reconocimiento heroe)}

{-Escalar el Olimpo: esta ardua tarea recompensa a quien la realice otorgándole 500 unidades de reconocimiento y triplica la rareza de todos sus artefactos, 
pero desecha todos aquellos que luego de triplicar su rareza no tengan un mínimo de 1000 unidades. Además, obtiene "El relámpago de Zeus" 
(un artefacto de 500 unidades de rareza).-}

escalarOlimpo :: Tarea
escalarOlimpo  = añadirArtefacto relampagoDeZeus . modificarReconocimiento (+ 500) . eliminarMenorRareza 1000 . modificarRarezaArtefactos (*3)

relampagoDeZeus :: Artefacto
relampagoDeZeus = Artefacto "El relampago de Zeus" 500

eliminarMenorRareza :: Int -> Heroe -> Heroe
eliminarMenorRareza valor = modificarArtefactos (filter (menorRareza valor))

menorRareza :: Int -> Artefacto -> Bool
menorRareza valor artefacto = rareza artefacto < valor

modificarRarezaArtefactos :: (Int -> Int) -> Heroe -> Heroe
modificarRarezaArtefactos modificador heroe = heroe {artefactos = map (modificarRarezaArtefacto modificador) (artefactos heroe)}

modificarRarezaArtefacto :: (Int -> Int) -> Artefacto -> Artefacto
modificarRarezaArtefacto modificador artefacto = artefacto {rareza = modificador (rareza artefacto)}

{-Ayudar a cruzar la calle: incluso en la antigua Grecia los adultos mayores necesitan ayuda para ello. Los héroes que realicen esta tarea obtiene el epíteto "Groso",
 donde la última 'o' se repite tantas veces como cuadras haya ayudado a cruzar. Por ejemplo, ayudar a cruzar una cuadra es simplemente "Groso", pero ayudar a cruzar 5
 cuadras es "Grosooooo". -}

ayudarACruzarCalle :: Int -> Tarea
ayudarACruzarCalle cuadras = modificarEpiteto ("Gros" ++ replicate cuadras 'o')

{-Matar una bestia: Cada bestia tiene una debilidad (por ejemplo: que el héroe tenga cierto artefacto, o que su reconocimiento sea al menos de tanto). 
Si el héroe puede aprovechar esta debilidad, entonces obtiene el epíteto de "El asesino de <la bestia>". Caso contrario, huye despavorido, perdiendo su primer artefacto.
Además, tal cobardía es recompensada con el epíteto  "El cobarde". -}

data Bestia = Bestia {
    nombreBestia :: String,
    debilidad :: Debilidad
}

type Debilidad = Heroe -> Bool

matarBestia :: Bestia -> Tarea
matarBestia bestia heroe
    | debilidad bestia heroe = modificarEpiteto ("El asesino de " ++ nombreBestia bestia) heroe
    | otherwise = modificarArtefactos (drop 1) . modificarEpiteto "El cobarde" $ heroe

----------------------------------------
--           EJERCICIO 4              --
----------------------------------------

{-Modelar a Heracles, cuyo epíteto es "Guardián del Olimpo" y tiene un reconocimiento de 700. Lleva una pistola de 1000 unidades de rareza (es un fierro en la antigua Grecia, 
obviamente que es raro) y el relámpago de Zeus. Este Heracles es el Heracles antes de realizar sus doce tareas, hasta ahora sabemos que solo hizo una tarea... -}

heracles :: Heroe
heracles = Heroe "Guardian del Olimpo" 700 [pistola, relampagoDeZeus] [matarBestia leonNemea]

pistola :: Artefacto
pistola = Artefacto "Pistola" 1000

----------------------------------------
--           EJERCICIO 5              --
----------------------------------------

-- Modelar la tarea "matar al león de Nemea", que es una bestia cuya debilidad es que el epíteto del héroe sea de 20 caracteres o más. Esta es la tarea que realizó Heracles.

matarLeonNemea :: Tarea
matarLeonNemea = matarBestia leonNemea

leonNemea :: Bestia
leonNemea = Bestia "Leon de Nemea" ((>= 20) . length . epiteto)

----------------------------------------
--           EJERCICIO 6              --
----------------------------------------

-- Hacer que un héroe haga una tarea. Esto nos devuelve un nuevo héroe con todos los cambios que conlleva realizar una tarea.

hacerTarea :: Tarea -> Heroe -> Heroe
hacerTarea tarea  = agregarTareaLista tarea . tarea

agregarTareaLista :: Tarea -> Heroe -> Heroe
agregarTareaLista tarea  = modificarTareas (tarea:)

modificarTareas :: ([Tarea] -> [Tarea]) -> Heroe -> Heroe
modificarTareas modificador heroe = heroe {listaTareas = modificador (listaTareas heroe)}

----------------------------------------
--           EJERCICIO 7              --
----------------------------------------

{-Hacer que dos héroes presuman sus logros ante el otro. Como resultado, queremos conocer la tupla que tenga en primer lugar al ganador de la contienda, 
y en segundo al perdedor. Cuando dos héroes presumen, comparan de la siguiente manera:
    A. Si un héroe tiene más reconocimiento que el otro, entonces es el ganador.
    B. Si tienen el mismo reconocimiento, pero la sumatoria de las rarezas de los artefactos de un héroe es mayor al otro, entonces es el ganador.
    C. Caso contrario, ambos realizan todas las tareas del otro, y vuelven a hacer la comparación desde el principio. Llegado a este punto, el intercambio 
    se hace tantas veces sea necesario hasta que haya un ganador.-}

presumirLogros :: Heroe -> Heroe -> (Heroe, Heroe)
presumirLogros heroe1 heroe2
    | heroe1 `mayorReconocimiento` heroe2 = (heroe1, heroe2)
    | heroe2 `mayorReconocimiento` heroe1 = (heroe2, heroe1)
    | heroe1 `masRarezaArtefactos` heroe2 = (heroe1, heroe2)
    | heroe2 `masRarezaArtefactos` heroe1 = (heroe2, heroe1)
    | otherwise = presumirLogros (intercambiarTareas heroe1 heroe2) (intercambiarTareas heroe2 heroe1)

mayorReconocimiento :: Heroe -> Heroe -> Bool
mayorReconocimiento ganador perdedor = masReconocimiento ganador (reconocimiento perdedor)

masRarezaArtefactos :: Heroe -> Heroe -> Bool
masRarezaArtefactos ganador perdedor = sumatoriaRarezas ganador > sumatoriaRarezas perdedor

sumatoriaRarezas :: Heroe -> Int
sumatoriaRarezas heroe = sum (map rareza (artefactos heroe))

intercambiarTareas :: Heroe -> Heroe -> Heroe
intercambiarTareas heroe1 heroe2 = hacerTareas heroe1 (listaTareas heroe2)

hacerTareas :: Heroe -> [Tarea] -> Heroe
hacerTareas = foldr hacerTarea

----------------------------------------
--           EJERCICIO 8              --
----------------------------------------

{-¿Cuál es el resultado de hacer que presuman dos héroes con reconocimiento 100, ningún artefacto y ninguna tarea realizada?
    Un bucle infinito. Al no cumplir ninguna de las primeras condiciones, estos heroes intercambian tareas pero al no tener, repite el ciclo
    con los mismos heroes con las mismas caracteristicas generando asi un ciclo infinito que no parara hasta que la computadora tenga que
    matar al proceso -}

heroe1 :: Heroe
heroe1 = Heroe "A" 100 [] []

heroe2 :: Heroe
heroe2 = Heroe "B" 100 [] []

----------------------------------------
--           EJERCICIO 9              --
----------------------------------------

-- Hacer que un héroe realice una labor, obteniendo como resultado el héroe tras haber realizado todas las tareas.

type Labor = [Tarea]

realizarLabor :: Heroe -> Labor -> Heroe
realizarLabor = hacerTareas

----------------------------------------
--           EJERCICIO 10             --
----------------------------------------

{-Si invocamos la función anterior con una labor infinita, ¿se podrá conocer el estado final del héroe? ¿Por qué?
    No, ya que haskell buscara aplicarle todas las tareas del labor al heroe previo a conocer su estado final pero, al tener tareas infinitas,
    nunca se terminaria de aplicar la totalidad de tareas. 
-}
