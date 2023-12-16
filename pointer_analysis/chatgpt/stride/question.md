You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    struct {int a; short b, c;} st[3];

int main(){

	int x,i;
	for(i =0 ; i < 3; i++){
		x = st[i].b;
	}
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 