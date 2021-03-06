% (c) Vijay Saraswat 2022

:- use_module(library(clpfd)).

at_least(1, V, [A1, A2, A3, A4, A5]):-
    A1 #= V #\/
    A2 #= V #\/
    A3 #= V #\/
    A4 #= V #\/
    A5 #= V.

at_least(2, V, [A1, A2, A3, A4, A5]):-
    (A1 #= V #/\ A2 #= V) #\/
    (A1 #= V #/\ A3 #= V) #\/
    (A1 #= V #/\ A4 #= V) #\/
    (A1 #= V #/\ A5 #= V) #\/
    
    (A2 #= V #/\ A3 #= V) #\/
    (A2 #= V #/\ A4 #= V) #\/
    (A2 #= V #/\ A5 #= V) #\/

    (A3 #= V #/\ A4 #= V) #\/
    (A3 #= V #/\ A5 #= V) #\/

    (A4 #= V #/\ A5 #= V).
    
at_least(3, V, [A1, A2, A3, A4, A5]):-
    (A1 #= V #/\ A2 #= V #/\ A3 #= V) #\/
    (A1 #= V #/\ A2 #= V #/\ A4 #= V) #\/
    (A1 #= V #/\ A2 #= V #/\ A5 #= V) #\/        
    (A1 #= V #/\ A3 #= V #/\ A4 #= V) #\/
    (A1 #= V #/\ A3 #= V #/\ A5 #= V) #\/
    (A1 #= V #/\ A4 #= V #/\ A5 #= V) #\/        
    
    (A2 #= V #/\ A3 #= V #/\ A4 #= V) #\/
    (A2 #= V #/\ A3 #= V #/\ A5 #= V) #\/
    (A2 #= V #/\ A4 #= V #/\ A5 #= V) #\/    

    (A3 #= V #/\ A4 #= V #/\ A5 #= V).

at_least(4, V, [A1, A2, A3, A4, A5]):-
    (A1 #= V #/\ A2 #= V #/\ A3 #= V #/\ A4 #= V) #\/
    (A1 #= V #/\ A2 #= V #/\ A3 #= V #/\ A5 #= V) #\/
    (A1 #= V #/\ A2 #= V #/\ A4 #= V #/\ A5 #= V) #\/    
    (A1 #= V #/\ A3 #= V #/\ A4 #= V #/\ A5 #= V) #\/

    (A2 #= V #/\ A3 #= V #/\ A4 #= V #/\ A5 #= V).

exactly(0, V, [A1, A2, A3, A4, A5]):-
    (A1 #\= V #/\ A2 #\= V #/\ A3 #\= V #/\ A4 #\= V #/\ A5 #\= V).

exactly(1, V, [A1, A2, A3, A4, A5]):-
    (A1 #= V #/\ A2 #\= V #/\ A3 #\= V #/\ A4 #\= V #/\ A5 #\= V) #\/
    (A1 #\= V #/\ A2 #= V #/\ A3 #\= V #/\ A4 #\= V #/\ A5 #\= V) #\/
    (A1 #\= V #/\ A2 #\= V #/\ A3 #= V #/\ A4 #\= V #/\ A5 #\= V) #\/
    (A1 #\= V #/\ A2 #\= V #/\ A3 #\= V #/\ A4 #= V #/\ A5 #\= V) #\/
    (A1 #\= V #/\ A2 #\= V #/\ A3 #\= V #/\ A4 #\= V #/\ A5 #= V).


exactly(2, V, [A1, A2, A3, A4, A5]):-
    (A1 #= V #/\ A2 #=  V  #/\ A3 #\= V #/\ A4 #\= V #/\ A5 #\= V) #\/
    (A1 #= V #/\ A2 #\= V  #/\ A3 #=  V #/\ A4 #\= V #/\ A5 #\= V) #\/
    (A1 #= V #/\ A2 #\= V  #/\ A3 #\= V #/\ A4 #=  V #/\ A5 #\= V) #\/
    (A1 #= V #/\ A2 #\= V  #/\ A3 #\= V #/\ A4 #\= V #/\ A5 #=  V) #\/


    (A1 #\= V #/\ A2 #= V  #/\ A3 #= V #/\ A4 #\= V #/\ A5 #\= V) #\/
    (A1 #\= V #/\ A2 #= V  #/\ A3 #\=  V #/\ A4 #= V #/\ A5 #\= V) #\/
    (A1 #\= V #/\ A2 #= V  #/\ A3 #\= V #/\ A4 #=  V #/\ A5 #= V) #\/

    (A1 #\= V #/\ A2 #\= V  #/\ A3 #= V #/\ A4 #= V #/\ A5 #\= V) #\/
    (A1 #\= V #/\ A2 #\= V  #/\ A3 #= V #/\ A4 #\= V #/\ A5 #= V) #\/

    (A1 #\= V #/\ A2 #\= V  #/\ A3 #\= V #/\ A4 #= V #/\ A5 #= V).
    
exactly(3, V, [A1, A2, A3, A4, A5]):-
    (A1 #= V #/\ A2 #=  V  #/\ A3 #= V #/\ A4 #\= V #/\ A5 #\= V) #\/
    (A1 #= V #/\ A2 #=  V  #/\ A3 #\= V #/\ A4 #= V #/\ A5 #\= V) #\/
    (A1 #= V #/\ A2 #=  V  #/\ A3 #\= V #/\ A4 #\= V #/\ A5 #= V) #\/
    (A1 #= V #/\ A2 #\= V  #/\ A3 #= V #/\ A4 #= V #/\ A5 #\= V) #\/
    (A1 #= V #/\ A2 #\=  V  #/\ A3 #= V #/\ A4 #\= V #/\ A5 #= V) #\/
    (A1 #= V #/\ A2 #\=  V  #/\ A3 #\= V #/\ A4 #= V #/\ A5 #= V) #\/

    (A1 #\= V #/\ A2 #= V  #/\ A3 #= V #/\ A4 #= V #/\ A5 #\= V) #\/
    (A1 #\= V #/\ A2 #= V  #/\ A3 #= V #/\ A4 #\= V #/\ A5 #= V) #\/
    (A1 #\= V #/\ A2 #= V  #/\ A3 #\= V #/\ A4 #= V #/\ A5 #= V) #\/

    (A1 #\= V #/\ A2 #\= V  #/\ A3 #= V #/\ A4 #= V #/\ A5 #= V).


exactly(4, V, [A1, A2, A3, A4, A5]):-
    (A1 #= V #/\ A2 #= V #/\ A3 #= V #/\ A4 #= V #/\ A5 #\= V) #\/
    (A1 #= V #/\ A2 #= V #/\ A3 #= V #/\ A4 #= V #/\ A5 #= V) #\/
    (A1 #= V #/\ A2 #= V #/\ A3 #\= V #/\ A4 #= V #/\ A5 #= V) #\/
    (A1 #= V #/\ A2 #\= V #/\ A3 #= V #/\ A4 #= V #/\ A5 #= V) #\/
    
    (A1 #\= V #/\ A2 #= V #/\ A3 #= V #/\ A4 #= V #/\ A5 #= V).

