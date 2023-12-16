You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    int main(){
    int* a[100];
    int b,c,k;
    int e[20];

    e[0] = 100;

    k = e[0]; 
    a[15] = &b;

    a[18] = &c;
    
    *a[18] = 100;
    
    k = *a[18];

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 