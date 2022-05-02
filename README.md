# wordle
A constraint programming formulation of wordle. Uses CLP(FD) and global cardinality constraints (as implemented in SWI-Prolog).

Works in "hard mode". The problem is posed as finding the solution for variables `X=[X1, X2, X3, X4, X5]`, which are constrained so that the word `X` takes on one of the values specified by `word/1` (a predicate initialized from a well-known dictionary, here a [dictionary of 12947 words](https://github.com/tabatkins/wordle-list)).  Each guess `G` is scored against the hidden word `H` yielding the familiar `g` (green) `y` (yellow) and `d` (dark) scores for each letter. Constraints are generated on `X` from the score. At each step the code then selects a word consistent with the current constraints and repeats the cycle until the score is `ggggg`.

Note: One has to be careful to correctly generate `y` and `d` scores for a character `C` that occurs multiple times in the guess (and/or the hidden word). See the comment on `wordle_constraint/4` for details.

The code has a couple of heuristics for making the next guess.
1. `next0`: Simply take the first word (in enumeration order determined by arguments to `labeling`) consistent with the given constraints.
2. `next1`: Let `C` be the set of words consistent with current known information. The secret word is in `C`. Your next guess `G` also is in `C`. Choose the word  which has the most number of distinct scores (against all the words in `C`). Think of each score as a "bucket" (since all the words in `C` are going to go into one of these buckets once you guess `G`). Choosing `G` with the most buckets gives u a chance that the size of the largest bucket will be smaller -- so you are taking a bigger step towards the answer. When using this option, we produce the size of `C` and the number of buckets for the choice at every step.
3. `next2`: (Still in progress.) Chose the word with the smallest size for its largest bucket. (Expensive to compute.)

TODO: Provide OPTIONS for the guess word, labeling strategy.

## Examples

Below we use the `next1` heuristic.
```prolog
?- time(play(L)).
% 24,333,922 inferences, 1.707 CPU in 1.712 seconds (100% CPU, 14251700 Lips)
L = [irate-ddydy-497-33, lemma-dyddy-223-37, spean-dyggd-2-2, aheap-gggg] 

?- time(play(buoys, bound, L)).
% 2,864,156 inferences, 0.222 CPU in 0.223 seconds (100% CPU, 12885642 Lips)
L = [buoys-gyydd-12-3, bijou-gddyy-10-6, bogue-ggdyd-4-4, bourd-gggdg-1-1, bound-gggg] .

?- 
```
The first example is read thus. The system chose the hidden word (`ahead`). The program started with the first guess `irate`. The system gave it the score `ddydy`. The program then guessed  `lemma`, `spean` and finally got to `ahead`. The program computed that the first guess (`irate`) resulted in only 497 candidates (that is, only 497 words in the given dictionary are consistent with the score `ddydy` for `irate`). The word chosen next (`lemma`) had 33 possible buckets (i.e. different scores, when rated against all the remaining words). This choice was able to reduce the candidate set to size 223. Next choice `spean` was able to reduce the candidate set to just 2, and then `aheap` was the answer.
In the second example we specify the initial guess (`buoys`) and the hidden word (`bound`). `L` is to be read as above.

The program can also be used to generate the next guess, given a sequence of guesses and scores, and without access to the hidden word. This is useful when playing wordle for real.

```prolog
?-  guess_next_word([irate-dydyd], W, S, N).
W = burnt,
S = 71,
N = 21 .

?- guess_next_word([irate-dydyd, burnt-ddydy], W, S, N).
W = motor,
S = 11,
N = 8 .

?- guess_next_word([irate-dydyd, burnt-ddydy, motor-dyydy], W, S, N).
W = stork,
S = N, N = 3 .

?- guess_next_word([irate-dydyd, burnt-ddydy, motor-dyydy,stork-ggggd], W, S, N).
W = story,
S = N, N = 1 .

?- 
```
