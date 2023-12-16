You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

typedef struct subagg1{
    int *d;
}subagg1;

typedef struct agg1{
    int *c;
    subagg1 sub;
}agg1;

int main(){
    int *a,*b,k1,k2;
    agg1 g1,g2;
    agg1 *g = &g1;

    if(k1){
        g = &g2;
        a = &k1;
    }
    else{
        a = &k2;
    }

    g->sub.d = a;
    // MAYALIAS(g1.sub.d,&k2);
    // MAYALIAS(g2.sub.d,&k1);
    // NOALIAS(g1.sub.d,&k1);
    // NOALIAS(g2.sub.d,&k2);

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 