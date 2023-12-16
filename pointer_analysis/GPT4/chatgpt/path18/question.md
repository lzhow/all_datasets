You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"
int x,y,*q,*f,*e,d;

void foo(int **p){
	f = &x;
	if(x){
		p = &e;
		f = &y;
	}

	*p = f;
    // MAYALIAS(q,&x);
    // MAYALIAS(e,&y);
    // NOALIAS(q,&y);
    // NOALIAS(q,&d);
    // NOALIAS(e,&x);
}



int main(){
	int **a,c;
	a = &q; f = &d;	
	foo(a);
}

 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 