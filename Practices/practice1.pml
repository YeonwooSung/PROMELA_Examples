bool state1 = false;
bool state2 = false;
bool state3 = false;

mtype = {three, two , one};
mtype x = one;

active proctype P1() {
  if
  :: !state2 && !state3 && x == one ->
      state1 = true;
      x = two;
      state1 = false;
  fi
}

active proctype P2() {
  if
  :: !state1 && !state3 && x == two ->
      state2 = true;
      x = three;
      state2 = false;
  fi
}

active proctype P3() {
  if
  :: !state1 && !state2 && x == three ->
      state3 = true;
      x = one;
      state3 = false;
  fi
}

never {
  do
  :: state1 && state2 -> break;
  :: state1 && state3 -> break;
  :: state2 && state3 -> break;
  :: else -> skip
  od
}
