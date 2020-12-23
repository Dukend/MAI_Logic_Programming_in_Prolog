:- ['data.pl'].

% 3 пункт
% X теща Y невозможно для семейной пары без детей
motherinlaw(Motherinlaw, P):-
    father(P, Child),
    mother(Wife, Child),
    mother(Motherinlaw, Wife).