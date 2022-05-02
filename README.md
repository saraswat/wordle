# wordle
A constraint programming formulation of wordle.

Uses CLP(FD) and global cardinality constraints (from SWI-Prolog).

TODO: Implement better heuristic to guess the next word. Currently it simply picks
a word consistent with current information.

TODO: Provide OPTIONS for the guess word, labeling strategy.

Example:
```prolog
?- play(H).
H = [irate-ddddd, dzhos-dddgd, cymol-dddgd, upbow-dddgd, gonof-gggg] 

?- play(buoys, bound, L).
L = [buoys-gyydd, bogue-ggdyd, bourn-gggdy, bound-gggg] .

?- 
```
