#define BUF 100

mtype={ack}

chan to_rcvr = [BUF] of {byte}; //sender to receiver, not always reliable
chan to_sndr = [BUF] of {mtype, byte}; //receiver to sender, always reliable


active proctype Sender() {
    byte value = 0;
    byte target = 0;
    byte acknowledged = 1;

    do
    :: acknowledged == 1 ->
        atomic {
            to_rcvr!value;
            acknowledged = 0;
        }
    :: to_sndr?ack,value ->
        atomic {
            if
            :: value == target ->
                target++;
                acknowledged = 1;
            :: else ->
                to_rcvr!value;
            fi
        }
    od;
}

active proctype Receiver() {
    byte received;

    do
    :: to_rcvr?received ->
        to_sndr!ack,received;
    :: timeout ->
        // As you could see, the "timeout" could be used for recovering from message loss
        to_sndr!ack,received;
    od;
}

// Trace to check if all messages that the Receiver sends via to_sndr channel are "ack" type.
trace {
    do
    :: to_sndr?ack,_;
    od;
}
