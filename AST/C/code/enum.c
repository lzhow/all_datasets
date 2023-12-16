#include <stdio.h>

enum Le {
  L,
  M,
  H
};
  
int main() {
  enum Le m = M;
 
  printf("%d", m);
  
  return 0;
}