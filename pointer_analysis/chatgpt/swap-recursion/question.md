You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    static int n;
void swap(char **a, char **b);
void swap1(char **a, char **b) {
   swap(a, b);
}

void swap(char **a, char **b) {
   char * c;
   c = *a;
   *a = * b;
   *b = c;
   
   n --;
   if (n > 0) swap1(a, b);
}

int main (){
    char b[20];
    char a[20];
    char * p1, *p2;
    char * pa, * pb;

    p1 = a;
    p2 = b;

    n = 4;
    swap (&p1, &p2);
    pa = p2;
    pb = p1;
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 