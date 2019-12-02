#define BUF 100

chan send = [BUF] of {byte};
chan ack = [BUF] of {byte};
chan repeat = [BUF] of {byte};


active proctype P1() {
    byte value = 0;
    byte resend_value = 0;
    byte acknowledged = 1;
    byte ack_value = 0;

    byte failure_count = 0;

    do
    :: acknowledged == 1 ->
        atomic {
            acknowledged = 0;
            send!value; // send value
        }
    :: repeat?resend_value; ->
        atomic {
            if
            :: failure_count > 3 ->
                    failure_count = 0;
                    acknowledged = 1;

                    if
                    :: value < 255 -> value = value + 1;
                    :: else -> value = 0;
                    fi;
            :: else ->
                failure_count++;
                send!resend_value;
            fi;
        }
    :: ack?ack_value ->
        atomic {
            failure_count = 0;

            if
            :: ack_value < 255 -> 
                value = ack_value + 1;
                acknowledged = 1;
            :: ack_value == 255 -> 
                value = 0;
                acknowledged = 1;
            fi;
        }
    od;
}

active proctype P2() {
    byte value = 0;

    // Decides nondeterministically whether to accept a received number or not.
    // If it accepts the received value, send the acknowledgement message via ask channel.
    // Otherwise, send the message via repeat channel.
    do
    :: value > -1 && send?value ->
        ack!value;
    :: send?value ->
        repeat!value;
    :: timeout ->
        // As you could see, the "timeout" could be used for recovering from message loss
        repeat!(value + 1);

        // The "timeout" only becomes executable if there is no other process in the system which is executable.
        // Thus, it is possible to say that by using the "timeout", we could establish that the system does not livelock.
    od;
}


// Construct the never claim to show that between multiple send communication actions there is
// always another communication.
// If the never claim success, then that means that all channel bufferes are empty eventually.
// Apparently, we expect this specification to always have message between P1 and P2.
// Thus, this never claim should be failed.
never {
    do
    :: true
    :: len(send) != 0 -> break;
    :: len(ack) != 0 -> break;
    :: len(repeat) != 0 -> break;
    od;

    do
    :: true
    :: len(send) == 0 && len(ack) == 0 && len(repeat) == 0 -> break;
    od;
}
