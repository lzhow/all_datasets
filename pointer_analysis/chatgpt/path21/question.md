You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"
int main(){
    int ***p,**a,**b,*q,*r,*f,v,z,*g,f1; 

    p = &a;
    a = b = &f;
    f = &f1;
    q = &v;

    if(a){
        f = &z;
        *p = &g;
        b = *p;
    }
    else{


    }

    *a = q;
    r = *b;
    // MUSTALIAS(r,q);
    // NOALIAS(r,&z);
    // NOALIAS(r,&f1);
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 