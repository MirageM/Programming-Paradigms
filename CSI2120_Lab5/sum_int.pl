% Excercise 3
% Write a predicate that finds the sum of the first N numbers, i.e., it should enable queries of the form sum_int(N,X).

sum_int(1,1).

sum_int(N,X) :-
	N > 1,
	NN is N-1,
	sum_int( NN, Y ),
	X is Y + N.