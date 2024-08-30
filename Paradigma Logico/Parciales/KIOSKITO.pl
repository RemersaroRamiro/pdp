%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PARCIAL : KIOSKITO %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Base de conocimientos %%

/*
dodain atiende lunes, miércoles y viernes de 9 a 15.
lucas atiende los martes de 10 a 20
juanC atiende los sábados y domingos de 18 a 22.
juanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
leoC atiende los lunes y los miércoles de 14 a 18.
martu atiende los miércoles de 23 a 24.
*/

atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).

/*
Definir la relación para asociar cada persona con el rango horario que cumple, e incorporar las siguientes cláusulas:
vale atiende los mismos días y horarios que dodain y juanC.
nadie hace el mismo horario que leoC
- No hace falta agregar esto por principio de universo cerrado
maiu está pensando si hace el horario de 0 a 8 los martes y miércoles
- Si no es algo seguro no se agerga.
En caso de no ser necesario hacer nada, explique qué concepto teórico está relacionado y justifique su respuesta.
*/

atiende(vale, Dia, HoraInicio, HoraFin) :- 
    atiende(dodain, Dia, HoraInicio, HoraFin), 
    atiende(juanC, Dia, HoraInicio, HoraFin).

% Definir un predicado que permita relacionar un día y hora con una persona, en la que dicha persona atiende el kiosko.

estaAtendiendo(Persona, Dia, Hora) :-
    atiende(Persona, Dia, HoraInicio, HoraFin),
    between(HoraInicio, HoraFin, Hora).

/*
Definir un predicado que permita saber si una persona en un día y horario determinado está atendiendo ella sola. En este predicado debe utilizar not/1,
 y debe ser inversible para relacionar personas. 
*/

atiendeSola(Persona, Dia, Hora) :-
    estaAtendiendo(Persona, Dia, Hora),
    not(atiendenMasDeUna(Dia, Hora)).

atiendenMasDeUna(Dia, Hora) :-
    estaAtendiendo(OtraPersona, Dia, Hora),
    estaAtendiendo(UnaPersona, Dia, Hora),
    OtraPersona \= UnaPersona.

/*
Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día. Por ejemplo, 
si preguntamos por el miércoles, tiene que darnos esta combinatoria:
nadie
dodain solo
dodain y leoC
dodain, vale, martu y leoC
vale y martu
etc.
Queremos saber todas las posibilidades de atención de ese día. La única restricción es que la persona atienda ese día 
(no puede aparecer lucas, por ejemplo, porque no atiende el miércoles).
*/

posiblesAtendedores(Dia, Personas) :-
    findall(Persona, atiende(Persona, Dia, _, _), Personas).

/*
En el kiosko tenemos por el momento tres ventas posibles:
golosinas, en cuyo caso registramos el valor en plata
cigarrillos, de los cuales registramos todas las marcas de cigarrillos que se vendieron (ej: Marlboro y Particulares)
bebidas, en cuyo caso registramos si son alcohólicas y la cantidad

Queremos agregar las siguientes cláusulas:
dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, cigarrillos Jockey, golosinas por $ 50
dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 1 bebida no-alcohólica, golosinas por $ 10
martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.
lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.

Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió, la primera venta que hizo fue importante. Una venta es importante:
en el caso de las golosinas, si supera los $ 100.
en el caso de los cigarrillos, si tiene más de dos marcas.
en el caso de las bebidas, si son alcohólicas o son más de 5.
*/

% ventas(Persona, dia, mes, venta(Tipo, Detalle))

ventas(dodain, lunes, 10 , agosto, [venta(golosinas, 1200), venta(cigarrillos, [jockey]), venta(golosinas, 50)]).
ventas(dodain, miercoles, 12, agosto, [venta(bebidas, alcholicas,8), venta(bebidas, noAlcholicas, 1), venta(golosinas, 10)]).
ventas(martu, miercoles, 12, agosto, [venta(golosinas, 1000), venta(cigarrillos, [chesterfield, colorado, parisiennes])]).
ventas(lucas, martes, 11, agosto, [venta(golosinas, 600)]).
ventas(lucas, martes, 18, agosto, [venta(bebidas, noAlcholicas ,2), venta(cigarrillos, [derby])]).

esSuertuda(Persona) :-
    ventas(Persona, _, _, _, _),
    forall(ventas(Persona, _, _, _, [Venta | _]), esImortante(Venta)).

esImortante(venta(golosinas, Monto)) :-
    Monto > 100.
esImortante(venta(cigarrillos, Marcas)) :-
    length(Marcas, Cantidad),
    Cantidad > 2.
esImortante(venta(bebidas, alcholicas, _)).
esImortante(venta(bebidas, noAlcholicas, Cantidad)) :-
    Cantidad > 5.

    
