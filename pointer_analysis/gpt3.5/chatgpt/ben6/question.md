You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    void foo(int*,int*);
struct ss{
    int k;
    struct ss* p;
};

typedef struct gg{
int *f1;
int f2;
int f3;
//ss f4;
}gg;

  gg g2;  

int main(){
    int *a,*b,obj,t,k;
    gg g1;
  struct  ss s1;
  struct ss* s2;
  s2 = malloc(1);
  s2=&s1;
  s2->k=100;
    g1.f1 = &obj;
    a = &g1.f2;
    b=&g1.f3;
    foo(a,b);
}

void foo(int* x, int *y){
    *x = *y;
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 