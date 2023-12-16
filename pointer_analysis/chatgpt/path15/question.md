You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

int main(){
    int **p, *q, **w,*v, *a,a1,q1;
    a = &a1;
    p = &a;
    q = &q1;
    w = 0;
    if(p)
        *p = q;
    else
        w = &a;

    v = *w;
    // NOALIAS(v,&q1);
    // MAYALIAS(v,&a1);

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 