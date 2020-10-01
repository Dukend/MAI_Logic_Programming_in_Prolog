% Task 2: Relational Data

% The line below imports the data
:- ['one.pl'].

group(X,L) :- findall(Z,student(X,Z),L).
