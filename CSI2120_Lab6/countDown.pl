%Exercise 1 : Looping
%Student : Mirage

%Loops forever since N is N -1 fails
%Free variable cannot be assigned therefore will not work

countDown(N) :- repeat, %repeat predicate
	writeln(N),
	N is N-1,
	N < 0, !.

%Recursion countDown Fucntion
countDownR(N) :- N<0,!. %Base Case checks if N is greater than zero
countDownR(N) :- writeln(N), %Recursive Case
	NN is N-1,
	countDownR(NN).
