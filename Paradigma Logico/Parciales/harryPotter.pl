%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PARCIAL : HARRY POTTER %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Base de conocimientos %%

/*
Harry es sangre mestiza, y se caracteriza por ser corajudo, amistoso, orgulloso e inteligente. Odiaría que el sombrero lo mande a Slytherin.
Draco es sangre pura, y se caracteriza por ser inteligente y orgulloso, pero no es corajudo ni amistoso. Odiaría que el sombrero lo mande a Hufflepuff.
Hermione es sangre impura, y se caracteriza por ser inteligente, orgullosa y responsable. No hay ninguna casa a la que odiaría ir.
*/

mago(harry, mestiza, [coraje, amistad, orgullo, inteligencia]).
mago(draco, pura, [inteligencia, orgullo]).
mago(hermione, impura, [inteligencia, orgullo, responsabilidad]).

odia(harry, slytherin).
odia(draco, hufflepuff).

sombrero(gryffindor, Caracteristicas) :-
    member(coraje, Caracteristicas).
sombrero(slytherin, Caracteristicas) :-
    member(orgullo, Caracteristicas),
    member(inteligencia, Caracteristicas).
sombrero(ravenclaw, Caracteristicas) :-
    member(inteligencia, Caracteristicas),
    member(responsabilidad, Caracteristicas).
sombrero(hufflepuff, Caracteristicas) :-
    member(amistad, Caracteristicas).

casa(Casa) :-
    sombrero(Casa, _).

dejaEntrar(Casa, Mago):-
    esMago(Mago),
    Casa \= slytherin.

dejaEntrar(slytherin, Mago):-
    not(sangreImpura(Mago)).

sangreImpura(Mago):-
    mago(Mago, impura, _).

caracterAdecuado(Casa, Mago):-
    mago(Mago, _, Caracteristicas),
    sombrero(Casa, Caracteristicas).

puedeQuedar(gryffindor, hermione).
puedeQuedar(Casa, Mago) :-
    dejaEntrar(Casa, Mago),
    caracterAdecuado(Casa, Mago),
    noLaOdia(Casa, Mago).

noLaOdia(Casa, Mago):-
    not(odia(Mago, Casa)).

cadenaDeAmistades(Magos) :-
    todosAmistosos(Magos),
    puedenQuedarEnLaMismaCasa(Magos).

todosAmistosos(Magos) :-
    forall(member(Mago, Magos), esAmistoso(Mago)).

esAmistoso(Mago) :-
    mago(Mago, _, Caracteristicas),
    member(amistad, Caracteristicas).

puedenQuedarEnLaMismaCasa([Mago1, Mago2 | Magos]) :-
    puedeQuedar(Casa, Mago1),
    puedeQuedar(Casa, Mago2),
    puedenQuedarEnLaMismaCasa([Mago2 | Magos]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

accion(harry, fueraDeCama).
accion(hermione, irA(tercerPiso)).
accion(hermione, irA(seccionRestringida)).
accion(harry, irA(bosque)).
accion(harry, irA(tercerPiso)).
accion(draco, irA(mazmorras)).
accion(ron, ganarPartidaAjedrez).
accion(hermione, salvarAmigos).
accion(harry, ganarleAVoldemort).

puntos(fueraDeCama, -50).
puntos(irA(tercerPiso), -75).
puntos(irA(seccionRestringida), -10).
puntos(irA(bosque), -50).
puntos(ganarPartidaAjedrez, 50).
puntos(salvarAmigos, 50).
puntos(ganarleAVoldemort, 60).

esMago(Mago):-
    esDe(Mago, _).

buenAlumno(Mago):-
    esMago(Mago),
    accion(Mago, _),
    forall(accion(Mago, Accion), not(puntosNegativos(Accion))).

puntosNegativos(Accion):-
    puntos(Accion, Puntos),
    Puntos < 0.

esRecurrente(Accion):-
    accion(Mago1, Accion),
    accion(Mago2, Accion),
    Mago1 \= Mago2.


puntajeTotal(Casa, PuntajeTotal) :-
    casa(Casa),
    magosDeMismaCasa(Casa, Magos),
    findall(Puntos, (member(Mago, Magos), sumarPuntosDel(Mago, Puntos)), ListaPuntos),
    sum_list(ListaPuntos, PuntajeTotal).

magosDeMismaCasa(Casa, Magos) :-
    findall(Mago, esDe(Mago, Casa), Magos).

sumarPuntosDel(Mago, Puntos) :-
    esMago(Mago),
    findall(PuntosAccion, puntosPorAccion(Mago, _, PuntosAccion), ListaPuntos),
    sum_list(ListaPuntos, Puntos).

puntosPorAccion(Mago, Accion, Puntos) :-
    accion(Mago, Accion),
    puntos(Accion, Puntos).





