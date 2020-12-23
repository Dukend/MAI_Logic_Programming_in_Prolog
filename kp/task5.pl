:- ['task4.pl'].

% 5 пункт

name(X) :- sex(X,_), !.
relation(X):- move(_,_,X),!.

% предикат для вывода коректного числа отношения
writes(X,N):- 
	N > 1, various(X,Y), !, write(Y); write(X).

% множественные числа
various(son, sons).
various(daughter, daughters).
various(sister, sisters).
various(brother, brothers).
various(granddaughter, granddaughters).
various(grandson, grandsons).


question1('how many').
question1('how much').
question2('who').
question3('what').
question(X) :- question1(X); question2(X); question3(X).

male_pronoun('him').
male_pronoun('he').
female_pronoun('her').
female_pronoun('she').
pronoun(X) :- male_pronoun(X); female_pronoun(X).

do('do').
do('does').
have('have').
have('has').
is('is').
is('are').

suffix('s').
qstn('?').
rel('relationship').
bet('between').
aand('and').

% предикат сохранения и загрузки связи местоимений
setval(X):- sex(X,'F'),nb_setval(last_female,X).
setval(X):- sex(X,'M'),nb_setval(last_male,X).
getval(X,Name):- female_pronoun(X),!,nb_getval(last_female,Name).
getval(X,Name):- male_pronoun(X),!,nb_getval(last_male,Name).


print([T],Who,R):-write(T), write(' is '), write(Who), write('`s '), write(R),write('.'),nl,!.
print([B|T],Who,R):-
	write(B), write(' is '), write(Who), write('`s '), write(R),write(','),nl, print(T,Who,R).

% Вопросы
% Пример запроса: [how many, *relation*, does, *name*/*pronoun*, have ,?]
q(Q):-
	Q = [Word, R, W2, Who, W3, W4],
	question1(Word), various(Rel, R), do(W2), name(Who), setval(Who), 
	have(W3), qstn(W4), setof(X, move(X, Who, Rel),  T), length(T, Res), !,
	write(Who), write(" has "), write(Res), write(" "),  writes(Rel, Res), write("."), !.
q(Q):-
	Q = [Word, R, W2, Who, W3, W4],
	question1(Word), various(Rel, R), do(W2), pronoun(Who), getval(Who,Name), 
	have(W3), qstn(W4), setof(X, move(X, Name, Rel), T), length(T, Res), !,
	write(Name), write(" has "), write(Res), write(" "), writes(Rel, Res), write("."), !.

% Пример запроса: [who, is, *name*/*pronoun*,s, *relation*, ?]
q(Q):-
	Q = [Word, W1, Who, W2, R, W3],
	question2(Word), is(W1),name(Who),setval(Who),suffix(W2),
	relation(R),qstn(W3),setof(Res,move(Res, Who, R),T),print(T,Who,R),!.
q(Q):-
	Q = [Word, W1, Who, W2, R, W3],
	question2(Word), is(W1),pronoun(Who),getval(Who,Name),suffix(W2),
	relation(R),qstn(W3),setof(Res,move(Res, Name, R),T),print(T,Name,R),!.

% Пример запроса: [what, is, relationship, between, *name*/*pronoun*, and, *name*/*pronoun*, ?]
q(Q):-
	Q = [Word, W1, W2, W3, Who1, W4, Who2, W5],question3(Word),is(W1),rel(W2),bet(W3),
	name(Who1),setval(Who1),aand(W4),name(Who2),setval(Who2),qstn(W5),
	contact(Who1,Who2,Res),
	write('Relationship between '), write(Who1), write(' and '), write(Who2), write(' is '), write(Res),write('.'), nl,!.
q(Q):-
	Q = [Word, W1, W2, W3, Who1, W4, Who2, W5], question3(Word), is(W1), rel(W2),bet(W3),
	pronoun(Who1), getval(Who1, Name), aand(W4), name(Who2), setval(Who2), qstn(W5),
	contact(Name,Who2,Res),
	write('Relationship between '), write(Name), write(' and '), write(Who2), write(' is '), write(Res),write('.'), nl,!.
q(Q):-
	Q = [Word, W1, W2, W3, Who1, W4, Who2, W5],question3(Word),is(W1),rel(W2),bet(W3),
	name(Who1),setval(Who1),aand(W4),pronoun(Who2),getval(Who2,Name),qstn(W5),
	contact(Who1,Name,Res),
	write('Relationship between '), write(Who1), write(' and '), write(Name), write(' is '), write(Res),write('.'), nl,!.
q(Q):-
	Q = [Word, W1, W2, W3, Who1, W4, Who2, W5],question3(Word),is(W1),rel(W2),bet(W3),
	pronoun(Who1),getval(Who1,Name1),aand(W4),pronoun(Who2),getval(Who2,Name2),qstn(W5),
	contact(Name1,Name2,Res),
	write('Relationship between '), write(Name1), write(' and '), write(Name2), write(' is '), write(Res),write('.'), nl,!.
