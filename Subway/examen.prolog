%================================================================================
%  Base de conocimiento sobre la red Metro de la Ciudad de México...
%  
%  Dr. Salvador Godoy C. - agosto 2015
%  Última actualización: julio_2019
%================================================================================

%-----------------------------------------------------
% Parámetros globales
%  tiempos en segundos...
%-----------------------------------------------------
valor_parámetro(tiempo_inicial, 8).
valor_parámetro(tiempo_tramo, 5).
valor_parámetro(tiempo_transbordo, 10).
valor_parámetro(tiempo_final, 7).


%-----------------------------------------------------
% Definición de las líneas...
%-----------------------------------------------------
color(línea_1, rosa).
color(línea_2, azul_marino).
color(línea_3, verde_olivo).
color(línea_4, azul_cielo).
color(línea_5, amarillo).
color(línea_6, rojo).
color(línea_7, naranja).
color(línea_8, verde_bandera).
color(línea_9, café).
color(línea_A, morado).
color(línea_B, gris_verde).
color(línea_12, dorado).

trayecto(línea_1, observatorio, pantitlán).
trayecto(línea_2, cuatro_caminos, tasqueña).
trayecto(línea_3, indios_verdes, universidad).
trayecto(línea_4, martín_carrera, santa_anita).
trayecto(línea_5, politécnico, pantitlán).
trayecto(línea_6, el_rosario, martín_carrera).
trayecto(línea_7, el_rosario, barranca_del_muerto).
trayecto(línea_8, garibaldi_lagunilla, constitución_de_1917).
trayecto(línea_9, tacubaya, pantitlán).
trayecto(línea_A, pantitlán, la_paz).
trayecto(línea_B, buenavista, ciudad_azteca).
trayecto(línea_12, mixcoac, tláhuac).

%-----------------------------------------------------
% Línea 1: Observatorio _ Pantitlán
%-----------------------------------------------------
sigue(observatorio, tacubaya, línea_1).
sigue(tacubaya, juanacatlán, línea_1).
sigue(juanacatlán, chapultepec, línea_1).
sigue(chapultepec, sevilla, línea_1).
sigue(sevilla, insurgentes, línea_1).
sigue(insurgentes, cuauhtémoc, línea_1).
sigue(cuauhtémoc, balderas, línea_1).
sigue(balderas, salto_del_agua, línea_1).
sigue(salto_del_agua, isabel_la_católica, línea_1).
sigue(isabel_la_católica, pino_suárez, línea_1).
sigue(pino_suárez, merced, línea_1).
sigue(merced, candelaria, línea_1).
sigue(candelaria, san_lázaro, línea_1).
sigue(san_lázaro, moctezuma, línea_1).
sigue(moctezuma, balbuena, línea_1).
sigue(balbuena, boulvd_puerto_aéreo, línea_1).
sigue(boulvd_puerto_aéreo, gómez_farías, línea_1).
sigue(gómez_farías, zaragoza, línea_1).
sigue(zaragoza, pantitlán, línea_1).

%-----------------------------------------------------
% Línea 2: Cuatro Caminos _  Tasqueña
%-----------------------------------------------------
sigue(cuatro_caminos, panteones, línea_2).
sigue(panteones, tacuba, línea_2).
sigue(tacuba, cuitláhuac, línea_2).
sigue(cuitláhuac, popotla, línea_2).
sigue(popotla, colegio_militar, línea_2).
sigue(colegio_militar, normal, línea_2).
sigue(normal, san_cosme, línea_2).
sigue(san_cosme, revolución, línea_2).
sigue(revolución, hidalgo, línea_2).
sigue(hidalgo, bellas_artes, línea_2).
sigue(bellas_artes, allende, línea_2).
sigue(allende, zócalo, línea_2).
sigue(zócalo, pino_suárez, línea_2).
sigue(pino_suárez, san_antonio_abad, línea_2).
sigue(san_antonio_abad, chabacano, línea_2).
sigue(chabacano, viaducto, línea_2).
sigue(viaducto, xola, línea_2).
sigue(xola, villa_de_cortés, línea_2).
sigue(villa_de_cortés, nativitas, línea_2).
sigue(nativitas, portales, línea_2).
sigue(portales, ermita, línea_2).
sigue(ermita, general_anaya, línea_2).
sigue(general_anaya, tasqueña, línea_2).

%-----------------------------------------------------
% Línea 3: Indios Verdes _ Universidad
%-----------------------------------------------------
sigue(indios_verdes, deportivo_18_de_marzo, línea_3).
sigue(deportivo_18_de_marzo, potrero, línea_3).
sigue(potrero, la_raza, línea_3).
sigue(la_raza, tlatelolco, línea_3).
sigue(tlatelolco, guerrero, línea_3).
sigue(guerrero, hidalgo, línea_3).
sigue(hidalgo, juárez, línea_3).
sigue(juárez, balderas, línea_3).
sigue(balderas, niños_héroes, línea_3).
sigue(niños_héroes, hospital_general, línea_3).
sigue(hospital_general, centro_médico, línea_3).
sigue(centro_médico, etiopía, línea_3).
sigue(etiopía, eugenia, línea_3).
sigue(eugenia, división_del_norte, línea_3).
sigue(división_del_norte, zapata, línea_3).
sigue(zapata, coyoacán, línea_3).
sigue(coyoacán, viveros, línea_3).
sigue(viveros, miguel_ángel_de_quevedo, línea_3).
sigue(miguel_ángel_de_quevedo, copilco, línea_3).
sigue(copilco, universidad, línea_3).

%-----------------------------------------------------
% Línea 4: Martín Carrera _ Santa Anita
%-----------------------------------------------------
sigue(martín_carrera, talismán, línea_4).
sigue(talismán, bondojito, línea_4).
sigue(bondojito, consulado, línea_4).
sigue(consulado, canal_del_norte, línea_4).
sigue(canal_del_norte, morelos, línea_4).
sigue(morelos, candelaria, línea_4).
sigue(candelaria, fray_servando, línea_4).
sigue(fray_servando, jamaica, línea_4).
sigue(jamaica, santa_anita, línea_4).

%-----------------------------------------------------
% Línea 5: Politécnico _ Pantitlán
%-----------------------------------------------------
sigue(politécnico, instituto_del_petróleo, línea_5).
sigue(instituto_del_petróleo, autobuses_del_norte, línea_5).
sigue(autobuses_del_norte, la_raza, línea_5).
sigue(la_raza, misterios, línea_5).
sigue(misterios, valle_gómez, línea_5).
sigue(valle_gómez, consulado, línea_5).
sigue(consulado, eduardo_molina, línea_5).
sigue(eduardo_molina, aragón, línea_5).
sigue(aragón, oceanía, línea_5).
sigue(oceanía, terminal_aérea, línea_5).
sigue(terminal_aérea, hangares, línea_5).
sigue(hangares, pantitlán, línea_5).

%-----------------------------------------------------
% Línea 6: El Rosario _ Martín Carrera
%-----------------------------------------------------
sigue(el_rosario, tezozómoc, línea_6).
sigue(tezozómoc, azcapotzalco, línea_6).
sigue(azcapotzalco, ferrería, línea_6).
sigue(ferrería, norte_45, línea_6).
sigue(norte_45, vallejo, línea_6).
sigue(vallejo, instituto_del_petróleo, línea_6).
sigue(instituto_del_petróleo, lindavista, línea_6).
sigue(lindavista, deportivo_18_de_marzo, línea_6).
sigue(deportivo_18_de_marzo, la_villa, línea_6).
sigue(la_villa, martín_carrera, línea_6).

%-----------------------------------------------------
% Línea 7: El Rosario _ Barranca del Muerto
%-----------------------------------------------------
sigue(el_rosario, aquiles_serdán, línea_7).
sigue(aquiles_serdán, camarones, línea_7).
sigue(camarones, refinería, línea_7).
sigue(refinería, tacuba, línea_7).
sigue(tacuba, san_joaquín, línea_7).
sigue(san_joaquín, polanco, línea_7).
sigue(polanco, auditorio, línea_7).
sigue(auditorio, constituyentes, línea_7).
sigue(constituyentes, tacubaya, línea_7).
sigue(tacubaya, san_pedro_de_los_pinos, línea_7).
sigue(san_pedro_de_los_pinos, san_antonio, línea_7).
sigue(san_antonio, mixcoac, línea_7).
sigue(mixcoac, barranca_del_muerto, línea_7).

%-----------------------------------------------------
% Línea 8: Garibaldi_Lagunilla _ Constitución de 1917
%-----------------------------------------------------
sigue(garibaldi_lagunilla, bellas_artes, línea_8).
sigue(bellas_artes, san_juan_de_letrán, línea_8).
sigue(san_juan_de_letrán, salto_del_agua, línea_8).
sigue(salto_del_agua, doctores, línea_8).
sigue(doctores, obrera, línea_8).
sigue(obrera, chabacano, línea_8).
sigue(chabacano, la_viga, línea_8).
sigue(la_viga, santa_anita, línea_8).
sigue(santa_anita, coyuya, línea_8).
sigue(coyuya, iztacalco, línea_8).
sigue(iztacalco, apatlaco, línea_8).
sigue(apatlaco, aculco, línea_8).
sigue(aculco, escuadrón_201, línea_8).
sigue(escuadrón_201, atlatilco, línea_8).
sigue(atlatilco, iztapalapa, línea_8).
sigue(iztapalapa, cerro_de_la_estrella, línea_8).
sigue(cerro_de_la_estrella, uam_1, línea_8).
sigue(uam_1, constitución_de_1917, línea_8).

%-----------------------------------------------------
% Línea 9: Tacubaya _ Pantitlán
%-----------------------------------------------------
sigue(tacubaya, patriotismo, línea_9).
sigue(patriotismo, chilpancingo, línea_9).
sigue(chilpancingo, centro_médico, línea_9).
sigue(centro_médico, lázaro_cárdenas, línea_9).
sigue(lázaro_cárdenas, chabacano, línea_9).
sigue(chabacano, jamaica, línea_9).
sigue(jamaica, mixiuhca, línea_9).
sigue(mixiuhca, velódromo, línea_9).
sigue(velódromo, ciudad_deportiva, línea_9).
sigue(ciudad_deportiva, puebla, línea_9).
sigue(puebla, pantitlán, línea_9).

%-----------------------------------------------------
% Línea A: Pantitlán _ La Paz
%-----------------------------------------------------
sigue(pantitlán, agrícola_oriental, línea_A).
sigue(agrícola_oriental, canal_de_san_juan, línea_A).
sigue(canal_de_san_juan, tepalcates, línea_A).
sigue(tepalcates, guelatao, línea_A).
sigue(guelatao, peñón_viejo, línea_A).
sigue(peñón_viejo, acatitla, línea_A).
sigue(acatitla, santa_marta, línea_A).
sigue(santa_marta, los_reyes, línea_A).
sigue(los_reyes, la_paz, línea_A).

%-----------------------------------------------------
% Línea B: Buenavista _ Ciudad Azteca
%-----------------------------------------------------
sigue(buenavista, guerrero, línea_B).
sigue(guerrero, garibaldi_lagunilla, línea_B).
sigue(garibaldi_lagunilla, lagunilla, línea_B).
sigue(lagunilla, tepito, línea_B).
sigue(tepito, morelos, línea_B).
sigue(morelos, san_lázaro, línea_B).
sigue(san_lázaro, flores_magón, línea_B).
sigue(flores_magón, romero_rubio, línea_B).
sigue(romero_rubio, oceanía, línea_B).
sigue(oceanía, deportivo_oceanía, línea_B).
sigue(deportivo_oceanía, bosque_de_aragón, línea_B).
sigue(bosque_de_aragón, villa_de_aragón, línea_B).
sigue(villa_de_aragón, nezahualcóyotl, línea_B).
sigue(nezahualcóyotl, impulsora, línea_B).
sigue(impulsora, río_de_los_remedios, línea_B).
sigue(río_de_los_remedios, múzquiz, línea_B).
sigue(múzquiz, ecatepec, línea_B).
sigue(ecatepec, olímpica, línea_B).
sigue(olímpica, plaza_aragón, línea_B).
sigue(plaza_aragón, ciudad_azteca, línea_B).

%============================================================
% OBSERVACIÓN:
%  No existen líneas 10 ni 11.  
%  Después de 9 siguen A y B y después sigue la línea 12...
%============================================================

%-----------------------------------------------------
% Línea 12: Mixcoac _ Tláhuac
%-----------------------------------------------------
sigue(mixcoac, insurgentes_sur, línea_12).
sigue(insurgentes_sur, hospital_20_de_noviembre, línea_12).
sigue(hospital_20_de_noviembre, zapata, línea_12).
sigue(zapata, parque_de_los_venados, línea_12).
sigue(parque_de_los_venados, eje_central, línea_12).
sigue(eje_central, ermita, línea_12).
sigue(ermita, mexicaltzingo, línea_12).
sigue(mexicaltzingo, atlatilco, línea_12).
sigue(atlatilco, culhuacán, línea_12).
sigue(culhuacán, san_andrés_tomatlán, línea_12).
sigue(san_andrés_tomatlán, lomas_estrella, línea_12).
sigue(lomas_estrella, calle_11, línea_12).
sigue(calle_11, periférico_oriente, línea_12).
sigue(periférico_oriente, tezonco, línea_12).
sigue(tezonco, olivos, línea_12).
sigue(olivos, nopalera, línea_12).
sigue(nopalera, zapotitlán, línea_12).
sigue(zapotitlán, tlaltenco, línea_12).
sigue(tlaltenco, tláhuac, línea_12).

% ==========================================================================
imprimirLista([]) :- nl.
imprimirLista([H|T]) :- 
	write(H),
	write(' '),
	nl,
	imprimirLista(T).

eliminar_duplicados([], []).
eliminar_duplicados([X|Resto],Lista) :-
    member(X,Resto), !,
    eliminar_duplicados(Resto,Lista).
eliminar_duplicados([X|Resto],[X|Lista]) :-
    eliminar_duplicados(Resto,Lista).

% Encuentra transbordos de una línea
transbordos(Ruta,Conexión):-
    sigue(X,_Y,Ruta), sigue(X,_Z,Conexión), dif(Ruta,Conexión).
transbordos(Ruta,Conexión):-
    sigue(_X,Y,Ruta), sigue(Y,_Z,Conexión), dif(Ruta,Conexión).
transbordos(Ruta,Conexión):-
    sigue(_X,Y,Ruta), sigue(_Z,Y,Conexión), dif(Ruta,Conexión).

% Encuentra conexiones de una línea, totales
conexiones(Ruta,Conexiones) :-
    findall(Líneas,transbordos(Ruta,Líneas),Lista), sort(Lista,Conexiones).

% Encuentra las líneas a las cuales pertenece un aestación
línea_de_estación(A,Línea) :-
    trayecto(Línea,A,_) ; trayecto(Línea,_,A).
línea_de_estación(A,Línea) :-
    sigue(A,_,Línea) , sigue(_,A,Línea).

% ===================================================================
% Código para encontrar mejor ruta
% ===================================================================

encontrar_ruta(A,B,Ruta) :-
    línea_de_estación(A,Línea_inicio),
    línea_de_estación(B,Línea_fin),
    Línea_fin == línea_A,
    línea_de_estación(pantitlán,Línea_aux),
    navegar(A-Línea_inicio,pantitlán-Línea_aux,[],Ruta_1),
    pairs_keys(Ruta_1,Estaciones), delete(Estaciones,pantitlán,Mem),
    navegar(pantitlán-Línea_aux,B-Línea_fin,Mem,Ruta_2),
    append(Ruta_1,Ruta_2,Lista),
    eliminar_duplicados(Lista,Ruta).

encontrar_ruta(A,B,Ruta) :-
    línea_de_estación(A,Línea_inicio),
    línea_de_estación(B,Línea_fin),
    Línea_inicio == línea_A,
    Línea_aux \== línea_A,
    línea_de_estación(pantitlán,Línea_aux),
    navegar(A-Línea_inicio,pantitlán-Línea_inicio,[],Ruta_aux),
    append(Ruta_1,[pantitlán-Línea_inicio],Ruta_aux),
    navegar(pantitlán-Línea_aux,B-Línea_fin,[Ruta_1],Ruta_2),
    append(Ruta_1,Ruta_2,Lista),
    eliminar_duplicados(Lista,Ruta).

encontrar_ruta(A,B,Ruta) :-
    línea_de_estación(A,Línea),
    línea_de_estación(B,Línea),
    navegar(A-Línea,B-Línea,[],Ruta).

encontrar_ruta(A,B,Ruta) :-
    línea_de_estación(A,Línea_inicio),
    línea_de_estación(B,Línea_fin),
    navegar(A-Línea_inicio,B-Línea_fin,[],Ruta).

navegar(A-Línea,A-Línea,_,[A-Línea]) :- !.

navegar(A-Línea,B-Línea,_,[A-Línea,B-Línea]) :- 
    A \== B, (sigue(A,B,Línea) ; sigue(B,A,Línea)).

navegar(A-Línea_inicio,B-Línea_fin,Mem,[A-Línea_inicio|Ruta]) :- 
    A \== B, 
    eliminar_duplicados(Mem,Lista),
    (sigue(A,Z,Línea_fin) ; sigue(Z,A,Línea_fin)),
    \+ member(Z,Lista),
    navegar(Z-Línea_fin,B-Línea_fin,[A,Z|Lista],Ruta).

navegar(A-Línea_inicio,B-Línea_fin,Mem,[A-Línea_inicio|Ruta]) :- 
    A \== B,
    Línea_inicio \== Línea_fin,
    eliminar_duplicados(Mem,Lista),
    (sigue(A,Z,Línea_inicio) ; sigue(Z,A,Línea_inicio)),
    \+ member(Z,Lista),
    navegar(Z-Línea_inicio,B-Línea_fin,[A,Z|Lista],Ruta).

navegar(A-Línea_inicio,B-Línea_fin,Mem,Ruta) :- 
    A \== B,
    Línea_inicio \== Línea_fin,
    conexiones(Línea_inicio,Conexiones_inicio),
    conexiones(Línea_fin,Conexiones_fin),
    intersection(Conexiones_inicio,Conexiones_fin,Conexiones_comunes),
    buscar_conexión(A-Línea_inicio,B-Línea_fin,Mem,Conexiones_comunes,Ruta).

buscar_conexión(A-Línea_inicio,B-Línea_fin,Mem,[Línea|_],[A-Línea_inicio|Ruta]) :-
    A \== B,
    eliminar_duplicados(Mem,Lista),
    Línea_inicio \== Línea_fin,
    Línea_inicio \== Línea, 
    (sigue(A,Z,Línea) ; sigue(Z,A,Línea)),
    \+ member(Z,Lista),
    navegar(Z-Línea,B-Línea_fin,[A|Lista],Ruta).

buscar_conexión(A-Línea_inicio,B-Línea_fin,Mem,[_|Resto],Ruta) :-
    buscar_conexión(A-Línea_inicio,B-Línea_fin,Mem,Resto,Ruta).

rutaH(A,B,Ruta) :- encontrar_ruta(A,B,Ruta). 

calcula_rutas(A,B,Rutas) :- findall(R,rutaH(A,B,R),Lista), eliminar_duplicados(Lista, Rutas).

% ===================================================================
% Código para encontrar peor ruta
% ===================================================================

encontrar_ruta_larga(A,B,Ruta) :-
    línea_de_estación(A,Línea_inicio),
    línea_de_estación(B,Línea_fin),
    navegar_l(A-Línea_inicio,B-Línea_fin,[],Ruta).

navegar_l(A-Línea,A-Línea,_,[A-Línea]) :- !.

navegar_l(A-Línea,B-Línea,_,[A-Línea,B-Línea]) :- 
    A \== B, (sigue(A,B,Línea) ; sigue(B,A,Línea)).

navegar_l(A-Línea_inicio,B-Línea_fin,Mem,[A-Línea_inicio|Ruta]) :- 
    A \== B, 
    dif(A, Z),
    dif(B, Z),
    (sigue(A,Z,Línea) ; sigue(Z,A,Línea)),
    \+ member(Z,Mem),
    navegar_l(Z-Línea,B-Línea_fin,[A|Mem],Ruta).

rutaH_larga(A,B,Ruta) :- limit(1000,encontrar_ruta_larga(A,B,Ruta)). 

calcula_rutas_largas(A,B,Rutas) :- findall(R,rutaH_larga(A,B,R),Lista), eliminar_duplicados(Lista, Rutas).

% ===================================================================
% Cálculo de costo de viaje y mejor/peor ruta
% ===================================================================

incidencias(A) :- 
    sigue(A,_X,_) ; sigue(_Y,A,_).

grado(A,Grado) :-
    findall(_, incidencias(A),Lista),
    length(Lista, Grado).

transbordo(Línea_1,Línea_2,Tiempo) :-
    ((Línea_1 == Línea_2) -> Tiempo is 0 ; valor_parámetro(tiempo_transbordo,Tiempo)).

suma_ruta([],0).
suma_ruta([_],Final) :-
    valor_parámetro(tiempo_final,Final).
suma_ruta([_-Línea_1,Y-Línea_2|Resto],Suma) :-
    valor_parámetro(tiempo_tramo,Tramo),
    grado(Y,Grado),
    append([Y-Línea_2],Resto,Lista),
    transbordo(Línea_1,Línea_2,Transbordo),
    suma_ruta(Lista,Suma_parcial),
    Suma is (Tramo * Grado) + Transbordo + Suma_parcial.

viaje(Ruta,Tiempo) :-
    suma_ruta(Ruta,Suma),
    valor_parámetro(tiempo_inicial,Inicial),
    Tiempo is Inicial + Suma.

ruta_corta(Rutas,R,Min) :-
    maplist(viaje,Rutas,Pesos),
    min_list(Pesos,Min),
    member(R,Rutas),
    viaje(R,Min).

ruta_larga(Rutas,R,Max) :-
    maplist(viaje,Rutas,Pesos),
    max_list(Pesos,Max),
    member(R,Rutas),
    viaje(R,Max).

mejor_ruta(A,B,Mejor,Tiempo) :- 
    calcula_rutas(A,B,Rutas),
    ruta_corta(Rutas,Mejor,Tiempo).

mejores_rutas(A,B,Mejores) :- findall(R-T,mejor_ruta(A,B,R,T),Mejores).

peor_ruta(A,B,Peor,Tiempo) :- 
    calcula_rutas_largas(A,B,Rutas),
    ruta_larga(Rutas,Peor,Tiempo).

peores_rutas(A,B,Peores) :- findall(R-T,peor_ruta(A,B,R,T),Peores).
% ===================================================================
% Código para despliegue de viaje
% ===================================================================

despliuegue_viaje([],_,_).
despliuegue_viaje([X-_],_,_) :-
    valor_parámetro(tiempo_final,Final),
    format('Final: ~w, ~w minutos ~n', [X,Final]).

despliuegue_viaje([X-_,Y-Línea_2|Resto],Línea_actual,Tramo) :-
    valor_parámetro(tiempo_tramo,Costo_tramo),
    grado(Y,Grado),
    append([Y-Línea_2],Resto,Lista),
    Resto = [_-Línea_siguiente|_],
    transbordo(Línea_actual,Línea_siguiente,Transbordo),
    Suma_tramo is (Costo_tramo * Grado) + Transbordo, 
    (((Transbordo == 0, Grado > 2 ,format('Tramo ~w: ~w, ~w, ~w minutos, destino con grado ~w, sin transbordo ~n', [Tramo,X,Y,Suma_tramo,Grado]),!)) ;
    (Transbordo == 0, format('Tramo ~w: ~w, ~w, ~w minutos, destino con grado ~w ~n', [Tramo,X,Y,Suma_tramo,Grado]),!) ;
    format('Tramo ~w: ~w, ~w, ~w minutos, destino con grado ~w, con transbordo ~n', [Tramo,X,Y,Suma_tramo,Grado]),!),
    N is Tramo + 1,
    despliuegue_viaje(Lista,Línea_siguiente,N).

despliuegue_viaje([X-_,Y-Línea_2],_,Tramo) :-
    valor_parámetro(tiempo_tramo,Costo_tramo),
    grado(Y,Grado),
    Suma_tramo is (Costo_tramo * Grado),
    format('Tramo ~w: ~w, ~w, ~w minutos, destino con grado ~w~n', [Tramo,X,Y,Suma_tramo,Grado]), 
    N is Tramo + 1,
    despliuegue_viaje([Y-Línea_2],Línea_2,N).

minutos_a_horas(Tiempo,Horas,Minutos) :-
    Horas is Tiempo // 60,
    Minutos is Tiempo mod 60.

reporte_viaje(A,B) :-
    mejores_rutas(A,B,Rutas),
    Rutas = [Ruta-Tiempo|_],
    minutos_a_horas(Tiempo,Horas,Minutos),
    format('Tiempo total de viaje: ~w minutos = ~w horas y ~w minutos ~n', [Tiempo,Horas,Minutos]),
    valor_parámetro(tiempo_inicial,Inicio),
    format('Inicio: ~w, ~w minutos~n', [A,Inicio]),
    Ruta = [_-Línea_inicio|_],
    despliuegue_viaje(Ruta,Línea_inicio,1).