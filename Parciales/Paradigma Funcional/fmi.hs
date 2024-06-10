{-
Enunciado: 
Enunciado general
El fondo monetario internacional nos solicitó que modelemos su negocio, basado en realizar préstamos a países en apuros financieros. Sabemos de cada país el "ingreso per cápita" que es el promedio de lo que cada habitante necesita para subsistir, también conocemos la población activa en el sector público y la activa en el sector privado, la lista de recursos naturales (ej: "Minería", "Petróleo", "Industria pesada") y la deuda que mantiene con el FMI.

El FMI es especialista en dar recetas. Cada receta combina una o más estrategias que se describen a continuación:
prestarle n millones de dólares al país, esto provoca que el país se endeude en un 150% de lo que el FMI le presta (por los intereses)
reducir x cantidad de puestos de trabajo del sector público, lo que provoca que se reduzca la cantidad de activos en el sector público y además que el ingreso per cápita disminuya en 20% si los puestos de trabajo son más de 100 ó 15% en caso contrario
darle a una empresa afín al FMI la explotación de alguno de los recursos naturales, esto disminuye 2 millones de dólares la deuda que el país mantiene con el FMI pero también deja momentáneamente sin recurso natural a dicho país. No considerar qué pasa si el país no tiene dicho recurso.
establecer un “blindaje”, lo que provoca prestarle a dicho país la mitad de su Producto Bruto Interno (que se calcula como el ingreso per cápita multiplicado por su población activa, sumando puestos públicos y privados de trabajo) y reducir 500 puestos de trabajo del sector público. Evitar la repetición de código.

-}

----------------------------------------
--           EJERCICIO 1              --
----------------------------------------

-- A. Representar el TAD País.

data Pais = Pais {
    ingresoPerCapita       :: Float,
    poblacionSectorPublico :: Float,
    poblacionSectorPrivado :: Float,
    recursosNaturales      :: [RecursoNatural],
    deudaFMI               :: Float
} deriving (Show)

type RecursoNatural = String

-- B. Dar un ejemplo de cómo generar al país Namibia, cuyo ingreso per cápita es de 4140 u$s, la población activa del sector público es de 400.000,
-- la población activa del sector privado es de 650.000, su riqueza es la minería y el ecoturismo y le debe 50 (millones de u$s) al FMI.

namibia :: Pais
namibia = Pais 4140 400000 650000 ["Mineria", "Ecoturismo"] 50

----------------------------------------
--           EJERCICIO 2              --
----------------------------------------

--Implementar las estrategias que forman parte de las recetas del FMI. 

type Estrategia = Pais -> Pais

-- A. Prestarle n millones de dólares al país, esto provoca que el país se endeude en un 150% de lo que el FMI le presta (por los intereses)
prestarDinero :: Float -> Estrategia
prestarDinero cantidadPrestamo   = modificarDeuda ((cantidadPrestamo  * 1.5) +) 

modificarDeuda :: (Float -> Float) -> Pais -> Pais
modificarDeuda modificador pais = pais { deudaFMI = modificador (deudaFMI pais) }

-- B. Reducir x cantidad de puestos de trabajo del sector público, lo que provoca que se reduzca la cantidad de activos en el sector público y 
-- además que el ingreso per cápita disminuya en 20% si los puestos de trabajo son más de 100 ó 15% en caso contrario

reducirPuestosTrabajo :: Float -> Estrategia
reducirPuestosTrabajo cantidadPuestosTrabajo pais
    | cantidadPuestosTrabajo > 100   = modificarPuestosTrabajo (flip (-) cantidadPuestosTrabajo) . modificarIngresoPerCapita (* 0.8) $ pais
    | otherwise                      = modificarPuestosTrabajo (flip (-) cantidadPuestosTrabajo) . modificarIngresoPerCapita (* 0.85) $ pais

modificarPuestosTrabajo :: (Float -> Float) -> Pais -> Pais
modificarPuestosTrabajo modificador pais = pais { poblacionSectorPublico = modificador (poblacionSectorPublico pais) }

modificarIngresoPerCapita :: (Float -> Float) -> Pais -> Pais
modificarIngresoPerCapita modificador pais = pais { ingresoPerCapita = modificador (ingresoPerCapita pais) }

-- C. Darle a una empresa afín al FMI la explotación de alguno de los recursos naturales, esto disminuye 2 millones de dólares la deuda que el país 
-- mantiene con el FMI pero también deja momentáneamente sin recurso natural a dicho país. No considerar qué pasa si el país no tiene dicho recurso.

explotarRecursosNaturales :: RecursoNatural -> Estrategia
explotarRecursosNaturales recurso = modificarDeuda (flip (-) 2000000) . modificarRecursosNaturales (filter (/= recurso))

modificarRecursosNaturales :: ([RecursoNatural] -> [RecursoNatural]) -> Pais -> Pais
modificarRecursosNaturales modificador pais = pais { recursosNaturales = modificador (recursosNaturales pais) }

-- D. establecer un “blindaje”, lo que provoca prestarle a dicho país la mitad de su Producto Bruto Interno (que se calcula como el ingreso per cápita multiplicado 
-- por su población activa, sumando puestos públicos y privados de trabajo) y reducir 500 puestos de trabajo del sector público. Evitar la repetición de código.

blindaje :: Estrategia
blindaje pais = prestarDinero (productoBrutoInterno pais / 2) (reducirPuestosTrabajo 500 pais)

productoBrutoInterno :: Pais -> Float
productoBrutoInterno pais = ingresoPerCapita pais * poblacionTotal pais

poblacionTotal :: Pais -> Float
poblacionTotal pais = poblacionSectorPublico pais + poblacionSectorPrivado pais

------------------------------------------
--           EJERCICIO 3               --
-----------------------------------------

-- Modelar una receta que consista en prestar 200 millones, y darle a una empresa X la explotación de la “Minería” de un país.

type Receta = [Estrategia]

receta1 :: Receta
receta1 = [prestarDinero 200, explotarRecursosNaturales "Mineria"]

-- Ahora queremos aplicar la receta del punto 3.a al país Namibia (creado en el punto 1.b). Justificar cómo se logra el efecto colateral.

aplicarReceta :: Receta -> Pais -> Pais
aplicarReceta receta pais = foldr ($) pais receta

namibiaModificada :: Pais
namibiaModificada = aplicarReceta receta1 namibia

------------------------------------------
--           EJERCICIO 4               --
-----------------------------------------
--Resolver todo el punto con orden superior, composición y aplicación parcial, no puede utilizar funciones auxiliares.

-- Dada una lista de países conocer cuáles son los que pueden zafar, aquellos que tienen "Petróleo" entre sus riquezas naturales.

paisesQueZafan :: [Pais] -> [Pais]
paisesQueZafan = filter (elem "Petroleo". recursosNaturales)

-- Dada una lista de países, saber el total de deuda que el FMI tiene a su favor.

deudaTotal :: [Pais] -> Float
deudaTotal = sum . map deudaFMI

------------------------------------------
--           EJERCICIO 5               --
-----------------------------------------

{-Debe resolver este punto con recursividad: dado un país y una lista de recetas, saber si la lista de recetas está ordenada de “peor” a “mejor”, 
en base al siguiente criterio: si aplicamos una a una cada receta, el PBI del país va de menor a mayor. Recordamos que el Producto Bruto Interno 
surge de multiplicar el ingreso per cápita por la población activa (privada y pública). -}

estaOrdenada :: Pais -> [Receta] -> Bool
estaOrdenada _ [] = True
estaOrdenada pais [_] = True
estaOrdenada pais (receta1:receta2:recetas) = productoBrutoInterno (aplicarReceta receta1 pais) > productoBrutoInterno (aplicarReceta receta2 pais) && estaOrdenada pais (receta2:recetas)

------------------------------------------
--           EJERCICIO 6               --
-----------------------------------------

-- Si un país tiene infinitos recursos naturales, modelado con esta función
recursosNaturalesInfinitos :: [String]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos
-- A. ¿qué sucede evaluamos la función 4a con ese país? 
-- La funcion nunca finalizara ya que al evaluar una lista infinita jamas terminara de filtrarla, aunque uno sepa que siempre sera energia 
-- y no petroleo, haskell no.
-- B. ¿y con la 4b?
-- En este caso se ejecutara con exito ya que la lista infinita de recursos no interviene en la deuda total de un pais  