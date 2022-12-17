:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(random)).

:- dynamic(nombre_jugador/2).

nombre_jugador(1, 'J1').
nombre_jugador(2, 'IA').

% print the mancala board
imprimir_tablero(Tablero, Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2):-
    write("Puntuación de "), ansi_format([bold,fg(blue)], '~w: ', [Jugador1]), write(Puntuación_Jugador1), nl,
    write("Puntuación de "), ansi_format([bold,fg(green)], '~w: ', [Jugador2]), write(Puntuación_Jugador2), nl,
    nth1(1, Tablero, Fila_jugador1),
    reverse(Fila_jugador1, Fila_jugador1_invertida),
    nth1(2, Tablero, Fila_jugador2),
    write("Fila de "), ansi_format([bold,fg(blue)], '~w: | ', [Jugador1]), write(Fila_jugador1_invertida), write(" | <-"), nl,
    write("Fila de "), ansi_format([bold,fg(green)], '~w: | ', [Jugador2]), write(Fila_jugador2), write(" | ->"), nl, !.

%   the main predicate of the program, start a mancala game
%   Player1- the name of the first player
%   Player2- the name of the second  player
%   PitsNumber- the number of pits in each row of the board
%   PiecesInPit- the number of pieces in each pit at the start of the game
%   Player1Func- the playing logic of the first player
%   Player2Func- the playing logic of the second player
iniciar_juego(Jugador1, Jugador2, NumeroCasillas, NumeroFichas, Función_Jugador1, Función_Jugador2, 1, Profundidad):-
    crear_lista_inicializada(NumeroCasillas, NumeroFichas, Fila),
    crear_lista_inicializada(2, Fila, Tablero),
    Puntuación_Jugador1 is 0,
    Puntuación_Jugador2 is 0,
    imprimir_tablero(Tablero, Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2),
    jugar(Tablero, Jugador1, Jugador2, 1, Puntuación_Jugador1, Puntuación_Jugador2, Función_Jugador1, Función_Jugador2, 1, Profundidad), !.

%   start the game with deafult arguments
iniciar_juego(Profundidad):-
    nombre_jugador(1, Jugador1),
    nombre_jugador(2, Jugador2),
    iniciar_juego(Jugador1, Jugador2, 6, 3, entrada_teclado, minimax_AB, 1, Profundidad), !.

% play a move in the game
% Board- the mancala board made of list containing two lists (one for each row)
% CurrentPlayerNumber- the number of the current player (1 for Player1 and 2 for Player2)
jugar(Tablero, Jugador1, Jugador2, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Función_Jugador1, Función_Jugador2, Profundidad_1, Profundidad_2):-
    (
        Jugador_en_turno = 1,
        Jugador = Jugador1,
        Función = Función_Jugador1,
        Color_jugador = 'blue',
        Profundidad = Profundidad_1
    ;
        Jugador_en_turno = 2,
        Jugador = Jugador2,
        Función = Función_Jugador2,
        Color_jugador = 'green',
        Profundidad = Profundidad_2
    ),
    write("Turno de: "), ansi_format([bold,fg(Color_jugador)], '~w', [Jugador]), nl,
    call(Función, Tablero, Jugador_en_turno, Índice_de_casilla, Profundidad),
    ansi_format([bold,fg(Color_jugador)], '~w', [Jugador]), ansi_format([bold,fg(cyan)], ' selecciona la casilla: ~w', [Índice_de_casilla]), nl,
    (
        realizar_jugada(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Índice_de_casilla, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador),
        imprimir_tablero(Nuevo_tablero, Jugador1, Jugador2, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2),
        siguiente_jugada(Nuevo_tablero, Jugador1, Jugador2, Siguiente_jugador, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Función_Jugador1, Función_Jugador2, Profundidad_1, Profundidad_2)
    ;
        ansi_format([bold,fg(red)], 'Movimiento inválido, tira de nuevo :)', []), nl,
        jugar(Tablero, Jugador1, Jugador2, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Función_Jugador1, Función_Jugador2, Profundidad_1, Profundidad_2) % play the turn again in case of invalid move
    ), !.

siguiente_jugada(Tablero, Jugador1, Jugador2, _, Puntuación_Jugador1, Puntuación_Jugador2,_,_,_,_):-
    comprobar_victoria(Tablero, Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2),
    write("Puntuación final de "), write(Jugador1), write(": "), write(Puntuación_Jugador1), write(" "), nl,
    write("Puntuación final de "), write(Jugador2), write(": "), write(Puntuación_Jugador2), nl, !. % someone won, the game end

siguiente_jugada(Tablero, Jugador1, Jugador2, Siguiente_jugador, Puntuación_Jugador1, Puntuación_Jugador2, Función_Jugador1, Función_Jugador2,  Profundidad_1, Profundidad_2):-
    jugar(Tablero, Jugador1, Jugador2, Siguiente_jugador, Puntuación_Jugador1, Puntuación_Jugador2, Función_Jugador1, Función_Jugador2,  Profundidad_1, Profundidad_2), !. % play the next move
    
% do a move in the game
% PitIndex- the of the pit the player chose to play (starting from 1)
% NewBoard- the board adter playing the move
% NextPlayer- the player that need to play the next move (can be the same player again)
realizar_jugada(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Índice_de_casilla, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador):-
    integer(Índice_de_casilla),
    nth1(Jugador_en_turno, Tablero, Fila),
    movimiento_válido(Fila, Índice_de_casilla),
    remplaza_nth1(Fila, Índice_de_casilla, Número_fichas, 0, Nueva_fila),
    remplaza_nth1(Tablero, Jugador_en_turno, _, Nueva_fila, Tablero_temporal),
    Nuevo_índice_casilla is Índice_de_casilla + 1,
    colocar_fichas(Tablero_temporal, Número_fichas, Jugador_en_turno, Nuevo_índice_casilla, Jugador_en_turno, 
            Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador), !.

% check if a given pit index is a valid move (the index in range and there are pieces in the pit)
% Row- the row of the player that want to do the move
movimiento_válido(Fila, Índice_de_casilla):-
    length(Fila, Tamaño_fila),
    between(1, Tamaño_fila, Índice_de_casilla),
    nth1(Índice_de_casilla, Fila, Fichas),
    Fichas > 0.

% put last piece in result pit, the player get another turn
colocar_fichas(Tablero, 0, _, 1, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Jugador_en_turno):- 
    validar_fila_vacía(Tablero, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2), !.

% put last piece, if in empty pit get other player piece from facing pit
colocar_fichas(Tablero, 0, Índice_de_fila, Índice_de_casilla, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador):-
    Siguiente_jugador is (Jugador_en_turno mod 2) + 1,
    (
        Jugador_en_turno = Índice_de_fila,
        Último_índice_casilla is Índice_de_casilla - 1,
        nth1(Índice_de_fila, Tablero, Fila),
        remplaza_nth1(Fila, Último_índice_casilla, 1, 0, Nueva_fila),
        nth1(Siguiente_jugador, Tablero, Fila_capturada),
        length(Fila_capturada, Tamaño_fila_capturada),
        Índice_de_casilla_capturada is Tamaño_fila_capturada - Último_índice_casilla + 1,
        remplaza_nth1(Fila_capturada, Índice_de_casilla_capturada, X, 0, Nueva_fila_capturada),
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

% put pieces in same row
colocar_fichas(Tablero, Número_fichas, Índice_de_fila, Índice_de_casilla, Jugador_en_turno,
           Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador):-
    nth1(Índice_de_fila, Tablero, Fila),
    length(Fila, Tamaño_fila),
    Índice_de_casilla =< Tamaño_fila,
    nth1(Índice_de_casilla, Fila, X),
    NX is X + 1,
    Nuevo_número_fichas is Número_fichas - 1,
    Nuevo_índice_casilla is Índice_de_casilla + 1,
    remplaza_nth1(Fila, Índice_de_casilla, X, NX, Nueva_fila),
    remplaza_nth1(Tablero, Índice_de_fila, Fila, Nueva_fila, Tablero_temporal),
    colocar_fichas(Tablero_temporal, Nuevo_número_fichas, Índice_de_fila, Nuevo_índice_casilla, Jugador_en_turno,
               Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador), !.

% move to the next row
colocar_fichas(Tablero, Número_fichas, Índice_de_fila, Índice_de_casilla, Jugador_en_turno,
           Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador):-
    nth1(Índice_de_fila, Tablero, Fila),
    length(Fila, Tamaño_fila),
    Índice_de_casilla =:= Tamaño_fila + 1,
    Nuevo_índice_casilla = 1,
    Nuevo_índice_fila is (Índice_de_fila mod 2) + 1,
    (
        Jugador_en_turno = Índice_de_fila,
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
        Puntuación_Jugador1_temporal is Puntuación_Jugador1,
        Puntuación_Jugador2_temporal is Puntuación_Jugador2,
        Nuevo_número_fichas is Número_fichas
    ),
    colocar_fichas(Tablero, Nuevo_número_fichas, Nuevo_índice_fila, Nuevo_índice_casilla, Jugador_en_turno,
               Puntuación_Jugador1_temporal, Puntuación_Jugador2_temporal, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador), !.

% check if there is an empty row in the board (in this case the game end) and update the scores and the board.
% 
% there is an empry row
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
    % empty the board
    length(Fila1, Tamaño_fila),
    crear_lista_inicializada(Tamaño_fila, 0, Fila),
    crear_lista_inicializada(2, Fila, Nuevo_tablero), !.

% there is no empty row, return the same values
validar_fila_vacía(Tablero, Puntuación_Jugador1, Puntuación_Jugador2, Tablero, Puntuación_Jugador1, Puntuación_Jugador2):- !.

% check if there is a winner
comprobar_victoria(Tablero, Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2):-
    sumar_tablero(Tablero, Sum),
    Sum =:= 0,
    determinar_ganador(Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2), !.

% declare who the winner is
determinar_ganador(Jugador1, _, Puntuación_Jugador1, Puntuación_Jugador2):-
    Puntuación_Jugador1 > Puntuación_Jugador2, !,
    write("El ganador es "), write(Jugador1), write("!!!!"), nl.

determinar_ganador(_, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2):-
    Puntuación_Jugador1 < Puntuación_Jugador2, !,
    write("El ganador es "), write(Jugador2), write("!!!!"), nl.

determinar_ganador(_, _, Puntuación_Jugador1, Puntuación_Jugador2):-
    Puntuación_Jugador1 = Puntuación_Jugador2, !,
    write("La partida quedó en empate!!!!"), nl.

sumar_tablero(Tablero, Sum):-
    nth1(1, Tablero, Fila1),
    nth1(2, Tablero, Fila2),
    sum_list(Fila1, Sum1),
    sum_list(Fila2, Sum2),
    Sum is Sum1 + Sum2.

remplaza_nth1(Lista, Índice, Antiguo_elemento, Nuevo_elemento, Nueva_lista) :-
    % predicate works forward: Index,List -> OldElem, Transfer
    nth1(Índice,Lista,Antiguo_elemento,Transferir),
    % predicate works backwards: Index,NewElem,Transfer -> NewList
    nth1(Índice,Nueva_lista,Nuevo_elemento,Transferir), !.

crear_lista_inicializada(Longitud, Valor, Lista):-
    length(Lista,Longitud), 
    maplist(=(Valor), Lista), !.

% playing logic, play by user input
entrada_teclado(_, _, Índice_de_casilla, _):-
    entrada_teclado(_, _, Índice_de_casilla), !.

entrada_teclado(_, _, Índice_de_casilla):-
    write("Ingresa el número de casilla a jugar: "),
    read(Índice_de_casilla), !.

% playing logic, play by alphabeta algorithm
minimax_AB(Tablero, Jugador_en_turno, Índice_de_casilla, Profundidad):-
    sumar_tablero(Tablero, Beta),
    Alpha is -Beta,
    minimax(estado_mancala(Tablero, Jugador_en_turno, 0, 0, -1), Alpha, Beta, estado_mancala(_, _, _, _, Índice_de_casilla), _, Profundidad), !.

minimax(Estado, Alpha, Beta, Mejor_jugada, Mejor_evaluación, Profundidad):-
    Profundidad > 0,
    listar_jugadas(Estado, Lista_estados),
    (
        jugador_maximizar(Estado),
        Jugador_maximizar = true
    ;
        jugador_minimizar(Estado),
        Jugador_maximizar = false
    ),
    mejor_jugada(Lista_estados, Alpha, Beta, Mejor_jugada, Mejor_evaluación, Profundidad, Jugador_maximizar), !.

%  use static val when Depth is 0 or reached leafs
minimax(Estado, _, _, Estado, Evaluación, _):-
    evaluación_heurística(Estado, Evaluación), !.

% MaxPlayer- true if the parent node is a max player
mejor_jugada([Estado | Lista_estados], Alpha, Beta, Mejor_jugada, Mejor_evaluación, Profundidad, Jugador_maximizar):-
    Nueva_profundidad is Profundidad - 1,
    minimax(Estado, Alpha, Beta, _, Evaluación, Nueva_profundidad),
    poda_alphabeta(Lista_estados, Alpha, Beta, Estado, Evaluación, Mejor_jugada, Mejor_evaluación, Profundidad, Jugador_maximizar), !.

poda_alphabeta([], _, _, Estado, Evaluación, Estado, Evaluación, _, _):- !. % No other candidate

poda_alphabeta(_, Alpha, Beta, Estado, Evaluación, Estado, Evaluación, _, Jugador_maximizar):-
    (
        Jugador_maximizar, Evaluación > Beta, ! % Maximizer attained upper bound
    ;
        \+(Jugador_maximizar), Evaluación < Alpha, ! % Minimizer attained lower bound
    ).

poda_alphabeta(Lista_estados, Alpha, Beta, Estado, Evaluación, Mejor_jugada, Mejor_evaluación, Profundidad, Jugador_maximizar):-
    nuevos_límites(Alpha, Beta, Estado, Evaluación, Nuevo_Alpha, Nuevo_Beta, Jugador_maximizar), % Refine bounds
    mejor_jugada(Lista_estados, Nuevo_Alpha, Nuevo_Beta, Estado_2, Evaluación_2, Profundidad, Jugador_maximizar),
    mejor_entre(Estado, Evaluación, Estado_2, Evaluación_2, Mejor_jugada, Mejor_evaluación, Jugador_maximizar), !.

nuevos_límites(Alpha, Beta, _, Evaluación, Evaluación, Beta, Jugador_maximizar):-
    Jugador_maximizar, Evaluación > Alpha, !. % Maximizer increased lower bound

nuevos_límites(Alpha, Beta, _, Evaluación, Alpha, Evaluación, Jugador_maximizar) :-
    \+(Jugador_maximizar), Evaluación < Beta, !. % Minimizer decreased upper bound

nuevos_límites(Alpha, Beta, _, _, Alpha, Beta, _). % Otherwise bounds unchanged

mejor_entre(Estado, Evaluación, _, Evaluación_2, Estado, Evaluación, Jugador_maximizar) :- % Pos better than Pos1
        Jugador_maximizar, Evaluación > Evaluación_2, !
    ;
        not(Jugador_maximizar), Evaluación < Evaluación_2, !.

betterof(_, _, Estado_2, Evaluación_2, Estado_2, Evaluación_2, _):- !. % Otherwise Pos1 better

% heuristic function, calculate the value of given mancala_pos
evaluación_heurística(estado_mancala(_, _, Puntuación_Jugador1, Puntuación_Jugador2, _), Evaluación):-
    Evaluación is Puntuación_Jugador1 - Puntuación_Jugador2, !.

% player1 is the max player
jugador_maximizar(estado_mancala(_, 1, _, _, _)):- !.

% player2 is the min player
jugador_minimizar(estado_mancala(_, 2, _, _, _)):- !.

% Poslist contain all the possible positions that can be reached by playing a move from the given mancala_pos
listar_jugadas(Estado, Lista_estados):-
    findall(Siguiente_estado, jugada(Estado, Siguiente_estado), Lista_estados), !.

% result_posistions(Pos, ResultPos): true if ResultPos is is a mancala_pos that can be reached from the given Pos
jugada(estado(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, _),
                  estado_mancala(Nuevo_tablero, Siguiente_jugador, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Índice_de_casilla)):-
    nth1(Jugador_en_turno, Tablero, Fila),
    findall(Índice_de_casilla, movimiento_válido(Fila, Índice_de_casilla), Movimientos_válidos),
    member(Índice_de_casilla, Movimientos_válidos),
    realizar_jugada(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Índice_de_casilla, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador).