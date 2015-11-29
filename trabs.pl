:- use_module(library(pio)).

:- ['Desktop/Prolog/dados.pl'].

pisoMinimo(P) :-
	dados_via(Cod, _, _, _, caracteristicas(X, _, _)),
	X >= P,
	write(Cod).

connected(X,Y,L) :- dados_via(_, X, Y, L, caracteristicas(_, _, _)) ; dados_via(_, Y, X, L, caracteristicas(_, _, _)).

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
