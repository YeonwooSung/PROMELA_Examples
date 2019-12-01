#define PRO 3
#define MAX 10
#define TOT ((MAX*(MAX+1))/2)
#define BUF 2

mtype={send,rec}
chan toD = [BUF] of {mtype,byte,byte};
chan toP[PRO] = [BUF] of {mtype,byte,byte};

proctype Participant(byte id){
    byte i=1;
    int sum=0;
    byte value;

    // We should be careful when using the atomic block, since it could lead to a deadlock!

    do
    :: atomic {
        // This atomic block will not be executed until the condition (i <= MAX && nfull(toD)) is true
        i <= MAX && nfull(toD);
        toD!send,id,i;
        i = i + 1;
    }
    :: sum < (TOT * (PRO - 1)) && toP[id]?[rec,_,_] ->
        toP[id]?rec,_,value;
        sum = sum + value;
    :: i == MAX + 1 && (sum == (TOT * (PRO - 1))) -> break
    od;
}

proctype Distributor(){
    byte name;
    byte value; // the value that the Distributor received from the channel toD
    byte r;     // To count the number of received messages

    do
    :: toD?send,name,value ->
        r=0;
        do
        :: r < PRO && r != name ->
            toP[r]!rec, name, value;
            r = r + 1;
        :: r == name -> r = r + 1;
        :: r == PRO -> break;
        od;
    od;
}

init {
    /*
     * Since it is declared as "atomic" block, any other process cannot intervene to the init process
     * until the init process finishes running the atomic block.
     */
    atomic {
        byte i = 0;

        // run the loop until the value of "i" is equal or greater than PRO
        do
        :: i < PRO ->
            run Participant(i); //generate and run the "i"th Participant process
            i = i+1;
        :: else -> break;
        od;

        // After generate n Participants, where the value of n is equal to PRO, the Distributor process will be generated
        run Distributor();
    };
}
