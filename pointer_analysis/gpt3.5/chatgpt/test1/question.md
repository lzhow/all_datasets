You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    char * g(char * a) {
    *a = 0;
    return a;
}

char * f(char * a) {
   char * b ;

   b = a;
    *(b) = 0;
   return g(b);
}

char * c;
int main (){
    char b[20];
    char a[20];
    char * p1, *p2;

    p1 = a;
    p2 = b;

    swap (&p1, &p2);
    c = b;
    c = f(c);
    g(c);
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 