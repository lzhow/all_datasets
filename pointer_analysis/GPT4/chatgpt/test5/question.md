You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    char * f(char * a) {
   char * b ;

   b = a;
    *(b++) = 1;
   return b;
}

char * g(char * a) {
    *a = 0;
    return f(a);
}

int main (){
    char a[10];
    char b[20];
    char * c;

    f(a);
    c = f(b);
    g(c);
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 