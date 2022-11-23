% =================================================================================== %
%
%   Alberto Palacios Cabrera
%	
%	Tarea #7. Gato 4x4
%
%   Construye un agente Prolog para jugar Gato 4x4 contra un oponente humano...
%	
%   Las reglas son exactamente las mismas que en el Gato tradicional; se puede ganar
%   alineando cuatro tiros en línea horizontal, vertical o sobre las dos diagonales
%   principales.
%
%   Se debe resolver usando MiniMax con podas Alpha-Beta
%
%   NOTA: La solución de este programa es a partir de MiniMax únicamente
%
%   REPRESENTACIÓN
%
%   - Tablero
%   
%   Representaremos el tablero como una lista de renglones y los espacios en 
%   blanco con un símbolo de guíon medio
%
%               Ejemplo 1: [[-,-,-,-],[-,-,-,-],[-,-,-,-],[-,-,-,-]]
%               Ejemplo 2: [[x,o,-,-],[x,-,-,-],[-,-,-,o],[x,-,o,-]]
%
%   - Estados
%
%   Los estados del juego se representarán como parejas:
%
%                       (Tablero,Jugador_en_turno)
%
%	Predicados relevantes:
%
%   jugar(<Profundidad>).
%   símbolo(<Jugador>,<Símbolo>).
%   siguiente_turno(<Jugador>,<Otro_jugador>).
%   jugada((<Tablero>,<Jugador>),(<Nuevo_tablero>,<Nuevo_jugador>)).
%   desplegar_tablero(<Tablero>).
%   evaluación_heurística((<Tablero>,<Jugador>),<Evaluación>).
%   minimax((<Tablero>,<Jugador>),<Profundidad>,<Siguiente_jugada>,<Evaluación>).
%
%
%   COMO JUGAR:
%      
%   - De manera inicial los símbolos para el jugador humano y la IA son "x" y "o"
%     correspondientemente, pero pueden ser cambiados por medio del predicado 
%     cambiar_símbolo/2 en el cual solo deben ingresarse los nuevos símbolos a usar.
%
%                           Ejemplo: cambiar_símbolo(@,#).
%
%   - Para comenzar un juego se debe llamar al predicado jugar/1, en el cual se 
%     debe ingresar un valor númerico corrsepondiente a la profundidad máxima que
%     se desea usar en MiniMax.
%
%   NOTA: Cuanto mayor sea el valor de profundidad, el agente jugador podrá realizar
%   mejores jugadas pero el tiempo de cómputo incrementa.
%
%   - Para realizar un tiro ya dentro de la partida de Gato, se debe ingresar el
%     tiro, cuando sea solicitado, de la siguiente manera:
%
%                                  [Columna,Fila]
%
%   Las columnas son representadas por las letras: A,B,C y D
%   Las filas son representadas por los números: 1,2,3 y 4
%
%                                   Ejemplo: ['A',3]
%
%                               "Fila A en la columna 3"
%
% =================================================================================== %

% =================================================================================== %
%   símbolo/2. Indica el símbolo asignado para cada jugador en la partida de Gato

%                   símbolo(<Jugador>,<Símbolo>).

%   Verdadero si <Símbolo> es el símbolo correspondiente a <Jugador>
%   NOTA: Se asigna como un predicado dinámico para poder ser modificado en tiempo
%   de ejecución.

:- dynamic(símbolo/2).

símbolo(1,x).
símbolo(2,o).

% =================================================================================== %

% =================================================================================== %
%   max/1. Indica que jugador se encuentra en un nivel Max en el algoritmo MiniMax

%                               max(<Jugador>).

%   Verdadero si <Jugador> es el jugador al cual se desea maximizar su evaluación en
%   la partida

max(2).

% =================================================================================== %

% =================================================================================== %
%   min/1. Indica que jugador se encuentra en un nivel Min en el algoritmo MiniMax

%                               min(<Jugador>).

%   Verdadero si <Jugador> es el jugador al cual se desea minimizar su evaluación en
%   la partida

min(1).

% =================================================================================== %

% =================================================================================== %
%   siguiente_turno/2. Indica el jugador que tira en el siguiente turno de Gato.

%                      siguiente_turno(<Jugador>,<Nuevo_jugador>).

%   Verdadero si <Nuevo_jugador> es el jugador que tira después del turno de <Jugador>

siguiente_turno(1,2).
siguiente_turno(2,1).

% =================================================================================== %

% =================================================================================== %
%   cambiar_símbolo/2. Permite modificar los símbolos de los jugadores en la partida
%   de Gato.

%                     cambiar_símbolo(<Símbolo_1>,<Símbolo_2>).

cambiar_símbolo(Símbolo_1,Símbolo_2) :-
    retractall(símbolo(_,_)),
    assert(símbolo(1,Símbolo_1)),
    assert(símbolo(2,Símbolo_2)).

% =================================================================================== %

% =================================================================================== %
%   jugada/2. Genera las jugadas posibles a partir del estado inicial proporcionado.

%           jugada((<Tablero>,<Jugador>),(<Nuevo_tablero>,<Nuevo_jugador>)).

%   Verdadero si (<Nuevo_tablero>,<Nuevo_jugador>) es un estado al cual se puede
%   llegar desde el estado inicial (<Tablero>,<Jugador>).

jugada((Tablero,Jugador),(NuevoTablero,NuevoJugador)) :-
    append(Arriba,[Renglón|Abajo],Tablero),
    append(Izquierda,[-|Derecha],Renglón),
    símbolo(Jugador,Símbolo),
    append(Izquierda,[Símbolo|Derecha],NuevoRenglón),
    append(Arriba,[NuevoRenglón|Abajo],NuevoTablero),
    siguiente_turno(Jugador,NuevoJugador).

% =================================================================================== %

% =================================================================================== %
%   desplegar_tablero/1. Despliega en pantalla el tablero proporcionado como
%   parámetro.

%                          desplegar_tablero(<Tablero>).

%   Verdadero si <Tablero> es una lista con el formato del tablero de Gato.

desplegar_tablero([A,B,C,D]) :-
    nl, format('~t    ~w ~t ~t ~w ~t ~t ~w ~t ~t ~w ~t ~n', [1,2,3,4]),
    format('~t  + ~t-~t - ~t-~t - ~t-~t - ~t-~t + ~n',[]),
    format('~w |~t ~w ~t|~t ~w ~t|~t ~w ~t|~t ~w ~t| ~n',['A'|A]),
    format('~t  + ~t-~t + ~t-~t + ~t-~t + ~t-~t + ~n',[]),
    format('~w |~t ~w ~t|~t ~w ~t|~t ~w ~t|~t ~w ~t| ~n',['B'|B]),
    format('~t  + ~t-~t + ~t-~t + ~t-~t + ~t-~t + ~n',[]),
    format('~w |~t ~w ~t|~t ~w ~t|~t ~w ~t|~t ~w ~t| ~n',['C'|C]),
    format('~t  + ~t-~t + ~t-~t + ~t-~t + ~t-~t + ~n',[]),
    format('~w |~t ~w ~t|~t ~w ~t|~t ~w ~t|~t ~w ~t| ~n',['D'|D]),
    format('~t  + ~t-~t - ~t-~t - ~t-~t - ~t-~t + ~n',[]), nl.

% =================================================================================== %

% =================================================================================== %
%   tablero_lleno/1. Indica si el tablero proporcionado como parámetro está lleno,
%   es decir que ya no se pueden realizar más tiros. 

%                           tablero_lleno(<Tablero>).

%   Verdadero si <Tablero> es un tablero lleno.

tablero_lleno([A,B,C,D]) :-
    \+ member(-,A),
    \+ member(-,B),
    \+ member(-,C),
    \+ member(-,D).

% =================================================================================== %
    
% =================================================================================== %
%   iguales/5. Indica los elementos pasados como parámetros son todos iguales. 

%       iguales(<Elemento_1>,<Elemento_2>,<Elemento_3>,<Elemento_4>,<Elemento_5>).

%   Verdadero si todos los elementos recibidos como parámetros son todos iguales.

iguales(J,J,J,J,J).

% =================================================================================== %

% =================================================================================== %
%   posiciones_de_victoria/2. Indica si el jugador recibido como parámetro se
%   encuentra en una posición de victoria de acuerdo a su tablero. 

%                   posiciones_de_victoria(<Jugador>,<Tablero>).

%   Verdadero si <Jugador> se encuentra en una posición de victoria de acuerdo a 
%   <Tablero>.

posiciones_de_victoria(J,[[A1,A2,A3,A4],[B1,B2,B3,B4],[C1,C2,C3,C4],[D1,D2,D3,D4]]) :-
    iguales(J,A1,A2,A3,A4);
    iguales(J,B1,B2,B3,B4);
    iguales(J,C1,C2,C3,C4);
    iguales(J,D1,D2,D3,D4);
    iguales(J,A1,B2,C3,D4);
    iguales(J,A4,B3,C2,D1);
    iguales(J,A1,B1,C1,D1);
    iguales(J,A2,B2,C2,D2);
    iguales(J,A3,B3,C3,D3);
    iguales(J,A4,B4,C4,D4).

% =================================================================================== %

% =================================================================================== %
%   posibilidad_de_victoria/2. Indica si el jugador recibido como parámetro tiene
%   posibilidad de victoria en una línea o diagonal del tablero de Gato. 

%                   posibilidad_de_victoria(<Jugador>,<Tablero>).

%   Verdadero si <Jugador> tiene posibilidad de realizar un tiro ganador en <Tablero>.

posibilidad_de_victoria(J,[[P1,P2,P3,P4],[_,_,_,_],[_,_,_,_],[_,_,_,_]]) :- 
    dif(J,O), símbolo(_,O), dif(P1,O), dif(P2,O), dif(P3,O), dif(P4,O).
posibilidad_de_victoria(J,[[_,_,_,_],[P1,P2,P3,P4],[_,_,_,_],[_,_,_,_]]) :- 
    dif(J,O), símbolo(_,O), dif(P1,O), dif(P2,O), dif(P3,O), dif(P4,O).
posibilidad_de_victoria(J,[[_,_,_,_],[_,_,_,_],[P1,P2,P3,P4],[_,_,_,_]]) :- 
    dif(J,O), símbolo(_,O), dif(P1,O), dif(P2,O), dif(P3,O), dif(P4,O).
posibilidad_de_victoria(J,[[_,_,_,_],[_,_,_,_],[_,_,_,_],[P1,P2,P3,P4]]) :- 
    dif(J,O), símbolo(_,O), dif(P1,O), dif(P2,O), dif(P3,O), dif(P4,O).
posibilidad_de_victoria(J,[[P1,_,_,_],[P2,_,_,_],[P3,_,_,_],[P4,_,_,_]]) :- 
    dif(J,O), símbolo(_,O), dif(P1,O), dif(P2,O), dif(P3,O), dif(P4,O).
posibilidad_de_victoria(J,[[_,P1,_,_],[_,P2,_,_],[_,P3,_,_],[_,P4,_,_]]) :- 
    dif(J,O), símbolo(_,O), dif(P1,O), dif(P2,O), dif(P3,O), dif(P4,O).
posibilidad_de_victoria(J,[[_,_,P1,_],[_,_,P2,_],[_,_,P3,_],[_,_,P4,_]]) :- 
    dif(J,O), símbolo(_,O), dif(P1,O), dif(P2,O), dif(P3,O), dif(P4,O).
posibilidad_de_victoria(J,[[_,_,_,P1],[_,_,_,P2],[_,_,_,P3],[_,_,_,P4]]) :- 
    dif(J,O), símbolo(_,O), dif(P1,O), dif(P2,O), dif(P3,O), dif(P4,O).
posibilidad_de_victoria(J,[[P1,_,_,_],[_,P2,_,_],[_,_,P3,_],[_,_,_,P4]]) :- 
    dif(J,O), símbolo(_,O), dif(P1,O), dif(P2,O), dif(P3,O), dif(P4,O).
posibilidad_de_victoria(J,[[_,_,_,P1],[_,_,P2,_],[_,P3,_,_],[P4,_,_,_]]) :- 
    dif(J,O), símbolo(_,O), dif(P1,O), dif(P2,O), dif(P3,O), dif(P4,O).

% =================================================================================== %

% =================================================================================== %
%   evaluación_heurística/2. Realiza la evaluación heurística de un estado para 
%   obtener su valor 

%                evaluación_heurística((<Tablero>,<Jugador>),Evaluación).

%   Verdadero si <Evaluación> corresponde al valor del estado proporcionado como
%   parámetro.

%   Debido a que el juego de Gato corresponde a un juego de suma cero, la evaluación 
%   heurística tiene la siguiente forma general:

%   Número de opciones ganadoras G menos el número de opciones perdedoras P.

%                                   f(e) = G - P.

%   En este caso al encontrar un estado en el cual el humano consiga situarse en 
%   una posición de victoria, la evaluación se asigna con el valor mínimo que puede
%   tomar MiniMax a partir de la función heurística.

evaluación_heurística((Tablero,Jugador),Evaluación) :-
    Jugador = 1,
    símbolo(1,Símbolo),
    posiciones_de_victoria(Símbolo,Tablero),
    Evaluación is -10, !.

%   En este caso al encontrar un estado en el cual el agente jugador consiga
%   situarse en una posición de victoria, la evaluación se asigna con un valor
%   superior al que puede tomar MiniMax a partir de la función heurística,
%   de esta manera prioriza esta jugada incluso si la profundidad de busqueda es
%   mayor a 1.

evaluación_heurística((Tablero,Jugador),Evaluación) :-
    Jugador = 2,
    símbolo(2,Símbolo),
    posiciones_de_victoria(Símbolo,Tablero),
    Evaluación is 10, !.

evaluación_heurística((Tablero,_),Evaluación) :-
    símbolo(2,IA),
    símbolo(1,Humano),
    findall([],posibilidad_de_victoria(IA,Tablero),Cuenta_ganadoras),
    findall([],posibilidad_de_victoria(Humano,Tablero),Cuenta_perdedoras),
    length(Cuenta_ganadoras,G),
    length(Cuenta_perdedoras,P),
    Evaluación is G - P. 

% =================================================================================== %

% =================================================================================== %
%   posibilidad_de_victoria/2. Genera una lista con todas las jugadas a las cuales
%   se pueden llegar a partir del estado inicial.

%                   listar_jugadas(<Estado>,<Jugadas>).

%   Verdadero si <Jugadas> corresponden a todas las jugadas generadas por <Estado>.

listar_jugadas(Estado,Jugadas) :-
    findall((NuevoTablero,NuevoJugador),jugada(Estado,(NuevoTablero,NuevoJugador)),Jugadas).

% =================================================================================== %

% =================================================================================== %
%   minimax/4. Realiza el algoritmo MiniMax desde un estado del juego.

%     minimax((<Tablero>,<Jugador>),<Profundidad>,<Siguiente_jugada>,<Evaluación>).

%   Verdadero si <Siguiente_jugada> a la mejor jugada a realizar a partir del estado
%   proporcionado.

%   Este caso corresponde a un estado en el cual es posible seguir descendiendo,
%   ya sea por que aún tiene posibles jugadas por realizar o por que aún estamos por
%   encima del límite de profundidad.

minimax((Tablero,Jugador),Profundidad,Siguiente_jugada,Evaluación) :-
    Profundidad > 0,
    N is Profundidad - 1,
    listar_jugadas((Tablero,Jugador),Jugadas),
    mejor_jugada(Jugadas,N,Siguiente_jugada,Evaluación),!.

%   Este caso corresponde a un estado que se encuentra en el último nivel de
%   profundidad, por lo cual se realiza la evaluación heurística del estado.

minimax(Estado,_,_,Evaluación) :-
    evaluación_heurística(Estado,Evaluación).

% =================================================================================== %

% =================================================================================== %
%   mejor_jugada/4. Determina cual es la mejor jugada a realizar entre el conjunto de 
%   jugadas generadas por el estado inicial en MiniMax.

%   mejor_jugada(<Jugadas>,<Profundidad>,<Jugada>,<Evaluación>).

%   Verdadero si <Jugada> corresponde a la mejor jugada entre la lista de <Jugadas>

%   Este predicado corresponde al caso en el cual existe únicamente una jugada en
%   la lista de jugadas, por lo cual se llama nuevamente a MiniMax para descender
%   otro nivel.

mejor_jugada([Jugada],Profundidad,Jugada,Evaluación) :-
    minimax(Jugada,Profundidad,_,Evaluación),!.

%   En este caso la lista de jugadas tiene más de un elemento y por lo tanto se 
%   deben comparar las jugadas para determinar la que da un mayor valor 
%   al realizar su evaluación.

mejor_jugada([Jugada_1|Jugadas],Profundidad,Mejor_jugada,Mejor_evaluación) :-
    minimax(Jugada_1,Profundidad,_,Evaluación_1),
    mejor_jugada(Jugadas,Profundidad,Jugada_2,Evaluación_2),
    mejor_entre(Jugada_1,Evaluación_1,Jugada_2,Evaluación_2,Mejor_jugada,Mejor_evaluación).

% =================================================================================== %

% =================================================================================== %
%   mejor_entre/6. Determina la mejor jugada entre un par de jugadas a partir de su
%   valor obtenido en la evaluación heurística.

%   mejor_entre(<Jugada_1>,<Evaluación_1>,<Jugada_2>,<Evaluación_2>,<Mejor_jugada>,<Mejor_evaluación>).

%   Verdadero si <Mejor_jugada> corresponde a la mejor jugada entre las dos
%   jugadas proporcionadas.

%   Este predicado corresponde al caso en el cual por medio del algoritmo MiniMax se maximizará o 
%   minimizará la ganancia de acuerdo al nivel que se esté analizando.

mejor_entre(Jugada_1,Evaluación_1,_,Evaluación_2,Jugada_1,Evaluación_1) :-
    Jugada_1 = (_,Jugador),
    (min(Jugador),
    Evaluación_1 >= Evaluación_2, ! ;
    max(Jugador),
    Evaluación_1 =< Evaluación_2, !).

mejor_entre(_,_,Jugada,Evaluación,Jugada,Evaluación).

% =================================================================================== %

% =================================================================================== %
%   tiro/5. Genera un tablero a partir de la fila y columna que selecciona un jugador
%   al realizar una jugada (tiro) en el juego de Gato.

%   mejor_entre((<Tablero>,<Jugador>),<Fila>,<Columna>,<Tablero>).

%   Verdadero si <Tablero> corresponde al tablero generado a partir del tiro realizado
%   en la fila y columna especificada. 

tiro(([A,B,C,D],Jugador),'A',Columna,[Fila_nueva,B,C,D]) :-
    símbolo(Jugador,Símbolo),
    append(Lista_1,[_|Lista_2],A),
    Índice is Columna - 1,
    length(Lista_1,Índice),
    append(Lista_1,[Símbolo|Lista_2],Fila_nueva).

tiro(([A,B,C,D],Jugador),'B',Columna,[A,Fila_nueva,C,D]) :-
    símbolo(Jugador,Símbolo),
    append(Lista_1,[_|Lista_2],B),
    Índice is Columna - 1,
    length(Lista_1,Índice),
    append(Lista_1,[Símbolo|Lista_2],Fila_nueva).
        
tiro(([A,B,C,D],Jugador),'C',Columna,[A,B,Fila_nueva,D]) :-
    símbolo(Jugador,Símbolo),
    append(Lista_1,[_|Lista_2],C),
    Índice is Columna - 1,
    length(Lista_1,Índice),
    append(Lista_1,[Símbolo|Lista_2],Fila_nueva).

tiro(([A,B,C,D],Jugador),'D',Columna,[A,B,C,Fila_nueva]) :-
    símbolo(Jugador,Símbolo),
    append(Lista_1,[_|Lista_2],D),
    Índice is Columna - 1,
    length(Lista_1,Índice),
    append(Lista_1,[Símbolo|Lista_2],Fila_nueva).

% =================================================================================== %

% =================================================================================== %
%   jugar/1. Inicia un juego de Gato de Humano vs IA (Utilizando MiniMax con límite 
%   de profundidad de busqueda).

%                               jugar(<Profundidad>).

jugar(Profundidad) :- 
    Tablero_inicial = [[-,-,-,-],[-,-,-,-],[-,-,-,-],[-,-,-,-]],
    desplegar_tablero(Tablero_inicial),
    jugar((Tablero_inicial,1),Profundidad).

% =================================================================================== %

% =================================================================================== %
%   jugar/2. Se encarga de alternar entre los turnos del jugador humano y la IA, por
%   lo cual en un caso se solicitan los datos por consola para el usuario y en el otro
%   se realiza la selección de la jugada a realizar por medio de MiniMax. 

%                  jugar((<Tablero_inicial>,<Jugador>),<Profundidad>).

jugar((Tablero_inicial,1),Profundidad) :-
    write('Es tú turno!'), nl,
    write('Ingresa tu tiro [Fila,Columna]: '), nl,
    read(Tiro),
    Tiro = [Fila,Columna],
    tiro((Tablero_inicial,1),Fila,Columna,Tablero_nuevo),
    listar_jugadas((Tablero_inicial,1),Jugadas),
    member((Tablero_nuevo,2), Jugadas),
    desplegar_tablero(Tablero_nuevo),
    ((símbolo(1,Jugador), posiciones_de_victoria(Jugador,Tablero_nuevo), write('Has ganado!'), !)
    ; (tablero_lleno(Tablero_nuevo), write('La partida ha quedado en empate!'), !)
    ; (write('Presiona una tecla para continuar...'), read(_), jugar((Tablero_nuevo,2),Profundidad),!)).    

jugar((Tablero_inicial,1),Profundidad) :-
    write('El tiro realizado no está permitido, ingresa un nuevo tiro'), nl,
    jugar((Tablero_inicial, 1),Profundidad).

jugar((Tablero_inicial,2),Profundidad) :-
    write('Turno de la IA'), nl,
    minimax((Tablero_inicial,2),Profundidad,(Tablero_nuevo,Siguiente_jugador),_),
    desplegar_tablero(Tablero_nuevo),
    ((símbolo(2,Jugador), posiciones_de_victoria(Jugador,Tablero_nuevo), write('Ha ganado la IA!'), !)
    ; (tablero_lleno(Tablero_nuevo), write('La partida ha quedado en empate!'), !)
    ; (jugar((Tablero_nuevo,Siguiente_jugador),Profundidad))).
    
% =================================================================================== %