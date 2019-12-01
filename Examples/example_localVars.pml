bool mygo = false;

active proctype P() {
    byte x = 0;
    do
    :: x < 10 && mygo ->
        x=x+1;
        mygo = !mygo;
    :: x >= 10 -> break;
    od
}

active proctype Q() {
    byte x = 0;
    do
    :: x<10 && !mygo ->
        x = x + 1;
        mygo = !mygo
    :: x >= 10 -> break
    od
}

active proctype Inv() {
    // Q:x means local variable x in process Q, and P:x means the local variable x in process P
    assert ((Q:x - P:x) >= 0 && (Q:x - P:x) <= 1)
}
