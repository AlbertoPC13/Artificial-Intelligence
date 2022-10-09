% =================================================================================== %
%
%   Alberto Palacios Cabrera
%	
%	Tarea #3. Problemas tipo cebra
%
%   - Versión 3: 4 casas con 4 atributos y 9 pistas
%       1) Hay dos casas entre la del bolichista y la del nadador
%       2) Hay una casa entre la del irlandés y la del que juega voleyball
%       3) La segunda casa es negra	
%       4) Hay una casa entre la del dueño de caballos y la casa roja
%       5) Un escocés vive junto al dueño de tortugas
%       6) Hay dos casas entre la del dueño de caballos y la casa del 
%       dueño de mariposas
%       7) El bolichista vive en algún lugar posterior a la casa del tenista
%       8) Hay una casa entre la del que juega voleyball y la casa blanca
%       9) Un ruso vive en la primera casa
%
%   - La única pregunta es la descripción completa del vecindario
%
%   - Especificar un predicado visualiza_vecindario(<var>) para la solución
%   de cada problema
%	
%	Predicados relevantes:
%
%   vecindario(<Lista>).
%   junto(<Casa 1>,<Casa 2>,<Lista>).
%   intermedia(<Casa 1>,<Casa 2>,<Lista>).
%   entre_2(<Casa 1>,<Casa 2>,<Lista>).
%   visualiza_vecindario(<Lista>).
%   
% =================================================================================== %

% =================================================================================== %
%   junto/3. Indica si las casas recibidas como parámtero se encuentran juntas en 
%   la lista proporcionada.

%                   junto(<Casa 1>,<Casa 2>,<Lista>).

%   Verdadero si <Lista> es una lista con los elementos <Casa 1> y <Casa 2> juntos
% =================================================================================== %

junto(Casa_1,Casa_2,Lista) :- append(_,[Casa_1,Casa_2|_],Lista).
junto(Casa_1,Casa_2,Lista) :- append(_,[Casa_2,Casa_1|_],Lista).

% =================================================================================== %
%   intermedia/3. Indica si las casas recibidas como parámtero se encuentran  
%   separadas por una casa en la lista proporcionada.

%                   intermedia(<Casa 1>,<Casa 2>,<Lista>).

%   Verdadero si <Lista> es una lista con los elementos <Casa 1> y <Casa 2>
%   separados por una posición.
% =================================================================================== %

intermedia(Casa_1,Casa_2,Lista) :- append(_,[Casa_1,_,Casa_2|_],Lista).
intermedia(Casa_1,Casa_2,Lista) :- append(_,[Casa_2,_,Casa_1|_],Lista).

% =================================================================================== %
%   entre_2/3. Indica si las casas recibidas como parámtero se encuentran  
%   separadas por dos casas en la lista proporcionada.

%                   entre_2(<Casa 1>,<Casa 2>,<Lista>).

%   Verdadero si <Lista> es una lista con los elementos <Casa 1> y <Casa 2>
%   separados por dos posiciones.
% =================================================================================== %

entre_2(Casa_1,Casa_2,Lista) :- append(_,[Casa_1,_,_,Casa_2|_],Lista).
entre_2(Casa_1,Casa_2,Lista) :- append(_,[Casa_2,_,_,Casa_1|_],Lista). 

% =================================================================================== %
%   posterior/3. Indica si la segunda casa recibida como parámtero se encuentra  
%   después de la primera en las posiciones de la lista proporcionada.

%                   posterior(<Casa 1>,<Casa 2>,<Lista>).

%   Verdadero si <Lista> es una lista donde <Casa 1> se encuentra en una posición 
%   anterior a la de <Casa 2>
% =================================================================================== %

posterior(Casa_1,Casa_2,Lista) :- append(_,[Casa_1|Resto],Lista), member(Casa_2,Resto).

% =================================================================================== %
%   vecindario/1. Genera una lista que muestra el universo descrito según las
%   pistas del problema tipo cebra.

%                   vecindario(<Lista>).

%   Verdadero si <Lista> es una lista que cumple con cada una de las pistas
%   que describen al universo planteado en el problema tipo cebra.
%
%   NOTA: Las casas que conforman el vecindario se representan de la siguente forma:
%
%                   casa(<Nacionalidad>,<Color>,<Mascota>,<Deporte>)
% =================================================================================== %
%   Verdadero si <Lista> es una lista donde <Casa 1> se encuentra en una posición 

vecindario(V) :-
    V = [_,_,_,_],                                                  % Pista                                                      
    entre_2(casa(_,_,_,boliche),casa(_,_,_,natación),V),            %   1
    intermedia(casa(irlandés,_,_,_),casa(_,_,_,voleyball),V),       %   2
    V = [_,casa(_,negro,_,_),_,_],                                  %   3
    intermedia(casa(_,_,caballos,X),casa(_,rojo,_,_),V),            %   4
    junto(casa(escocés,_,_,_),casa(_,_,tortugas,_),V),              %   5
    entre_2(casa(_,_,caballos,X),casa(_,_,mariposas,_),V),          %   6
    posterior(casa(_,_,_,tenis),casa(_,_,_,boliche),V),             %   7
    intermedia(casa(_,_,_,voleyball),casa(_,blanco,_,_),V),         %   8
    V = [casa(ruso,_,_,_),_,_,_].                                   %   9

% =================================================================================== %
%   visualiza_vecindario/1. Imprime el universo de vecindario en formato de tabla.

%                   visualiza_vecindario(<Lista>).

%   Verdadero si <Lista> corresponde al universo descrito para el vecindario
%   del problema tipo cebra y es posible imprimirlo con el formato definido.
% =================================================================================== %

visualiza_vecindario(V) :-
    vecindario(V),
    format('~n~n+~`-t~80|+ ~n', []),
    format('|~t~w~t~20+|~t~w~t~20+|~t~w~t~20+|~t~w~t~20+|~n',
    ['Nacionalidad','Color','Mascotas','Deporte']),
    imprimir(V).

% =================================================================================== %
%   imprimir/1. Imprime cada elemento 'casa' contenido en la lista proporcionada.

%                   imprimir(<Lista>).

%   Verdadero si <Lista> corresponde a una lista de elementos 'casa' que puedan
%   ser impresos con el formato definido.
% =================================================================================== %

imprimir([X|Resto]) :-
    X = casa(Nacionalidad,Color,Mascotas,Deporte),
    format('~`-t~80| ~n', []),
    format('|~t~w~t~20+|~t~w~t~20+|~t~w~t~20+|~t~w~t~20+|~n',
    [Nacionalidad,Color,Mascotas,Deporte]),
    format('~`-t~80| ~n', []),
    imprimir(Resto).