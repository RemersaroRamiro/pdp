%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PARCIAL : TURF %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Base de conocimientos %%

% jockey(nombre, altura(cm), peso).
jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano, 149, 50).
jockey(baratucci, 153, 55).
jockey(falero, 157, 52).

esJockey(Jockey) :- 
    jockey(Jockey, _, _).

% caballo(nombre, preferncias).

caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

preferencia(botafogo, baratucci).
preferencia(botafogo, Jockey) :-
    esJockey(Jockey),
    pesaMenosDeNKilos(Jockey, 52).
preferencia(oldMan, Jockey) :-
    esJockey(Jockey),
    nombreLargo(Jockey).
preferencia(energica, Jockey) :-   
    esJockey(Jockey),
    not(preferencia(botafogo, Jockey)).
preferencia(matBoy, Jockey) :-
    esJockey(Jockey),
    mideMasDeNcm(Jockey, 170).  

pesaMenosDeNKilos(Jockey, N) :-
    jockey(Jockey, _, Peso),
    Peso < N.
nombreLargo(Jockey) :-
    atom_length(Jockey, Largo),
    Largo > 7.
mideMasDeNcm(Jockey, N) :-
    jockey(Jockey, Altura, _),
    Altura > N.

% stud(Jockey, Caballeriza).

stud(valdivieso, elTute).
stud(falero, elTute).
stud(lezcano, lasHormigas).
stud(baratucci, elCharabon).
stud(leguisamo, elCharabon).

% premio(caballo, premio).

premio(botafogo, granPremioNacional).
premio(botafogo, granPremioRepublica).
premio(oldMan, granPremioRepublica).
premio(oldMan, campeonatoPalermoDeOro).
premio(matBoy, granPremioCriadores).

prefierenMasDeUnJockey(Caballo) :-
    esJockey(Jockey1),
    esJockey(Jockey2),
    preferencia(Caballo, Jockey1),
    preferencia(Caballo, Jockey2),
    Jockey1 \= Jockey2.

aborreceA(Caballo, Caballeriza) :- 
    stud(_, Caballeriza),
    not(prefiereAlgunJockeyDe(Caballo, Caballeriza)).

prefiereAlgunJockeyDe(Caballo, Caballeriza) :-
    stud(Jockey, Caballeriza),
    preferencia(Caballo, Jockey).

premioImportante(granPremioNacional).
premioImportante(granPremioRepublica).

esPiolin(Jockey) :-
    esJockey(Jockey),
    forall(caballosImportantes(Caballo), preferencia(Caballo, Jockey)).

caballosImportantes(Caballo) :-
    premioImportante(Premio),
    premio(Caballo, Premio).

apuestaGanador(Caballo, Resultado) :- 
    caballo(Caballo),
    salioPrimero(Caballo, Resultado).

salioPrimero(Caballo, [Caballo | _]).

apuestaSegundo(Caballo, Resultado) :- 
    caballo(Caballo),
    salioSegundo(Caballo, Resultado).

salioSegundo(Caballo, [_, Caballo | _]).

apuestaExacta(Caballo1, Caballo2, Resultado) :- 
    salioPrimero(Caballo1, Resultado),
    salioSegundo(Caballo2, Resultado),
    Caballo1 \= Caballo2.

apuestaImperfecto(Caballo1, Caballo2, Resultado) :- 
     apuestaExacta(Caballo1, Caballo2, Resultado).
apuestaImperfecto(Caballo1, Caballo2, Resultado) :-
    apuestaExacta(Caballo2, Caballo1, Resultado).

coloCrin(botafogo, tordo).
colorCrin(oldMan, alazan).
colorCrin(energica, ratonero).
colorCrin(matBoy, palomino).
colorCrin(yatasto, pinto).

color(tordo, negro).
color(alazan, marron).
color(ratonero, gris).
color(ratonero, negro).
color(palomino, marron).
color(palomino, blanco).
color(pinto, blanco).
color(pinto, marron).

puedeComprar(Caballos, PreferenciaColor) :-
    findall(Caballo, tieneColor(Caballo, PreferenciaColor), Caballos).

tieneColor(Caballo, Color) :-
    colorCrin(Caballo, Crin),
    color(Crin, Color).
    



