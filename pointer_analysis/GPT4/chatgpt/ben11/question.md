You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    int main(){



	int *p, *q, c,d;

	p  =&c;
	q = &d;

	p = q;

	*p = 100;
	*q = 100;
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 