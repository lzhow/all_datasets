You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    extern void * malloc(unsigned);


typedef struct{
    int * b;
    int * a;
} basestruct;

typedef struct {
    int * b;
    basestruct * a;
    unsigned temp;
} extendstruct;

extendstruct gvar[10];

int * saveptr[5];
int i;

void save(basestruct ** var) {
    unsigned idx = i;
    int * temp = var;
    saveptr[idx] = (int *)(var);
    saveptr[idx+1] = (int *)(*var);
}

void f() {
    gvar[0].a = malloc(sizeof(basestruct));
    save (&gvar[0]);

    basestruct * temp = saveptr[i];
    extendstruct * t1 = (extendstruct *) temp;

    basestruct * t2 = t1->a;
    *(t2->a) = 0;
}



 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 