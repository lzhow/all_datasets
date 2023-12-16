You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    extern char * malloc(int);
char * h() {
   char * a = malloc(20);
   return a;
}

char * g() {
    char * a = malloc(10);
    return a;
}

char * f(int flag) {
   if (flag == 1) return h();
   else return g();
}


int main (){
    char a[20];
    int flag = a[0];
    char * pa, * pb;

    pa = 0; pb = 0;
    if (flag == 1) {
       pa = f(flag);
    }
    else  {
       pb = f(flag);
    }
    * pa = 0;
    * pb = 1;
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 