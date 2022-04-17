%Mirage Lab 8
%Excercise 2: Leaf Nodes
leafNodes(T,L) :- leafNodes(T,[],L).

%base case
leafNodes(nil,L,L):-!.

leafNodes(t(Root,nil,nil),L,[Root|L]):-!.
%K is right
%I is left
leafNodes(t(Root,Left,Right),L,K) :-
	leafNodes(Left,L,I),
	leafNodes(Right,I,K).

%leafNodes(t( 2, nil, t(3, nil, nil)),L).