%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARCIAL : Steam Summer Sale %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Base de conocimientos %

% juego(nombre, precio, caracteristica(accion))
juego(counterStrike, 300, caracteristicas(accion)).
juego(gtaV, 500, caracteristicas(accion)).
juego(fortnite, 200, caracteristicas(accion)).

% juego(nombre, precio, caracteristicas(rol, usuariosActivos))
juego(wow, 500, caracteristicas(rol, 1000000)).
juego(dota2, 300, caracteristicas(rol, 500000)).
juego(minecraft, 100, caracteristicas(rol, 100000)).

% juego(nombre, precio, caracteristicas(puzzle, niveles, dificultad))
juego(candyCrush, 7, caracteristicas(puzzle, 1000, facil)).
juego(tetris, 10, caracteristicas(puzzle, 1, dificil)).
juego(2048, 5, caracteristicas(puzzle, 75, medio)).

% estaEnOferta(juego, descuento)
estaEnOferta(counterStrike, 25).
estaEnOferta(gtaV, 50).
estaEnOferta(tetris, 10).
estaEnOferta(minecraft, 75).

precio(Juego, Precio) :-
    juego(Juego, Precio, _).

precio(Juego, Precio) :-
    estaEnOferta(Juego, Descuento),
    juego(Juego, PrecioOriginal, _),
    Precio is PrecioOriginal - (PrecioOriginal * Descuento / 100).

buenDescuento(Juego) :-
    estaEnOferta(Juego, Descuento),
    Descuento > 50.

esPopular(counterStrike).
esPopular(minecraft).
esPopular(Juego) :-
    juego(Juego, _, caracteristicas(accion)).
esPopular(Juego) :-
    juego(Juego, _, caracteristicas(rol, Usuarios)),
    Usuarios > 1000000.
esPopular(Juego) :-
    juego(Juego, _, caracteristicas(puzzle, _, facil)).
esPopular(Juego) :-
    juego(Juego, _, caracteristicas(puzzle, 25, _)).

% usuario(nombre, juegosQuePosee, juegosQueQuiere).
usuario(nico, [counterStrike, wow, candyCrush], [gtaV, dota2, tetris]).
usuario(mati, [gtaV, minecraft, candyCrush], [tetris, 2048, counterStrike]).
usuario(eli, [tetris, 2048, candyCrush], [gtaV, dota2, minecraft]).
usuario(agus, [gtaV, dota2, minecraft], [counterStrike, wow, candyCrush]).

esUsuario(Usuario) :-
    usuario(Usuario, _, _).

% regaloPosible(Regalador, Receptor, Juego)

regaloPosible(nico, mati, counterStrike).
regaloPosible(mati, eli, gtaV).
regaloPosible(agus, mati, dota2).
regaloPosible(eli, agus, tetris).

adictoPorDescuentos(Usuario) :-
    usuario(Usuario, _, JuegosQueQuiere),
    forall(member(Juego, JuegosQueQuiere), buenDescuento(Juego)),
    forall(regaloPosible(Usuario, _, Juego), buenDescuento(Juego)).

esFanatico(Usuario, Genero) :-
    usuario(Usuario, JuegosQueTiene, _),
    juegosMismoGenero(JuegosQueTiene, Genero, JuegosDelGenero),
    length(JuegosDelGenero, Cantidad),
    Cantidad > 2.

juegosMismoGenero(Juegos, Genero, JuegosDelGenero) :-
    findall(Juego, esDelGenero(Juego, Juegos, Genero), JuegosDelGenero).

esDelGenero(Juego, Juegos, Genero) :-
    member(Juego, Juegos),
    genero(Juego, Genero).

genero(Juego, Genero) :-
    juego(Juego, _, caracteristicas(Genero)).
genero(Juego, Genero) :-
    juego(Juego, _, caracteristicas(Genero, _)).
genero(Juego, Genero) :-
    juego(Juego, _, caracteristicas(Genero, _, _)).

monotematico(Jugador, Genero) :- 
    usuario(Jugador, JuegosQueTiene, _),
    genero(_, Genero),
    sonMismoGenero(JuegosQueTiene, Genero).

sonMismoGenero(Juegos, Genero) :-
    forall(member(Juego, Juegos), genero(Juego, Genero)).

buenosAmigos(Usuario1, Usuario2) :-
    esUsuario(Usuario1),
    esUsuario(Usuario2),
    Usuario1 \= Usuario2,
    regalosPopulares(Usuario1, Usuario2),
    regalosPopulares(Usuario2, Usuario1).

regalosPopulares(Usuario1, Usuario2) :-
    forall(regaloPosible(Usuario1, Usuario2, Juego), esPopular(Juego)).

gastoCompras(Usuario, GastoTotal) :-
    usuario(Usuario, _, JuegosQueQuiere),
    sumarGastos(JuegosQueQuiere, GastoTotal).

gastoRegalos(Usuario, GastoTotal) :-
    findall(Juego, regaloPosible(_, Usuario, Juego), JuegosRecibidos),
    sumarGastos(JuegosRecibidos, GastoTotal).

gastoTotal(Usuario, GastoTotal) :-
    gastoCompras(Usuario, GastoCompras),
    gastoRegalos(Usuario, GastoRegalos),
    GastoTotal is GastoCompras + GastoRegalos.

sumarGastos(Juegos, GastoTotal) :-
    findall(Precio, (member(Juego, Juegos), precio(Juego, Precio)), Precios),
    sumlist(Precios, GastoTotal).


