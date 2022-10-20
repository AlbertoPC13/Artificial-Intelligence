arista(a,b,1).
arista(a,c,8).
arista(b,a,3).
arista(b,b,4).
arista(b,d,2).
arista(c,a,6).
arista(c,c,2).
arista(c,e,1).
arista(d,b,7).
arista(d,d,5).
arista(d,e,9).
arista(e,c,3).
arista(e,d,11).

navegar(A,A,_,[A]).
navegar(A,B,_,[A,B]) :- A \== B, arista(A,B,_).
navegar(A,B,Mem,[A|Ruta]) :- 
    A \== B, arista(A,Z,_),
    Z \== B,
    Z \== A,
    \+ member(Z,Mem),
    navegar(Z,B,[A,Z|Mem],Ruta).

rutaH(A,B,Ruta) :- navegar(A,B,[],Ruta).

calcula_rutas(A,B,Rutas) :- findall(R,rutaH(A,B,R),Rutas).

peso_ciclo([X],Peso) :-
    arista(X,X,Peso).

suma_ruta([],0).
suma_ruta([_X],0).
suma_ruta([X,Y|Resto],Suma) :-
    arista(X,Y,Peso),
    append([Y],Resto,Lista),
    suma_ruta(Lista,Suma_parcial),
    Suma is Peso + Suma_parcial.

ruta_corta(Rutas,R) :-
    maplist(suma_ruta,Rutas,Pesos),
    min_list(Pesos,Min),
    member(R,Rutas),
    suma_ruta(R,Min).

mejor_ruta(A,B,Mejor) :- 
    calcula_rutas(A,B,Rutas),
    ruta_corta(Rutas,Mejor).

mejores_rutas(A,B,Mejores) :- findall(R,mejor_ruta(A,B,R),Mejores).
