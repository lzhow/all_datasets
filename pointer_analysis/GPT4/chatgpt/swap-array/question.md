You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    void swap(char **a, char **b) {
   char * c;
   c = *a;
   *a = * b;
   *b = c;
}

int main (){
    char b[20];
    char a[20];
    char * p1[2];
    char * pa, * pb;

    p1[0] = a;
    p1[1] = b;

    swap (&p1[0], &p1[1]);
    pa = p1[1];
    pb = p1[0];
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 