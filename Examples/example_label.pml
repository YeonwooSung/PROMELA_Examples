byte x = 0;

active[3] proctype P(){
m1: do
    :: x < 10 ->
        m2: x = x + 1;
    :: x > 5 ->
        m3: break;
    od
}

active proctype Inv(){
    // P@loc is only true when P is at loc (loc is label name, and P is the process name)
    P[0]@m3;
    P[1]@m3;
    P[2]@m3;

    assert(x <= 11);
}
