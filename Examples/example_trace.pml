mtype={send,ack};

active proctype P1() {
    byte v=1;
    byte reply;

    do
    :: v<=N ->
        toP2!send,v;
        toP1?ack,reply;
        if
        :: reply == v -> v = v+1
        :: else -> skip
        fi
    :: else -> break
    od;
}

active proctype P2(){ 
    byte newv=0; byte n=0;
    do
    :: toP2?send,n ->
        if
        :: true -> newv=n;
            if
            :: newv == N -> break
            :: else -> skip
            fi
        :: true -> skip
        fi;
    toP1!ack,newv;
    od;
}


// Trace specifications only concern communication actions.
// Also, the Trace specifications must be deterministic.
// A specification can only contain one trace constraint.
trace {
    do
    :: toP2!send,_; // no condition -> deterministic
        toP1!ack,_;
    od
}
