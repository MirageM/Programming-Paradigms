%Mirage Lab 7
%Exercise 1: Maximum and Minimum Elements
maxmin([H|T],Max,Min) :-
    maxmin(T,H,H,Max,Min), !.
%Base Case
maxmin([],Max,Min,Max,Min).

%Finding Maximum Value
maxmin([H|T],MX,MN,Max,Min) :-
    H > MX,
    maxmin(T,H,MN,Max,Min).
%Finding Minimum Value
maxmin([H|T],MX,MN,Max,Min) :-
    H < MN,
    maxmin(T,MX,H,Max,Min).
%Recursive Case
maxmin([_|T],MX,MN,Max,Min) :-
    maxmin(T,MX,MN,Max,Min).
