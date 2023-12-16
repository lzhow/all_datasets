You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

int main(){

    int **p,**q;
    int *a,*b;
    int *m,*n;
    int a1,b1,m1;

    a = &a1;
    b = &b1;
    m = &m1;
	p = &a;
	q = &b;

    if(a){
	    p = &b;
	    q = &a;
    }

    *p = m;
	n = *q;
    // MAYALIAS(p,&a);
    // MAYALIAS(p,&b);
    // MAYALIAS(n,&a1);
    // MAYALIAS(n,&b1);
    // NOALIAS(p,q);
    // NOALIAS(n,&m1);
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 