bit x, y;
byte mutex;

// mutual exclusion example

// The process A will set the value of x to 1, and B will set the value of y to 1.
// Then, A will wait until the value of y is equal to 0, and B will wait until the value of x is equal to 0.


active proctype A() {
    x = 1;
    y == 0; // wait until the value of y is equal to 0

    mutex++;
    printf("MSC: A has entered the critical section.\n");
    mutex--;
    x = 0;
}

active proctype B() {
    y = 1;
    x == 0; // wait until the value of x is equal to 0

    mutex++;
    printf("MSC: B has entered the critical section.\n");
    mutex--;
    y = 0;
}

active proctype monitor() {
    assert(mutex != 2);
}
