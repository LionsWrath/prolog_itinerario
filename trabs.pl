:- use_module(library(pio)).

:- ['dados/dados_teste.pl'].

pisoMinimo(Z,P) :-
	Z >= P.

duracao(L,V,D) :-
	D is L/V.

%----Verifica Duracao
connected_dur(X,Y,P,D,I) :-
	dados_via(I, X, Y, L, caracteristicas(Z, _, V)),
	pisoMinimo(Z,P),
	duracao(L,V,D)
	;
	dados_via(I, Y, X, L, caracteristicas(Z, _, V)),
	pisoMinimo(Z,P),
	duracao(L,V,D).


%----Verifica Distancia
connected(X,Y,P,L,I) :-
	dados_via(I, X, Y, L, caracteristicas(Z, _, _)),
	pisoMinimo(Z,P)
	;
	dados_via(I, Y, X, L, caracteristicas(Z, _, _)),
	pisoMinimo(Z,P).

%----Distancia
path(A,B,V,Path,Len) :-
	travel(A,B,[A],V,Q,Len),
	reverse(Q,Path).

travel(A,B,P,V,[B|P],L) :-
	connected(A,B,V,L,_).

travel(A,B,Visited,V,Path,L) :-
	connected(A,C,V,D,_),
	C \== B,
	\+ member(C, Visited),
	travel(C,B,[C|Visited],V,Path,L1),
	L is D+L1.

shortest(A,B,V,Path,Lenght) :-
	setof([P,L],path(A,B,V,P,L),Set),
	Set = [_|_],
	minimal(Set,[Path,Lenght]).

%----Duracao
path_dur(A,B,V,Path,Len) :-
	travel_dur(A,B,[A],V,Q,Len),
	reverse(Q,Path).

travel_dur(A,B,P,V,[B|P],L) :-
	connected_dur(A,B,V,L,_).

travel_dur(A,B,Visited,V,Path,L) :-
	connected_dur(A,C,V,D,_),
	C \== B,
	\+ member(C, Visited),
	travel_dur(C,B,[C|Visited],V,Path,L1),
	L is D+L1.

shortest_dur(A,B,V,Path,Lenght) :-
	setof([P,L],path_dur(A,B,V,P,L),Set),
	Set = [_|_],
	minimal(Set,[Path,Lenght]).

%----Verificador
minimal([F|R],M) :- min(R,F,M).

min([],M,M).
min([[P,L]|R],[_,M],Min) :- L < M, !, min(R,[P,L],Min).
min([_|R], M, Min) :- min(R,M,Min).
