%Exercise 4 List Processing
%Student: Mirage

%Base Case
secondLast(H, [H|[_|[]]]) :- !.
%Recursive Case
secondLast(X, [_|T]) :- secondLast(X, T).

/*
[1, 2, 3, 4] = [H| T] ===> [H|[H2|T]]
							H = 1
							H2 = 2
							T = [3, 4]
				H = 1
				T = [2, 3, 4]  
[2, 3] = [2|[3| []]]
		H = 2
		T = [3] => [H | T]
					H = 3
					T = []
*/
