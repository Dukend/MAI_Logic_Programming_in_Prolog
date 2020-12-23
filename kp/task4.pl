:- ['data.pl'].

% 4 пункт

% X брат Y
brother(X, Y):-
	sex(X, 'M'),
	(	father(Z, X),
		father(Z, Y)
	;	mother(Q, X),
		mother(Q, Y)
	),
	X \= Y.
% X сестра Y
sister(X, Y):-
	sex(X, 'F'),
	(	father(Z, X),
		father(Z, Y)
	;	mother(Q, X),
		mother(Q, Y)
	),
	X \= Y.
% X муж Y
husband(X, Y):-
	father(X, Z),
	mother(Y, Z).
% X жена Y
wife(X, Y):-
	mother(X, Z),
	father(Y, Z).
% X сын Y
son(X, Y):-
	sex(X, 'M'),
	(father(Y, X) ; mother(Y, X)).
% X дочь Y
daughter(X, Y):-
	sex(X, 'F'),
	(father(Y, X) ; mother(Y, X)).
% X внук Y
grandson(X, Y):-
	sex(X, 'M'),
	(	father(Z, X),
		father(Y, Z)
	;	mother(C, X),
		father(Y, C)
	).
% X внучка Y
granddaughter(X, Y):-
	sex(X, 'F'),
	(	father(Z, X),
		father(Y, Z)
	;	mother(C, X),
		father(Y, C)
	).
% X дедушка Y
grandfather(X, Y):-
	father(X, Z),
	(	father(Z, Y)
	;	mother(Z, Y)
	).
% X бабушка Y
grandmother(X, Y):-
	mother(X, Z),
	(	father(Z, Y)
	;	mother(Z, Y)
	).
% X тесть или свекор Y
fatherinlaw(X, Y):-
	(	father(Y, C),
		mother(W, C)
	;	mother(Y, C),
		father(W, C)
	),
	father(X, W).
% X теща или свекровь Y
motherinlaw(X, Y):-
	(	father(Y, C),
		mother(W, C)
	;	mother(Y, C),
		father(W, C)
	),
	mother(X, W).

% движения для алгоритма поиска
move(X, Y, grandson):- grandson(X, Y).
move(X, Y, granddaughter):- granddaughter(X, Y).
move(X, Y, grandfather):- grandfather(X, Y).
move(X, Y, grandmother):- grandmother(X, Y).
move(X, Y, fatherinlaw):- fatherinlaw(X, Y).
move(X, Y, motherinlaw):- motherinlaw(X, Y).
move(X, Y, father):-father(X, Y).
move(X, Y, mother):-mother(X, Y).
move(X, Y, son):-son(X, Y).
move(X, Y, daughter):-daughter(X, Y).
move(X, Y, brother):-brother(X, Y).
move(X, Y, sister):-sister(X, Y).
move(X, Y, husband):- husband(X, Y).
move(X, Y, wife):- wife(X, Y).

% итерационный поиск
%%%%%%%%%%%%%%%%%%%%
int(1).
int(N):-
	int(M),
	N is M+1.

iter([Now|T1], Now, [Now|T1], [], 1). 
iter([Now|T1], Final, Path, [Rel|T2], N):-
	N>0,
	move(Now, New, Rel),
	not(member(New, [Now|T1])),
	N1 is N-1,
	iter([New, Now|T1], Final, Path, T2, N1).

iter_search(Start, Fin, Path, Rel):-
	int(N),
	(	N > 50, !
	;	iter([Start], Fin, Path, Rel, N)
	).
%%%%%%%%%%%%%%%%%%%%

% Определение степени родства
contact(X, Y, Ans):-
	iter_search(X, Y, _, Ans),!.
