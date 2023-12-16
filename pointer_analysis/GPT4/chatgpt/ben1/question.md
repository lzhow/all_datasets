You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    struct agg{

	int* f;
	int *g;

}agg;

int main(){
	int a1, b1,c1;
	int *a, *b,*c;
	struct agg agg1[100];
	a = &a1;
	b = &b1;
	agg1[1].f = a;
	agg1[1].g = b;
	//agg1[0].f = &c;

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 