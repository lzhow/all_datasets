You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    struct agg{
    int a;
    struct fgg{
	int k;
    }fgg;
}agg;

int main(){
    struct agg str1;
    struct agg* str2 = &str1;

    str2->fgg.k = 100;    

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 