You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    
extern void * malloc(unsigned);

char * ptrs[10];
void  my_malloc(unsigned idx, unsigned length) {
    char * a = malloc(length);
    free (ptrs[idx]);
    ptrs[idx] = a;
}

char * my_malloc1(unsigned idx, unsigned lenght) {
    static char * a = 0;

    my_malloc(idx, lenght);
    if (a != 0) {
        a = malloc(idx +1);
    } else {
       a = malloc(idx);
    }
    return a;
}


unsigned malloc2(unsigned idx, unsigned length){
    unsigned curidx;
    my_malloc(idx, length);
    my_malloc1(idx+1, length);
    curidx = idx +2; 
    if (curidx < 8) 
        return malloc2(curidx, length);
    return curidx;
}

int main () {

    malloc2(1, 10);
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 