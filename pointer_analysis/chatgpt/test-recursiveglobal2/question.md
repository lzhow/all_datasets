You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    char *p;
char *q;

void recursion (unsigned);
void swap(unsigned);

void swap(unsigned i) {
    char * c = p;
    p = q;
    q = c;

    recursion (i --);
}


void recursion(unsigned i) {
    if (i == 0) {
        return;
    }
    swap(i);
}

int main () {
    char a[10];
    char b[10];

    p = a;
    q = b;

    recursion(10);
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 