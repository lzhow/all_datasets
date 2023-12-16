You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    struct node{
    int* number;

}node;

int main(){
    struct node node1,node2;
    struct node ** _node;
    struct node node_arr[10];
    int k,*a;
    _node = malloc(sizeof(node)*2);
    _node[0] = &node1;
    _node[1] = &node2;
    _node[0]->number = &k;
    *(_node[0]->number) = 1;

    node_arr[0].number = &k;
    *(node_arr[0].number) = 100;

}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 