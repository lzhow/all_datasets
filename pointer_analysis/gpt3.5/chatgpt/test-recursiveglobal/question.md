You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    char *p;

char accessA(unsigned i) {
  return *(p+i);
}


void recursion(unsigned i) {
    if (accessA(i) > 0) return;
    recursion(i++);
}
int main () {
    unsigned i = 0;
    unsigned a[10];
    p = a;
    recursion(0);
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 