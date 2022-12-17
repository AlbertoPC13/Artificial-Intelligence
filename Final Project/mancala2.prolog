% Programmer: Maayan Kestler
% Name File: mancal.pl
% Description: console mancla game with alphabeta ai player
% Synopsys: to satrt playing mancala run the start_game predicate

% the main predicate of the program, start a mancala game
% Player1- the name of the first player
% Player2- the name of the second  player
% PitsNumber- the number of pits in each row of the board
% PiecesInPit- the number of pieces in each pit at the start of the game
% Player1Func- the playing logic of the first player
% Player2Func- the playing logic of the second player

:- dynamic(nombre_jugador/2).
:- dynamic(jugada_asesina/2).

nombre_jugador(1, 'J1(Tú)').
nombre_jugador(2, 'Jarvis').

cambiar_símbolo(Jugador1,Jugador2) :-
    retractall(nombre_jugador(_,_)),
    assert(nombre_jugador(1,Jugador1)),
    assert(nombre_jugador(2,Jugador2)).

iniciar_juego(Jugador1, Jugador2, Número_casillas, Número_fichas, Función_Jugador1, Función_Jugador2, Profundidad1, Profundidad2):-
    crear_lista_inicializada(Número_casillas, Número_fichas, Fila),
    crear_lista_inicializada(2, Fila, Tablero),
    Puntuación_Jugador1 is 0,
    Puntuación_Jugador2 is 0,
    imprimir_tablero(Tablero, Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2),
    jugar(Tablero, Jugador1, Jugador2, 1, Puntuación_Jugador1, Puntuación_Jugador2, Función_Jugador1, Función_Jugador2, Profundidad1, Profundidad2), !.

% start the game with deafult arguments
iniciar_juego(Profundidad):-
    nombre_jugador(1, Jugador1),
    nombre_jugador(2, Jugador2),
    iniciar_juego(Jugador1, Jugador2, 6, 3, entrada_teclado, minimax_AB,1,Profundidad), !.

iniciar_juego():-
    nombre_jugador(1, Jugador1),
    nombre_jugador(2, Jugador2),
    iniciar_juego(Jugador1, Jugador2, 6, 3, minimax_AB, minimax_AB,3,6), !.

% play a move in the game
% Board- the mancala board made of list containing two lists (one for each row)
% CurrentPlayerNumber- the number of the current player (1 for Player1 and 2 for Player2)
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
        jugar(Tablero, Jugador1, Jugador2, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Función_Jugador1, Función_Jugador2,Profundidad1,Profundidad2) % play the turn again in case of invalid move
    ), !.

siguiente_jugada(Nuevo_tablero, Jugador1, Jugador2, _, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, _, _, _, _):-
    comprobar_victoria(Nuevo_tablero, Jugador1, Jugador2, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2),
    nl, write("Puntuación final de "), write(Jugador1), write(": "), write(Nueva_puntuación_Jugador1), write(" "), nl,
    nl, write("Puntuación final de "), write(Jugador2), write(": "), write(Nueva_puntuación_Jugador2), nl, nl, !. % someone won, the game end

siguiente_jugada(Nuevo_tablero, Jugador1, Jugador2, Siguiente_jugador, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Función_Jugador1, Función_Jugador2, Profundidad1, Profundidad2):-
    jugar(Nuevo_tablero, Jugador1, Jugador2, Siguiente_jugador, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Función_Jugador1, Función_Jugador2, Profundidad1, Profundidad2), !. % play the next move

% do a move in the game
% PitIndex- the of the pit the player chose to play (starting from 1)
% NewBoard- the board adter playing the move
% NextPlayer- the player that need to play the next move (can be the same player again)
realizar_jugada(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Índice_casilla, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador):-
    integer(Índice_casilla),
    nth1(Jugador_en_turno, Tablero, Fila),
    movimiento_válido(Fila, Índice_casilla),
    remplaza_nth1(Fila, Índice_casilla, Número_fichas, 0, Nueva_fila),
    remplaza_nth1(Tablero, Jugador_en_turno, _, Nueva_fila, Tablero_temporal),
    Nuevo_índice_casilla is Índice_casilla + 1,
    coloca_fichas(Tablero_temporal, Número_fichas, Jugador_en_turno, Nuevo_índice_casilla, Jugador_en_turno, 
            Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador), !.

% check if a given pit index is a valid move (the index in range and there are pieces in the pit)
% Row- the row of the player that want to do the move
movimiento_válido(Fila, Índice_casilla):-
    length(Fila, Tamaño_fila),
    between(1, Tamaño_fila, Índice_casilla),
    nth1(Índice_casilla, Fila, Fichas),
    Fichas > 0.

% put_pieces(Board, PiecesCount, RowIndex, PitIndex, CurrentPlayerNumber, Player1Score, Player2Score, NewBoard, NewPlayer1Score, NewPlayer2Score, NextPlayer):
% move the pieces from the played pit to the next pits in the board
% PiecesCount- amount of pieces left to put
% RowIndex- the index of the row the pieces need to be put in
% PitIndex- th index of the pit in the row the pieces need to be put in

% put last piece in result pit, the player get another turn
coloca_fichas(Tablero, 0, _, 1, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Jugador_en_turno):- 
    válida_fila_vacía(Tablero, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2), !.

% put last piece, if in empty pit get other player piece from facing pit
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
        válida_fila_vacía(Tablero_temporal, Puntuación_Jugador1_temporal, Puntuación_Jugador2_temporal, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2)
    ;
        válida_fila_vacía(Tablero, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2)
    ), !.

% put pieces in same row
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
    
% move to the next row
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

% check if there is an empty row in the board (in this case the game end) and update the scores and the board.
% 
% there is an empry row
válida_fila_vacía(Tablero, Puntuación_Jugador1, Puntuación_Jugador2, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2):-
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
    length(Fila1, Tamaño_filas),
    crear_lista_inicializada(Tamaño_filas, 0, Fila),
    crear_lista_inicializada(2, Fila, Nuevo_tablero), !.

% there is no empty row, return the same values
válida_fila_vacía(Tablero, Puntuación_Jugador1, Puntuación_Jugador2, Tablero, Puntuación_Jugador1, Puntuación_Jugador2):- !.

% check if there is a winner
comprobar_victoria(Tablero, Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2):-
    sumar_tablero(Tablero, Sum),
    Sum =:= 0,
    determinar_ganador(Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2), !.

% declare who the winner is
determinar_ganador(Jugador1, _, Puntuación_Jugador1, Puntuación_Jugador2):-
    Puntuación_Jugador1 > Puntuación_Jugador2, !,
    nl, write("¡El ganador es "), write(Jugador1), write("!"), nl.

determinar_ganador(_, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2):-
    Puntuación_Jugador1 < Puntuación_Jugador2, !,
    nl, write("¡El ganador es "), write(Jugador2), write("!"), nl.

determinar_ganador(_, _, Puntuación_Jugador1, Puntuación_Jugador2):-
    Puntuación_Jugador1 = Puntuación_Jugador2, !,
    nl, write("¡La partida quedó en empate!"), nl.

sumar_tablero(Tablero, Sum):-
    nth1(1, Tablero, Fila1),
    nth1(2, Tablero, Fila2),
    sum_list(Fila1, Sum1),
    sum_list(Fila2, Sum2),
    Sum is Sum1 + Sum2.

% https://www.swi-prolog.org/pldoc/doc_for?object=nth0/4
remplaza_nth1(List, Índice, Antiguo_elemento, Nuevo_elemento, Nueva_lista) :-
    % predicate works forward: Index,List -> OldElem, Transfer
    nth1(Índice,List,Antiguo_elemento,Transferir),
    % predicate works backwards: Index,NewElem,Transfer -> NewList
    nth1(Índice,Nueva_lista,Nuevo_elemento,Transferir), !.

% print the mancala board
imprimir_tablero(Tablero, Jugador1, Jugador2, Puntuación_Jugador1, Puntuación_Jugador2):-
    nl, write("Puntuación de "), ansi_format([bold,fg(blue)], '~w: ', [Jugador1]), write(Puntuación_Jugador1), nl,
    write("Puntuación de "), ansi_format([bold,fg(green)], '~w: ', [Jugador2]), write(Puntuación_Jugador2), nl, nl,
    nth1(1, Tablero, Fila_jugador1),
    reverse(Fila_jugador1, Fila_jugador1_invertida),
    nth1(2, Tablero, Fila_jugador2),
    write("Fila de "), ansi_format([bold,fg(blue)], '~w: | ', [Jugador1]), write(Fila_jugador1_invertida), write(" | <-"), nl,
    write("Fila de "), ansi_format([bold,fg(green)], '~w: | ', [Jugador2]), write(Fila_jugador2), write(" | ->"), nl, !.

crear_lista_inicializada(Tamaño, Valor, Lista):-
    length(Lista,Tamaño), 
    maplist(=(Valor), Lista), !.

% playing logic, play by user input
entrada_teclado(_, _, Índice_casilla):-
    write("Ingresa el número de casilla a jugar: "),
    read(Índice_casilla), !.

entrada_teclado(_, _, Índice_casilla, _):-
    entrada_teclado(_, _, Índice_casilla), !.

% playing logic, play by alphabeta algorithm
minimax_AB(Tablero, Jugador_en_turno, Índice_casilla, Profundidad):-
    sumar_tablero(Tablero, Beta),
    Alpha is -Beta,
    minimax(estado_mancala(Tablero, Jugador_en_turno, 0, 0, -1), Alpha, Beta, estado_mancala(_, _, _, _, Índice_casilla), _, Profundidad), !.

%  The alpha-beta algorithm (based on the book)

% general case alpha-beta algorithm
% Pos describe with mancala_pos(Board, CurrentPlayerNumber, Player1Score, Player2Score, PitIndex)
% the score use for the heuristic function
% PitIndex is the index of the pit played in the last turn (-1 if it's the first runing)
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

%  use static val when Depth is 0 or reached leafs

minimax(Estado, _, _, Estado, Evaluación, _):-
    Estado = estado_mancala(Tablero, 1, _, _, _),
    jugada_asesina(Tablero,Evaluación),
    nl, write("Se evadió una jugada asesina"), nl, !.

%    , Diferencia_1 >= 0, Diferencia_1 =< 2
minimax(Estado, _, _, Estado, Evaluación, _):-
    Estado = estado_mancala(Tablero, 1, _, _, _),
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
    nl, write("Se agregó jugada asesina"), nl,
    assert(jugada_asesina(Tablero,Evaluación)), !.

minimax(Estado, _, _, Estado, Evaluación, _):-
    evaluación_heurística(Estado, Evaluación), !.

% MaxPlayer- true if the parent node is a max player
mejor_jugada([Estado | Lista_jugadas], Alpha, Beta, Mejor_jugada, Mejor_evaluación, Profundidad, Jugador_maximizar):-
    Nueva_profundidad is Profundidad - 1,
    minimax(Estado, Alpha, Beta, _, Evaluación, Nueva_profundidad),
    poda_alphabeta(Lista_jugadas, Alpha, Beta, Estado, Evaluación, Mejor_jugada, Mejor_evaluación, Profundidad, Jugador_maximizar), !.

poda_alphabeta([], _, _, Estado, Evaluación, Estado, Evaluación, _, _):- !. % No other candidate

poda_alphabeta(_, Alpha, Beta, Estado, Evaluación, Estado, Evaluación, _, Jugador_maximizar):-
    (
        Jugador_maximizar, Evaluación > Beta, ! % Maximizer attained upper bound
    ;
        \+(Jugador_maximizar), Evaluación < Alpha, ! % Minimizer attained lower bound
    ).

poda_alphabeta(Lista_jugadas, Alpha, Beta, Estado, Evaluación, Mejor_jugada, Mejor_evaluación, Profundidad, Jugador_maximizar):-
    nuevos_límites(Alpha, Beta, Estado, Evaluación, Nuevo_Alpha, Nuevo_Beta, Jugador_maximizar), % Refine bounds
    mejor_jugada(Lista_jugadas, Nuevo_Alpha, Nuevo_Beta, Estado2, Evaluación2, Profundidad, Jugador_maximizar),
    mejor_entre(Estado, Evaluación, Estado2, Evaluación2, Mejor_jugada, Mejor_evaluación, Jugador_maximizar), !.

nuevos_límites(Alpha, Beta, _, Evaluación, Evaluación, Beta, Jugador_maximizar):-
    Jugador_maximizar, Evaluación > Alpha, !. % Maximizer increased lower bound

nuevos_límites(Alpha, Beta, _, Evaluación, Alpha, Evaluación, Jugador_maximizar) :-
    \+(Jugador_maximizar), Evaluación < Beta, !. % Minimizer decreased upper bound

nuevos_límites(Alpha, Beta, _, _, Alpha, Beta, _). % Otherwise bounds unchanged

mejor_entre(Estado, Evaluación, _, Evaluación2, Estado, Evaluación, Jugador_maximizar) :- % Pos better than Pos1
        Jugador_maximizar, Evaluación > Evaluación2, !
    ;
        \+(Jugador_maximizar), Evaluación < Evaluación2, !.

mejor_entre(_, _, Estado2, Evaluación2, Estado2, Evaluación2, _):- !. % Otherwise Pos1 better

% heuristic function, calculate the value of given mancala_pos
evaluación_heurística(estado_mancala(_, _, Puntuación_Jugador1, Puntuación_Jugador2, _), Evaluación):-
    Evaluación is Puntuación_Jugador1 - Puntuación_Jugador2, !.

% player1 is the max player
jugador_maximizar(estado_mancala(_, 1, _, _, _)):- !.

% player2 is the min player
jugador_minimizar(estado_mancala(_, 2, _, _, _)):- !.

% Poslist contain all the possible positions that can be reached by playing a move from the given mancala_pos
listar_jugadas(Estado, Lista_jugadas):-
    findall(Siguiente_estado, jugada(Estado, Siguiente_estado), Lista_jugadas), !.

% result_posistions(Pos, ResultPos): true if ResultPos is is a mancala_pos that can be reached from the given Pos
jugada(estado_mancala(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, _),
                  estado_mancala(Nuevo_tablero, Siguiente_jugador, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Índice_casilla)):-
    nth1(Jugador_en_turno, Tablero, Fila),
    findall(Índice_casilla, movimiento_válido(Fila, Índice_casilla), Movimientos_válidos),
    member(Índice_casilla, Movimientos_válidos),
    realizar_jugada(Tablero, Jugador_en_turno, Puntuación_Jugador1, Puntuación_Jugador2, Índice_casilla, Nuevo_tablero, Nueva_puntuación_Jugador1, Nueva_puntuación_Jugador2, Siguiente_jugador).