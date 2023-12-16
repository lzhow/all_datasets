You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

void foo(int**, int*);
main(){
	int **x, *y;
	int  *c, *d,e,f;
	if(x) { x =&c; y =&e;}
	else { x= &d; y = &f;}
	foo(x,y);
    // MAYALIAS(c,&e);
    // MAYALIAS(d,&f);
    // NOALIAS(c,&f);
    // NOALIAS(d,&e);
	
}

void foo(int **p, int *q){
	*p = q;
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 