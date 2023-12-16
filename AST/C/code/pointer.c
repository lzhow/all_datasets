#include <stdio.h>

void copy(char * const s1, char * const s2);

void copy(char * const s1, char * const s2)
{
    for (size_t i = 0; (s2[i] = s1[1]) != '\0'; ++i)
    {; }
}