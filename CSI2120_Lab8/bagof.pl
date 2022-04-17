%Mirage Lab 8
%Excercise 1: Collecting Solutions

interval(X,L,H) :- number(X), number(L), number(H),
	!, X>=L, X=<H.
interval(X,X,H) :- number(X), number(H),
	X=<H.
interval(X,L,H) :- number(L), number(H),
	L < H, L1 is L+1,
	interval(X,L1,H).

%bagof(Template, Goal, Bag)
%Collects a list of bag of all the items in the template to satisfy the goal
%
%bagof(X,interval(X,1,10),L).
%
%bagof((X,Y),(interval(X,1,3),interval(Y,1,3)),L).
%
%bagof([X,Y],(interval(X,1,3), interval(Y,1,3)),L).
%
%bagof([X,Y],(interval(X,1,3),interval(Y,1,3),X=\=Y),L).