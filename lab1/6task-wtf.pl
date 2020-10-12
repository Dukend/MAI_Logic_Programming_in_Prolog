removeDukend(X,[X|L],L).
removeDukend(X,[H|L],[H|L1]) :-
	removeDukend(X,L,L1).
appendDukend([], L, L).
appendDukend([X|L1], L2, [X|L3]):- 
	appendDukend(L1, L2, L3).
lengthDukend([], 0).
lengthDukend([H|L], X) :- 
	length(L, X1), X is X1+1.
morelessDukend([], _, [],[]):-!.
morelessDukend([H|L], X, [H|Lb], Lm):-
    H > X,
    morelessDukend(L, X, Lb, Lm).
morelessDukend([H|L], X, Lb, [H|Lm]):-
    morelessDukend(L, X, Lb, Lm).

replaceDukend([_|L], 0, X, [X|L]).     
replaceDukend([H|L], I, X, [H|L1]):-
	I > 0,
	N is I-1,
	replaceDukend(L, N, X, L1),
	!.
replaceDukend(L, _, _, L).
wtf(L,X):-
	appendDukend(L, [a], R),
	lengthDukend(R,N),
	replaceDukend(R,N-1,X,C),
	removeDukend(a,C,T),
	morelessDukend(T,X,More,Less),
	write(X), nl,
	write(less), write(': '),write(More), nl,
	write(more), write(': '),write(Less).
