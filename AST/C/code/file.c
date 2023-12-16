#include <stdio.h>

int main()
{
  FILE *file = fopen("example.txt", "r");
  if (file != NULL)
  {
    fclose(file);
  }
  return 0;
}