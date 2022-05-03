%CSI2120 Programming Paradigms Assignment 4
%Comprehensive Prolog Assignment MergeClusters
%Student: Mirage Mohammad

%replaces the given value in the desired index
replaceIndex([_|Y], 0, X, [X|Y]).
replaceIndex([N|Y], IDX, X, [N|R]):-
	IDX > -1,
	IIndex is IDX-1,
	replaceIndex(Y, IIndex, X, R), !.
replaceIndex(B,_,_,B).

%changes the label of one of the clusters
changingLabel(_,_,_,[],[]).
changingLabel(EL, Z, IDX, [Head|Tail], VAL) :-
	%Returns true when the element in the list starts with index zero
	nth0(IDX,Head,Bit), Bit = EL, !, replaceIndex((Head), IDX, Z, R1),
	[R1|Tail1] = VAL,
	changingLabel(EL,Z,IDX,Tail,Tail1).
changingLabel(EL,Z,IDX,[Head|Tail], VAL) :-
	[Head|Tail1]=VAL,
	changingLabel(EL,Z,IDX,Tail,Tail1).

%relabels the points of the clusters with a  new label
relabel(Elem,Xyz,Line,Rocks):- changingLabel(Elem,Xyz,3,Line,Rocks).

%checks if the clusters contain same points then said to be intersecting points
intersectingPoints([Head1|_],[Head1|_]).

%returns true if list1 is found in the list2 which is a 2D list otherwise, returns false
existsInList([],[]).
existsInList(List1,[Head2|_Tail2]):- intersectingPoints(List1,Head2),!.
existsInList(List1,[_Head2|Tail2]):- existsInList(List1,Tail2).


%represents a list of intersection of points by comparing two clusters
clusterListIntersection([],_,[]).
clusterListIntersection([Head1|Tail1],List2,Same):- existsInList(Head1,List2),!, [Head1|M1] = Same, clusterListIntersection(Tail1,List2,M1).
clusterListIntersection([_Head1|Tail1],List2,Same):- clusterListIntersection(Tail1,List2,Same).


%represents a list of union of points by comparing two clusters
clusterListUnion([], List, List).
clusterListUnion([Head|List1Tail], List2, List3) :-
        memberchk(Head, List2),!,
        clusterListUnion(List1Tail, List2, List3).
clusterListUnion([Head|List1Tail], List2, [Head|List3Tail]) :-
        clusterListUnion(List1Tail, List2, List3Tail).



%creates a new 3D outer layer cluster consisting of multiple clusters
createClusters(ListOutput):-findall([D,X,Y,C],partition(_,D,X,Y,C),L),createClusters(L,[],ListOutput).
createClusters([],_,[]).
createClusters([Head|Tail],J,List1):- [_|[_|[_|[Head1]]]] = Head,
	member(Head1,J), !,
	createClusters(Tail,J,List1).
createClusters([Head|Tail],J,List1):- [_|[_|[_|[Head1]]]] = Head,
	cluster(Head,Tail,C),
	[C|M1] = List1,
	createClusters(Tail,[Head1|J], M1).


%returns a list of points that belong to the same clusters
cluster(Head,[],[Head|[]]).
cluster(Head,[Head1|Tail],L) :-
	[_|[_|[_|[Head2]]]] = Head,
	[_|[_|[_|[Head3|_]]]] = Head1,
	Head2 =:= Head3, !,
	[Head1|Tail1] = L,
	cluster(Head,Tail,Tail1).
cluster(Head,[_|Tail],L) :- cluster(Head,Tail,L).

%displays a new list of cluster labels
extract-labels([],[]).
extract-labels([[_|[_|[_|[Head|_]]]]|Tail],Labels):- [Head|M1] = Labels, extract-labels(Tail,M1).

%iterates and relabels each intersection
relabelIntersection(_,[], ClusterList, ClusterList).
relabelIntersection(LabelC,[Head|T],ClusterList,ClusterListOutput):-
	relabel(Head,LabelC,ClusterList,RelabeledClusterList),
	relabelIntersection(LabelC,T,RelabeledClusterList,ClusterListOutput).

%iterates and relabels each cluster in the local list of clusters
relabelCluster([],ClusterList,ClusterList).
relabelCluster([C|Tail],ClusterList,ClusterListOutput) :-
	clusterListIntersection(ClusterList, C, I),
	extract-labels(I,L),
	[Head1|_] = C,
	[_|[_|[_|[Head2|_]]]] = Head1,
	relabelIntersection(Head2,L,ClusterList,RelabeledClusterList),
	clusterListUnion(C,RelabeledClusterList,UnionClusterList),
	relabelCluster(Tail,UnionClusterList,ClusterListOutput).

%merges the intersecting clusters from adjacent partitions
%helper predicate called mergeClusters that produces the list of all points with their cluster ID
mergeClusters(L):- createClusters(Clusters), relabelCluster(Clusters,[],L).
%these clusters must be merged because they should constitute one large clusters covering more than one partition


%?- test(relabel).
%relabel(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result) [[1,2.2,3.1,77],[2,2.1,3.1,22],[3,2.5,3.1,77],[4,2.1,4.1,77],[5,4.1,3.1,30]]
%true .

%Definition of test (replaceIndex)
test(replaceIndex) :- write('replaceIndex([1,2.2,3.1,33],3, 77, Result)'), nl,
	replaceIndex([1,2.2,3.1,33],3,77,Result),
	write(Result).

%Defintion of test (changingLabel)
test(changingLabel):- write('changingLabel(33, 77, 3, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result)'),nl,
	changingLabel(33, 77, 3, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result),
	write(Result).

 %Defintion of test (relabel)
test(relabel):- write('relabel(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result)'),nl,
	relabel(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result),
	write(Result).


 %Defintion of test (existsInList)
test(existsInList):- write('existsInList(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33],[5,4.1,3.1,30]],Result)'),nl,
	existsInList(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result),
	write(Result).

 %Defintion of test (intersectingPoints)
test(intersectingPoints):- write('intersectingPointsl(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33],[5,4.1,3.1,30]],Result)'),nl,
	intersectingPoints(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result),
	write(Result).

 %Defintion of test (clusterListIntersection)
test(clusterListIntersection):- write('clusterListIntersection(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33],[5,4.1,3.1,30]],Result)'),nl,
	clusterListIntersection(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result),
	write(Result).

 %Defintion of test (clusterListUnion)
test(clusterListUnion):- write('clusterListUnion(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33],[5,4.1,3.1,30]],Result)'),nl,
	clusterListUnion(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result),
	write(Result).

%Defintion of test (createClusters)
test(createClusters):- write('createClusters(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33],[5,4.1,3.1,30]],Result)'),nl,
	createClusters(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result),
	write(Result).

 %Defintion of test (cluster)
test(cluster):- write('cluster(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33],[5,4.1,3.1,30]],Result)'),nl,
	cluster(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result),
	write(Result).

%Defintion of test (extract-labels)
test(extract-labels):- write('extract-labels(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33],[5,4.1,3.1,30]],Result)'),nl,
	extract-labels(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result), 
	write(Result).

%Defintion of test ()
test(relabelIntersection):- write('relabelIntersection(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33],[5,4.1,3.1,30]],Result)'),nl,
	relabelIntersection(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result),
	write(Result).

 %Defintion of test (relabelCluster)
test(relabelCluster):- write('relabelCluster(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33],[5,4.1,3.1,30]],Result)'),nl,
	relabelCluster(33, 77, [[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result),
	write(Result).

