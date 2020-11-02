sublistDukend(L, T) :-
	appendDukend(S, _, T),
	appendDukend(_, L, S), !.

lengthDukend([], 0).
lengthDukend([H|L], X) :- 
	length(L, X1), X is X1+1.

memberDukend(X, [X|L]).
memberDukend(X, [H|L]) :- 
	memberDukend(X, L).

appendDukend([], L, L).
appendDukend([X|L1], L2, [X|L3]):- 
	appendDukend(L1, L2, L3).

removeDukend(X,[X|L],L).
removeDukend(X,[H|L],[H|L1]) :-
	removeDukend(X,L,L1).

permuteDukend([],[]).
permuteDukend(X, [H|L]):-
	removeDukend(H, X, Y),
	permuteDukend(Y, L).

%..............................................

gods([truth, lie, dipl]). % Список богов

% высказывания 
speak(pos(left, truth)).
speak(pos(center, dipl)).
speak(pos(right, lie)).


choice(left, V, [V, _, _]).
choice(center, V, [_, V, _]).
choice(right, V, [_, _, V]).

change(left, right).
change(right, left).

task :-
	gods(List),
	L=[_, _, _],
	speak(pos(center, Center)),
	(	
		Center == dipl,
		(	
			speak(pos(X, truth)),
			change(X, Y),
			choice(Y, truth, L),
			speak(pos(Y, Ans)),
			choice(center, Ans, L);
			permuteDukend([lie, dipl], [God, _]),
			choice(center, God, L)
		);
		Center == lie, 
		choice(center, dipl, L),
		speak(pos(Truth, dipl)), 
		choice(Truth, truth, L),
		speak(pos(Truth, Ans)),
		choice(center, Ans, L);
		Center == truth 
	),
	permuteDukend(List, L), 
	!,
	writeln(L).
