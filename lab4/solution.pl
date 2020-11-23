operation("+",1).
operation("-",1).
operation("*",2).
operation("/",2).

expr(3,[Num|T],T,number(Num)).
expr(N,List,Tail,Expr):-
	N<3,
	N1 is N+1,
	expr(N1,List,TTail,Expr1),
	apply(TTail,Tail,Expr1,Expr,N).

apply([Operation|T],Tail,Expr1,Expr,N):-
	operation(Operation,N),
	N1 is N+1,
	expr(N1,T,List1,Expr2),!,
	transfer(Operation,Expr1,Expr2,Term),
	apply(List1,Tail,Term,Expr,N).
apply(List,List,Exp,Exp,_).

transfer("+",Left,Right,add(Left,Right)).
transfer("-",Left,Right,subtract(Left,Right)).
transfer("*",Left,Right,multiply(Left,Right)).
transfer("/",Left,Right,divide(Left,Right)).

%///////////////////////

modify(add(Left,Right),["+"|List]):-
	modify(Left,L1),
	modify(Right,L2),
	append(L1,L2,List).
modify(subtract(Left,Right),["-"|List]):-
	modify(Left,L1),
	modify(Right,L2),
	append(L1,L2,List).
modify(multiply(Left,Right),["*"|List]):-
	modify(Left,L1),
	modify(Right,L2),
	append(L1,L2,List).
modify(divide(Left,Right),["/"|List]):-
	modify(Left,L1),
	modify(Right,L2),
	append(L1,L2,List).
modify(number(N),[N]).

%///////////////////////

calculate(List,X):-
	expr(1,List,_,Term),
	modify(Term,X).

