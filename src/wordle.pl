% (c) Vijay Saraswat 2022
:- use_module(library(clpfd)).
:- use_module(library(lists)).

:- [wordle_words].
:- [one_way_cardinality].
:- [utils].

/** 
  play(History):-
    History is the list of guesses and scores in a game where
    the computer arbitrarily choses the hidden word, and the
    first guess is pre-specified.
*/
play(History) :-
    play(irate, History).

play(Guess, History) :-
    all_words(Words),
    length(Words, L),
    random(0, L, R),
    nth0(R, Words, Hl),
    atom_codes(Hidden, Hl),
    play(Guess, Hidden, Words, History).

play2(Hidden, History):-
    play(irate, Hidden, History).

play(Guess, Hidden, History):-
    all_words(Words),
    play(Guess, Hidden, Words, History).
    
play(Guess, Hidden, Words, History) :-
    score(Guess, Hidden, Score),
    play_with_word([Guess-Score], Hidden, Words, History).

play_with_word([Guess-Score], Hidden, Words, History):-
    wordle_word(Words, X),
    play_with_word(X, Guess, Score, Hidden, Words, History).

play_with_word(_X, Guess, ggggg, _Hidden, _Words, [Guess-gggg]).
play_with_word(X, Guess, Score, Hidden, Words, [Guess-Score-Size-NBuckets|History]):-
    Score \= ggggg,
    constraint(X, Guess, Score),
    guess_word(X, Word, Size, NBuckets),
    score(Word, Hidden, Score1),
    play_with_word(X, Word, Score1, Hidden, Words, History).

% Guess a word consistent with current constraints, using labeling.
% This is being developed further. Below are three heuristics.
guess_word(X, Word, Size, NBuckets):-
    next1(X, Word, Size, NBuckets).

% Select a random word (satisfying all constraints).
next0(X, Word, na, na):- 
    setof(X, once(labeling([enum, ffc, down], X)), [W]),
    atom_codes(Word, W).

random_select(N, Candidates, Guesses):-
    length(Candidates, L),
    random_select(1, N, L, Candidates, Guesses).

random_select(K, N, _L, _C, []):-
    K > N.
random_select(K, N, L, Candidates, [G | Guesses]):-
    K =< N,
    random(0, L, R),
    nth0(R, Candidates, G),
    K1 is K+1,
    random_select(K1, N, L, Candidates, Guesses).

% Select the word which has most possible scores -- the idea is that
% all the available candidate words have more buckets to spread themselves
% into, hence the size of the largest bucket is going to be smaller.
next1(X, Word, Size, NBuckets):-
    setof(X, label(X), Candidates), % Collect all possible answers
    length(Candidates, Size),
    random_select(10, Candidates, Guesses), 
    setof(M1-G, Gl^G^(member(Gl, Guesses),
		     atom_codes(G, Gl),
		     setof(S, Hl^H^(member(Hl, Candidates),
				    atom_codes(H, Hl), 
				    score(G, H, S)),
			   Ss), % valid scores
		     length(Ss, M),
		     M1 is -M),  % We want to take max.
	  Guesses2),
    sort(Guesses2, [NBuckets1-Word | _]),
    NBuckets is -NBuckets1.


%% Explicitly look for the word which is such that it has the smallest size
%% (among all candidate words) for its largest bucket.

next2(X, Word, Size, SizeOfBiggestBucket):-
    setof(X, label(X), Candidates), % Collect all possible answers
    length(Candidates, Size),
    random_select(2, Candidates, Guesses), 
    setof(Max-G, Gl^G^(member(Gl, Guesses),
		  atom_codes(G, Gl),
		  setof(S, Hl^H^(member(Hl, Candidates),
				 atom_codes(H, Hl), 
				 score(G, H, S)),
			Ss), % valid scores
		  % L is the number of solutions when extending current
		  % state with G with score Score, across all possible scores.
		  setof(L, Score^X2^(member(Score, Ss),
				     setof(X, (constraint(X, G, Score), label(X)), X2),
				     length(X2, L)),
			Ls),
		   print(before_max_list(G, Ls)),
		   max_list(Ls, Max)),
	  Guesses2),
    sort(Guesses2, [U1-Word | _]),
    SizeOfBiggestBucket is -U1.

all_words(Words):-
    setof(Y, W^(word(W), string_codes(W, Y)), Words).

wordle_word(Words, X):-
    X = [_, _, _, _, _],
    tuples_in([X], Words).


/*
wordle(A, GS):-
   A ranges over all atoms that are consistent with the guess-scores in GS. 
*/
wordle(A, GuessScores):-
    all_words(Words),
    wordle(A, Words, GuessScores).

wordle(A, Words, GuessScores):-
    wordle_word(Words, X),
    constraints(X, GuessScores),
    labeling([ff], X),
    atom_codes(A, X).

constraints(_X, []).
constraints(X, [Guess-Score | R]):-
    constraint(X, Guess, Score),
    constraints(X, R).

constraint(X, Guess, Score):-
    atom_codes(Guess, Gl), 
    atom_codes(Score, Sl),
    wordle_constraint(X, Gl, Sl, _).

/**
  wordle_constraint(X, Guess, Score, Result):-
    This is the workhorse. It imposes constraints on X generated
    from the current Guess and Score given to it. (Result is used for 
    debugging, provides a symbolic representation of the constraints 
    imposed.)

    Constraints generated:
      Score[i] = g  => X[i] #= Guess[i]
      Score[i] \= g => X[i] #\= Guess[i]
    For every i s.t. Score[i]=d add the constraint exactly(N, C, X)
    where N is the number of positions j where Guess[j]=Guess[i] and 
    Score[j]=y. Note N can be 0, this means C does not occur in X.

    For every i s.t. Score[i]=y add the constraint at_least(N, C, X), 
    where N is as above.

    The above is a special case of global cardinality constraints. But it seems
    SWI Prolog does not implement cardinality constraints where only a lower
    bound is known. We implement it ourselves using reification. See one_way_cardinality.pl.

*/
wordle_constraint(X, Guess, Score, Result):-
    g(X, Guess, Score),
    yd(X, Guess, Score, Result).

g([], [], []).
g([A | W], [G | Guess], [Green | Score]):-
    (char_code(g, Green) -> 
         A #= G;
     A #\=G),
    g(W, Guess, Score).

yd(W, Guess, Score, Result):-
    g_to_y(Score, Score1),
    pair(Guess, Score1, GS),
    count(GS, CGS),
    combine(W, CGS, Result).

combine(_W, [], []).
combine(W, [Char-Y-Count | R], [Goal | Z]):-
    char_code(y, Y), char_code(d, D), char_code(C, Char),
    (item(Char-D-_, R, R1) ->
	 exactly(Count, Char, W),
	 Goal = exactly(Count, C, W) ;
     at_least(Count, Char, W),
     Goal =  at_least(Count, C, W),
     R1=R),
    combine(W, R1, Z).
combine(W, [Char-D-_| R], [exactly(Count, C, W) | Z]):-
    char_code(y, Y), char_code(d, D), char_code(C, Char),
    (item(Char-Y-Count, R, R1) ->
	 exactly(Count, Char, W);
     Count=0,
     R1=R),
    exactly(Count, Char, W),
    combine(W, R1, Z).
    
g_to_y([], []).
g_to_y([G|A], [Y|B]):- char_code(g, G), char_code(y, Y), g_to_y(A, B).
g_to_y([Y|A], [Y|B]):- char_code(y, Y), g_to_y(A, B).
g_to_y([D|A], [D|B]):- char_code(d, D), g_to_y(A, B).


/*
 score(G, H, S):-
   Compute the score S for the guess G, given the hidden
   word (atom) H. G, H and S are words of length 5; S contains only
   the characters g, y and d, corresponding to green, yellow
   and dark scores in Wordle. 

   The only slightly tricky part is the case where
   the same letter (say C) occurs multiple times in the guess. The 
   y scores generated for C in this case cannot be more than the 
   (non-green) occurrences of C in H; the remaining occurrences (if any)
   in G must be scored as d.

   We must count the number of y's in the score for a given letter C.
   If C has k y scores (and no d scores), then we will generate the 
   constraint that the hidden word has *at least* k C's. If C also has
   at least one d score, then we will generate the constraint that the
   hidden word has *exactly* k C's.

   See below for definition of non_green.
   S[i] = g if G[i]= H[i].
   S[i] = y if G[i] != H[i] but G[i] in non_green. 
     After this, one instance of G[i] is removed from non_green. 
     S is computed in order, from i=0 to i=4.
   S[i] = d if G[i] != H[i] and G[i] not in non_green.

 */
score(Guess, Hidden, Score):-
    atom_codes(Guess, Gl),
    atom_codes(Hidden, Hl),
    score1(Gl, Hl, Sl), 
    atom_codes(Score, Sl).

score1(Gl, Hl, Sl):-
    non_green(Gl, Hl, NonGreen),
    score2(Gl, Hl, NonGreen, Sl).

/*
  non_green(Guess, Hidden, NonGreen):-
    NonGreen is the list of all characters in Hidden at non-green
    positions, i.e. at positions i where Guess[i] != Hidden[i].
*/
non_green([], [], []).
non_green([G | Guess], [H | Hidden], NonGreen):-
    G == H,
    non_green(Guess, Hidden, NonGreen).

non_green([G | Guess], [H | Hidden], [H | NonGreen]):-
    G \= H,
    non_green(Guess, Hidden, NonGreen).

score2([], [], _, []).
score2([G | Guess], [H | Hidden], NonGreen, [S | Score]):-
    char_code(g, S),
    G ==H,
    score2(Guess, Hidden, NonGreen, Score).

score2([G | Guess], [H | Hidden], NonGreen, [S | Score]):-
    char_code(y, S),    
    G \=H,
    item(G, NonGreen, Rest), 
    score2(Guess, Hidden, Rest, Score).

score2([G | Guess], [H | Hidden], NonGreen, [S | Score]):-
    char_code(d, S),        
    G \=H,
    not_item(G, NonGreen),
    score2(Guess, Hidden, NonGreen, Score).

    
