%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PARCIAL : Improlog %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Base de conocimientos %%

integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

esGrupo(Grupo) :-
    integrante(Grupo, _, _).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

esMusico(Musico) :-
    nivelQueTiene(Musico, _, _).

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

tieneBuenaBase(Grupo) :-
    esGrupo(Grupo),
    cubreRolDe(Grupo, Musico1, ritmico),
    cubreRolDe(Grupo, Musico2, armonico),
    Musico1 \= Musico2.

cubreRolDe(Grupo, Musico, Rol) :-
    integrante(Grupo, Musico, Instrumento),
    instrumento(Instrumento, Rol).

seDestaca(Grupo, Musico) :-
    integrante(Grupo, Musico, _),
    nivelQueTiene(Musico, _, Nivel),
    not(otroIntegranteMejor(Grupo, Musico, Nivel)).

otroIntegranteMejor(Grupo, Musico, Nivel) :-
    integrante(Grupo, OtroMusico, _),
    OtroMusico \= Musico,
    nivelQueTiene(OtroMusico, _, NivelOtro),
    NivelOtro + 1 > Nivel.

% grupo(nombre, tipo).

grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).

grupo(estudio1, ensamble).

hayCupo(Grupo, Instrumento) :-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)).
hayCupo(Grupo, Instrumento) :-
    grupo(Grupo, _),
    instrumento(Instrumento, _),
    sirve(Grupo, Instrumento),
    not(integrante(Grupo, _, Instrumento)).

sirve(Grupo, Instrumento) :-
    grupo(Grupo, formacion(Instrumentos)),
    member(Instrumento, Instrumentos).  
sirve(Grupo, Instrumento) :-
    grupo(Grupo, bigBand),
    member(Instrumento, [bateria, bajo, piano]).
sirve(Grupo, _) :-
    grupo(Grupo, ensamble).

puedeIncorporarse(Grupo, Musico, Instrumento) :-
    esMusico(Musico),
    not(integrante(Grupo, Musico, _)),
    hayCupo(Grupo, Instrumento),
    cumpleConNivel(Musico, Instrumento, Grupo).

cumpleConNivel(Musico, Instrumento, Grupo) :-
    nivelQueTiene(Musico, Instrumento, NivelMusico),
    nivelMinimo(Grupo, NivelMinimo),
    NivelMusico >= NivelMinimo.

nivelMinimo(bigBand, 1).
nivelMinimo(ensamble, 3).
nivelMinimo(formacion(Instrumentos), Nivel) :-
    length(Instrumentos, CantidadInstrumentos),
    Nivel is 7 - CantidadInstrumentos.
    
seQuedoEnBanda(Musico) :- 
    esMusico(Musico),
    not(integrante(_, Musico, _)),
    not(puedeIncorporarse(_, Musico, _)).

puedeTocar(Grupo) :-
    grupo(Grupo, ensamble),
    tieneBuenaBase(Grupo),
    cubreRolDe(Grupo, _, melodico(_)).

puedeTocar(Grupo) :-
    grupo(Grupo, bigBand),
    tieneBuenaBase(Grupo),
    tocan5Vientos(Grupo).
puedeTocar(Grupo) :-
    grupo(Grupo, formacion(InstrumentosRequeridos)),
    forall(member(Instrumento, InstrumentosRequeridos), integrante(Grupo, _, Instrumento)).

tocan5Vientos(Grupo) :-
    findall(Musico, (integrante(Grupo, Musico, Instrumento), instrumento(Instrumento, melodico(viento))), MusicosVientos),
    length(MusicosVientos, CantidadMusicoVientos),
    CantidadMusicoVientos >= 5.

