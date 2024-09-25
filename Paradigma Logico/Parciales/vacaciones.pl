%%%%%%%%%%%%%%%%%%%%%%%%
% PARCIAL : Vacaciones %
%%%%%%%%%%%%%%%%%%%%%%%%

% Base de conocimientos %

seVa(dodain, [pehuenia, sanMartinDeLosAndes, esquel, sarmiento, camarones, playasDoradas]). 
seVa(alf, [bariloche, sanMartinDeLosAndes, elBolson]).
seVa(nico, [marDelPlata]).
seVa(vale, [elCalafate, elBolson]).
seVa(martu, Destinos) :-
    seVa(dodain, Destinos1),
    seVa(alf, Destinos2),
    intersection(Destinos1, Destinos2, Destinos).

% Juan y Carlos no se ponen debido al universo cerrado y necesidad de certeza.

% playa(diferenciaMarea).


tieneAtracciones(esquel, parqueNacional(losAlerces)).
tieneAtracciones(esquel, excursion(trochita)).
tieneAtracciones(esquel, excursion(trevelin)).
tieneAtracciones(pehuenia, cerro(bateaMahuida, 2000)).
tieneAtracciones(pehuenia, cuerpoDeAgua(moquehue, sePuedePescar, 14)).
tieneAtracciones(pehuenia, cuerpoDeAgua(alumine, sePuedePescar, 19)).

vacaionesCopadas(Peronsa) :-
    seVa(Peronsa, Destinos),
    forall(member(Destino, Destinos), tieneAtraccionCopada(Destino)).

tieneAtraccionCopada(Destino) :-
    tieneAtracciones(Destino, Atraccion),
    atraccionCopada(Atraccion).

atraccionCopada(parqueNacional(_)).
atraccionCopada(excursion(Nombre)) :-
    length(Nombre, Letras),
    Letras > 7.
atraccionCopada(playa(DiferenciaDeMareas)) :-
    DiferenciaDeMareas < 5.
atraccionCopada(cuerpoDeAgua(_, sePuedePescar, _)).
atraccionCopada(cuerpoDeAgua(_, _, TemperaturaPromedio)) :-
    TemperaturaPromedio > 20.
atraccionCopada(cerro(_, Altura)) :-
    Altura > 2000.

noSeCruzaron(Persona1, Persona2) :-
    seVa(Persona1, Destinos1),
    seVa(Persona2, Destinos2),
    Persona1 \= Persona2,
    not(seCruzaron(Destinos1, Destinos2)).

seCruzaron(Destinos1, Destinos2) :-
    member(Destino, Destinos1),
    member(Destino, Destinos2).

costoDeVida(sarmiento, 100).
costoDeVida(esquel, 150).
costoDeVida(pehuenia, 180).
costoDeVida(sanMartinDeLosAndes, 150).
costoDeVida(camarones, 135).
costoDeVida(playasDoradas, 170).
costoDeVida(bariloche, 140).
costoDeVida(elCalafate, 240).
costoDeVida(elBolson, 145).
costoDeVida(marDelPlata, 140).

fueGasolera(Persona) :-
    seVa(Persona, Destinos),
    forall(member(Destino, Destinos), destinoGasolero(Destino)).

destinoGasolero(Destino) :-
    costoDeVida(Destino, Costo),
    Costo < 160.

itinerario(Persona, Itinerario) :-
    seVa(Persona, Destinos),
    permutation(Destinos, Itinerario).






    


    