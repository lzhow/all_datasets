You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    int main(){

	int* pins_per_class;
	int a[100];
	int *b[100];
	unsigned int i;
	pins_per_class = (int*) malloc(100);

	if(10){
	//	for(i = 0; i < 10; i++)
		pins_per_class[1] = i;
		a[10] = 200;
		*b[20] = 300;
	}

	free(pins_per_class);

	printf("%d",a[10]);

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 