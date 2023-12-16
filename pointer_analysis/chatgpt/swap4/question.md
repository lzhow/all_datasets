You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
        char b[20];
    char a[20];
  
void swap(char **a, char **b) {
   char * c;
   c = *a;
   *a = * b;
   *b = c;
}

int main (){
    char * p1, *p2;
    char * pa, * pb;
 
    p1 = a;
    p2 = b;

    swap (&p1, &p2);
    swap (&p1, &p2);
    swap (&p2, &p1);
    swap (&p1, &p2);
    pa = p2;
    pb = p1;
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 