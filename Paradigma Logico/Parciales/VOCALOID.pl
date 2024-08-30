%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PARCIAL : VOCALOID %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Base de conocimientos %%

% sabeCantar(Nombre, cancion(nombre, duracion)).

sabeCantar(megurineLuka, cancion(nightFever, 4)).
sabeCantar(megurineLuka, cancion(foreverYoung, 5)).
sabeCantar(hatsuneMiku, cancion(tellYourWorld, 4)).
sabeCantar(gumi, cancion(foreverYoung, 4)).
sabeCantar(gumi, cancion(tellYourWorld, 5)).
sabeCantar(seeU, cancion(novemberRain, 6)).
sabeCantar(seeU, cancion(nightFever, 5)).

% concierto(Nombre, Pais, Fama, gigante(cancionesMinimas, duracionTotalMinima)).
concierto(mikuExpo, estadosUnidos, 2000, gigante(3, 6)).
concierto(magicalMirai, japon, 3000, gigante(4, 10)).
% concierto(Nombre, Pais, Fama, mediano(duracionTotalMaxima)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
% concierto(Nombre, Pais, Fama, pequenio(duracionMinima)).
concierto(mikuFest, argentina, 100, pequenio(4)).

% conoceA(Nombre1, Nombre2).

conoceA(megurineLuka, hatsuneMiku).
conoceA(megurineLuka, gumi).
conoceA(seeU, kaito).
conoceA(gumi, seeU).



/*
Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, por lo que necesitamos un predicado para saber si un vocaloid 
es novedoso cuando saben al menos 2 canciones y el tiempo total que duran todas las canciones debería ser menor a 15.
*/

esNovedoso(Vocaloid):-
    sabeCantar(Vocaloid, _),
    masDeNcanciones(Vocaloid, 2),
    minimoDuracion(Vocaloid, 15).

duracionTotal(Vocaloid, DuracionTotal):-
    findall(Duracion, (sabeCantar(Vocaloid, cancion(_, Duracion))), Duraciones),
    sumlist(Duraciones, DuracionTotal).

minimoDuracion(Vocaloid, DuracionTotalMinima):-
    duracionTotal(Vocaloid, DuracionTotal),
    DuracionTotal >= DuracionTotalMinima.

cantidadCanciones(Vocaloid, Cantidad):-
    findall(Cancion, sabeCantar(Vocaloid, Cancion), Canciones),
    length(Canciones, Cantidad).

masDeNcanciones(Vocaloid, Cantidad):-
    cantidadCanciones(Vocaloid, CantidadCanciones),
    CantidadCanciones >= Cantidad.

/*
Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta, es por eso que se pide saber si un cantante es acelerado, 
condición que se da cuando todas sus canciones duran 4 minutos o menos. Resolver sin usar forall/2.
*/

esAcelerado(Vocaloid):-
    sabeCantar(Vocaloid, _),
    not(tieneCancionLarga(Vocaloid)).

tieneCancionLarga(Vocaloid):-
    sabeCantar(Vocaloid, cancion(_, Duracion)),
    Duracion > 4.
 
/*
Se requiere saber si un vocaloid puede participar en un concierto, esto se da cuando cumple los requisitos del tipo de concierto. También sabemos que Hatsune Miku 
puede participar en cualquier concierto.
*/

puedeParticipar(hatsuneMiku, _).
puedeParticipar(Vocaloid, Concierto) :-
    sabeCantar(Vocaloid, _),
    concierto(Concierto, _, _, TipoConcierto),
    cumpleRequisitos(Vocaloid, TipoConcierto).

cumpleRequisitos(Vocaloid, gigante(CancionesMinimas, DuracionTotalMinima)):-
    masDeNcanciones(Vocaloid, CancionesMinimas),
    minimoDuracion(Vocaloid, DuracionTotalMinima).

cumpleRequisitos(Vocaloid, mediano(DuracionTotalMaxima)):-
    duracionTotal(Vocaloid, DuracionTotal),
    DuracionTotal =< DuracionTotalMaxima.

cumpleRequisitos(Vocaloid, pequenio(DuracionMinima)):-
    duracionTotal(Vocaloid, DuracionTotal),
    DuracionTotal >= DuracionMinima.

/*
Conocer el vocaloid más famoso, es decir con mayor nivel de fama. El nivel de fama de un vocaloid se calcula como la fama total que le dan los conciertos en los cuales 
puede participar multiplicado por la cantidad de canciones que sabe cantar.
*/

masFamoso(Vocaloid) :-
    nivelFama(Vocaloid, Fama),
    forall(nivelFama(_, OtraFama), Fama >= OtraFama).

nivelFama(Vocaloid, FamaTotal):-
    famaPorGira(Vocaloid, FamaPorGira),
    cantidadCanciones(Vocaloid, CantidadCanciones),
    FamaTotal is FamaPorGira * CantidadCanciones.

famaPorGira(Vocaloid, FamaPorGira):-
    sabeCantar(Vocaloid, _),
    findall(Fama, famaDeConciertosDisponibles(Vocaloid, Fama), Famas),
    sumlist(Famas, FamaPorGira).

famaDeConciertosDisponibles(Vocaloid, Fama):-
    puedeParticipar(Vocaloid, Concierto),
    concierto(Concierto, _, Fama, _).

/*
Queremos verificar si un vocaloid es el único que participa de un concierto, esto se cumple si ninguno de sus conocidos ya sea directo o indirectos 
(en cualquiera de los niveles) participa en el mismo concierto.
*/

unicoParticipante(Vocaloid, Concierto):-
    puedeParticipar(Vocaloid, Concierto),
    not(tieneUnConocidoEnConcierto(Vocaloid,Concierto)).

tieneUnConocidoEnConcierto(Vocaloid, Concierto):-
    conocido(Vocaloid, Conocido),
    puedeParticipar(Conocido, Concierto).

conocido(Vocaloid, Conocido):-
    conoceA(Vocaloid, Conocido).

conocido(Vocaloid, Conocido):-
    conoceA(Vocaloid, OtroConocido),
    conocido(OtroConocido, Conocido).

/*
Supongamos que aparece un nuevo tipo de concierto y necesitamos tenerlo en cuenta en nuestra solución, explique los cambios que habría que realizar para que siga todo 
funcionando. ¿Qué conceptos facilitaron dicha implementación?

Para que siga todo funcionando, deberíamos agregar un nuevo tipo de concierto en la base de conocimientos y modificar el predicado puedeParticipar/2 para que
cumpla los requisitos del nuevo tipo de concierto. Los conceptos que facilitaron dicha implementación son el polimorfismo y el uso de predicados que permiten
abstraer la lógica de los conciertos, como cumpleRequisitos/2.
*/

