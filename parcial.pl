% PARTE 1: POKEDEX

pokemon(pikachu,electrico).
pokemon(charizard,fuego).
pokemon(venusaur,planta).
pokemon(blastoise,agua).
pokemon(snorlax,normal).
pokemon(rayquaza,dragon).
pokemon(rayquaza,volador).
pokemon(arceus).

entrenador(ash,pikachu).
entrenador(ash,charizard).
entrenador(brock,snorlax).
entrenador(misty,blastoise).
entrenador(misty,venusaur).
entrenador(misty,arceus).

entrenador(alf,arceus).

% 1. Saber si un pokémon es de tipo múltiple, esto ocurre cuando tiene más de un tipo.

esDeTipoMultiple(Pokemon):-
    pokemon(Pokemon,Tipo),
    pokemon(Pokemon,OtroTipo),
    Tipo \= OtroTipo.

% 2. Saber si un pokemon es legendario, lo cual ocurre si es de tipo múltiple y ningún entrenador lo tiene.

esLegendario(Pokemon):-
    pokemon(Pokemon,_),
    esDeTipoMultiple(Pokemon),
    ningunEntrenadorLoTiene(Pokemon).

ningunEntrenadorLoTiene(Pokemon):-
    pokemon(Pokemon,_),
    not(entrenador(_,Pokemon)).

% 3. Saber si un pokemon es misterioso, lo cual ocurre si es el único en su tipo o ningún entrenador lo tiene.

esMisterioso(Pokemon):-
    esElUnicoEnSuTipo(Pokemon),
    ningunEntrenadorLoTiene(Pokemon).

esElUnicoEnSuTipo(Pokemon):-
    pokemon(Pokemon,Tipo),
    pokemon(OtroPokemon,_),
    not(pokemon(OtroPokemon,Tipo)).

% PARTE 2. MOVIMIENTOS.

%fisico(Potencia).
%especial(Potencia,Tipo).
%defensivo(PorcentajeReduccion).

% movimiento(pokemon,nombre,tipo()).

movimiento(pikachu,mordedura,fisico(95)).
movimiento(pikachu,impactrueno,especial(40,electrico)).
movimiento(charizard,garraDragon,especial(100,dragon)).
movimiento(charizard,mordedura,fisico(95)).
movimiento(blastoise,proteccion,defensivo(10)).
movimiento(blastoise,placaje,fisico(50)).
movimiento(arceus,impactrueno,especial(40,electrico)).
movimiento(arceus,garraDragon,especial(100,dragon)).
movimiento(arceus,proteccion,defensivo(10)).
movimiento(arceus,placaje,fisico(50)).
movimiento(arceus,alivio,defensivo(100)).
%snorlax no se escribe por principio de universo cerrado ;)

% 1.El daño de ataque de un movimiento

danioDeAtaque(Movimiento,Ataque):- 
    movimiento(_,Movimiento,fisico(Potencia)),
    Ataque is Potencia.

danioDeAtaque(Movimiento,0):-
    movimiento(_,Movimiento,defensivo(_)).

danioDeAtaque(Movimiento,Ataque):-
    movimiento(_,Movimiento,especial(Potencia,Tipo)),
    esdeTipoBasico(Tipo),
    Ataque is Potencia * 1.5.

danioDeAtaque(Movimiento, Ataque):-
    movimiento(_,Movimiento,especial(Potencia,dragon)),
    Ataque is Potencia * 3.

danioDeAtaque(Movimiento,Ataque):-
    movimiento(_,Movimiento,especial(Potencia,Tipo)),
    not(esdeTipoBasico(Tipo)),
    Tipo \= dragon,
    Ataque is Potencia.

esdeTipoBasico(fuego).
esdeTipoBasico(agua).
esdeTipoBasico(planta).
esdeTipoBasico(normal).

% 2. La capacidad ofensiva de un pokémon, la cual está dada por la sumatoria de los daños de ataque de los movimientos que puede usar.

esPokemon(Pokemon):- pokemon(Pokemon,_).
esPokemon(Pokemon):- pokemon(Pokemon).

capacidadOfensiva(Pokemon,DanioTotal):-
    esPokemon(Pokemon),
    listaDeAtaques(Pokemon,ListaAtaques),
    sum_list(ListaAtaques, DanioTotal).

ataqueDeUnPokemon(Pokemon, Ataque):- 
    movimiento(Pokemon,Movimiento,_),
    danioDeAtaque(Movimiento,Ataque).
    
listaDeAtaques(Pokemon,ListaAtaques):-
    findall(Ataque, distinct(ataqueDeUnPokemon(Pokemon, Ataque)), ListaAtaques).

% 3 Si un entrenador es picante, lo cual ocurre si todos sus pokemons tienen una capacidad ofensiva total superior a 200 o son misteriosos.

esPicante(Entrenador):-
    entrenador(Entrenador,_),
    forall(entrenador(Entrenador,Pokemon), esPokePicante(Pokemon)).

esPokePicante(Pokemon):-
    esPokemon(Pokemon),
    capacidadOfensiva(Pokemon,CapacidadOfensiva),
    CapacidadOfensiva > 200.

esPokePicante(Pokemon):-
    esMisterioso(Pokemon).

    
