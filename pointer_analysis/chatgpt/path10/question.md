You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

void foo(int** s);
void bar(int** s);
int k;
int main(){

    int **p,*q;
    int *b,*c,e;
    if(e){
        p = &b;
        foo(&q);
    }
    else{
        p = &c;
        q = &e;
    }

    *p = q;
    // MAYALIAS(b,&k);
    // MAYALIAS(c,&e);
    // NOALIAS(b,&e);
    // NOALIAS(c,&k);
}

void foo(int**x){
    bar(x);
}

void bar(int**s){
    *s = &k;
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 