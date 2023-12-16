You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    void D(char ***ppp) { ***ppp = 0; }

void C(char ***ppp) { ***ppp = 0; }

void B(char ***ppp) { D(ppp); }

void A() {
  char c;
  char *p = &c;
  char **pp = &p;
  B(&pp);
  C(&pp);
} 
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 