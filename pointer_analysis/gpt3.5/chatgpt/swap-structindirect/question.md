You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    struct ptrstruct{
    int temp;
    char * p1;
    char *p2;
}; 

void swap(struct ptrstruct ** pstruct) {
   struct ptrstruct *P = *pstruct;
   char * c;
   c = P->p1;
   P->p1 = P->p2;
   P->p2 = c;
}

 

int main (){
    struct ptrstruct PSt;
    struct ptrstruct * pstruct = &PSt;
    char * pa, * pb;
    char b[20];
    char a[20];
 
    PSt.p1 = a;
    PSt.p2 = b;

    swap (&pstruct);
    pa = PSt.p2;
    pb = PSt.p1;
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 