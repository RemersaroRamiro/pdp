----------------------------------------
--           EJERCICIO 1              --
----------------------------------------

-- Modelar los TAD cliente, chofer y viaje. 

data Cliente = Cliente {
    nombreCliente :: String,
    domicilio :: String
}

data Chofer = Chofer {
    nombreChofer :: String,
    kilometraje  :: Float,
    viajes       :: [Viaje],
    condicion    :: Condicion
}

data Viaje = Viaje {
    fecha   :: (Dia, Mes, Año),
    cliente :: Cliente,
    costo   :: Float
}
type Dia = Int
type Mes = Int
type Año = Int
type Condicion = Viaje -> Bool

----------------------------------------
--           EJERCICIO 2              --
----------------------------------------

{-En cuanto a la condición para tomar un viaje
A. Algunos choferes toman cualquier viaje
B. Otros solo toman los viajes que salgan más de $ 200
C. Otros toman aquellos en los que el nombre del cliente tenga más de n letras
D. Algunos requieren que el cliente no viva en una zona determinada
-}
-- Implementar condiciones

cualquierViaje :: Condicion
cualquierViaje _ = True

viajeMasCaro :: Condicion
viajeMasCaro viaje = costo viaje > 200

viajeNombresLargos :: Int -> Condicion
viajeNombresLargos n viaje = length nombreDelCliente > n
    where nombreDelCliente = nombreCliente (cliente viaje)

viajeSegunZona :: String -> Condicion
viajeSegunZona zona viaje = domicilio (cliente viaje) /= zona

----------------------------------------
--           EJERCICIO 3              --
----------------------------------------

{-Definir las siguientes expresiones: 
A. El cliente “Lucas” que vive en Victoria
B. El chofer “Daniel”, su auto tiene 23.500 kms., hizo un viaje con el cliente Lucas el 20/04/2017 cuyo costo fue $ 150, y toma los viajes donde el cliente no viva en “Olivos”.
C. La chofer “Alejandra”, su auto tiene 180.000 kms, no hizo viajes y toma cualquier viaje.
-}

lucas :: Cliente
lucas = Cliente "Lucas" "Victoria"

daniel :: Chofer
daniel = Chofer "Daniel" 23.500 [viajeLucas] (viajeSegunZona "Olivos")

viajeLucas :: Viaje
viajeLucas = Viaje (20,4,2017) lucas 150

alejandra :: Chofer
alejandra = Chofer "Alejandra" 180.000 [] cualquierViaje

----------------------------------------
--           EJERCICIO 4              --
----------------------------------------

-- Saber si un chofer puede tomar un viaje.

puedeTomarViaje :: Viaje -> Chofer -> Bool
puedeTomarViaje viaje chofer = condicion chofer viaje

----------------------------------------
--           EJERCICIO 5              --
----------------------------------------

-- Saber la liquidación de un chofer, que consiste en sumar los costos de cada uno de los viajes. Por ejemplo, Alejandra tiene $ 0 y Daniel tiene $ 150.

liquidacion :: Chofer -> Float
liquidacion chofer = sum (costoViajes chofer)

costoViajes :: Chofer -> [Float]
costoViajes = map costo . viajes

----------------------------------------
--           EJERCICIO 6              --
----------------------------------------

{-Realizar un viaje: dado un viaje y una lista de choferes, se pide que:
A. Filtre los choferes que toman ese viaje. Si ningún chofer está interesado, no se preocupen: el viaje no se puede realizar.
B. Considerar el chofer que menos viaje tenga. Si hay más de un chofer elegir cualquiera.
C. Efectuar el viaje: esto debe incorporar el viaje a la lista de viajes del chofer. ¿Cómo logra representar este cambio de estado?
-}

realizarViaje :: Viaje -> [Chofer] -> Chofer
realizarViaje viaje  = agregarViaje viaje . elegirMenosViajes . filtrarChoferesInteresados viaje

filtrarChoferesInteresados :: Viaje -> [Chofer] -> [Chofer]
filtrarChoferesInteresados viaje = filter (puedeTomarViaje viaje)

elegirMenosViajes :: [Chofer] -> Chofer
elegirMenosViajes  = head . choferesConMenosViajes 

choferesConMenosViajes :: [Chofer] -> [Chofer]
choferesConMenosViajes choferes = filter ((==minimoViajes choferes) . length . viajes) choferes

minimoViajes :: [Chofer] -> Int
minimoViajes = minimum . map (length . viajes)

agregarViaje :: Viaje -> Chofer -> Chofer
agregarViaje viaje = modificarViajes (++ [viaje])

modificarViajes :: ([Viaje] -> [Viaje]) -> Chofer -> Chofer
modificarViajes modificador chofer = chofer {viajes = modificador (viajes chofer)}

----------------------------------------
--           EJERCICIO 7              --
----------------------------------------

{-Al infinito y más allá
A. Modelar al chofer “Nito Infy”, su auto tiene 70.000 kms., que el 11/03/2017 hizo infinitos viajes de $ 50 con Lucas y toma cualquier viaje donde el cliente 
tenga al menos 3 letras. Puede ayudarse con esta función:
-}

nitoInfy :: Chofer
nitoInfy = Chofer "Nito Infy" 70.000 (viajesInfinitos viajeNuevoLucas) (viajeNombresLargos 3)

viajesInfinitos :: Viaje -> [Viaje]
viajesInfinitos  = repeat 

viajeNuevoLucas :: Viaje
viajeNuevoLucas = Viaje (11,3,2017) lucas 50

-- B. ¿Puede calcular la liquidación de Nito? Justifique.
-- No, porque la liquidacion de Nito es infinita

-- C. Y saber si Nito puede tomar un viaje de Lucas de $ 500 el 2/5/2017? Justifique. 
-- Si, ya que se puede utilizar tomarViaje con el nuevo directamente sin involucrar la lista inifnita pendiente

----------------------------------------
--           EJERCICIO 8              --
----------------------------------------

-- Inferir el tipo de la función gōngnéng
{-
gongNeng arg1 arg2 arg3 = max arg1 . head . filter arg2 . map arg3
Primero realiza un mapeo a una lista [a] con arg3, por lo tanto este es una funcion (a -> b)
quedando ahora una lista [b]. Ahora se filtra [b] con arg2 por lo tanto este es una funcion (b -> Bool).
Luego con el head se tema el primer elemento de la lista: b. Y se busca el maximo entre este y arg1.
Por lo que este es un dato tipo b. Devolviendo tambien un tipo de dato b.
Por lo tanto el tipo de la función es 
b->(b->Bool)->(a->b)->[a]->b
Siendo que se tienen que b tiene que poder compararse con max:
Ord b => b->(b->Bool)->(a->b)->[a]->b
-}

