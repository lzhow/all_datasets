You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

int obj, t,s;
void foo(int**, int**);

void main(){
	int **x, **y;
	int *a, *b, *c, *d,*e;
	e = &t; d = &obj;
	c = &s;
	if(t) { x =&c; y =&e;}
	else { x= &d; y = &d;}
    foo(x,y);
    // NOALIAS(c,&obj);
    // NOALIAS(d,&t);
	
}

void foo(int **p, int **q){
	*p = *q;
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 