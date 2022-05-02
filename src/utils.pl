item(A, [B|C], C):-
    A = B.
item(A, [B|C], [B|D]):-
    A \= B,
    item(A, C, D).

not_item(_A, []).
not_item(A, [B | R]):-
    A \= B,
    not_item(A, R).


pair([], [], []).
pair([A|As], [B|Bs], [A-B|C]):- pair(As, Bs, C).

/*
 count(As, Counts):-
  As must be instantiated to a list of ground atoms (numbers for our 
  application). 

  Counts is the duplicate-free list of pairs A-C, where C (> 0) is the number of times
  A occurs in As. 

*/   
count([], []).
count([A|As], [A-C|X]):-
    count(A, As, Rest, C),
    count(Rest, X).

count(_, [], [], 1).
count(A, [A|X], Y, C):-
    count(A, X, Y, C1),
    C is C1+1.
count(A, [B|X], [B|Y], C):-
    A \== B,
    count(A, X, Y, C).

