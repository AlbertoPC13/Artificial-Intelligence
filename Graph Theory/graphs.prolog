arco(a, b).
arco(a, f).
arco(b, c).
arco(c, d).
arco(c, e).
arco(e, d).
arco(f, c).
arco(f, e).
arco(f, g).
arco(g, c).
arco(e, a).
arco(b, b).
arco(d, g).

navegar(A,A,_,[A]).
navegar(A,B,_,[A,B]) :- A \== B, arco(A,B).
navegar(A,B,Mem,[A|Ruta]) :- 
    A \== B, arco(A,Z),
    Z \== B,
    \+ member(Z,Mem),
    navegar(Z,B,[Z|Mem],Ruta).

rutaH(A,B,Ruta) :- navegar(A,B,[],Ruta).

calcula_rutas(A,B,Rutas) :- findall(R,rutaH(A,B,R),Rutas).

ruta_corta(Rutas,R) :-
    maplist(length,Rutas,Len),
    min_list(Len,Min),
    member(R,Rutas),
    length(R,Min).

mejor_ruta(A,B,Mejor) :- 
    calcula_rutas(A,B,Rutas),
    ruta_corta(Rutas,Mejor).

mejores_rutas(A,B,Mejores) :- findall(R,mejor_ruta(A,B,R),Mejores).