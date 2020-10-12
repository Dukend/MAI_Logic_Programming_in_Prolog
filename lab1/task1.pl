%%%%%%%%%%%%%%%%%%%%%%%
%      by Dukend      %  
%%%%%%%%%%%%%%%%%%%%%%%
% Первая часть задания - предикаты работы со списками

% Задание 1(Реализовать свои версии стандартных предикатов)

% предикат рассчитаывания длины списка 

lengthDukend([], 0).
lengthDukend([H|L], X) :- 
	length(L, X1), X is X1+1.

% предикат проверки наличия элемента в списке

memberDukend(X, [X|L]).
memberDukend(X, [H|L]) :- 
	memberDukend(X, L).

% предикат объединения двух списков

appendDukend([], L, L).
appendDukend([X|L1], L2, [X|L3]):- 
	appendDukend(L1, L2, L3).

% предикат удаления элементов списка

removeDukend(X,[X|L],L).
removeDukend(X,[H|L],[H|L1]) :-
	removeDukend(X,L,L1).

% предикат перестановок списка

permuteDukend([],[]).
permuteDukend(X, [H|L]):-
	removeDukend(H, X, Y),
	permuteDukend(Y, L).

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

% Задание 2(Замена N-го элемента списка на указанный)

% без стандартных
% replaceDukend(список/ индекс в списке(с 0)/ константа, на которую изменяем элемент/ имя списка).
replaceDukend([_|L], 0, X, [X|L]).
replaceDukend([H|L], I, X, [H|L1]):-
	I > 0,
	N is I-1,
	replaceDukend(L, N, X, L1),
	!.
replaceDukend(L, _, _, L).

% со стандартными
replace(L, I, E, K) :-
	nth0(I, L, _, R),
	nth0(I, K, E, R).
replace(L, _, _, L).

% Задание 3(Разделение списка на два относительно первого элемента (по принципу "больше-меньше"))

% morelessDukend([1,2,3,4,5], 3, More, Less).
morelessDukend([], _, [],[]):-!.
morelessDukend([H|L], X, [H|Lb], Lm):-
    H > X,
    morelessDukend(L, X, Lb, Lm).
morelessDukend([H|L], X, Lb, [H|Lm]):-
    morelessDukend(L, X, Lb, Lm).
