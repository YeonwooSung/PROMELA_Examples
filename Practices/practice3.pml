byte x=1;
byte y=0;

#define X_ODD (x%2 == 1)
#define X_IS_NOT_TEN (x != 10)
#define C1 (x <= y)
#define C2 (x == y)
#define C3 (x != y)


//ltl a { eventually X_IS_NOT_TEN }

// Negate and Spin check for reverse condition.
// Spin succeeds, so the original condition is false.
//ltl b { !(eventually (always X_ODD)) }

// Weak fairness, P2 will eventually make x odd.
// No fairness, P2 never executes, P1 does not change x's parity, so x is always odd.
//ltl c { !(eventually (always (eventually X_ODD))) }

// Weak fairness, once x reaches 255, do not execute P1 or P2, as those will result in a byte overflow.
// No fairness, never execute P3, so y will alawys be 0.
//ltl d { always C1 }

// Weak fairness, eventually P1 or P2 will run after P3
// No fairness, nothing runs after P3
ltl e { always (C3 implies (eventually C2)) }


active proctype P1(){
    do
    :: x=x+2
    od;
}

active proctype P2(){
    do
    :: x=x+1
    od;
}

active proctype P3(){
    do
    :: y<x -> y=x
    od
}
