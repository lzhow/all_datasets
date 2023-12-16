You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    
#include <stdlib.h>

int g1;
int g2;

void f1(int **pp) {
        *pp = &g1;
}
void f2(int **pp) {
        f1(pp);
            *pp = &g2;
}
int f3() {
        int **pp = malloc(sizeof(int *));
            f2(pp);
                return **pp;
}
int f4() {
        int *p;
            f2(&p);
                return *p;
} 
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 