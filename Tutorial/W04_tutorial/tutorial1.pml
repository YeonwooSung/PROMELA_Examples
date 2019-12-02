#define p (state==ok)
#define q (alarm!=red)

mtype={ok,nok,green,red};
mtype state=ok;
mtype alarm=green;
byte c=50;

#define NOT_P (state != ok)
#define NOT_Q (state == red)

//ltl l1 { eventually p }
//ltl l2 { always (NOT_P implies not (eventually p)) }
//ltl l3 { always (NOT_P implies NOT_Q) }
//ltl l4 { always (p implies q) }

active proctype SmokeDetector() {
    state = ok;

    start: if
    :: c > 100 && state == ok ->
        atomic {
            state=nok;
            alarm=red;
        }
    :: else -> skip
    fi;

    if
    :: c > 20 -> c = c - 1;
    :: c < 120 -> c = c + 1;
    fi;

    goto start
}

// never claim for ltl l2
never {
    do
    :: !p -> break;
    :: true
    od;

    do
    :: p -> break;
    :: true
    od;
}
