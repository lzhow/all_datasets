You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    char * h(char * a) {
   *a = 0;
   return a;
}

char * f(char * a, char * b, unsigned flag) {
   if (flag == 1) return h(a);
   else return h(b);
}


int main (){
    char b[20];
    char a[20];
    int flag = a[0];
    char * pa;
    char * pb;

    pa = f(a, b, 0);
    pb = f(a, b, 1);
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 