byte x=0;

active proctype Increment1(){
    byte temp = x;

    do
    :: x == 255 ->
        x = x - 1;
    :: x < 0 -> break;
    :: else ->
        temp = x;
        temp = temp + 65;
        x = temp;
    od
}

active proctype Increment2(){
    do
    :: x == 255 ->
        x = x - 1;
    :: x < 0 -> break;
    :: else ->
        x = x + 2;
    od
}
