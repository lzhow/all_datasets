You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    // #include "aliascheck.h"

int main(){

    int **p,*q;
    int *b,*c,d,e;

    p = &c;

c1:    if(e){
           p = &b;
           q = &d;
       }
       else if(b) {
           q = &e;
       }
       else if(c){
          printf("dummy branch\n");
       }
       else{
           goto c1;
       }

       *p = q;
    //    MAYALIAS(p,&c);
    //    MAYALIAS(p,&b);
    //    MAYALIAS(c,&e);
    //    MAYALIAS(b,&d);
    //    NOALIAS(c,&d);
    //    NOALIAS(b,&e);
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 