You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    void swap1(char **a, char **b) {
    char *c;
   c = *a;
   *a = * b;
   *b = c;
}

void swap(char ***a, char ***b) {
    swap1(*a, *b);
}

void f(char ***a, char ***b) {
    swap(a, b);
    swap(a,b);
}

int main (){
    char b[20];
    char a[20];
    char * p1, *p2, *t1, *t2;
    char ** pa, ** pb;

    p1 = a;
    p2 = b;

    pa = & p1;
    pb = & p2;

    f (&pa, &pb);

    t1 = *pa;
    *t1 = 0;

    t2= *pb;
    *t2 = 0;

}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 