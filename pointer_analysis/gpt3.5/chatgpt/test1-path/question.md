You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    char h(char * a) {
   *a = 0;
   return 0;
}

char g(char * a) {
    *a = 0;
    return 0;
}

char * f(char * a, int flag) {
   if (flag == 1) h(a);
   else g(a);
}


int main (){
    char b[20];
    char a[20];

    f(b, 1);
    f(a, 2);
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 