You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    int g1;
int g2;

const struct {
    int *p1;
    int *p2;
} obj = { &g1, &g2 };

int f() {
    int *p = obj.p1;
    return *p;
} 
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 