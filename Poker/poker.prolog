%===================================================================
%
%	Alberto Palacios Cabrera
%	
%	Tarea #1. Modelado de "manos" en Poker
%
%	- Modele el dominio Poker en una base de conocimiento Prolog
%	y construya un programa para generar aleatoriamente "manos"
%	de Poker, compararlas y ordenarlas descendentemente
%	
%	- El predicado principal "juega_Poker/1" recibe como argumento
%	el número de manos que se debe generar aleatoriamente
%
%	
%	Predicados relevantes:
%
%		númeroBarajas(<NúmeroJugadores>,<NúmeroBarajas>)
%		generarMazo(<NúmeroBarajas>,<Baraja>,<Mazo>)
%		analizarManos(<listaManos>,<ListaLugares>)
%		repartirCartas(<NúmeroJugadores>,<Mazo>,<Manos>)
%		crearMano(<NúmeroCartas>,<Mazo>,<Mano>,<MazoActualizado>)
%		mano(<ValorMano>,<NombreMano>)
%		personaje(<ValorCarta>,<SímboloPersonaje>)
%
%	NOTA PARA LA EJECUCIÓN:
%
%	Para la ejecución del programa se debe de hacer uso del
%	predicado "juega_Poker/1" que recibe como argumento
%	el número de manos (Jugadores) que se deben generar
%	aleatoriamente. El argumento debe ser únicamente de tipo
%	entero.
%
%===================================================================

%===================================================================
%	baraja/1
%	baraja(-<Baraja>).
%
%	Predicado en el cual está declarada la baraja inglesa. Consta
%	de una lista en la cual cada elemento es una sublista de dos
%	elementos:
%	
%	1 .- Valor de la carta
%	2 .- Símbolo del palo
%	
%	Los valores de la carta están en el rango de [2,14]
%	Los símbolos del palo corresponden a:
%
%	- Picas (♠)
%	- Corazones (♥)
%	- Rombos (♦)
%	- Tréboles (♣)
%===================================================================

baraja([[2,♠],[2,♥],[2,♦],[2,♣],
	[3,♠],[3,♥],[3,♦],[3,♣],
	[4,♠],[4,♥],[4,♦],[4,♣],
	[5,♠],[5,♥],[5,♦],[5,♣],
	[6,♠],[6,♥],[6,♦],[6,♣],
	[7,♠],[7,♥],[7,♦],[7,♣],
	[8,♠],[8,♥],[8,♦],[8,♣],
	[9,♠],[9,♥],[9,♦],[9,♣],
	[10,♠],[10,♥],[10,♦],[10,♣],
	[11,♠],[11,♥],[11,♦],[11,♣],
	[12,♠],[12,♥],[12,♦],[12,♣],
	[13,♠],[13,♥],[13,♦],[13,♣],
	[14,♠],[14,♥],[14,♦],[14,♣]]).

%===================================================================
%	valorMax/2
%	valorMax(+<Mano>,-<ValorMáximo>).
%
%	Predicado que devuelve el valor máximo de una lista. 
%	La lista corresponde a una mano.
%===================================================================

valorMax([_|[[[Valor1|_],[Valor2|_],[Valor3|_],[Valor4|_],[Valor5|_]]]],Máximo) :-
	max_member(Máximo,[Valor1,Valor2,Valor3,Valor4,Valor5]).

%===================================================================
%	mano/2
%	mano(+<ValorMano>,-<NombreMano>).
%
%	Conjunto de predicados (hechos) que representan los tipos
%	de manos existentes en el juego de Poker. Cada predicado
%	está formado por dos elementos:
%
%	1 .- Valor de la mano
%	2 .- Nombre de la mano
%===================================================================
mano(0,'Nada').
mano(1,'Par').
mano(2,'Doble Par').
mano(3,'Tercia').
mano(4,'Escalera').
mano(5,'Color').
mano(6,'Full House').
mano(7,'Poker').
mano(8,'Flor').
mano(9,'Flor Imperial').

%===================================================================
%	personaje/2
%	personaje(+<ValorCarta>,-<SímboloPersonaje>).
%
%	Conjunto de predicados (hechos) que representan los personajes
%	existentes en el juego de Poker. Cada predicado
%	está formado por dos elementos:
%
%	1 .- Valor de la carta
%	2 .- Símbolo del personaje
%	
%	En el caso de que el valor de la carta esté en el rango [2,10]
%	el símbolo del personaje será el mismo valor de la carta
%===================================================================
personaje(Valor1,Valor2) :- Valor1 >= 2, Valor1 =< 10, Valor2 = Valor1.
personaje(11,'J').
personaje(12,'Q').
personaje(13,'K').
personaje(14,'A').

%===================================================================
%	florImperial/2
%	florImperial(+<Mano>,-<Máximo>).
%
%	Predicado (hecho) que representa la estructura de la mano de
%	Poker "flor imperial".
%	
%	Se recibe como argumento una lista que corresponde a una mano,
%	la cual debe cumplir que sean las cinco cartas de mayor
%	valor, consecutivas y todas del mismo palo
%===================================================================
florImperial([_|[[[10|[Palo]],[11|[Palo]],[12|[Palo]],[13|[Palo]],[14|[Palo]]]]],14).

%===================================================================
%	flor/2
%	flor(+<Mano>,-<Máximo>).
%
%	Predicado (hecho) que representa la estructura de la mano de
%	Poker "flor".
%	
%	Se recibe como argumento una lista que corresponde a una mano,
%	la cual debe cumplir que sean cinco cartas consecutivas 
%	y del mismo palo
%===================================================================
flor([_|[[[Valor1|[Palo]],[Valor2|[Palo]],[Valor3|[Palo]],[Valor4|[Palo]],[Valor5|[Palo]]]]],Valor5) :-
	Valor2 is Valor1 + 1,
	Valor3 is Valor1 + 2,
	Valor4 is Valor1 + 3,
	Valor5 is Valor1 + 4.

%===================================================================
%	poker/2
%	poker(+<Mano>,-<Máximo>).
%
%	Conjunto de predicados (hechos) que representan la estructura de 
% 	la mano de Poker "poker".
%	
%	Se recibe como argumento una lista que corresponde a una mano,
%	la cual debe cumplir que sean cuatro cartas con el mismo valor
%	o personaje
%===================================================================
poker([_|[[[Valor|_],[Valor|_],[Valor|_],[Valor|_],_]]],Valor).
poker([_|[[_,[Valor|_],[Valor|_],[Valor|_],[Valor|_]]]],Valor).

%===================================================================
%	fullHouse/2
%	fullHouse(+<Mano>,-<Máximo>).
%
%	Conjunto de predicados (hechos) que representan la estructura de 
% 	la mano de Poker "full house".
%	
%	Se recibe como argumento una lista que corresponde a una mano,
%	la cual debe cumplir que sean tres cartas con el mismo valor
%	más un par también con el mismo valor (Tercia + Par)
%===================================================================
fullHouse([_|[[[Valor1|_],[Valor1|_],[Valor1|_],[Valor2|_],[Valor2|_]]]],Máximo) :- 
	valorMax([Valor1,Valor2],Máximo).
fullHouse([_|[[[Valor1|_],[Valor1|_],[Valor2|_],[Valor2|_],[Valor2|_]]]],Máximo) :- 
	valorMax([Valor1,Valor2],Máximo).

%===================================================================
%	color/2
%	color(+<Mano>,-<Máximo>).
%
%	Predicado (hecho) que representa la estructura de la mano de
%	Poker "color".
%	
%	Se recibe como argumento una lista que corresponde a una mano,
%	la cual debe cumplir que sean cinco cartas del mismo palo, no
%	necesariamente consecutivas
%===================================================================
color([_|[[[Valor1|[Palo]],[Valor2|[Palo]],[Valor3|[Palo]],[Valor4|[Palo]],[Valor5|[Palo]]]]],Máximo) :- 
	valorMax([Valor1,Valor2,Valor2,Valor3,Valor4,Valor5],Máximo).

%===================================================================
%	escalera/2
%	escalera(+<Mano>,-<Máximo>).
%
%	Predicado (hecho) que representa la estructura de la mano de
%	Poker "escalera".
%	
%	Se recibe como argumento una lista que corresponde a una mano,
%	la cual debe cumplir que sean cinco cartas consecutivas, 
%	no necesariamente del mismo palo
%===================================================================
escalera([_|[[[Valor1|_],[Valor2|_],[Valor3|_],[Valor4|_],[Valor5|_]]]],Máximo) :-
	Valor2 is Valor1 + 1,
	Valor3 is Valor1 + 2,
	Valor4 is Valor1 + 3,
	Valor5 is Valor1 + 4,
	valorMax([Valor1,Valor2,Valor2,Valor3,Valor4,Valor5],Máximo).

%===================================================================
%	tercia/2
%	tercia(+<Mano>,-<Máximo>).
%
%	Conjunto de predicados (hechos) que representan la estructura de 
% 	la mano de Poker "tercia".
%	
%	Se recibe como argumento una lista que corresponde a una mano,
%	la cual debe cumplir que sean tres cartas con el mismo valor
%	o personaje
%===================================================================
tercia([_|[[[Valor|_],[Valor|_],[Valor|_],_,_]]],Valor).
tercia([_|[[_,[Valor|_],[Valor|_],[Valor|_],_]]],Valor).
tercia([_|[[_,_,[Valor|_],[Valor|_],[Valor|_]]]],Valor).

%===================================================================
%	doblePar/2
%	doblePar(+<Mano>,-<Máximo>).
%
%	Conjunto de predicados (hechos) que representan la estructura de 
% 	la mano de Poker "doble par".
%	
%	Se recibe como argumento una lista que corresponde a una mano,
%	la cual debe cumplir que sean dos pares con dos cartas con el
%	mismo valor
%===================================================================
doblePar([_|[[[Valor1|_],[Valor1|_],[Valor2|_],[Valor2|_],_]]],Máximo) :- 
	valorMax([Valor1,Valor2,Valor2],Máximo).
doblePar([_|[[[Valor1|_],[Valor1|_],_,[Valor2|_],[Valor2|_]]]],Máximo) :- 
	valorMax([Valor1,Valor2,Valor2],Máximo).
doblePar([_|[[_,[Valor1|_],[Valor1|_],[Valor2|_],[Valor2|_]]]],Máximo) :- 
	valorMax([Valor1,Valor2,Valor2],Máximo).

%===================================================================
%	par/2
%	par(+<Mano>,-<Máximo>).
%
%	Conjunto de predicados (hechos) que representan la estructura de 
% 	la mano de Poker "par".
%	
%	Se recibe como argumento una lista que corresponde a una mano,
%	la cual debe cumplir que sean dos cartas con el mismo valor
%===================================================================
par([_|[[[Valor|_],[Valor|_],_,_,_]]],Valor).
par([_|[[_,[Valor|_],[Valor|_],_,_]]],Valor).
par([_|[[_,_,[Valor|_],[Valor|_],_]]],Valor).
par([_|[[_,_,_,[Valor|_],[Valor|_]]]],Valor).

%===================================================================
%	ninguna/2
%	ninguna(+<Mano>,-<Máximo>).
%
%	Predicado (hecho) que representan la estructura de una mano
%	que no cumple con las condiciones para ser una mano clásica
%	del juego de Poker
%===================================================================
ninguna(Mano,Máximo) :-
	\+ (
		par(Mano,Máximo);
		doblePar(Mano,Máximo);
		tercia(Mano,Máximo);
		escalera(Mano,Máximo);
		color(Mano,Máximo);
		fullHouse(Mano,Máximo);
		poker(Mano,Máximo);
		flor(Mano,Máximo);
		florImperial(Mano,Máximo)
	), 
	valorMax(Mano,Máximo).

%===================================================================
%	númeroBarajas/2
%	númeroBarajas(+<NúmeroJugadores>,-<NúmeroBarajas>).
%
%	Conjunto de predicados que permiten determinar el número
%	de barajas a utilizar dependiendo del número de jugadores
%	
%	En caso de que el número de jugadores sea '1', el número
%	de barajas siempre será '1'. Mientras que si el número de
%	barajas es mayor o igual que '2', el número de barajas
%	corresponde a la división entera del número de jugadores
%	entre '2'
%===================================================================
númeroBarajas(1,1).
númeroBarajas(Jugadores,Barajas) :- Jugadores >= 2, Barajas is Jugadores // 2.

%===================================================================
%	concatenar/3
%	concatenar(+<N>,+<Lista>,-<ListaNueva>).
%
%	Conjunto de predicados que permiten concatenar una lista N
%	veces consigo misma
%===================================================================
concatenar(0,_,[]).
concatenar(0,Lista,[Lista]).
concatenar(N,Lista,[Lista|Resto]) :-
	M is N-1,
	concatenar(M,Lista,Resto).

%===================================================================
%	generarMazo/3
%	generarMazo(+<NúmeroBarajas>,+<Baraja>,-<Mazo>)
%	
%	Predicado que permite generar un mazo compuesto del número de
%	barajas que se indique y la baraja proporcionada. El mazo 
% 	resultante es el utilizado para generar las manos de los 
%	jugadores.
%===================================================================
generarMazo(NúmeroBarajas,Baraja,Mazo) :-
	concatenar(NúmeroBarajas,Baraja,Auxiliar),
	append(Auxiliar,Mazo).

%===================================================================
%	removerElemento/3
%	removerElemento(+<Elemento>,+<Lista>,-<ListaActualizada>).
%
%	Conjunto de predicados que permiten eliminar un elemento de
%	una lista y generar una lista actualizada sin ese elemento
%===================================================================
removerElemento(_,[],[]).
removerElemento(Elemento, [Elemento|Resto], Resto).
removerElemento(Elemento, [Inicio|Resto], [Inicio|Resultado]) :-
	removerElemento(Elemento, Resto, Resultado).

%===================================================================
%	crearMano/4
%	crearMano(+<NúmeroCartas>,+<Mazo>,-<Mano>,-<MazoActualizado>).
%
%	Conjunto de predicados que permiten crear una mano con el
%	número de cartas indicado, el mazo del cual se extraen las
%	cartas y genera una versión actualizada del mazo tras las
%	extracciones
%===================================================================
crearMano(0, NuevoMazo, [], NuevoMazo).
crearMano(NúmeroCartas, Mazo, Mano, NuevoMazo) :-
	random_member(Carta, Mazo),
	removerElemento(Carta,Mazo,MazoActualizado),
	Mano = [Carta|Resto],
	M is NúmeroCartas - 1,
	crearMano(M,MazoActualizado,Resto, NuevoMazo).

%===================================================================
%	repartirCartas/3
%	repartirCartas(+<NúmeroJugadores>,+<Mazo>,-<Manos>).
%
%	Conjunto de predicados que permiten crear una lista con 
%	los mazos para cada jugador indicado en los argumentos
%===================================================================
repartirCartas(0, _, []).
repartirCartas(NúmeroJugadores, Mazo, Manos) :-
	crearMano(5, Mazo, Mano,MazoActualizado),
	msort(Mano,ManoOrdenada),
	Manos = [[NúmeroJugadores|[ManoOrdenada]]|Resto],
	M is NúmeroJugadores - 1,
	repartirCartas(M, MazoActualizado, Resto).

%===================================================================
%	analizarManos/2
%	analizarManos(+<listaManos>,-<ListaLugares>).
%
%	Conjunto de predicados que permiten analizar una lista
%	correspondiente a una mano para determinar que mano del juego
%	de Poker es. Se genera un listado de las manos ya identificadas
%	y se añade el valor de la carta con mayor valor en la mano
%===================================================================
analizarManos([],[]).
analizarManos([Mano|RestoManos],Lugar) :-
	((florImperial(Mano,Máximo), Lugar = [[9,Máximo,Mano]|Resto]);
	(flor(Mano,Máximo), Lugar = [[8,Máximo,Mano]|Resto]);
	(poker(Mano,Máximo), Lugar = [[7,Máximo,Mano]|Resto]);
	(fullHouse(Mano,Máximo), Lugar = [[6,Máximo,Mano]|Resto]);
	(color(Mano,Máximo), Lugar = [[5,Máximo,Mano]|Resto]);
	(escalera(Mano,Máximo), Lugar = [[4,Máximo,Mano]|Resto]);
	(tercia(Mano,Máximo), Lugar = [[3,Máximo,Mano]|Resto]);
	(doblePar(Mano,Máximo), Lugar = [[2,Máximo,Mano]|Resto]);
	(par(Mano,Máximo), Lugar = [[1,Máximo,Mano]|Resto]);
	(ninguna(Mano,Máximo), Lugar = [[0,Máximo,Mano]|Resto])),
	analizarManos(RestoManos,Resto).

%===================================================================
%	imprimirLista/1
%	imprimirLista(+<Lista>).
%
%	NOTA: Este predicado solo es utilizado con propósitos de
%	pruebas
%
%	Conjunto de predicados que permiten imprimir en consola los
%	elementos de una lista
%===================================================================
imprimirLista([]) :- nl.
imprimirLista([H|T]) :- 
	write(H),
	write(' '),
	nl,
	imprimirLista(T).

%===================================================================
%	imprimirCabecera/0
%	imprimirCabecera().
%
%	Predicados que imprime en consola la cabecera con información
%	del juego de Poker para el usuario
%===================================================================
imprimirCabecera() :-
	writeln('Generando mano de cada jugador...'),
	writeln('Resultado:'),
	write('Lugar'),tab(2),
	write('Jugador'),tab(7),
	write('Mano'),tab(10),
	write('Contenido'),nl,
	writeln('=======================================================').

%===================================================================
%	imprimirResultado/2
%	imprimirResultado(+<listaManos>,+<ValorLugar>).
%
%	Conjunto de predicados que imprimen los resultados de la
%	partida de Poker a partir de la lista de manos proporcionada.
%	Se incluye como argumento el lugar en el cual se encuentra un
%	jugador para la tabla de posiciones en la partida. 
%===================================================================
imprimirResultado([],_) :- nl.
imprimirResultado([Elemento|Resto],Lugar) :-
	nth0(0,Elemento,ValorMano),
	mano(ValorMano,TipoMano),
	nth0(2,Elemento,DatosJugador),
	nth0(0,DatosJugador,Jugador),
	nth0(1,DatosJugador,Mano),
	nth0(0,Mano,Carta1),
	nth0(0,Carta1,Valor1),nth0(1,Carta1,Palo1),
	nth0(1,Mano,Carta2),
	nth0(0,Carta2,Valor2),nth0(1,Carta2,Palo2),
	nth0(2,Mano,Carta3),
	nth0(0,Carta3,Valor3),nth0(1,Carta3,Palo3),
	nth0(3,Mano,Carta4),
	nth0(0,Carta4,Valor4),nth0(1,Carta4,Palo4),
	nth0(4,Mano,Carta5),
	nth0(0,Carta5,Valor5),nth0(1,Carta5,Palo5),
	personaje(Valor1,Personaje1),
	personaje(Valor2,Personaje2),
	personaje(Valor3,Personaje3),
	personaje(Valor4,Personaje4),
	personaje(Valor5,Personaje5),
	tab(2),write(Lugar),tab(4),
	write('Jugador - '),write(Jugador),tab(3),
	write(TipoMano), tab(10),
	write(Personaje1),write(Palo1),write(' '),tab(1),
	write(Personaje2),write(Palo2),write(' '),tab(1),
	write(Personaje3),write(Palo3),write(' '),tab(1),
	write(Personaje4),write(Palo4),write(' '),tab(1),
	write(Personaje5),write(Palo5),write(' '),
	nl,
	N is Lugar + 1,
	imprimirResultado(Resto,N).

%===================================================================
%	juega_Poker/1
%	juega_Poker(+<NúmeroJugadores>).
%
%	Predicado principal. Recibe como parámetro el número de
%	jugadores para los cuales se generarán las manos.
%
%	El predicado está limitado a entregar una única solución.
%===================================================================
juega_Poker(NúmeroJugadores) :-
	once(baraja(Baraja)),
	once(númeroBarajas(NúmeroJugadores,NúmeroBarajas)),
	once(generarMazo(NúmeroBarajas,Baraja,Mazo)),
	once(repartirCartas(NúmeroJugadores, Mazo, Manos)),
	once(analizarManos(Manos,Posiciones)),
	once(msort(Posiciones,PosicionesOrdenadas)),
	once(reverse(Reverso,PosicionesOrdenadas)),
	once(imprimirCabecera()),
	once(imprimirResultado(Reverso,1)).