byte y = 0;
bool b = false;

active proctype Invariant() {
    //Note, assert statement is only executed once!
    assert( !b ||y > 42);
}
