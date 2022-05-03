%CSI2120 Programming Paradigms Assignment 2
%Sudoku Prolog Assignment (Mini-Sudoku)
%Student : Mirage Mohammad


%Question 1: The predicate different/1 is true if all numbers in a list are different

different([]).
different([Head|Tail]) :- not(member(Head,Tail)), different(Tail).

%different([1,3,6,4,8,0]).
%
%different([1,3,6,4,1,8,0]).

%Question 2: The predicate extract4Columns extracts the 4 columns of the 4x4 mini-Sudoku
extractColumn1([W,_,_,_],[X,_,_,_],[Y,_,_,_],[Z,_,_,_],[W,X,Y,Z]).
extractColumn2([_,W,_,_],[_,X,_,_],[_,Y,_,_],[_,Z,_,_],[W,X,Y,Z]).
extractColumn3([_,_,W,_],[_,_,X,_],[_,_,Y,_],[_,_,Z,_],[W,X,Y,Z]).
extractColumn4([_,_,_,W],[_,_,_,X],[_,_,_,Y],[_,_,_,Z],[W,X,Y,Z]).

extract4Columns([Row1,Row2,Row3,Row4],[Column1,Column2,Column3,Column4]):-
	extractColumn1(Row1,Row2,Row3,Row4,Column1),
	extractColumn2(Row1,Row2,Row3,Row4,Column2),
	extractColumn3(Row1,Row2,Row3,Row4,Column3),
	extractColumn4(Row1,Row2,Row3,Row4,Column4).

%sudoku(M), extract4Columns(M,L).
%L=[[2,4,1,3],[1,3,2,4],[4,2,3,1],[3,1,4,2]])

%Question 3: The predicate extract4Quadrants/2 extracts the 4 quadrants of teh 4x4 Sudoku

extractQuadrant1([W,X,_,_],[Y,Z,_,_],[_,_,_,_],[_,_,_,_],[W,X,Y,Z]).
extractQuadrant2([_,_,W,X],[_,_,Y,Z],[_,_,_,_],[_,_,_,_],[W,X,Y,Z]).
extractQuadrant3([_,_,_,_],[_,_,_,_],[W,X,_,_],[Y,Z,_,_],[W,X,Y,Z]).
extractQuadrant4([_,_,_,_],[_,_,_,_],[_,_,W,X],[_,_,Y,Z],[W,X,Y,Z]).

extract4Quadrants([Row1,Row2,Row3,Row4],[Quadrant1,Quadrant2,Quadrant3,Quadrant4]):-
	extractQuadrant1(Row1,Row2,Row3,Row4,Quadrant1),
	extractQuadrant2(Row1,Row2,Row3,Row4,Quadrant2),
	extractQuadrant3(Row1,Row2,Row3,Row4,Quadrant3),
	extractQuadrant4(Row1,Row2,Row3,Row4,Quadrant4).

%sudoku(M), extract4Quadrants(M,L).
%L=[[2,1,4,3],[4,3,2,1],[1,2,3,4],[3,4,1,2]])


%Question 4: The predicate allDifferents/1 checks if each sublist of a list of list contains different numbers

allDifferents([]).
allDifferents([A|B]) :- different(A), !, allDifferents(B).

%allDifferents([[1,3,6,4,8,0],[1,3,6,4,1,8,0]]).

%Question 5: Verification of a Sudoku checks if each of the lists in the sudoku represenation are  all allDifferents
%and if the lists from extract4Columns and extract4Quadrants are also alldifferents
checkSudoku(M) :-
	print('yes'); print('no'),
	allDifferents(C),!,
	extract4Columns(M,C), allDifferents(C),!,
	extract4Quadrants(M,Q), allDifferents(Q),!,

%sudoku(M),checkSudoku(M).
%sudoku(L),checkSudoku(L).


%Sudoku verification 4x4 matrix (16 cells)
%Sudoku checks if the board is valid
%The Sudoku is represented with a list of 4 lists, each list element representing one row of the matrix
sudoku([[2,1,4,3],[4,3,2,1],[1,2,3,3],[3,4,1,2]]).
sudoku([[2,1,4,3],[4,3,2,1],[1,2,3,4],[3,4,1,2]]).
