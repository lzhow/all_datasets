You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    char * p1, * p2;
void swap() {
   char * c;
   c = p1;
   p1 = p2;
   p2 = c;
}

void f() {
    swap();
}

int main (){
    char b[20];
    char a[20];
    char * pa, *pb;

    p1 = a;
    p2 = b;

    f();
    pa = p1;
    pb = p2;
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 