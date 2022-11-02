% =================================================================================== %
%
%   Alberto Palacios Cabrera
%	
%   Misioneros y caníbales
%
%   - Programa para resolver el problema de Misioneros y caníbales
%
%   - El programa puede entregar la solución al problema, buscando en tres órdenes
%   diferentes: profundo, ancho y profundización iterativa.
%
%   PROBLEMA DE LOS MISIONEROS Y CANÍBALES:
%
%   3 misioneros y 3 caníbales deben cruzar un río.
%           
%   La barca diponible sólo tiene capacidad para 2 ocupantes incluyendo el remero y,
%   tanto misioneros como caníbales pueden remar...
%           
%   En ningún momento deben encontrarse, en orilla alguna, más caníbales que misioneros
%   (para evitar que ocurra canibalismo).        
%
%   REPRESENTACIÓN DE ESTADOS:
%
%                    |o.o|o.d|b| **
%   Estado Inicial = [3,3,0,0,o]
%
%                 |o.o|o.d|b| **
%   Estado Meta = [0,0,3,3,d]
%
%   ** o.o = orilla origen, o.d = orilla destino, b = barca
%       
%	  Predicados relevantes:
%
%   movimiento(<estado inicio>,<estado destino>)
%   busca_DFS(<estado inicial>,<estado meta>,<plan>)
%   busca_BFS(<estado inicial>,<estado meta>,<plan>)
%   busca_IDS(<estado inicial>,<estado meta>,<plan>)
%   despliega(<plan>)
%   
% =================================================================================== %

% =================================================================================== %
%   edo_válido/1. Determina si un estado es válido de acuerdo a las restricciones
%   planteadas en el problema. 

%                           edo_válido(<estado>).

%   Verdadero si <estado> es un estado válido. Para que el estado sea válido, se
%   requiere que en ambas orillas, exista igual o mayor número de misioneros que de
%   caníbales, o bien, que el número de caníbales sea cero. 

edo_válido([Mis1,Can1,Mis2,Can2]) :-
    Mis1 >= 0, Can1 >= 0,
    Mis2 >= 0, Can2 >= 0,
    (Mis1 >= Can1 ; Mis1 is 0),
    (Mis2 >= Can2 ; Mis2 is 0).

% =================================================================================== %

% =================================================================================== %
%   movimiento/2. A partir de un estado proporcionado determina un estado destino que
%   cumpla con la condición de ser un estado válido. 

%                     movimiento(<estado inicio>,<estado destino>).

%   Verdadero si existe un <estado inicio> tal que al aplicar un movimiento se pueda 
%   llegar a <estado destino> que sea válido.

movimiento([MO,CO,MD,CD,L1],[MO2,CO2,MD2,CD2,L2]) :-
    % Un misionero
    ( (MO2 is MO - 1, CO2 is CO, MD2 is MD + 1, CD2 is CD, L1 = 'o', L2 = 'd');
      (MO2 is MO + 1, CO2 is CO, MD2 is MD - 1, CD2 is CD, L1 = 'd', L2 = 'o');

    % Dos misioneros
      (MO2 is MO - 2, CO2 is CO, MD2 is MD + 2, CD2 is CD, L1 = 'o', L2 = 'd');
      (MO2 is MO + 2, CO2 is CO, MD2 is MD - 2, CD2 is CD, L1 = 'd', L2 = 'o');

    % Misionero y caníbal
      (MO2 is MO - 1, CO2 is CO - 1, MD2 is MD + 1, CD2 is CD + 1, L1 = 'o', L2 = 'd');
      (MO2 is MO + 1, CO2 is CO + 1, MD2 is MD - 1, CD2 is CD - 1, L1 = 'd', L2 = 'o');

    % Un caníbal
      (MO2 is MO, CO2 is CO - 1, MD2 is MD, CD2 is CD + 1, L1 = 'o', L2 = 'd');
      (MO2 is MO, CO2 is CO + 1, MD2 is MD, CD2 is CD - 1, L1 = 'd', L2 = 'o');
    
    % Dos caníbales
      (MO2 is MO, CO2 is CO - 2, MD2 is MD, CD2 is CD + 2, L1 = 'o', L2 = 'd');
      (MO2 is MO, CO2 is CO + 2, MD2 is MD, CD2 is CD - 2, L1 = 'd', L2 = 'o') ),
    
    edo_válido([MO2,CO2,MD2,CD2]).

% =================================================================================== %

% =================================================================================== %
%   sucesores/2. Predicado que permite conocer los sucesores de un estado. Es decir,
%   realiza la expansión de un estado. 

%                     sucesores(<estado>,<sucesores>).

%   Verdadero si <sucesores> es una lista con los sucesores del estado proporcionado.

sucesores([Edo|Resto], Sucesores) :-
    findall([S,Edo|Resto], (movimiento(Edo,S), \+member(S,[Edo|Resto])),Sucesores).

% =================================================================================== %

% =================================================================================== %
%   busca_BFS/3. Predicado que entrega el plan de recorrido de un estado inicial a
%   un estado inicio ocupando la busqueda en anchura. 

%                  busca_BFS(<estado inicial>,<estado meta>,<plan>).

%   Verdadero si <plan> es una lista con los estados requeridos para llegar del
%   <estado inicial> al <estado meta>.
%
%   NOTA: El predicado hace uso de reverse/2 debido a que bfs/3 devuelve una lista
%   con el plan pero en orden inverso.

busca_BFS(Ei,Em,Plan) :- 
    bfs(Em,[[Ei]],Ruta),
    reverse(Ruta,Plan).

% =================================================================================== %

% =================================================================================== %
%   bfs/3. Predicado que realiza la busqueda ordenada por anchura para la
%   solución del problema planteado. 

%                  bfs(<estado inicial>,<agenda>,<ruta>).

%   Verdadero si <ruta> es una lista con los estados requeridos para llegar del
%   <estado inicial> al estado meta con el cual inicia la agenda.
%   
%   NOTA: Al se una busqueda ordenada BFS la agenda con la cual se realiza el
%   recorrido hace uso de una estructura de tipo Cola (FIFO).

bfs(Meta,[[Meta|Trayecto]|_],[Meta|Trayecto]).
bfs(Meta,[Candidato|Frontera],Ruta) :-
    sucesores(Candidato,Suc),
    append(Frontera,Suc,NuevaAgenda),
    bfs(Meta,NuevaAgenda,Ruta).

% =================================================================================== %

% =================================================================================== %
%   busca_DFS/3. Predicado que entrega el plan de recorrido de un estado inicial a
%   un estado inicio ocupando la busqueda en profundidad. 

%                  busca_DFS(<estado inicial>,<estado meta>,<plan>).

%   Verdadero si <plan> es una lista con los estados requeridos para llegar del
%   <estado inicial> al <estado meta>.
%
%   NOTA: El predicado hace uso de reverse/2 debido a que dfs/3 devuelve una lista
%   con el plan pero en orden inverso.

busca_DFS(Ei,Em,Plan) :- 
    dfs(Em,[[Ei]],Ruta),
    reverse(Ruta,Plan).

% =================================================================================== %

% =================================================================================== %
%   dfs/3. Predicado que realiza la busqueda ordenada en profundidad para la
%   solución del problema planteado. 

%                  dfs(<estado inicial>,<agenda>,<ruta>).

%   Verdadero si <ruta> es una lista con los estados requeridos para llegar del
%   <estado inicial> al estado meta con el cual inicia la agenda.
%   
%   NOTA: Al se una busqueda ordenada BFS la agenda con la cual se realiza el
%   recorrido hace uso de una estructura de tipo Pila (LIFO).

dfs(Meta,[[Meta|Trayecto]|_],[Meta|Trayecto]).
dfs(Meta,[Candidato|Frontera],Ruta) :-
  sucesores(Candidato,Suc),
  append(Suc,Frontera,NuevaAgenda),
  dfs(Meta,NuevaAgenda,Ruta).

% =================================================================================== %

% =================================================================================== %
%   Definición del predicado edo_meta/1 como tipo dinámico. De esta forma podrá ser 
%   removido en tiempo de ejecución por medio del predicado retractall/1 y también
%   para agregarlos con assert/1.
%
%   El predicado edo_meta/1 se utiliza para almacenar el estado meta durante la
%   busqueda en profundidad iterativa (IDS)

:- dynamic(edo_meta/1).

% =================================================================================== %

% =================================================================================== %
%   busca_IDS/3. Predicado que entrega el plan de recorrido de un estado inicial a
%   un estado inicio ocupando la busqueda en profundidad iterativa. 

%                  busca_IDS(<estado inicial>,<estado meta>,<plan>).

%   Verdadero si <plan> es una lista con los estados requeridos para llegar del
%   <estado inicial> al <estado meta>.
%
%   NOTA: El predicado hace uso de reverse/2 debido a que dfs/2 devuelve una lista
%   con el plan pero en orden inverso.

busca_IDS(Ei,Em,Plan) :-
    retractall(edo_meta(_)),
    assert(edo_meta(Em)),
    dfs([[Ei]],Ruta),
    reverse(Ruta,Plan).

% =================================================================================== %

% =================================================================================== %
%   dfs/2. Predicado que realiza la busqueda ordenada en profundidad iterativa para 
%   la solución del problema planteado. 

%                  dfs(<agenda>,<ruta>).

%   Verdadero si <ruta> es una lista con los estados requeridos para llegar del
%   estado inicial, con el cual inicia la agenda,al estado meta.
%   
%   NOTA 1: Al se una busqueda ordenada BFS la agenda con la cual se realiza el
%   recorrido hace uso de una estructura de tipo Pila (LIFO).
%   NOTA 2: El estado meta no se incluye de manera inicial a la agenda sino que se
%   obtiene a partir de la consulta al predicado dinámico edo_meta/1

dfs([[Meta|Trayecto]|_],[Meta|Trayecto]) :- edo_meta(Meta).
dfs([Candidato|Frontera],Ruta) :-
    sucesores(Candidato,Suc),
    append(Suc,Frontera,NuevaAgenda),
    dfs(NuevaAgenda,Ruta).

% =================================================================================== %

% =================================================================================== %
%   movimiento/3. A partir de un estado proporcionado determina un estado destino que
%   cumpla con la condición de ser un estado válido. Además, indica por medio de una
%   cadena de texto el tipo de movimiento que se está realizando. 

%               movimiento(<estado inicio>,<estado destino>,<movimiento>).

%   Verdadero si existe un <estado inicio> tal que al aplicar un movimiento se pueda 
%   llegar a <estado destino> que sea válido.

despliega_movimiento([MO,CO,MD,CD,L1],[MO2,CO2,MD2,CD2,L2],Movimiento) :-
  % Un misionero
  ( ((MO2 is MO - 1, CO2 is CO, MD2 is MD + 1, CD2 is CD, L1 = 'o', L2 = 'd'),Movimiento = 'aplicando UN-MISIONERO');
    ((MO2 is MO + 1, CO2 is CO, MD2 is MD - 1, CD2 is CD, L1 = 'd', L2 = 'o'),Movimiento = 'aplicando UN-MISIONERO');

  % Dos misioneros
    ((MO2 is MO - 2, CO2 is CO, MD2 is MD + 2, CD2 is CD, L1 = 'o', L2 = 'd'),Movimiento = 'aplicando DOS-MISIONEROS');
    ((MO2 is MO + 2, CO2 is CO, MD2 is MD - 2, CD2 is CD, L1 = 'd', L2 = 'o'),Movimiento = 'aplicando DOS-MISIONEROS');

  % Misionero y caníbal
    ((MO2 is MO - 1, CO2 is CO - 1, MD2 is MD + 1, CD2 is CD + 1, L1 = 'o', L2 = 'd'),Movimiento = 'aplicando MISIONERO-Y-CANÍBAL');
    ((MO2 is MO + 1, CO2 is CO + 1, MD2 is MD - 1, CD2 is CD - 1, L1 = 'd', L2 = 'o'),Movimiento = 'aplicando MISIONERO-Y-CANÍBAL');

  % Un caníbal
    ((MO2 is MO, CO2 is CO - 1, MD2 is MD, CD2 is CD + 1, L1 = 'o', L2 = 'd'),Movimiento = 'aplicando UN-CANÍBAL');
    ((MO2 is MO, CO2 is CO + 1, MD2 is MD, CD2 is CD - 1, L1 = 'd', L2 = 'o'),Movimiento = 'aplicando UN-CANÍBAL');
  
  % Dos caníbales
    ((MO2 is MO, CO2 is CO - 2, MD2 is MD, CD2 is CD + 2, L1 = 'o', L2 = 'd'),Movimiento = 'aplicando DOS-CANÍBALES');
    ((MO2 is MO, CO2 is CO + 2, MD2 is MD, CD2 is CD - 2, L1 = 'd', L2 = 'o'),Movimiento = 'aplicando DOS-CANÍBALES')),
  
  edo_válido([MO2,CO2,MD2,CD2]).

% =================================================================================== %

% =================================================================================== %
%   recorrer_pasos/2. A partir de una lista de estados determina cuales fueron los 
%   movimientos realizados en cada transición de estados. Muestra la información 
%   en la consola.

%               recorrer_pasos(<plan>,<número de movimiento>).

%   Verdadero si existe un <plan> corresponde a una lista de estados válidos.

recorrer_pasos([Origen,Destino],N) :-
  Destino = [MO,CO,MD,CD,L1],
  ((L1 = o, Barca_origen is 1, Barca_destino is 0) ; (L1 = d, Barca_origen is 0, Barca_destino is 1)),
  despliega_movimiento(Origen,Destino,Movimiento),
  format('(~w)~t aplicando ~w~t se llega a ((~w ~w ~w) (~w ~w ~w))\n', [N,Movimiento,MO,CO,Barca_origen,MD,CD,Barca_destino]),!.

recorrer_pasos([Origen,Destino|Resto],N) :-
  Destino \= [],
  Resto \= [],
  Destino = [MO,CO,MD,CD,L1],
  ((L1 = o, Barca_origen is 1, Barca_destino is 0) ; (L1 = d, Barca_origen is 0, Barca_destino is 1)),
  despliega_movimiento(Origen,Destino,Movimiento),
  format('(~w)~t aplicando ~w~t se llega a ((~w ~w ~w) (~w ~w ~w))\n', [N,Movimiento,MO,CO,Barca_origen,MD,CD,Barca_destino]),
  M is N + 1,
  recorrer_pasos([Destino|Resto],M).    

% =================================================================================== %

% =================================================================================== %
%   despliega/1. Predicado que permite visualizar en consola la solución al problema
%   de los misioneros y caníbales de manera detallada. Se hace uso de la busqueda en 
%   profundidad para que sea realizada de manera óptima.

%               despliega(<plan>).

%   Verdadero si <plan> es una lista con los estados requeridos para dar solución al 
%   problema de los misioneros y caníbales.

despliega(Plan) :-
  busca_BFS([3,3,0,0,o],[0,0,3,3,d],Plan),
  length(Plan, Tamaño),
  Num_Pasos is Tamaño - 1,
  Plan = [Inicio|_],
  Inicio = [MO,CO,MD,CD,L1],
  format('\nÉxito. Solución con ~w pasos:\n', [Num_Pasos]),
  ((L1 = o, Barca_origen is 1, Barca_destino is 0) ; (L1 = d, Barca_origen is 0, Barca_destino is 1)),
  format('Inicio en: (~w ~w ~w) (~w ~w ~w)\n', [MO,CO,Barca_origen,MD,CD,Barca_destino]),
  recorrer_pasos(Plan,1).

% =================================================================================== %

% =================================================================================== %
%   imprimir_lista/1. Imprime cada elemento contenido en la 
%	lista proporcionada.
%
%                   imprimir_lista(<Lista>).
%
%	NOTA: Este predicado solo es utilizado con propósitos de pruebas.

imprimir_lista([]) :- nl.
imprimir_lista([X|Resto]) :- 
	write(X),
	write(' '),
	nl,
	imprimir_lista(Resto).

% =================================================================================== %