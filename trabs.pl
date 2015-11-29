:- use_module(library(pio)).

:- ['dados/dados_teste.pl'].

pisoMinimo(Z,P) :-
	Z >= P.

%----Verifica se esta conectado
connected(X,Y,L) :-
	dados_via(_,X,Y,L,caracteristicas(_,_,_))
	;
	dados_via(_,Y,X,L,caracteristicas(_,_,_)).

%----Verifica se esta conectado e o piso e suficientemente bom
connected(X,Y,P,L) :-
	dados_via(_, X, Y, L, caracteristicas(Z, _, _)),
	pisoMinimo(Z,P)
	;
	dados_via(_, Y, X, L, caracteristicas(Z, _, _)),
	pisoMinimo(Z,P).

path(A,B,V,Path,Len) :-
	travel(A,B,[A],V,Q,Len),
	reverse(Q,Path).

travel(A,B,P,V,[B|P],L) :-
	connected(A,B,V,L).

travel(A,B,Visited,V,Path,L) :-
	connected(A,C,V,D),
	C \== B,
	\+ member(C, Visited),
	travel(C,B,[C|Visited],V,Path,L1),
	L is D+L1.

shortest(A,B,V,Path,Lenght) :-
	setof([P,L],path(A,B,V,P,L),Set),
	Set = [_|_],
	minimal(Set,[Path,Lenght]).

%----

path(A,B,Path,Len) :-
	travel(A,B,[A],Q,Len),
	reverse(Q, Path).

travel(A,B,P,[B|P],L) :-
	connected(A,B,L).

travel(A,B,Visited,Path,L) :-
	connected(A,C,D),
	C \== B,
	\+ member(C, Visited),
	travel(C,B,[C|Visited],Path,L1),
	L is D+L1.

shortest(A,B,Path,Lenght) :-
	setof([P,L],path(A,B,P,L),Set),
	Set = [_|_], % Verifica se esta vazio
	minimal(Set,[Path,Lenght]).

minimal([F|R],M) :- min(R,F,M).

%----Verificador
min([],M,M).
min([[P,L]|R],[_,M],Min) :- L < M, !, min(R,[P,L],Min).
min([_|R], M, Min) :- min(R,M,Min).
