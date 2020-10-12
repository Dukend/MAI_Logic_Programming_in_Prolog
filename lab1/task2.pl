%%%%%%%%%%%%%%%%%%%%%%%
%      by Dukend      %  
%%%%%%%%%%%%%%%%%%%%%%%
% Task 2: Relational Data

:- ['two.pl'].
%:- encoding(utf8).


withoutcopy([], []):-!.
withoutcopy([X|L], List):-
          member(X, L),
	  !, 
	  withoutcopy(L, List).
withoutcopy([X|L], [X|List]):-
	  !, 
	  withoutcopy(L, List).
%######################
% пункт 1 Напечатать средний балл для каждого предмета
task1():-
	findall(Sub, grade(_, _, Sub, _), S),
	withoutcopy(S, Subj),
	mark(Subj).
sum([],0).
sum([M|Marks],Sum):-
	sum(Marks,S),
	Sum is M + S.
mark([]).
mark([Subj|T]):-
	findall(Mark,grade(_,_,Subj,Mark),Marks),
	sum(Marks,M),
	length(Marks,Len),
	X is M / Len,
	write(Subj), write(': '), write(X), nl,
	mark(T).

%######################
%  пункт 2 Для каждой группы, найти количество не сдавших студентов
task2():-
	findall(Gr, grade(Gr, _, _, _), Group),
	withoutcopy(Group, G),
	pass(G).
pass([]).
pass([Group|T]):-
	findall(Stud,grade(Group,Stud,_,2),Studs),
	withoutcopy(Studs,S),
	length(S,X),
	write(Group), write(': '),write(X), nl,
	pass(T).

%######################
% пункт 3 Найти количество не сдавших студентов для каждого из предметов
task3():-
	findall(Sub, grade(_, _, Sub, _), S),
	withoutcopy(S, Subj),
	subj(Subj).
subj([]).
subj([Subj|T]):-
	findall(Stud,grade(_,Stud,Subj,2),Studs),
	length(Studs,X),
	write(Subj), write(': '), write(X), nl,
	subj(T).

%######################

