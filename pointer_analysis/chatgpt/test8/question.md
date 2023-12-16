You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    void f(char ** a) {
   int b[10];
   (*a)++; 

   b[10] = 0;
}

int main (){
    char a[10];
    char * c;

    c = a;

    f(&c);
    f(&c);

    *c = 0;
    a[10] = 0;
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 