You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    typedef struct node{
    char* s;
    struct node* tail;

}node_t;

typedef struct arc{
    node_t *tail;
    struct arc*next;

}art_t;

typedef struct agg1{
    int *k;
    
}agg1;


int main(){
    agg1 a1,a2;
    agg1 *a = &a1;
    agg1 *c = &a2;
    int obj,*b;
    a->k = &obj;
    c->k = a->k;
    b = c->k;
    *(c->k) =100;
    *b = 100;
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 