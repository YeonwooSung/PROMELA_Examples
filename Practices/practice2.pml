#define N 4

int flags[N] = -1;
int turn[N] = -1;

int major_pid = 0;
bool print[N] = false;

int numberAvailable = 0;

active [N] proctype P1() {
  int id = _pid;

  int count;

  printf("unlocking the print");
  numberAvailable++;
  print[id] = true;

  //Unlocking
  for(count : 0 .. N-1){
    flags[id] = count;
    turn[count] = id;
    bool toContinue = false;

    do
    :: toContinue -> break;
    :: else ->
      int k;
      int valid;

      for (k : 0 .. N - 1) {
        if
        :: (k != id && flags[k] < count) -> valid++;
        :: else
        fi;
      }

      if
      :: (valid == N - 1 || turn[count] != id) -> toContinue = true;
      :: else
      fi;

    od;
  }

  //printf("unlocking the print");
  //numberAvailable++;
  //print[id] = true;

  print[id] = false;
  numberAvailable--;

  printf("locked the print");
  flags[id] = -1;
}

never {
  do
  :: numberAvailable < 2
  :: else -> break;
  od;
}