bool s1, s2, s3 = false;
mtype ={one, two , three};
mtype x = one;

active proctype P1() {
  if
  :: !s2 && !s3 && x == one ->
      s1 = true;
      x = two;
      s1 = false;
  fi
}

active proctype P2() {
  if
  :: !s1 && !s3 && x == two ->
      s2 = true;
      x = three;
      s2 = false;
  fi
}

active proctype P3() {
  if
  :: !s1 && !s2 && x == three ->
      s3 = true;
      x = one;
      s3 = false;
  fi
}

never {
  do
  :: s1 && s2 -> break;
  :: s1 && s3 -> break;
  :: s2 && s3 -> break;
  :: else -> skip
  od
}
