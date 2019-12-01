byte x;
byte y;

proctype P() {
    byte c;
    c=x;
    x=y;
    y=c;
}

init {
    x=2;
    y=3;
    run P();
    run P();
}