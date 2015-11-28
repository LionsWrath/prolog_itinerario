:- use_module(library(pio)).

lerArquivo :- ['Desktop/Prolog/dados.pl'].

pisoMinimo(P) :-
	dados_via(Cod, _, _, Dist, caracteristicas(X, _, _)),
	X >= P,
	write(Cod).
