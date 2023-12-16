You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"
int main(){
    int **p,*q;
    int *a,*b,c,d,e;
    q = &c;
    if(a){
        p = &a;
        if(c){
            q = &d;
        }
    }
    else{
        p = &b;
        q = &e;
    }

    *p = q;
    // MAYALIAS(a,&c);
    // MAYALIAS(a,&d);
    // MAYALIAS(b,&e);
    // NOALIAS(a,&e);
    // NOALIAS(b,&c);
    // NOALIAS(b,&d);

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 