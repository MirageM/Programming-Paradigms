%Exercise 3 Cut-Fail
%Student: Mirage

canalOpen(saturday).
canalOpen(monday).
canalOpen(tuesday).

rainning(saturday).

melting(saturday).
melting(sunday).
melting(monday).

weather(X) :- melting(X),
	!, fail.
weather(X) :- rainning(X),
	!, fail.
weather(_).

winterlude(X) :- canalOpen(X),
	weather(X).