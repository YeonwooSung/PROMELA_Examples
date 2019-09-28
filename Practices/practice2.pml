#define N 4

int flags[N] = -1;
int turn[N] = -1;

int major_pid = 0;
bool print[N] = false;

int numberAvailable = 0;

active [N] proctype P1() {
  int this_pid = _pid;

  int count;

  /* do */
  //Unlocking
  for(count : 0 .. N-1){
    flags[this_pid] = count;
    turn[count] = this_pid;
    bool toContinue = false;

    do
    :: toContinue -> break;
    :: else ->
      int k;
      int valid;

      for (k : 0 .. N - 1) {
        if
        :: (k != this_pid && flags[k] < count) -> valid++;
        :: else
        fi;
      }

      if
      :: (valid == N - 1 || turn[count] != this_pid) -> toContinue = true;
      :: else
      fi;

    od;
  }

    printf("unlocking the print");
    numberAvailable++;
    print[this_pid] = true;
    print[this_pid] = false;
    numberAvailable--;

    printf("locked the print");
    flags[this_pid] = -1;
  /* od; */
}

never {
  do
  :: numberAvailable < 2
  :: else -> break;
  od;
}