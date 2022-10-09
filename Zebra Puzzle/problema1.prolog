% =================================================================================== %
%
%   Alberto Palacios Cabrera
%	
%	Tarea #3. Problemas tipo cebra
%
%   - Versión 1: Sólo 3 casas con 2 atributos y 3 pistas
%       1) El español vive junto a la casa roja
%       2) El noruego vive en la casa azul
%       3) Un italiano vive en la segunda casa	
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
%   vecindario/1. Genera una lista que muestra el universo descrito según las
%   pistas del problema tipo cebra.

%                   vecindario(<Lista>).

%   Verdadero si <Lista> es una lista que cumple con cada una de las pistas
%   que describen al universo planteado en el problema tipo cebra.
%
%   NOTA: Las casas que conforman el vecindario se representan de la siguente forma:
%
%                   casa(<Nacionalidad>,<Color>)
% =================================================================================== %

vecindario(V) :-                                % Pista
    V = [_,_,_],                                
    junto(casa(español,_),casa(_,rojo),V),      %   1 
    member(casa(noruego,azul),V),               %   2
    V = [_,casa(italiano,_),_].                 %   3

% =================================================================================== %
%   visualiza_vecindario/1. Imprime el universo de vecindario en formato de tabla.

%                   visualiza_vecindario(<Lista>).

%   Verdadero si <Lista> corresponde al universo descrito para el vecindario
%   del problema tipo cebra y es posible imprimirlo con el formato definido.
% =================================================================================== %

visualiza_vecindario(V) :-
    vecindario(V),
    format('~n~n+~`-t~40|+ ~n', []),
    format('|~t~w~t~20+|~t~w~t~20+|~n', ['Nacionalidad','Color']),
    imprimir(V).

% =================================================================================== %
%   imprimir/1. Imprime cada elemento 'casa' contenido en la lista proporcionada.

%                   imprimir(<Lista>).

%   Verdadero si <Lista> corresponde a una lista de elementos 'casa' que puedan
%   ser impresos con el formato definido.
% =================================================================================== %

imprimir([X|Resto]) :-
    X = casa(Nacionalidad,Color),
    format('~`-t~40| ~n', []),
    format('|~t~w~t~20+|~t~w~t~20+| ~n', [Nacionalidad,Color]),
    format('~`-t~40| ~n', []),
    imprimir(Resto).