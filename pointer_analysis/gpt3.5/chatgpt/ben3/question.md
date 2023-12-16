You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    typedef struct{
    int f1, f2;
}FOO;

int *z;


int main(){
    FOO a;
    int *b;
    b = &a.f1;
    *b = 100;
}

 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 