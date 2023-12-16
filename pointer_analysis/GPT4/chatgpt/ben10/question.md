You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    int main(){

	int a,b,*p,i,c;

	if(i) 
		p =&a;
	else
		p = &b;

	*p = 10;

	c = *p;

	a = 5;

	b = 4;

	*p = 20;

	p = &a;

	*p = 10;

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 