You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

int main(){

    int **p,*q;
    int *a,*b,c,d;
    p = &a;
    if(p){
        if(c){
            q = &c;
        }
    }
    else{
        p = &b;
        q = &d;
    }
    if(d){
        *p = q;
    }
    // MAYALIAS(a,&c);
    // MAYALIAS(b,&d);
    // NOALIAS(a,&d);
    // NOALIAS(b,&c);


}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 