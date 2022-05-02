# wordle
A constraint programming formulation of wordle. Uses CLP(FD) and global cardinality constraints (as implemented in SWI-Prolog).

Works in "hard mode". The problem is posed as finding the solution for constraints on variables `X=[X1, X2, X3, X4, X5]`, which are constrained so that the word `X` takes on one of the values specified by `word/1`. Each guess `G` is scored against the hidden word `H` yielding the familiar `g` (green) `y` (yellow) and `d` (dark) scores for each letter. Constraints are generated on `X` from the score. At each step the code then selects a word consistent with the current constraints and repeats the cycle until the score is `ggggg`.

Note: One has to be careful to account for `y` and `d` scores generated for a character `C` that occurs multiple times in the guess. See the comment on `wordle_constraint/4` for details.

TODO: Implement better heuristic to guess the next word. Currently it simply picks a word consistent with current information. This has a tendency to rathole into the "wordle tarpit". 

TODO: Provide OPTIONS for the guess word, labeling strategy.

## Examples
```prolog
?- play(H).
H = [irate-ddddd, dzhos-dddgd, cymol-dddgd, upbow-dddgd, gonof-gggg] 

?- play(buoys, bound, L).
L = [buoys-gyydd, bogue-ggdyd, bourn-gggdy, bound-gggg] .

?- 
```
