proctype Test1() {
    byte x = 0;
    byte y = 3;
    byte z = 4;

    do
    :: atomic {
        true && (x > y); //Due to this line, this atomic block will not executed until (x > y) is true
        x = 0;
        z = 3;
        break;
    }
    :: x < y -> x = x + 1;
    :: timeout -> // timeout is enabled if no other statement in the entire PROMELA model is enabled
        z = 2;
        break;
    od;

    // +a) "skip" is best to use if you want to be sure to analyze the effect of possibly premature timeout
}

init {
    run Test1();
}
