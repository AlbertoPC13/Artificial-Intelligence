% =================================================================================== %
%
%   Alberto Palacios Cabrera
%	
%	Tarea #3. Problemas tipo cebra
%
%   - Versión 2: 3 casas con 4 atributos y 6 pistas
%       1) El brasileño NO vive en la segunda casa
%       2) El dueño de perros juega baloncesto
%       3) Hay una casa intermedia entre la del que juega fútbol y la casa roja	
%       4) El dueño de peces vive junto al dueño de gatos
%       5) El dueño de perros vive junto a la casa verde
%       6) Un alemán vive en la tercera casa
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

vecindario(V) :-
    V = [_,_,_],                                                            % Pista
    (V = [casa(brasileño,_,_,_),_,_] ; V = [_,_,casa(brasileño,_,_,_)]),    %   1
    member(casa(_,_,perros,baloncesto),V),                                  %   2
    intermedia(casa(_,_,_,fútbol),casa(_,rojo,_,_),V),                      %   3
    junto(casa(_,_,peces,_),casa(_,_,gatos,_),V),                           %   4
    junto(casa(_,_,perros,_),casa(_,verde,_,_),V),                          %   5
    V = [_,_,casa(alemán,_,_,_)].                                           %   6

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