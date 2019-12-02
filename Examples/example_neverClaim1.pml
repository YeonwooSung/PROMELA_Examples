byte x=3;

active proctype P() {
    x = 1;
}

never {
    x == 3;
    x == 1;
    x == 1;
    x == 1;
}
