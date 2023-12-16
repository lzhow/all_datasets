You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    int main(){
    int *p, *s,*r,*w,*q,*x;
    int ***m,**n,*z,*y,z1,y1;

    m=&n;
    n=&z;
    *m=&y;
    z=&z1;
    y=&y1;
    ***m=10;
    z=**m;
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 