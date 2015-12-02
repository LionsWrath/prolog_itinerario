:- use_module(library(pio)).

:- ['dados/dados_teste.pl'].

pisoMinimo(Z,P) :-
	Z >= P.

duracao(L,V,D) :-
	D is L/V.

custo(L,P,V,C,R) :-
        duracao(L,V,D),
	R is (V/C*D*2.5+P). 

%----Transform

print_rota([],[]) :- !.

print_rota([T|R],[X|Path]) :-
	getDes(Path,Y),
	writeln([T,X,Y]),
	print_rota(R,Path).

get_rota(A,B,V) :-
	shortest(A,B,V,Path,Len),
	recursive_search(Path,V,[],L,R),
	L == Len,
	print_rota(R,Path).

recursive_search([_],_,I,L,R) :- reverse(I,R), L is 0,!.

recursive_search([X|Path],V,New,Len,R) :-
	getDes(Path,Y),
	connected(X,Y,V,D,I),
	recursive_search(Path,V,[I|New],L,R),
	Len is D+L.

getDes([Y|_],Y).

%----Verifica Custo
connected_custo(X,Y,M,C,R,I) :-
	dados_via(I, X, Y, L, caracteristicas(Z, P, V)),
	pisoMinimo(Z,M),
	custo(L,P,V,C,R)
	;
	dados_via(I, Y, X, L, caracteristicas(Z, P, V)),
	pisoMinimo(Z,M),
	custo(L,P,V,C,R).

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

%----Custo
path_custo(A,B,V,C,Path,Len) :-
	travel_custo(A,B,[A],V,C,Q,Len),
	reverse(Q,Path).

travel_custo(A,B,P,V,C,[B|P],L) :-
	connected_custo(A,B,V,C,L,_).

travel_custo(A,B,Visited,V,K,Path,L) :-
	connected_custo(A,C,V,K,D,_),
	C \== B,
	\+ member(C, Visited),
	travel_custo(C,B,[C|Visited],V,K,Path,L1),
	L is D+L1.

shortest_custo(A,B,V,C,Path,Lenght) :-
	setof([P,L],path_custo(A,B,V,C,P,L),Set),
	Set = [_|_],
	minimal(Set,[Path,Lenght]).

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










































