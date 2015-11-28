:- use_module(library(pio)).

program :-
	open('Desktop/Prolog/dados.txt', read, X),
	read_file(X, Lines),
	close(X),
	write(Lines).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).
