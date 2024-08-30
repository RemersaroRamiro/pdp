/*
TEG
E n vista de que gran parte de las personas (chicos y grandes) abandonan los juegos clásicos por modernos juegos de PC, la juguetería de Lanús Quindimil SRL decide 
llevar su negocio al terreno digital para poder competir con las nuevas formas de esparcimiento. Así es como se comunican con nosotros solicitándonos que realicemos 
el desarrollo de ciertas consultas para un tablero de TEG, que se realizan cada cierto tiempo. Cada vez que se realizan las consultas, vamos a contar con ciertos 
hechos como los que ejemplificamos a continuación. 
*/

paisContinente(americaDelSur, argentina).
paisContinente(americaDelSur, bolivia).
paisContinente(americaDelSur, brasil).
paisContinente(americaDelSur, chile).
paisContinente(americaDelSur, ecuador).
paisContinente(europa, alemania).
paisContinente(europa, espania).
paisContinente(europa, francia).
paisContinente(europa, inglaterra).
paisContinente(asia, aral).
paisContinente(asia, china).
paisContinente(asia, india).
paisContinente(asia, afganistan).
paisContinente(asia, nepal).

paisImportante(argentina).
paisImportante(alemania).

limitrofes(argentina, brasil).
limitrofes(bolivia, brasil).
limitrofes(bolivia, argentina).
limitrofes(argentina, chile).
limitrofes(espania, francia).
limitrofes(alemania, francia).
limitrofes(nepal, india).
limitrofes(china, india).
limitrofes(nepal, china).
limitrofes(afganistan, china).

ocupa(argentina, azul).
ocupa(bolivia, rojo).
ocupa(brasil, verde).
ocupa(chile, negro).
ocupa(ecuador, rojo).
ocupa(alemania, azul).
ocupa(espania, azul).
ocupa(francia, azul).
ocupa(inglaterra, azul).
ocupa(aral, verde).
ocupa(china, negro).
ocupa(india, verde).
ocupa(afganistan, verde).

continente(americaDelSur).
continente(europa).
continente(asia).

% Se solicita construir un programa que permita la resolución de las siguientes consultas. Todos los predicados deben ser inversibles.

% 1. estaEnContinente/2: relaciona un jugador y un continente si el jugador ocupa al menos un país en el continente.

estaEnContinente(Jugador, Continente) :-
    paisContinente(Continente, Pais),
    ocupa(Pais, Jugador).

% ocupaContinente/2: relaciona un jugador y un continente si el jugador ocupa totalmente el continente. 

ocupaContinente(Jugador, Continente) :-
    jugador(Jugador),
    continente(Continente),
    forall(paisContinente(Continente,Pais), ocupa(Pais, Jugador)).

jugador(Jugador) :-
    ocupa(_, Jugador).

% cubaLibre/1: es verdadero para un país si nadie lo ocupa.

cubaLibre(Pais) :-
    pais(Pais),
    not(ocupa(Pais, _)).

pais(Pais) :-
    paisContinente(_, Pais).

% leFaltaMucho/2: relaciona a un jugador si está en un continente pero le falta ocupar otros 2 países o más.

leFaltaMucho(Jugador, Continente) :-
    jugador(Jugador),
    continente(Continente),
    estaEnContinente(Jugador, Continente),
    noOcupaPaisDe(Continente, Pais, Jugador),
    noOcupaPaisDe(Continente, OtroPais, Jugador),
    Pais \= OtroPais.

noOcupaPaisDe(Continente, Pais, Jugador) :-
    paisContinente(Continente, Pais),
    not(ocupa(Pais, Jugador)).

% sonLimitrofes/2: relaciona dos países si son limítrofes considerando que si A es limítrofe de B, entonces B también es limítrofe de A.

sonLimitrofes(Pais, OtroPais) :-
    limitrofes(Pais, OtroPais).

sonLimitrofes(Pais, OtroPais) :-
    limitrofes(OtroPais, Pais).

% tipoImportante/1: un jugador es importante si ocupa todos los países importantes.

tipoImportante(Jugador) :-
    jugador(Jugador),
    forall(paisImportante(Pais), ocupa(Pais, Jugador)).

% estaEnElHorno/1: un país está en el horno si todos sus países limítrofes están ocupados por el mismo jugador que no es el mismo que ocupa ese país.

estaEnElHorno(Pais) :-
    jugador(Jugador),
    jugador(Enemigo),
    ocupa(Pais, Jugador1),
    forall(limitrofes(Pais, PaisVecino), ocupa(PaisVecino, Enemigo)),
    Jugador1 \= Enemigo.    

% esCompartido/1: un continente es compartido si hay dos o más jugadores en él.

esCompartido(Continente) :-
    estaEnContinente(Jugador, Continente),
    estaEnContinente(OtroJugador, Continente),
    Jugador \= OtroJugador.