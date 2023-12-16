You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    struct agg{

	int* f;
	int* g;

}agg;


void foo(struct agg* agg1,int *p){

	agg1->f = p;
	agg1->g = p;

}

int main(){
	int a1, b1,c1;
	int *a, *b,*c;
	struct agg agg1;

	a = &a1;
	foo(&agg1,a);
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 