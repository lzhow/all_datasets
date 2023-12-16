#include <stdio.h>

int main(void)
{
    unsigned int aCount = 0;

    int grade;

    while ((grade = getchar()) != EOF)
    {
        switch (grade) 
        { 
        case 'a':
            ++aCount;
            break; 
        case 'b':
            printf("%d\n", aCount);
        case 'c':
            --aCount;
            break;
        default:
            break;
        }
    }

}