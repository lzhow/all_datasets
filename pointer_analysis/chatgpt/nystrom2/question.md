You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    int a,b;
struct foo{
	int x;
	int y;

};

typedef struct foo FOO;

void* alloc(int n){
	return malloc(n);

}

void allocation(int** s){

	*s = malloc(10);
}
FOO *ex(){

	int *q;
	FOO *p;
	allocation(&p);
	/*
	FOO *w;
	p = (FOO*)alloc(sizeof(FOO));
	p->x = a;
	p->y = b;
	q = &a;
	*q = b;
	*/
	return p;

}

void main(){

	ex();

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 