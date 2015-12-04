:- use_module(library(plunit)).

:- [trabs].

:- begin_tests(shortest).

test(t0, P == [sarandi, mandaguari, fenix, iretama], L == 195.0) :- shortest(sarandi,iretama, 0, P, L).

:- end_tests(shortest).
