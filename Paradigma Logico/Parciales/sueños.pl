%%%%%%%%%%%%%%%%%%%%%%%%
%   PARCIAL : Sueños   %
%%%%%%%%%%%%%%%%%%%%%%%%

% Base de conocimientos %

creeEn(gabriel, campanita).
creeEn(gabriel, elMagoDeOz).
creeEn(gabriel, cavenaghi).
creeEn(juan, conejoDePascua).
creeEn(macarena, reyesMagos).
creeEn(macarena, elMagoCapria).
creeEn(macarena, campanita).

% Como diego no cree en nada no lo pongo -> Universo cerrado

sueniaCon(gabriel, ganarLoteria([5,9])).
sueniaCon(gabriel, serFutbolista(arsenal)).
sueniaCon(juan, cantante(100000)).
sueniaCon(macarena, cantante(10000)).

% Macarena no quiere ganar la loteria, por lo que no se pone 

dificultad(cantante(Ventas), Dificultad) :-
    Ventas > 500000,
    Dificultad is 6.

dificultad(cantante(Ventas), Dificultad) :-
    Ventas =< 500000,
    Dificultad is 4.

dificultad(ganarLoteria(Numeros), Dificultad) :-
    length(Numeros, Cantidad),
    Dificultad is Cantidad * 10.

dificultad(serFutbolista(Equipo), 3) :-
    equipoChico(Equipo).

dificultad(serFutbolista(Equipo), 16) :-
    not(equipoChico(Equipo)).

equipoChico(arsenal).
equipoChico(aldosivi).

esAmbiciosa(Persona) :-
    findall(Dificultad, (sueniaCon(Persona, Suenio), dificultad(Suenio, Dificultad)), Dificultades),
    sum_list(Dificultades, Total),
    Total > 20.

tieneQuimica(Persona, campanita) :-
    creeEn(Persona, campanita),
    tieneSuenioProbable(Persona).

tieneQuimica(Persona, Personaje) :-
    creeEn(Persona, Personaje),
    Personaje \= campanita,
    not(esAmbiciosa(Persona)),
    not(tieneSuenioImpuro(Persona)).

tieneSuenioProbable(Persona) :-
    sueniaCon(Persona, Suenio),
    dificultad(Suenio, Dificultad),
    Dificultad < 5.

tieneSuenioImpuro(Persona) :-
    sueniaCon(Persona, Suenio),
    not(esPuro(Suenio)).

esPuro(cantante(Ventas)) :-
    Ventas < 200000.
esPuro(serFutbolista(_)).

esAmiga(campanita, reyesMagos).
esAmiga(campanita, conejoDePascua).
esAmiga(conejoDePascua, cavenaghi).

% "Entre otras amistades" no se tiene en cuenta ya que no es certero


puedeAlegrar(Personaje, Persona) :-
    sueniaCon(Persona, _),
    tieneQuimica(Persona, Personaje),
    algunoNoEstaEnfermo(Personaje).

estaEnfermo(campanita).
estaEnfermo(conejoDePascua).

algunoNoEstaEnfermo(Personaje) :-
    not(estaEnfermo(Personaje)).
algunoNoEstaEnfermo(Personaje) :-
    esAmiga(Personaje, Amigo),
    not(estaEnfermo(Amigo)).
algunoNoEstaEnfermo(Personaje) :-
    esAmiga(Personaje, Amigo),
    algunoNoEstaEnfermo(Amigo).


