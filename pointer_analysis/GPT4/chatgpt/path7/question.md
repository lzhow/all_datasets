You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

int main(){

    int **p,*q;
    int *b,*c,d,e;

    p = &c;
    q = &e;

    if(d){
        p = &b;
    }
    else{
        q = &d;
    }

    *p = q;

    // MAYALIAS(b,&e);
    // MAYALIAS(c,&d);
    // NOALIAS(c,&e);
    // NOALIAS(b,&d);
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 