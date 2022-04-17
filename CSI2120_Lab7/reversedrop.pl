%Mirage Lab 7
%Exercise 3: Reversal with Every Second Element
reverseDrop(L,R) :- reverseDrop(L,1,[],R), !.

reverseDrop([],_,R,R) :- !.

reverseDrop([HL|TL],N,I,R) :-
	N = 1,
	reverseDrop(TL,0,[HL|I],R).

reverseDrop([_|TL],N,I,R) :-
	N = 0,
	reverseDrop(TL,1,I,R).