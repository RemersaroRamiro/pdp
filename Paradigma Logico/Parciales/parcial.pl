%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PARCIAL : AmorEnElAire %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%persona(Nombre, Edad, Genero).

persona(juan, 25, masculino).
persona(maria, 21, femenino).
persona(ana, 30, femenino).
persona(fer, 17, femenino). 

esPersona(Persona) :- 
    persona(Persona, _, _).

%preferencias(Persona, GenerosQueLeGustan, edad(Min, Max), Gustos, Disgustos).

preferencias(juan, [femenino], edad(20, 30), [comer, tomar, bailar, deporte, jugarJuegos], [cine, teatro, escucharMusica, estudiar, viajar]).
preferencias(maria, [masculino], edad(20, 30), [comer, tomar, bailar, deporte, jugarJuegos], [cine, teatro, escucharMusica, estudiar, viajar]).
preferencias(ana, [masculino, femenino], edad(25, 35), [cine, teatro, escucharMusica, estudiar, viajar], [comer, tomar, bailar, deporte, jugarJuegos]).
preferencias(fer, [masculino, femenino], edad(25, 35), [cine, teatro, escucharMusica, estudiar, viajar], [comer, tomar, bailar, deporte, jugarJuegos]).

perfilIncompleto(Persona) :- 
    esPersona(Persona),
    not(preferencias(Persona, _, _, _, _)).
perfilIncompleto(Persona) :- 
    esPersona(Persona),
    dejoVaciaAlgunaLista(Persona).
perfilIncompleto(Persona) :-
    esPersona(Persona),
    noCompletoEdad(Persona).
perfilIncompleto(Persona) :-
    esPersona(Persona),
    esMenorDeEdad(Persona).
perfilIncompleto(Persona) :-
    esPersona(Persona),
    preferencias(Persona, _, _, Gustos, Disgustos),
    not(tieneMinimo5(Gustos)),
    not(tieneMinimo5(Disgustos)).

dejoVaciaAlgunaLista(Persona) :-
    preferencias(Persona, [], _, _, _).
dejoVaciaAlgunaLista(Persona) :-
    preferencias(Persona, _, [], _, _).
dejoVaciaAlgunaLista(Persona) :-
    preferencias(Persona, _, _, _, []).

noCompletoEdad(Persona) :-
    preferencias(Persona, _, edad(Min, Max), _, _),
    Min \= _,
    Max \= _.

esMenorDeEdad(Persona) :-
    persona(Persona, Edad, _),
    Edad < 18.

tieneMinimo5(Lista) :-
    length(Lista, Cantidad),
    Cantidad >= 5.

almaLibre(Persona) :-
    esPersona(Persona),
    esBisexual(Persona).
almaLibre(Persona) :- 
    esPersona(Persona),
    aceptaPretendientesEnRango(30, Persona).

esBisexual(Persona) :-
    preferencias(Persona, Generos, _, _, _),
    member(masculino, Generos),
    member(femenino, Generos).

aceptaPretendientesEnRango(Rango, Persona) :-
    preferencias(Persona, _, edad(Min, Max), _, _),
    RangoEdades is Max - Min,
    RangoEdades >= Rango.

quiereLaHerencia(Persona) :-
    persona(Persona, Edad, _),
    preferencias(Persona, _, edad(Min, _), _, _),
    Min >= Edad + 30.

esIndeseable(Persona) :-
    esPersona(Persona),
    not(tienePretendiente(Persona)).

tienePretendiente(Persona) :-
    esPretendiente(_, Persona).

esPretendiente(Pretendiente, Pretendido) :-
    noSonLaMismaPersona(Pretendiente, Pretendido),
    preferencias(Pretendiente, Generos, edad(Min, Max), _, _),
    persona(Pretendido, Edad, Genero),
    compartenUnGusto(Pretendiente, Pretendido),
    member(Genero, Generos),
    between(Min, Max, Edad).

noSonLaMismaPersona(Persona1, Persona2) :-
    esPersona(Persona1),
    esPersona(Persona2),
    Persona1 \= Persona2.

compartenUnGusto(Persona1, Persona2) :-
    preferencias(Persona1, _, _, Gustos1, _),
    preferencias(Persona2, _, _, Gustos2, _),
    member(Gusto, Gustos1),
    member(Gusto, Gustos2).

hayMatch(Persona1, Persona2) :-
    noSonLaMismaPersona(Persona1, Persona2),
    esPretendiente(Persona1, Persona2),
    esPretendiente(Persona2, Persona1).

trianguloAmoroso(Persona1, Persona2, Persona3) :-
    noSonLasMismasPersona(Persona1, Persona2, Persona3),
    esPretendiente(Persona1, Persona2),
    esPretendiente(Persona2, Persona3),
    esPretendiente(Persona3, Persona1),
    not(hayMatch(Persona1, Persona2)),
    not(hayMatch(Persona2, Persona3)),
    not(hayMatch(Persona3, Persona1)).

noSonLasMismasPersona(Persona1, Persona2, Persona3) :-
    noSonLaMismaPersona(Persona1, Persona2),
    noSonLaMismaPersona(Persona1, Persona3),
    noSonLaMismaPersona(Persona2, Persona3).

unoParaElOtro(Persona1, Persona2) :-
    hayMatch(Persona1, Persona2),
    noLesMolestaSusGustos(Persona1, Persona2).

noLesMolestaSusGustos(Persona1, Persona2) :-
    preferencias(Persona1, _, _, Gustos1, Disgustos1),
    preferencias(Persona2, _, _, Gustos2, Disgustos2),
    not(leDisgustaAlgodeLaOtraPersona(Gustos1, Disgustos2)),
    not(leDisgustaAlgodeLaOtraPersona(Gustos2, Disgustos1)).

leDisgustaAlgodeLaOtraPersona(Lista1, Lista2) :-
    member(Elemento, Lista1),
    member(Elemento, Lista2).

% indiceDeAmor(PersonaQueEnvia, PersonaQueRecibe, Indice).

indiceDeAmor(maria, juan, 10).
indiceDeAmor(juan, maria, 2).
indiceDeAmor(ana, juan, 5).

hayDesbalance(Persona1, Persona2) :-
    indiceDeAmor(Persona1, Persona2, Indice),
    indiceDeAmor(Persona2, Persona1, OtroIndice),
    Indice >= OtroIndice * 2.

ghostea(Ghosteado, Ghosteador) :-
    recibioMensaje(Ghosteado, Ghosteador),
    not(recibioMensaje(Ghosteador, Ghosteado)).

recibioMensaje(Persona1, Persona2) :-
    indiceDeAmor(Persona1, Persona2, _).
    

