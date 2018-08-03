%PULP FICTION

personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

%PUNTO 1
esPeligroso(Personaje):-
	personaje(Personaje,ActividadPeligrosa),
	actividadPeligrosa(ActividadPeligrosa).
esPeligroso(Personaje):-
	trabajaPara(Personaje,Empleado),
	esPeligroso(Empleado).

actividadPeligrosa(ladron(LugaresRobados)):-
	member(licorerias,LugaresRobados).
actividadPeligrosa(mafioso(maton)).

%PUNTO2
duoTemible(Personaje1,Personaje2):-
	esPeligroso(Personaje1),
	esPeligroso(Personaje2),
	conocidos(Personaje1,Personaje2).

conocidos(Personaje1,Personaje2):-
	pareja(Personaje1,Personaje2).
conocidos(Personaje1,Personaje2):-
	amigo(Personaje1,Personaje2).

%PUNTO3
estaEnProblemas(butch).
estaEnProblemas(Personaje):-
	trabajaPara(Jefe,Personaje),
	esPeligroso(Jefe),
	pareja(Jefe,Esposa),
	encargo(Jefe,Personaje,cuidar(Esposa)).
estaEnProblemas(Personaje):-
	encargo(_,Personaje,buscar(Boxeador,_)),
	personaje(Boxeador,boxeador).
	
%PUNTO4
sanCayetano(Personaje):-
	encargo(Personaje,_,_),
	forall(tieneCerca(Personaje,Alguien),encargo(Personaje,Alguien,_)).

tieneCerca(Personaje,Alguien):-
	amigo(Personaje,Alguien).
tieneCerca(Personaje,Alguien):-
	trabajaPara(Alguien,Personaje).

%PUNTO5
masAtareado(Personaje):-
	cuantasTareasTiene(Personaje,Cantidad),
	forall((cuantasTareasTiene(Personaje2,Cantidad2),Personaje2\=Personaje),Cantidad2=<Cantidad).

cuantasTareasTiene(Personaje,Cantidad):-
	personaje(Personaje,_),
	findall(Tarea,encargo(_,Personaje,Tarea),ListaTareas),
	length(ListaTareas,Cantidad).

%PUNTO6
personajesRespetables(Personaje):-
	personaje(Personaje,Tarea),
	respetable(Tarea,Nivel),
	Nivel>9.

respetable(actriz(ListaPeliculas),Nivel):-
	length(ListaPeliculas,CantPeliculas),
	Nivel is CantPeliculas/10.
respetable(mafioso(Tipo),Nivel):-
	tipoMafioso(Tipo,Nivel).

tipoMafioso(resuelveProblemas,10).
tipoMafioso(maton,1).
tipoMafioso(capo,20).

%PUNTO7
hartoDe(Personaje1,Personaje2):-
	encargo(_,Personaje1,Tarea),
	personaje(Personaje2,_),
	interactuar(Tarea,Personaje2).

interactuar(cuidar(Personaje2),Personaje2).
interactuar(ayudar(Personaje2),Personaje2).
interactuar(buscar(Personaje2,_),Personaje2).
interactuar(Tarea,Personaje2):-
	amigo(Personaje2,Amigo),
	interactuar(Tarea,Amigo).

%PUNTO8
duoDiferenciable(Personaje1,Personaje2):-
	caracteristicas(Personaje1,Caracteristicas1),
	caracteristicas(Personaje2,Caracteristicas2),
	conocidos(Personaje1,Personaje2),
	not(tienenMismasCaracteristicas(Caracteristicas1,Caracteristicas2)).

tienenMismasCaracteristicas(Caracteristicas1,Caracteristicas2):-
	forall(member(C1,Caracteristicas1),member(C1,Caracteristicas2)),
	forall(member(C2,Caracteristicas2),member(C2,Caracteristicas1)).	