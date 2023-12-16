#include <stdlib.h>

void main()
{

  int *ptr = (int *)malloc(sizeof(int));
  if (ptr != NULL)
  {
    *ptr = 10;            
    printf("%d\n", *ptr); 
    free(ptr);        
  }
}