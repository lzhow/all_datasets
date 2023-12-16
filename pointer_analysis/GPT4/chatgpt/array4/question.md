You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    int main(){
    int* a[100];
    int *b,c,k;
    int e[20];

	if(b)
    e[10] = c;

	*a = k;

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 