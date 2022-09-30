% =================================================================================== %
%
%   Alberto Palacios Cabrera
%	
%	Tarea #2. Paquete de ejercicios Prolog
%
%	- Construya predicados Prolog, etiquetados como se indica en cada problema el
%   enunciado del mismo. Puede usar más de un predicado para cada problema.
%	
%	Predicados relevantes:
%
%       contiene_número(<lista>).
%       inserta_ceros(<lista>,<respuesta>).
%       rota(<lista>,<n>,<respuesta>).
%       reversa_simple(<lista>,<respuesta>).
%       inserta0_en(<término>,<lista>,<posición>,<resultado>).
%       promedio_parcial(<lista>,<n>,<resultado>).
%       fibonacci(<n>,<resultado>).
%       simplifica(<lista>,<resultado>).
%       depura(<lista>,<resultado>).
%       máximo(<lista>,<resultado>).
%       anti_consonante(<lista>,<resultado>).
%       vocales(<lista>,<resultado>).
%       cada_dos(<lista>,<resultado>).
%       contexto(<lista>,<elemento>,<resultado>).
%       particiona(<lista>,<pos1>,<lista1>,<lista2>).
%
% =================================================================================== %

% =================================================================================== %
% 1) [] contiene_número/1. Verificar si una lista contiene algún elemento númerico.
%
%                   contiene_número(<lista>).
%
% Verdadero si <lista> es una lista que contiene algún elemento númerico**,
% falso en cualquier otro caso.
%
% **El valor númerico puede ser entero o cualquier elemento perteneciente a los reales

contiene_número([X|_]) :-
    number(X),!.

contiene_número([_|Resto]) :-
    contiene_número(Resto).

% =================================================================================== %

% =================================================================================== %
% 2) [] inserta_ceros/2. Intercalar ceros después de cada elemento original.
%
%                   inserta_ceros(<lista>,<respuesta>).
%
% Verdadero si <respuesta> es una lista con los mismos elementos que <lista>,
% pero con un cero agregado después de cada elemento original.
% La lista vacía debe conservarse.

inserta_ceros([],[]).

inserta_ceros([X|Resto],[X,0|Respuesta]) :-
    inserta_ceros(Resto,Respuesta).

% =================================================================================== %

% =================================================================================== %
% 3) [sin usar append] rota/3. Rotar los elementos de una lista algún número
% de posiciones hacia la derecha.

%                   rota(<lista>,<n>,<respuesta>).

% Verdadero si <respuesta> es una lista con los mismos elementos que <lista>,
% pero rotados hacia la derecha <n> posiciones.

rota(Lista,0,Lista) :- !.

rota(Lista, N, Respuesta) :-
    N > 0,
    desplazar_1(Lista,ListaNueva),
    M is N - 1,
    rota(ListaNueva,M,Respuesta).

% desplazar_1/2. Toma una lista y desplaza 1 posición a la derecha cada elemento 
% que la conforma.

%                   desplaza_1(<lista>,<respuesta>).

desplazar_1(Lista, [Resto|Inicio]):- 
    concatenar(Inicio,[Resto], Lista).

% concatenar/3. Concatena dos listas para generar una nueva lista conformada por
% los elementos que conforman a las listas originales.

%                   concatenar(<lista_1>,<lista_2>,<respuesta>).

concatenar([],Lista,Lista) :- !.

concatenar([Inicio|Resto],Lista2,[Inicio|Lista3]):- concatenar(Resto,Lista2,Lista3).

% =================================================================================== %

% =================================================================================== %
% 4) [sin usar reverse, ni append] reversa_simple/2. Invertir una lista.

%                   reversa_simple(<lista>,<respuesta>).

% Verdadero si <respuesta> es la inversión de primer nivel de <lista>.

reversa_simple([],[]).

reversa_simple([X|Resto],Respuesta) :-
    reversa_simple(Resto,Lista),
    concatenar(Lista,[X],Respuesta).

% =================================================================================== %

% =================================================================================== %
% 5) [sin usar select] inserta0_en/4. Insertar un término arbitrario en
% alguna posición específica de una lista.

%                   inserta0_en(<término>,<lista>,<posición>,<resultado>).

% Verdadero si <resultado> es una lista con los mismos elementos que <lista>
% pero con <término> insertado en la <posición>, considerando el inicio de la
% lista como la posición 0. 

inserta0_en(Término,Lista,0,Respuesta) :-
    append([Término],Lista,Respuesta), !.

inserta0_en(Término,[X|Resto],Posición,[X|Respuesta]) :-
    Posición > 0,
    N is Posición - 1,
    inserta0_en(Término,Resto,N,Respuesta).

% =================================================================================== %

% =================================================================================== %
% 6) [] promedio_parcial/3. Calcular el promedio (media aritmética) de los
% primeros n elementosResultado de un a lista

%                   promedio_parcial(<lista>,<n>,<resultado>).

% Verdadero si <resultado> es un número que representa el promedio de los
% primeros <n> elementos numéricos de <lista> (que puede tener otros
% elementos no-numéricos).

promedio_parcial(Lista,N,Resultado) :-
    obtener_números(Lista,Números),
    suma_n(Números,N,Suma),
    Resultado is Suma rdiv N.

% obtener_números/2. Toma una lista y genera una nueva lista que contiene únicamente
% los elementos númericos de la lista original.

%                   desplaza_1(<lista>,<resultado>).

obtener_números([],[]).

obtener_números([X|Resto],[X|Lista]) :-
    number(X),
    obtener_números(Resto,Lista), !.

obtener_números([X|Resto],Lista) :-
    \+ number(X),
    obtener_números(Resto,Lista).

% suma/3. Realiza la suma de los primeros N elementos de la lista.
%
% NOTA: La lista que recibe como parámetro debe incluir únicamente elementos númericos.

%                   suma(<lista>,<N>,<resultado>).

suma([],_,0) :- !.
suma_n(_,0,0) :- !.

suma_n([X|Resto],N,Resultado) :-
    N > 0,
    number(X),
    M is N - 1,
    suma_n(Resto,M,Suma),
    Resultado is X + Suma.

% =================================================================================== %

% =================================================================================== %
% 7) [sin cortes] fibonacci/2. Calcular cada término en la serie de Fibonacci.

%                   fibonacci(<n>,<resultado>).

% Verdadero si <resultado> es el número Fibonacci correspondiente a <n>.
%
% NOTA: El orden de la base de conocimiento permite que al encontrar el primer
% resultado a la consulta el motor de inferencia no continúe buscando respuestas.

fibonacci(N,Resultado) :-
    N > 1,
    Índice_1 is N - 1,
    Índice_2 is N - 2,
    fibonacci(Índice_1,Número_1),
    fibonacci(Índice_2,Número_2),
    Resultado is Número_1 + Número_2. 

fibonacci(0,0).
fibonacci(1,1).

% =================================================================================== %

% =================================================================================== %
% 8) [sin usar sort ni list_to_set, ni list_to_otd_set] simplifica/2.
% Eliminar de una lista todos los elementos que se encuentren duplicados.

%                   simplifica(<lista>,<resultado>).

% Verdadero si <resultado> es una lista con los mismos elementos que <lista> pero con
% sólo una instancia de cada elemento. 

simplifica([],[]).

simplifica([X|Resto],[X|Lista]):-
    \+ member(X,Resto),
    simplifica(Resto,Lista), !.

simplifica([X|Resto],Lista):-
    member(X,Resto),
    simplifica(Resto,Lista), !.
    
% =================================================================================== %

% =================================================================================== %
% 9) [] depura/2. Eliminar de una lista todos los elementos que NO se encuentren duplicados,
% cuando menos, una vez.

%                   depura(<lista>,<resultado>).

% Verdadero si <resultado> es una lista contenido sólo una instancia de cada elemento
% en <lista> que sí tenía repeticiones.

depura([],[]).

depura([X|Resto],[X|Lista]):-
    member(X,Resto),
    depura(Resto,Lista), !.

depura([X|Resto],Lista):-
    \+ member(X,Resto),
    depura(Resto,Lista), !.

% =================================================================================== %

% =================================================================================== %
% 10) [] máximo/2. Identificar el mayor valor de entre aquellos contenidos en una lista.

%                   máximo(<lista>,<resultado>).

% Verdadero si <resultado> es el mayor valor númerico contenido en <lista>.
% No todods los elementos necesitan ser numéricos.

máximo(Lista,Resultado) :-
    obtener_números(Lista,Números),
    obtener_máximo(Números,Resultado).

% obtener_máximo/2. Obtiene el valor númerico máximo de la lista recibida como
% parámetro.

% NOTA: La lista que recibe como parámetro debe incluir únicamente elementos númericos.

%                   desplaza_1(<lista>,<resultado>).

obtener_máximo([],0).

obtener_máximo([X|Resto],Resultado) :-
    obtener_máximo(Resto,Valor),
    X >= Valor,
    Resultado is X, !.

obtener_máximo([X|Resto],Resultado) :-
    obtener_máximo(Resto,Valor),
    X < Valor,
    Resultado is Valor, !.

% =================================================================================== %

% =================================================================================== %
% 11) [] anti_consonante/2. Elimina de una lista todos los elementos que sean
% consonantes o que tengan longitud mayor a una letra.

%                   anti_consonante(<lista>,<resultado>).

% Verdadero si <resultado> es una lista con los mismos elementos que <lista> excepto
% aquellos elementos que sean consonantes del abecedario.

anti_consonante([],[]).

anti_consonante([X|Resto],[X|Resultado]) :-
    member(X,[a,e,i,o,u]),
    anti_consonante(Resto,Resultado), !.

anti_consonante([X|Resto],Resultado) :-
    \+ member(X,[a,e,i,o,u]),
    anti_consonante(Resto,Resultado), !.

% =================================================================================== %

% =================================================================================== %
% 12) [] vocales/2. Selecciona los elementos que sean vocales dentro de una lista
% , pero representados como mayúsculas.

%                   vocales(<lista>,<resultado>).

% Verdadero si <resultado> es una lista conteniendo exculisvamente los elementos de
% <lista> que son vocales, en el mismo orden y número que en la lista original, pero 
% representadas como mayúsculas.

vocales([],[]).

vocales([X|Resto],[Mayúscula|Resultado]) :-
    member(X,[a,e,i,o,u]),
    upcase_atom(X, Mayúscula),
    vocales(Resto,Resultado), !.

vocales([X|Resto],Resultado) :-
    \+ member(X,[a,e,i,o,u]),
    vocales(Resto,Resultado), !.

% =================================================================================== %

% =================================================================================== %
% 13) [] cada_dos/2. Selecciona los elementos intercalados de la lista original a
% partir del tercer elemento.

%                   cada_dos(<lista>,<resultado>).

% Verdadero si <resultado> es una lista conteniendo exculisvamente los elementos
% intercalados de uno en uno, a partir del tercer elemento en <lista>.

cada_dos([],[]).

cada_dos(Lista,Resultado) :-
    length(Lista, Tamaño),
    intercalar_lista(Lista,0,Tamaño,Resultado), !.

% intercalar_lista/4. Genera una lista nueva con los elementos intercalados de dos
% en dos dentro de la lista original.

% NOTA: Se aprovecha la operación módulo para encontrar los índices deseados
% de la lista.

%                   intercalar_lista(<lista>,<índice>,<tamaño>,<resultado>).

intercalar_lista([],_,_,[]).

intercalar_lista([_|Resto],0,Tamaño,Resultado) :-
    intercalar_lista(Resto,1,Tamaño,Resultado).

intercalar_lista([X|Resto],Índice,Tamaño,[X|Resultado]) :-
    Tamaño > 0,
    Índice > 0,
    Índice < Tamaño,
    Índice mod 2 =:= 0,
    N is Índice + 1,
    intercalar_lista(Resto,N,Tamaño,Resultado).

intercalar_lista([_|Resto],Índice,Tamaño,Resultado) :-
    Tamaño > 0,
    Índice > 0,
    Índice < Tamaño,
    Índice mod 2 =\= 0,
    N is Índice + 1,
    intercalar_lista(Resto,N,Tamaño,Resultado).

% =================================================================================== %

% =================================================================================== %
% 14) [] contexto/3. Identifica los elementos contexto de una posición indicada
% en una lista.

%                   contexto(<lista>,<elemento>,<resultado>).

% Verdadero si <resultado> es una lista conteniendo exculisvamente el elemento
% anterior y el posterior, en la lista original, de cada instancia de <elemento>.

contexto([],_,[]).

contexto(Lista,Elemento,Respuesta) :-
    nth1(Índice_elemento,Lista,Elemento),
    Índice_1 is Índice_elemento - 1,
    Índice_2 is Índice_elemento + 1,
    length(Lista,Tamaño),
    encontrar_contexto(Lista,Índice_1,Índice_2,Tamaño,Respuesta), !.

% encontrar_contexto/5. Encuentra el contexto de un elemento a partir de los índices
% de los elementos adyacentes al mismo, validando las limitaciones del tamaño de 
% la lista.

%       encontrar_contexto(<lista>,<índice_1>,<índice_2>,<tamaño>,<resultado>).

encontrar_contexto(Lista,Índice_1,Índice_2,Tamaño,[Elemento_1,Elemento_2]) :-
    Índice_1 >= 1,
    Índice_2 =< Tamaño,
    nth1(Índice_1,Lista,Elemento_1),
    nth1(Índice_2,Lista,Elemento_2).

encontrar_contexto(Lista,Índice_1,Índice_2,Tamaño,[[],Elemento_2]) :-
    Índice_1 < 1,
    Índice_2 =< Tamaño,
    nth1(Índice_2,Lista,Elemento_2).

encontrar_contexto(Lista,Índice_1,Índice_2,Tamaño,[Elemento_1,[]]) :-
    Índice_1 >= 1,
    Índice_2 > Tamaño,
    nth1(Índice_1,Lista,Elemento_1).

encontrar_contexto(_,Índice_1,Índice_2,Tamaño,[[],[]]) :-
    Índice_1 < 1,
    Índice_2 > Tamaño.

% =================================================================================== %

% =================================================================================== %
% 15) [] particiona/3. Parte una lista en dos listas a partir de alguna posición en
% la lista inicial.

%                   particiona(<lista>,<pos1>,<lista1>,<lista2>).

% Verdadero si <lista1> y <lista2> son listas cconteniendo los mismos elementos de
% <lista> separados a partir de la posición <pos1> considerando el primer elemento
% como en la posición 1.           

particiona([],_,_,_) :- !, fail.

particiona(Lista,Posición_1,Lista_1,Lista_2) :-
    Índice is Posición_1 - 1,
    length(Lista_1,Índice),
    append(Lista_1,Lista_2,Lista).

% =================================================================================== %