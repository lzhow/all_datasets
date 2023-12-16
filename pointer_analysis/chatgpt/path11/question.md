You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

void foo(int**,int* );
int main(){

    int **p,*q;
    int *a,*b,c,d;
    if(a){
        p = &a;
        q = &c;
        foo(p,q);
    }
    else{
        p = &b;
        q = &d;
        foo(p,q);
    }

    *p = q;
    // MAYALIAS(a,&c);
    // MAYALIAS(b,&d);
    // NOALIAS(a,&d);
    // NOALIAS(b,&c);
}

void foo(int**x,int *y){
    *x = y;
}

 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 