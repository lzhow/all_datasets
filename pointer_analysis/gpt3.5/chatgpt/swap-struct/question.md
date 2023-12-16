You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
     void swap(char **a, char **b) {
   char * c;
   c = *a;
   *a = * b;
   *b = c;
}

struct ptrstruct{
    char * p1;
    char *p2;
}; 

int main (){
    struct ptrstruct PSt;
    char * pa, * pb;
    char b[20];
    char a[20];
 
    PSt.p1 = a;
    PSt.p2 = b;

    swap (&PSt.p1, &PSt.p2);
    pa = PSt.p2;
    pb = PSt.p1;
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 