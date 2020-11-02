<<<<<<< Updated upstream
sublistDukend(L, T) :-
	appendDukend(S, _, T),
	appendDukend(_, L, S), !.

=======
% Place your solution here
>>>>>>> Stashed changes
lengthDukend([], 0).
lengthDukend([H|L], X) :- 
	length(L, X1), X is X1+1.

<<<<<<< Updated upstream
=======
% предикат проверки наличия элемента в списке

>>>>>>> Stashed changes
memberDukend(X, [X|L]).
memberDukend(X, [H|L]) :- 
	memberDukend(X, L).

<<<<<<< Updated upstream
=======
% предикат объединения двух списков

>>>>>>> Stashed changes
appendDukend([], L, L).
appendDukend([X|L1], L2, [X|L3]):- 
	appendDukend(L1, L2, L3).

<<<<<<< Updated upstream
=======
% предикат удаления элементов списка

>>>>>>> Stashed changes
removeDukend(X,[X|L],L).
removeDukend(X,[H|L],[H|L1]) :-
	removeDukend(X,L,L1).

<<<<<<< Updated upstream
=======
% предикат перестановок списка

>>>>>>> Stashed changes
permuteDukend([],[]).
permuteDukend(X, [H|L]):-
	removeDukend(H, X, Y),
	permuteDukend(Y, L).

<<<<<<< Updated upstream
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
=======
% предикат проверки вхождения одного списка в другой

% S - список-вложение, L - основной список
sublistDukend(S, L):- 
   liststartDukend(S, L), 
   !.
sublistDukend(S, [H|List]):-
   sublistDukend(S, List).
liststartDukend([], _).
liststartDukend([H|Sub], [H|List]):-
   liststartDukend(Sub, List).
>>>>>>> Stashed changes
