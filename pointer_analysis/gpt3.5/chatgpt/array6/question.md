You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    double **bus;
int main(){
	int i;
	bus = (double**) malloc(100);

	for(i = 0; i < 10; i++){
		bus[i] = (int*)malloc(10);
	}
	for(i = 0; i < 10; i++){
		free(bus[i]);
	}

	free(bus);


}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 