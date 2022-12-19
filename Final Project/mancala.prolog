% ============================================================================================== %
%
%   Alberto Palacios Cabrera
%	
%	Proyecto Final. Agente jugador
%
%   Programe en Prolog un agente jugador para uno de los tres juegos descritos en 
%   la presentación #27 Proyecto Final
%	
%   El agente jugador debe usar algoritmo MiniMax/NegaMax, Podas Alfa-Beta y 
%   cuando menos una  heurística  auxiliar,  que  puede  ser alguna de las clásicas
%   o una de su propia invención.
%
%   Este programa se deberá desarrollar PARA CONSOLA Swipl
%
%
%   REPRESENTACIÓN
%
%   - Tablero
%   
%   Representaremos el tablero como una lista de dos dimensiones que representan las
%   filas correspondientes al área de juego de cada jugador
%
%               Ejemplo: [[3,3,3,3,3,3],[3,3,3,3,3,3]] <- Tablero inicial
%
%   - Estados
%
%   Los estados del juego se representarán de la siguiente manera:
%
%   estado(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Índice_casilla)
%
%
%	Predicados relevantes:
%
%   iniciar_juego(<Profundidad>).
%   jugar(<Tablero>,<Jugador1>,<Jugador2>,<Jugador_en_turno>,<Puntuación_Jugador1>,
%       <Puntuación_Jugador2>,<Función_Jugador1>,<Función_Jugador2>,<Profundidad1>,<Profundidad2>).
%   minimax_AB(<Tablero>,<Jugador_en_turno>,<Índice_casilla>,<Profundidad>).
%   minimax(<Estado>,<Alpha>,<Beta>,<Mejor_jugada>,<Evaluación>,<Profundidad>).
%   evaluación_heurística(<Estado>,<Evaluación>).
%
%   COMO JUGAR:
%      
%   - De manera inicial los símbolos para el jugador humano y la IA son "J1(Tú)" y "Jarvis"
%     correspondientemente, pero pueden ser cambiados por medio del predicado 
%     cambiar_nombre/2 en el cual solo deben ingresarse los nuevos símbolos a usar.
%
%                      Ejemplo: cambiar_nombre('Alberto','Diana').
%
%   - Para comenzar un juego se debe llamar al predicado iniciar_juego/1, en el cual se 
%     debe ingresar un valor númerico corrsepondiente a la profundidad máxima que
%     se desea usar en MiniMax.
%
%   NOTA: Cuanto mayor sea el valor de profundidad, el agente jugador podrá realizar
%   mejores jugadas pero el tiempo de cómputo incrementa.
%
%   - El tablero de Mancala se muestra al usuario de la siguiente manera:
%   
%                           TABLERO PREDETERMINADO
%
%                   Puntuación de J1(Tú): 0
%                   Puntuación de Jarvis: 0
%                   
%                   Fila de J1(Tú): | [3,3,3,3,3,3] | <-
%                   Fila de Jarvis: | [3,3,3,3,3,3] | ->
%   
%       La fila superior corresponde a la fila del jugador y debe ser leída de derecha a 
%       izquierda desde la casilla 1 hasta la 6.
%
%       La fila inferior corresponde a la fila del agente jugador y debe ser leída de 
%       izquierda a derecha desde la casilla 1 hasta la 6.
%
%       Se tiene un símbolo de flecha que ayuda al jugador a visualizar el sentido en
%       el cual deben ser colocadas las fichas en el tablero.
%
%   - En esta versión del juego de Mancala se tienen 6 casillas por jugador que cada una
%     contiene 3 fichas con valor de 1 punto.
%
%   - Para realizar una jugada dentro de la partida de Mancala, se debe ingresar la casilla
%     de la cual se tomarán las fichas de la siguiente manera:
%
%                   Ejemplo:  3.   <- Se tomarán las fichas de la casilla 3 
%
% ============================================================================================== %

% ============================================================================================== %
%   nombre_jugador/2. Indica el nombre asignado para cada jugador en la partida de Mancala

%                   nombre_jugador(<Jugador>,<Nombre>).

%   Verdadero si <Nombre> es el nombre correspondiente a <Jugador>
%   NOTA: Se asigna como un predicado dinámico para poder ser modificado en tiempo
%   de ejecución.

:- dynamic(nombre_jugador/2).

nombre_jugador(1, 'J1(Tú)').
nombre_jugador(2, 'Jarvis').

% ============================================================================================== %

% ============================================================================================== %
%   jugada_asesina/2. Sirve como registro para la heurística de jugadas asesinas.

%                   jugada_asesina(<Tablero>,<Evaluación>).

%   Verdadero si <Tablero> y <Ecaluación> corresponden a un movimiento_asesino registrada
%   NOTA: Se asigna como un predicado dinámico para poder ser modificado en tiempo
%   de ejecución.

:- dynamic(jugada_asesina/2).

% ============================================================================================== %

% ============================================================================================== %
%   cambiar_nombre/2. Permite modificar los nombres de los jugadores en la partida
%   de Mancala.

%                     cambiar_nombre(<Nombre_1>,<Nombre_2>).

cambiar_nombre(Jugador1,Jugador2) :-
    retractall(nombre_jugador(_,_)),
    assert(nombre_jugador(1,Jugador1)),
    assert(nombre_jugador(2,Jugador2)).

% ============================================================================================== %

% ============================================================================================== %
%   jugador_maximizar/1. Indica que jugador maximiza en el siguiente nivel en el algoritmo MiniMax

%                               jugador_maximizar(<Estado>).

jugador_maximizar(estado(_, 1, _, _, _)):- !.

% ============================================================================================== %

% ============================================================================================== %
%   jugador_minimizar/1. Indica que jugador maximiza en el siguiente nivel en el algoritmo MiniMax

%                               jugador_minimizar(<Estado>).

jugador_minimizar(estado(_, 2, _, _, _)):- !.

% ============================================================================================== %

% ============================================================================================== %
%   imprimir_tablero/5. Despliega en pantalla el tablero proporcionado como
%   parámetro.

%   imprimir_tablero(<Tablero>,<Jugador1>,<Jugador2>,<Puntuación_Jugador1>,<Puntuación_Jugador2>).

%   Tablero: Representación del tablero actual en la partida de Mancala
%   Jugador1: Nombre del jugador 1
%   Jugador2: Nombre del jugador 2
%   Puntuación_Jugador1: Indica la puntuación del Jugador 1
%   Puntuación_Jugador2: Indica la puntuación del Jugador 2

imprimir_tablero(Tablero, Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2):-
    nl, write("Puntuación de "), ansi_format([bold,fg(blue)], '~w: ', [Jugador1]), write(Puntuación_Jugador1), nl,
    write("Puntuación de "), ansi_format([bold,fg(green)], '~w: ', [Jugador2]), write(Puntuación_Jugador2), nl, nl,
    nth1(1, Tablero, Fila_jugador1),
    reverse(Fila_jugador1, Fila_jugador1_invertida),
    nth1(2, Tablero, Fila_jugador2),
    write("Fila de "), ansi_format([bold,fg(blue)], '~w: | ', [Jugador1]), write(Fila_jugador1_invertida), write(" | <-"), nl,
    write("Fila de "), ansi_format([bold,fg(green)], '~w: | ', [Jugador2]), write(Fila_jugador2), write(" | ->"), nl, !.

% ============================================================================================== %

% ============================================================================================== %
%   iniciar_juego/8. Inicia un juego de Mancala.

%           iniciar_juego(<Jugador1>,<Jugador2>,<Número_casillas>,<Número_fichas>,
%               <Función_Jugador1>,<Función_Jugador2>,<Profundidad1>,<Profundidad2>)

%   Jugador1: Nombre del jugador 1
%   Jugador2: Nombre del jugador 2
%   Número_casillas: Número de casillas en cada fila del tablero de Mancala
%   Número_fichas: Número de fichas que tendrá cada casilla al inicio del juego
%   Función_Jugador1: Nombre de la función con la cual se seleccionará la jugada del Jugador 1
%   Función_Jugador2: Nombre de la función con la cual se seleccionará la jugada del Jugador 1
%
%   NOTA: Para la función de selección de jugada, solo se cuenta con la función de 
%   "entrada_teclado" y "minimax_AB"

iniciar_juego(Jugador1, Jugador2, Número_casillas, Número_fichas, Función_Jugador1, Función_Jugador2, Profundidad1, Profundidad2):-
    crear_lista_inicializada(Número_casillas, Número_fichas, Fila),
    crear_lista_inicializada(2, Fila, Tablero),
    Puntuación_Jugador1 is 0,
    Puntuación_Jugador2 is 0,
    imprimir_tablero(Tablero, Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2),
    jugar(Tablero, Jugador1, Jugador2, 1, Puntuación_Jugador1, Puntuación_Jugador2, Función_Jugador1, Función_Jugador2, Profundidad1, Profundidad2), !.

% ============================================================================================== %

% ============================================================================================== %
%   iniciar_juego/1. Inicia un juego de Mancala de Humano vs IA.

%                               jugar(<Profundidad>).

iniciar_juego(Profundidad):-
    nombre_jugador(1, Jugador1),
    nombre_jugador(2, Jugador2),
    iniciar_juego(Jugador1, Jugador2, 6, 3, entrada_teclado, minimax_AB,1,Profundidad), !.

% ============================================================================================== %

% ============================================================================================== %
%   iniciar_juego/0. Inicia un juego de Mancala de IA vs IA.

iniciar_juego():-
    nombre_jugador(1, Jugador1),
    nombre_jugador(2, Jugador2),
    iniciar_juego(Jugador1, Jugador2, 6, 3, minimax_AB, minimax_AB,6,6), !.

% ============================================================================================== %

% ============================================================================================== %
%   jugar/10. Realiza un turno de juego en el juego de Mancala.

%         jugar(<Tablero>,<Jugador1>,<Jugador2>,<Jugador_en_turno>,<Puntuación_Jugador1>,
%   <Puntuación_Jugador2>,<Función_Jugador1>,<Función_Jugador2>,<Profundidad1>,<Profundidad2>).

%   Tablero: Representación del tablero actual en la partida de Mancala
%   Jugador1: Nombre del jugador 1
%   Jugador2: Nombre del jugador 2
%   Jugador_en_turno: Indica que jugador está en turno, su valor puede ser 1 o 2
%   Puntuación_Jugador1: Indica la puntuación del Jugador 1 (El valor de las fichas en su base)
%   Puntuación_Jugador2: Indica la puntuación del Jugador 2 (El valor de las fichas en su base)
%   Función_Jugador1: Nombre de la función con la cual se seleccionará la jugada del Jugador 1
%   Función_Jugador2: Nombre de la función con la cual se seleccionará la jugada del Jugador 1
%   Profundidad1: Indica la profundidad de búsqueda para el Jugador 1
%   Profundidad2: Indica la profundidad de búsqueda para el Jugador 2
%
%   NOTA: Los valores de profundidad no necesariamente serán usados en el caso de que la
%   función de selección de jugada corresponda a "entrada_teclado" por lo que se puede poner un
%   valor numérico arbitrario. Así mismo, esta forma de manejar el predicado permite incluso
%   cambiar a que el juego sea de Jugador vs Jugador, Jugador vs IA o IA vs IA. 

jugar(Tablero, Jugador1, Jugador2, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Función_Jugador1, Función_Jugador2, Profundidad1, Profundidad2):-
    (
        Jugador_en_turno = 1,
        Jugador = Jugador1,
        Función = Función_Jugador1,
        Color = 'blue',
        Profundidad = Profundidad1
    ;
        Jugador_en_turno = 2,
        Jugador = Jugador2,
        Función = Función_Jugador2,
        Color = 'green',
        Profundidad = Profundidad2
    ),
    nl, write("Jugador en turno: "), ansi_format([bold,fg(Color)], '~w', [Jugador]), nl,
    call(Función, Tablero, Jugador_en_turno, Índice_casilla, Profundidad),
    nl, ansi_format([bold,fg(Color)], '~w', [Jugador]), ansi_format([bold,fg(cyan)], ' seleccionó la casilla: ~w', [Índice_casilla]), nl,
    (
        realizar_jugada(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Índice_casilla, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador),
        imprimir_tablero(Nuevo_tablero, Jugador1, Jugador2, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2),
        siguiente_jugada(Nuevo_tablero, Jugador1, Jugador2, Siguiente_jugador, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Función_Jugador1, Función_Jugador2,Profundidad1,Profundidad2)
    ;
        ansi_format([bold,fg(red)], 'Movimiento inválido, vuelve a tirar', []), nl,
        jugar(Tablero, Jugador1, Jugador2, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Función_Jugador1, Función_Jugador2,Profundidad1,Profundidad2)
    ), !.

% ============================================================================================== %

% ============================================================================================== %
%   siguiente_jugada/10. Determina la siguiente jugada a ejecutar en la partida.

%           siguiente_jugada(<Nuevo_tablero>,<Jugador1>,<Jugador2>,<Siguiente_jugador>, 
%                   <Nueva_puntuación_Jugador1>,<Nueva_puntuación_Jugador2>,
%               <Función_Jugador1>,<Función_Jugador2>,<Profundidad1>,<Profundidad2>).


%   Nuevo_tablero: Representación del tablero actual en la partida de Mancala
%   Jugador1: Nombre del jugador 1
%   Jugador2: Nombre del jugador 2
%   Siguiente jugador: Indica el jugador que tirará a continuación, su valor puede ser 1 o 2
%   Nueva_puntuación_Jugador1: Indica la nueva puntuación del Jugador 1
%   Nueva_puntuación_Jugador2: Indica la nueva puntuación del Jugador 2
%   Función_Jugador1: Nombre de la función con la cual se seleccionará la jugada del Jugador 1
%   Función_Jugador2: Nombre de la función con la cual se seleccionará la jugada del Jugador 1
%   Profundidad1: Indica la profundidad de búsqueda para el Jugador 1
%   Profundidad2: Indica la profundidad de búsqueda para el Jugador 2

%   Este caso permite comprobar si la partida ha finalizado, ya sea por la victoria de uno de
%   los jugadores o un empate.

siguiente_jugada(Nuevo_tablero, Jugador1, Jugador2, _, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, _, _, _, _):-
    comprobar_victoria(Nuevo_tablero, Jugador1, Jugador2, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2),
    nl, write("Puntuación final de "), write(Jugador1), write(": "), write(Nueva_puntuación_Jugador1), write(" "), nl,
    nl, write("Puntuación final de "), write(Jugador2), write(": "), write(Nueva_puntuación_Jugador2), nl, nl, !.

%   Este caso corresponde al escenario general en el cual aún hay oportunidad de jugadas
%   en la partida de Mancala.

siguiente_jugada(Nuevo_tablero, Jugador1, Jugador2, Siguiente_jugador, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Función_Jugador1, Función_Jugador2, Profundidad1, Profundidad2):-
    jugar(Nuevo_tablero, Jugador1, Jugador2, Siguiente_jugador, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Función_Jugador1, Función_Jugador2, Profundidad1, Profundidad2), !.

% ============================================================================================== %

% ============================================================================================== %
%   realizar_jugada/9. Realiza una jugada en el juego.

%   realizar_jugada(<Tablero>,<Jugador_en_turno>,<Puntuación_Jugador1>,<Puntuación_Jugador2>,
%                               <Índice_casilla>,<Nuevo_tablero>,
%          <Nueva_puntuación_Jugador1>,<Nueva_puntuación_Jugador2>,<Siguiente_jugador>).

%   Tablero: Representación del tablero actual en la partida de Mancala
%   Jugador_en_turno: Indica que jugador está en turno, su valor puede ser 1 o 2
%   Puntuación_Jugador1: Indica la puntuación del Jugador 1
%   Puntuación_Jugador2: Indica la puntuación del Jugador 2
%   Índice: Índice de la casilla del tablero seleccionada para realizar la jugada
%   Nuevo_tablero: Representación del tablero actualizado tras realizar la jugada
%   Nueva_puntuación_Jugador1: Indica la nueva puntuación del Jugador 1
%   Nueva_puntuación_Jugador2: Indica la nueva puntuación del Jugador 2
%   Siguiente jugador: Indica el jugador que tirará a continuación, su valor puede ser 1 o 2

realizar_jugada(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Índice_casilla, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador):-
    integer(Índice_casilla),
    nth1(Jugador_en_turno, Tablero, Fila),
    movimiento_válido(Fila, Índice_casilla),
    remplaza_nth1(Fila, Índice_casilla, Número_fichas, 0, Nueva_fila),
    remplaza_nth1(Tablero, Jugador_en_turno, _, Nueva_fila, Tablero_temporal),
    Nuevo_índice_casilla is Índice_casilla + 1,
    coloca_fichas(Tablero_temporal, Número_fichas, Jugador_en_turno, Nuevo_índice_casilla, Jugador_en_turno, 
            Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador), !.

% ============================================================================================== %

% ============================================================================================== %
%   movimiento_válido/2. Comprueba que el movimiento realizado sea válido según el tablero
%   y las reglas del juego

%                       movimiento_válido(<Fila>,<Índice_casilla>).


%   Fila: Indica la fila del jugador que realiza la jugada, su valor puede ser 1 o 2
%   Índice_casilla: Indica el índice de la casilla seleccionada para realizar la jugada

movimiento_válido(Fila, Índice_casilla):-
    length(Fila, Tamaño_fila),
    between(1, Tamaño_fila, Índice_casilla),
    nth1(Índice_casilla, Fila, Fichas),
    Fichas > 0.

% ============================================================================================== %

% ============================================================================================== %
%   coloca_fichas/11. Realiza una jugada en el juego.

%   coloca_fichas(<Tablero>,<Número_fichas>,<Índice_fila>,<Índice_casilla>,<Jugador_en_turno>,
%               <Puntuación_Jugador1>,<Puntuación_Jugador2>,<Nuevo_tablero>,
%       <Nueva_puntuación_Jugador1>,<Nueva_puntuación_Jugador2>,<Siguiente_jugador>).

%   Tablero: Representación del tablero actual en la partida de Mancala
%   Número_fichas: Número de fichas contenidas en la casilla seleccionada
%   Índice_fila: Índice de la fila del tablero en la cual se colocarán las fichas
%   Índice_casilla: Índice de la casilla del tablero seleccionada para realizar la jugada
%   Jugador_en_turno: Indica que jugador está en turno, su valor puede ser 1 o 2
%   Puntuación_Jugador1: Indica la puntuación del Jugador 1
%   Puntuación_Jugador2: Indica la puntuación del Jugador 2
%   Nuevo_tablero: Representación del tablero actualizado tras realizar la jugada
%   Nueva_puntuación_Jugador1: Indica la nueva puntuación del Jugador 1
%   Nueva_puntuación_Jugador2: Indica la nueva puntuación del Jugador 2
%   Siguiente jugador: Indica el jugador que tirará a continuación, su valor puede ser 1 o 2

%   En este caso la última ficha cae en la base propia del jugador, el jugador obtiene otro tiro

coloca_fichas(Tablero, 0, _, 1, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Jugador_en_turno):- 
    validar_fila_vacía(Tablero, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2), !.

%   CASO EXTRA: Este caso corresponde a la regla del ladrón, si la última ficha cae en una 
%   casilla vacía el jugador toma las fichas de su adversario de la casilla opuesta y las
%   agrega a su base junto con su propia ficha.

coloca_fichas(Tablero, 0, Índice_fila, Índice_casilla, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador):-
    Siguiente_jugador is (Jugador_en_turno mod 2) + 1,
    (
        Jugador_en_turno = Índice_fila,
        Último_índice_casilla is Índice_casilla - 1,
        nth1(Índice_fila, Tablero, Fila),
        remplaza_nth1(Fila, Último_índice_casilla, 1, 0, Nueva_fila),
        nth1(Siguiente_jugador, Tablero, Fila_capturada),
        length(Fila_capturada, Tamaño_fila_capturada),
        Índice_casilla_capturada is Tamaño_fila_capturada - Último_índice_casilla + 1,
        remplaza_nth1(Fila_capturada, Índice_casilla_capturada, X, 0, Nueva_fila_capturada),
        X > 0,
        (
            Jugador_en_turno = 1,
            Puntuación_Jugador1_temporal is Puntuación_Jugador1 + X + 1,
            Puntuación_Jugador2_temporal = Puntuación_Jugador2,
            Tablero_temporal = [Nueva_fila, Nueva_fila_capturada]
        ;
            Jugador_en_turno = 2,
            Puntuación_Jugador2_temporal is Puntuación_Jugador2 + X + 1,
            Puntuación_Jugador1_temporal = Puntuación_Jugador1,
            Tablero_temporal = [Nueva_fila_capturada, Nueva_fila]
        ),
        validar_fila_vacía(Tablero_temporal, Puntuación_Jugador1_temporal, Puntuación_Jugador2_temporal, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2)
    ;
        validar_fila_vacía(Tablero, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2)
    ), !.

%   Este caso ocurre cuando todas las fichas son colocadas en la misma fila del jugador

coloca_fichas(Tablero, Número_fichas, Índice_fila, Índice_casilla, Jugador_en_turno,
           Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador):-
    nth1(Índice_fila, Tablero, Fila),
    length(Fila, Tamaño_fila),
    Índice_casilla =< Tamaño_fila,
    nth1(Índice_casilla, Fila, X),
    NX is X + 1,
    Nuevo_número_fichas is Número_fichas - 1,
    Nuevo_índice_casilla is Índice_casilla + 1,
    remplaza_nth1(Fila, Índice_casilla, X, NX, Nueva_fila),
    remplaza_nth1(Tablero, Índice_fila, Fila, Nueva_fila, Tablero_temporal),
    coloca_fichas(Tablero_temporal, Nuevo_número_fichas, Índice_fila, Nuevo_índice_casilla, Jugador_en_turno,
               Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador), !.
    
%   Este caso ocurre cuando al colocar las fichas se atraviesa la base y se colocan
%   fichas en la fila del oponente

coloca_fichas(Tablero, Número_fichas, Índice_fila, Índice_casilla, Jugador_en_turno,
           Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador):-
    nth1(Índice_fila, Tablero, Fila),
    length(Fila, Tamaño_fila),
    Índice_casilla =:= Tamaño_fila + 1,
    Nuevo_índice_casilla = 1,
    Nuevo_índice_fila is (Índice_fila mod 2) + 1,
    (
        Jugador_en_turno = Índice_fila,
        Nuevo_número_fichas is Número_fichas - 1,
        (
            Jugador_en_turno = 1,
            Puntuación_Jugador1_temporal is Puntuación_Jugador1 + 1,
            Puntuación_Jugador2_temporal is Puntuación_Jugador2
        ;
            Jugador_en_turno = 2,
            Puntuación_Jugador2_temporal is Puntuación_Jugador2 + 1,
            Puntuación_Jugador1_temporal is Puntuación_Jugador1
        )
    ;
        Puntuación_Jugador2_temporal is Puntuación_Jugador2,
        Puntuación_Jugador1_temporal is Puntuación_Jugador1,
        Nuevo_número_fichas is Número_fichas
    ),
    coloca_fichas(Tablero, Nuevo_número_fichas, Nuevo_índice_fila, Nuevo_índice_casilla, Jugador_en_turno,
               Puntuación_Jugador1_temporal, Puntuación_Jugador2_temporal, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador), !.

% ============================================================================================== %

% ============================================================================================== %
%   validar_fila_vacía/6. Valida si existe una fila vacía en el tablero y actualiza las 
%   puntuaciones y el tablero.

%           validar_fila_vacía(<Tablero>,<Puntuación_Jugador1>,<Puntuación_Jugador2>,
%           <Nuevo_tablero>,<Nueva_puntuación_Jugador1>,<Nueva_puntuación_Jugador2>).

%   Tablero: Representación del tablero actual en la partida de Mancala
%   Puntuación_Jugador1: Indica la puntuación del Jugador 1
%   Puntuación_Jugador2: Indica la puntuación del Jugador 2
%   Nuevo_tablero: Representación del tablero actualizado tras realizar la jugada
%   Nueva_puntuación_Jugador1: Indica la nueva puntuación del Jugador 1
%   Nueva_puntuación_Jugador2: Indica la nueva puntuación del Jugador 2

%   En este caso una de las filas está vacía, por lo cual la partida ha terminado

validar_fila_vacía(Tablero, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2):-
    nth1(1, Tablero, Fila1),
    nth1(2, Tablero, Fila2),
    sum_list(Fila1, Sum1),
    sum_list(Fila2, Sum2),
    (
        Sum1 =:= 0,
        Nueva_puntuación_Jugador1 is Puntuación_Jugador1 + Sum2,
        Nueva_puntuación_Jugador2 = Puntuación_Jugador2
    ;
        Sum2 =:= 0,
        Nueva_puntuación_Jugador2 is Puntuación_Jugador2 + Sum1,
        Nueva_puntuación_Jugador1 = Puntuación_Jugador1
    ),
    length(Fila1, Tamaño_filas),
    crear_lista_inicializada(Tamaño_filas, 0, Fila),
    crear_lista_inicializada(2, Fila, Nuevo_tablero), !.

%   En este caso no hay filas vacías, por lo cual se retornan los mismos valores

validar_fila_vacía(Tablero, Puntuación_Jugador1, Puntuación_Jugador2, Tablero, Puntuación_Jugador1, Puntuación_Jugador2):- !.

% ============================================================================================== %

% ============================================================================================== %
%   comprobar_victoria/5. Comprueba si uno de los jugadores ha ganado la partida

%                   comprobar_victoria(<Tablero>,<Jugador1>,<Jugador2>,
%                       <Puntuación_Jugador1>,<Puntuación_Jugador2>).


%   Tablero: Representación del tablero actual en la partida de Mancala
%   Jugador1: Nombre del jugador 1
%   Jugador2: Nombre del jugador 2
%   Puntuación_Jugador1: Indica la puntuación del Jugador 1
%   Puntuación_Jugador2: Indica la puntuación del Jugador 2

comprobar_victoria(Tablero, Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2):-
    sumar_tablero(Tablero, Sum),
    Sum =:= 0,
    determinar_ganador(Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2), !.

% ============================================================================================== %

% ============================================================================================== %
%   determinar_ganador/4. Determina el jugador que ha ganado la partida de Mancala

%   determinar_ganador(<Jugador1>,<Jugador1>,<Puntuación_Jugador1>,<Puntuación_Jugador2>).                

%   Jugador1: Nombre del jugador 1
%   Jugador2: Nombre del jugador 2
%   Puntuación_Jugador1: Indica la puntuación del Jugador 1
%   Puntuación_Jugador2: Indica la puntuación del Jugador 2

%   Este caso ocurre cuando el Jugador 1 ha ganado la partida

determinar_ganador(Jugador1, _, Puntuación_Jugador1, Puntuación_Jugador2):-
    Puntuación_Jugador1 > Puntuación_Jugador2, !,
    nl, write("¡El ganador es "), write(Jugador1), write("!"), nl.

%   Este caso ocurre cuando el Jugador 2 ha ganado la partida

determinar_ganador(_, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2):-
    Puntuación_Jugador1 < Puntuación_Jugador2, !,
    nl, write("¡El ganador es "), write(Jugador2), write("!"), nl.

%   Este caso ocurre cuando la partida ha quedado en empate

determinar_ganador(_, _, Puntuación_Jugador1, Puntuación_Jugador2):-
    Puntuación_Jugador1 = Puntuación_Jugador2, !,
    nl, write("¡La partida quedó en empate!"), nl.

% ============================================================================================== %

% ============================================================================================== %
%   sumar_tablero/2. Realiza la suma de los valores de las fichas dentro de el tablero

%                       sumar_tablero(<Tablero>,<Sum>).           

%   Tablero: Representación del tablero actual en la partida de Mancala
%   Sum: Valor de la suma de todas las fichas dentro del tablero

%   NOTA: La suma de las fichas no incluye aquellas que están dentro de las bases

sumar_tablero(Tablero, Sum):-
    nth1(1, Tablero, Fila1),
    nth1(2, Tablero, Fila2),
    sum_list(Fila1, Sum1),
    sum_list(Fila2, Sum2),
    Sum is Sum1 + Sum2.

% ============================================================================================== %
%   remplaza_nth1/2. Remplaza el n-ésimo elemento de una lista.

%       remplaza_nth1(<Lista>,<Índice>,<Antiguo_elemento>,<Nuevo_elemento>,<Nueva_lista>).

%   Lista: Lista que va a ser modificada
%   Índice: Índice de el elemento a remplazar
%   Antiguo_elemento: Corresponde al elemento a remplazar
%   Nuevo_elemento: Corresponde al elemento que entrará a la lista
%   Nueva_lista: Corresponde a la lista actualizada tras remplazar los elementos

%   NOTA: La lista no se maneja como una lista cero-indexada, sino que se toma a partir del
%   índice 1 

remplaza_nth1(Lista, Índice, Antiguo_elemento, Nuevo_elemento, Nueva_lista) :-
    nth1(Índice,Lista,Antiguo_elemento,Temporal),
    nth1(Índice,Nueva_lista,Nuevo_elemento,Temporal), !.

% ============================================================================================== %

% ============================================================================================== %
%   crear_lista_inicializada/3. Crea una lista inicializada con el valor y el tamaño indicado.

%                   crear_lista_inicializada(<Tamaño>,<Valor>,<Lista>).

%   Tamaño: Tamaño de la lista a generar
%   Valor: Indica el valor que contendrá la lista en cada índice
%   Lista: Lista que va a ser modificada

crear_lista_inicializada(Tamaño, Valor, Lista):-
    length(Lista,Tamaño), 
    maplist(=(Valor), Lista), !.

% ============================================================================================== %

% ============================================================================================== %
%   entrada_teclado/3. Solicita al usuario que ingrese por teclado el número de casilla
%   para su jugada a ejecutar.

%                           entrada_teclado(_,_,<Índice_casilla>).

%   Índice_casilla: Corresponde al valor ingresado por el usuario para la casilla a jugar

entrada_teclado(_, _, Índice_casilla):-
    write("Ingresa el número de casilla a jugar: "),
    read(Índice_casilla), !.

% ============================================================================================== %

% ============================================================================================== %
%   entrada_teclado/4. Predicado auxiliar que llama al predicado entrada_teclado/3.

%                           entrada_teclado(_,_,<Índice_casilla>).

%   Índice_casilla: Corresponde al valor ingresado por el usuario para la casilla a jugar

%   NOTA: Este predicado corresponde a una de las funciones de selección de jugadas para
%   los jugadores en la partida

entrada_teclado(_, _, Índice_casilla, _):-
    entrada_teclado(_, _, Índice_casilla), !.

% ============================================================================================== %

% ============================================================================================== %
%   minimax_AB/4. Predicado que ejecuta el algoritmo MiniMax con podas Alpha-Beta para
%   encontrar la mejor jugada a realizar.


%           minimax_AB(<Tablero>,<Jugador_en_turno>,<Índice_casilla>,<Profundidad>).

%   Tablero: Representación del tablero actual en la partida de Mancala
%   Jugador_en_turno: Indica que jugador está en turno, su valor puede ser 1 o 2
%   Índice_casilla: Índice de la casilla del tablero seleccionada para realizar la jugada
%   Profundidad: Indica la profundidad de búsqueda

%   NOTA: Este predicado corresponde a una de las funciones de selección de jugadas para
%   los jugadores en la partida

minimax_AB(Tablero, Jugador_en_turno, Índice_casilla, Profundidad):-
    sumar_tablero(Tablero, Beta),
    Alpha is -Beta,
    minimax(estado(Tablero, Jugador_en_turno, 0, 0, -1), Alpha, Beta, estado(_, _, _, _, Índice_casilla), _, Profundidad), !.

% ============================================================================================== %

% ============================================================================================== %
%   minimax/6. Realiza el algoritmo MiniMax desde un estado del juego.

%           minimax(<Estado>,<Alpha>,<Beta>,<Mejor_jugada>,<Evaluación>,<Profundidad>).

%   Estado: Representación del estado actual de la partida de Mancala
%   Alpha: Indica el valor actual de Alpha para las podas Alpha-Beta
%   Beta: Indica el valor actual de Beta para las podas Alpha-Beta
%   Mejor_jugada: Indica la mejor jugada a realizar según el algoritmo MiniMax
%   Evaluación: Indica el valor obtenido por la evalucación heurística de la mejor jugada
%   Profundidad: Indica la profundidad de búsqueda

%   Este caso corresponde a un estado en el cual es posible seguir descendiendo,
%   ya sea por que aún tiene posibles jugadas por realizar o por que aún estamos por
%   encima del límite de profundidad.

minimax(Estado, Alpha, Beta, Mejor_jugada, Evaluación, Profundidad):-
    Profundidad > 0,
    listar_jugadas(Estado, Lista_jugadas),
    (
        jugador_maximizar(Estado),
        Jugador_maximizar = true
    ;
        jugador_minimizar(Estado),
        Jugador_maximizar = false
    ),
    mejor_jugada(Lista_jugadas, Alpha, Beta, Mejor_jugada, Evaluación, Profundidad, Jugador_maximizar), !.

%   Este caso corresponde a un estado que se encuentra en el último nivel de
%   profundidad, pero el estado actual del tablero corresponde a una jugada
%   que previamente ha sido identificado como un movimiento_asesino y se evita
%   en el algoritmo MiniMax.

minimax(Estado, _, _, Estado, Evaluación, _):-
    Estado = estado(Tablero, 1, _, _, _),
    jugada_asesina(Tablero,Evaluación),
    nl, ansi_format([bold,fg(red)], 'Se evadió un movimiento_asesino', []), nl, !.

%   Este caso corresponde a un estado que se encuentra en el último nivel de
%   profundidad, por lo cual se comprueba si el estado corresponde a un 
%   movimiento_asesino.

minimax(Estado, _, _, Estado, Evaluación, _):-
    heurística_auxiliar(Estado,Evaluación), !.

%   Este caso corresponde a un estado que se encuentra en el último nivel de
%   profundidad, por lo cual se realiza la evaluación heurística del estado.

minimax(Estado, _, _, Estado, Evaluación, _):-
    evaluación_heurística(Estado, Evaluación), !.

% ============================================================================================== %

% ============================================================================================== %
%   mejor_jugada/7. Determina cual es la mejor jugada a realizar entre el conjunto de 
%   jugadas generadas por el estado inicial en MiniMax.

%                       mejor_jugada(<Jugadas>,<Alpha>,<Beta>,<Mejor_jugada>,
%                       <Mejor_evaluación>,<Profundidad>,<Jugador_maximizar>).

%   Jugadas: Lista de posibles jugadas a realizar
%   Alpha: Indica el valor actual de Alpha para las podas Alpha-Beta
%   Beta: Indica el valor actual de Beta para las podas Alpha-Beta
%   Mejor_jugada: Indica la mejor jugada a realizar según el algoritmo MiniMax
%   Mejor_evaluación: Indica el valor obtenido por la evalucación heurística de la mejor jugada
%   Profundidad: Indica la profundidad de búsqueda
%   Jugador_maximizar: Indica el jugador a maximizar en el nivel de búsqueda actual

mejor_jugada([Estado | Lista_jugadas], Alpha, Beta, Mejor_jugada, Mejor_evaluación, Profundidad, Jugador_maximizar):-
    Nueva_profundidad is Profundidad - 1,
    minimax(Estado, Alpha, Beta, _, Evaluación, Nueva_profundidad),
    poda_alphabeta(Lista_jugadas, Alpha, Beta, Estado, Evaluación, Mejor_jugada, Mejor_evaluación, Profundidad, Jugador_maximizar), !.

% ============================================================================================== %

% ============================================================================================== %
%   poda_alphabeta/9. Determina si los valores de Alpha y Beta corresponden a un caso de poda.

%               poda_alphabeta(<Lista_jugadas>,<Alpha>,<Beta>,<Estado>,<Evaluación>,
%               <Mejor_jugada>,<Mejor_evaluación>,<Profundidad>,<Jugador_maximizar>).

%   Lista_jugadas: Lista de posibles jugadas a realizar
%   Alpha: Indica el valor actual de Alpha para las podas Alpha-Beta
%   Beta: Indica el valor actual de Beta para las podas Alpha-Beta
%   Estado: Representación del estado actual de la partida de Mancala
%   Evaluación: Indica el valor obtenido por la evalucación heurística del estado
%   Mejor_jugada: Indica la mejor jugada a realizar según el algoritmo MiniMax
%   Mejor_evaluación: Indica el valor obtenido por la evalucación heurística de la mejor jugada
%   Profundidad: Indica la profundidad de búsqueda
%   Jugador_maximizar: Indica el jugador a maximizar en el nivel de búsqueda actual

%   Este caso ocurre cuando no existen posibles jugadas a realizar.

poda_alphabeta([], _, _, Estado, Evaluación, Estado, Evaluación, _, _):- !.

%   Este caso ocurre cuando los límites de Alpha y Beta no se afectan por los valores
%   de la evaluación en ese nivel.

poda_alphabeta(_, Alpha, Beta, Estado, Evaluación, Estado, Evaluación, _, Jugador_maximizar):-
    (
        Jugador_maximizar, Evaluación > Beta, !
    ;
        \+(Jugador_maximizar), Evaluación < Alpha, !
    ).

%   Este caso ocurre cuando los límites de Alpha y Beta corresponden a un caso de poda
%   y los valores de Alpha y Beta deben ser actualizados.

poda_alphabeta(Lista_jugadas, Alpha, Beta, Estado, Evaluación, Mejor_jugada, Mejor_evaluación, Profundidad, Jugador_maximizar):-
    nuevos_límites(Alpha, Beta, Estado, Evaluación, Nuevo_Alpha, Nuevo_Beta, Jugador_maximizar),
    mejor_jugada(Lista_jugadas, Nuevo_Alpha, Nuevo_Beta, Estado2, Evaluación2, Profundidad, Jugador_maximizar),
    mejor_entre(Estado, Evaluación, Estado2, Evaluación2, Mejor_jugada, Mejor_evaluación, Jugador_maximizar), !.

% ============================================================================================== %

% ============================================================================================== %
%   nuevos_límites/9. Determina si los valores de Alpha y Beta corresponden a un caso de poda.

%   nuevos_límites(<Alpha>,<Beta>,<Estado>,<Evaluación>,<Nuevo_Alpha>,<Nuevo_Beta>,<Jugador_maximizar>).

%   Alpha: Indica el valor actual de Alpha para las podas Alpha-Beta
%   Beta: Indica el valor actual de Beta para las podas Alpha-Beta
%   Estado: Representación del estado actual de la partida de Mancala
%   Evaluación: Indica el valor obtenido por la evalucación heurística del estado
%   Alpha: Indica el valor actualizado de Alpha
%   Beta: Indica el valor actualizado de Beta
%   Jugador_maximizar: Indica el jugador a maximizar en el nivel de búsqueda actual

%   Este caso ocurre cuando el valor de la evaluación es mayor que Alpha, por lo cual el valor
%   de Alpha debe ser actualizado.

nuevos_límites(Alpha, Beta, _, Evaluación, Evaluación, Beta, Jugador_maximizar):-
    Jugador_maximizar, Evaluación > Alpha, !.

%   Este caso ocurre cuando el valor de la evaluación es menor que Beta, por lo cual el valor
%   de Beta debe ser actualizado.

nuevos_límites(Alpha, Beta, _, Evaluación, Alpha, Evaluación, Jugador_maximizar) :-
    \+(Jugador_maximizar), Evaluación < Beta, !.

%   Este caso ocurre cuando el valor de la evaluación no cumple con las condiciones para 
%   modificar los valores de Alpha o Beta, por lo cual los valores se mantienen iguales.

nuevos_límites(Alpha, Beta, _, _, Alpha, Beta, _).

% ============================================================================================== %

% ============================================================================================== %
%   mejor_entre/7. Determina la mejor jugada entre un par de jugadas a partir de su
%   valor obtenido en la evaluación heurística.

%           mejor_entre(<Jugada_1>,<Evaluación_1>,<Jugada_2>,<Evaluación_2>,<Mejor_jugada>,
%                           <Mejor_evaluación>,<Jugador_maximizar>).

%   Este predicado corresponde al caso en el cual por medio del algoritmo MiniMax se maximizará o 
%   minimizará la ganancia de acuerdo al nivel que se esté analizando.

mejor_entre(Estado, Evaluación, _, Evaluación2, Estado, Evaluación, Jugador_maximizar) :-
        Jugador_maximizar, Evaluación > Evaluación2, !
    ;
        \+(Jugador_maximizar), Evaluación < Evaluación2, !.

mejor_entre(_, _, Estado2, Evaluación2, Estado2, Evaluación2, _):- !.

% ============================================================================================== %


% ============================================================================================== %
%   evaluación_heurística/2. Realiza la evaluación heurística de un estado para 
%   obtener su valor 

%                evaluación_heurística(<Estado>,<Evaluación>).

%   Debido a que el juego de Mancala puede ser considerado como un juego de suma cero,
%   la evaluación heurística puede tomar la siguiente forma general:

%   Puntuación del jugador (PA) menos puntuación del adversario (PJ).

%                                   f(e) = PJ - PA.

evaluación_heurística(estado(_, _, Puntuación_Jugador1, Puntuación_Jugador2, _), Evaluación):-
    Evaluación is Puntuación_Jugador1 - Puntuación_Jugador2, !.

% ============================================================================================== %

% ============================================================================================== %
%   heurística_auxiliar/2. Realiza la heurística auxiliar de movimientos asesinos.

%                heurística_auxiliar(<Estado>,<Evaluación>).

%   Para mejorar las decisiones que toma el agente jugador, es útil hacer uso de heurísticas
%   auxiliares que permitan encontrar las jugadas que producen mayor ventaja o desventaja.

%   La heurística auxiliar utilizada es la denominada "Heurística asesina", que permite 
%   identificar los mejores movimientos del oponente y almacenarlos para que puedan ser
%   analizados con prioridad en las siguientes partidas. Esto evita que el agente jugador 
%   caiga en la misma jugada múltiples veces.

%   Para encontrar los mejores movimientos del oponente se usará el número de fichas en cada
%   casilla de la fila del opoenente, ya que existe una relación directa entre este número y
%   la mejor jugada a realizar.

%   EXPLICACIÓN

%   La proporción de fichas en cada casilla con la cual se consigue la mejor jugada,
%   es la siguiente:

%                                   | [6,5,4,3,2,1] | -> [Base]

%   De esta forma el jugador tiene la pósibilidad de terminar con todas sus fichas con 
%   movimientos consecutivos.

%   EJEMPLO DE PASOS:

%   Paso 1:            | [6,5,4,3,2,0] | -> [1]    Vuelve a tirar al caer en base
%   Paso 2:            | [6,5,4,3,0,1] | -> [2]    Vuelve a tirar al caer en base
%   Paso 3:            | [6,5,4,3,0,0] | -> [3]    Vuelve a tirar al caer en base
%   Paso 4:            | [6,5,4,0,1,1] | -> [4]    Vuelve a tirar al caer en base
%   Paso 5:            | [6,5,4,0,1,0] | -> [5]    Vuelve a tirar al caer en base
%   ...

%   Las jugadas se realizan de manera ininterrumpida hasta llegar al estado:

%                             | [0,0,0,0,0,0] | -> [21]

%   Además, al terminar con todas las fichas se procede a sumar el valor X que corresponde
%   a las fichas del oponente.

%   Por lo tanto la función que indica si la jugada corresponde a una movida asesina, se 
%   determina como la diferencia entre el valor ideal de cada casilla con el valor real
%   en el tablero. Para que una jugada sea considerada un movimiento asesino la suma de
%   diferencias en cada casilla del tablero debe ser menor a 6 que corresponde al número
%   de casillas disponibles para cada jugador y significa que a lo más debe existir una
%   diferencia de una ficha en cada una de las casillas contra el valor ideal.


heurística_auxiliar(Estado,Evaluación) :-
    Estado = estado(Tablero, 1, _, _, _),
    nth1(1, Tablero, Fila_jugador1),
    Fila_jugador1 = [C1,C2,C3,C4,C5,C6],
    Diferencia_1 is 6 - C1 , Diferencia_1 >= 0, Diferencia_1 =< 2,
    Diferencia_2 is 5 - C2 , Diferencia_2 >= 0, Diferencia_2 =< 2, 
    Diferencia_3 is 4 - C3 , Diferencia_3 >= 0, Diferencia_3 =< 2,
    Diferencia_4 is 3 - C4 , Diferencia_4 >= 0, Diferencia_4 =< 2,
    Diferencia_5 is 2 - C5 , Diferencia_5 >= 0, Diferencia_5 =< 1,
    Diferencia_6 is 1 - C6 , Diferencia_6 >= 0, Diferencia_6 =< 1,
    Fila is Diferencia_1 + Diferencia_2 + Diferencia_3 + Diferencia_4 + Diferencia_5 + Diferencia_6,
    Fila =< 6, Fila >= 0,
    Evaluación is -100,
    nl, ansi_format([bold,fg(red)], 'Se agregó al registro un movimiento_asesino', []), nl,
    assert(jugada_asesina(Tablero,Evaluación)).

% ============================================================================================== %


% ============================================================================================== %
%   listar_jugadas/2. Genera una lista con todas las jugadas a las cuales
%   se pueden llegar a partir del estado inicial.

%                   listar_jugadas(<Estado>,<Jugadas>).

listar_jugadas(Estado, Lista_jugadas):-
    findall(Siguiente_estado, jugada(Estado, Siguiente_estado), Lista_jugadas), !.

% ============================================================================================== %

% ============================================================================================== %
%   jugada/2. Genera las jugadas posibles a partir del estado inicial proporcionado.

%                       jugada(<Estado>,<Estado>).

jugada(estado(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, _),estado(Nuevo_tablero, Siguiente_jugador, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Índice_casilla)):-
    nth1(Jugador_en_turno, Tablero, Fila),
    findall(Índice_casilla, movimiento_válido(Fila, Índice_casilla), Movimientos_válidos),
    member(Índice_casilla, Movimientos_válidos),
    realizar_jugada(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Índice_casilla, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador).

% ============================================================================================== %