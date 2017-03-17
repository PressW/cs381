% Luay Alshawi: alshawil
% Preston Wipf: wipfp

% Here are a bunch of facts describing the Simpson's family tree.
% Don't change them!

female(mona).
female(jackie).
female(marge).
female(patty).
female(selma).
female(lisa).
female(maggie).
female(ling).

male(abe).
male(clancy).
male(herb).
male(homer).
male(bart).

married_(abe,mona).
married_(clancy,jackie).
married_(homer,marge).

married(X,Y) :- married_(X,Y).
married(X,Y) :- married_(Y,X).

parent(abe,herb).
parent(abe,homer).
parent(mona,homer).

parent(clancy,marge).
parent(jackie,marge).
parent(clancy,patty).
parent(jackie,patty).
parent(clancy,selma).
parent(jackie,selma).

parent(homer,bart).
parent(marge,bart).
parent(homer,lisa).
parent(marge,lisa).
parent(homer,maggie).
parent(marge,maggie).

parent(selma,ling).



%%
% Part 1. Family relations
%%

% 1. Define a predicate `child/2` that inverts the parent relationship.
child(X,Y) :-
    parent(Y,X),
    parent(Z,X),
    Y \= Z.


% 2. Define two predicates `isMother/1` and `isFather/1`.
isMother(X) :-
    female(X),
    parent(X,_).

mother(X,Y) :-
    female(X),
    parent(X,Y).

isFather(X) :-
    male(X),
    parent(X,_).

father(X,Y) :-
    male(X),
    parent(X,Y).


% 3. Define a predicate `grandparent/2`.
grandparent(X,Z) :-
    parent(X,Y),
    parent(Y,Z).


% 4. Define a predicate `sibling/2`. Siblings share at least one parent.
sibling(Y,Z) :-
    parent(X,Y),
    parent(X,Z),
    Y \= Z.
% Breaks becuase Abe is only considered to have 1 parent...
% mother(X,Y), mother(X,Z), father(W,Y), father(W,Z), Y \= Z.


% 5. Define two predicates `brother/2` and `sister/2`.
brother(X,Y) :-
    sibling(X,Y),
    male(X).

sister(X,Y) :-
    sibling(X,Y),
    female(X).


% 6. Define a predicate `siblingInLaw/2`. A sibling-in-law is either married to
%    a sibling or the sibling of a spouse.
siblingInLaw(X,Y) :-
    sibling(Y,Z),
    married(X,Z)|
    sibling(X,Z),
    married(Y,Z).


% 7. Define two predicates `aunt/2` and `uncle/2`. Your definitions of these
%    predicates should include aunts and uncles by marriage.
aunt(X,Y) :-
    sibling(X,Z),
    parent(Z,Y),
    female(X)|
    siblingInLaw(X,Z),
    parent(Z,Y),
    female(X).

uncle(X,Y) :-
    sibling(X,Z),
    parent(Z,Y),
    male(X)|
    siblingInLaw(X,Z),
    parent(Z,Y),
    male(X).


% 8. Define the predicate `cousin/2`.
cousin(W,X) :-
    child(W,Y),
    sibling(Y,Z),
    parent(Z,X).


% 9. Define the predicate `ancestor/2`.
ancestor(X,Z) :-
    parent(X,Y),
    ancestor(Y,Z)|
    parent(X,Z).


% Extra credit: Define the predicate `related/2`.
related(X,Y) :- ancestor(X,Y).
related(X,Y) :- ancestor(Y,X).
related(X,Y) :- aunt(X,Y).
related(X,Y) :- aunt(Y,X).
related(X,Y) :- uncle(X,Y).
related(X,Y) :- uncle(Y,X).
related(X,Y) :- cousin(X,Y).
related(X,Y) :- siblingInLaw(X,Y).
related(X,Y) :- sibling(X,Y).


%%
% Part 2. Language implementation
%%

% 1. Define the predicate `cmd/3`, which describes the effect of executing a
%    command on the stack.
cmd(add,[H1,H2|TAIL],STACK) :- Result is (H1+H2), STACK=[Result|TAIL].
cmd(lte,[H1,H2|T],S)        :- C = (H1 =< H2 -> R=t;R=f),call(C), S=[R|T].
cmd(if(P1,_),[t|T],S)       :- prog(P1,T,S).
cmd(if(_,P2),[f|T],S)       :- prog(P2,T,S).
cmd(A,B,S)                  :- S = [A|B].

% 2. Define the predicate `prog/3`, which describes the effect of executing a
%    program on the stack.
prog([], S1, S2) :- S1 = S2.
prog([Cmd|Tail], X, Z) :- cmd(Cmd, X, Y), prog(Tail,Y,Z).
