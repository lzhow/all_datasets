You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

void foo(int ***,int**);
int obj;
int main(){

    int ***p,**q, **a, **b, *c, *m,*n,d;
    m = &d;
    a = b = &c;
    if(a){
        p = &a;
        q = &c;
        foo(p,q);
    }
    else{
        p = &b;
        q = &c;
        foo(p,q);
    }

   *a = m;
   n = *b;
//    MUSTALIAS(a,b);
//    MUSTALIAS(m,n);
}

void foo(int ***x,int **y){
    *x = y;
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 