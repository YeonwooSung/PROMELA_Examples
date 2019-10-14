byte x=1;
byte y=0;

active proctype P1(){
    do
    :: x=x+2
    od;
}

active proctype P2(){
    do
    :: x=x+1
    od;
}

active proctype P3(){
    do
    :: y<x ->y=x
    od
}
å