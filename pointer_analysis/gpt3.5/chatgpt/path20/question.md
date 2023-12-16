You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"
int main(){

    int**a,**b, *f,*g,r,w,q,*obj,k;
    f = &k;
    if(a){
        a = &f;
        f = &r;
    }
    else{
        a = &g;
        g = &w;
    }
    a = b;

    *a = &q;
    obj = *b;
    // MUSTALIAS(obj,&q);
    // NOALIAS(obj,&r);
    // NOALIAS(obj,&w);

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 