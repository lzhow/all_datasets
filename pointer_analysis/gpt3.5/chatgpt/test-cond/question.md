You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    char g1;
char g2;

int cond();

void f1(char **p) {
        //char *tmp = *p;
        if (cond()) *p = &g2;
}

char *f2() {
        char *p = &g1;
            f1(&p);
                return p;
} 
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 