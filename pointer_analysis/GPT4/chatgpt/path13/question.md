You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

struct agg{
	int **i;
}agg;

int main(){
	int *b,*c,*d,f,w;
	struct agg ag1, *a;
	a = &ag1;

	if(a){
        if(f){
		    a->i = &c;
		    b = &f;
        }
	}
	else{
		a->i = &d;
		b = &w;
	}
	*(a->i) = b;
    // MAYALIAS(c,&f);
    // MAYALIAS(d,&w);
    // NOALIAS(c,&w);
    // NOALIAS(d,&f);
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 