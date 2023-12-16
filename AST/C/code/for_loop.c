#include <stdio.h>

unsigned int f(unsigned int l); 

unsigned int f(unsigned int l)
{
    unsigned int s;
    s = 0;
    for (unsigned int i = 1; i <= l; i += 1)
    {
        s += i;
    }
  return s;
}