You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    typedef struct{
    int f1, f2;
}FOO;

int *z;

void f(int*x, FOO*y);

int main(){
    FOO *a,b;
    int *c;

    a=&b;
    c=&b.f1;
    f(a,c);

}

void f(int *x, FOO*y){
    z = &(y->f2);
    
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 