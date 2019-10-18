#define N 100

bool print[N];
int numOfLock = 0;

active [N] proctype P1() {
    pid id = _pid;

    waitRelease:
    // Increase the value of numOfLock to grab the lock.
    numOfLock++;

    // Checkf the other process else already had it. If so, release the lock.
    if
    :: numOfLock != 1 ->
        numOfLock--;
        goto waitRelease;
    :: else -> skip;
    fi

    // Printing (the critical section).
    print[id] = true;
    printf("Now the process P1[%d] can print!\n", id);
    print[id] = false;

    // decrease the value of numOfLock so that other process could also get in to the critical section
    numOfLock--;

    // Repeat infinetely often.
    goto waitRelease;
}

active proctype Checker() {
    int i, j;
    do
    :: atomic {
        for (i : 0 .. (N-1)) {
            for (j : i .. (N-1)) {
                if
                :: i != j -> assert(!print[i] || !print[j]);
                :: else -> skip;
                fi
            }
        }
    }
    od
}
