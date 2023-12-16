You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    struct list {
    struct list * prev;
};

struct list * construct (struct list * head) {
    int i;
   if (i > 0) {
       struct list * tmp = malloc(sizeof(struct list));
       head->prev = tmp;
       return construct (tmp);

    } 
    return head;
}
int main () {
    struct list * head;
    head = malloc(sizeof(struct list));
    head->prev = 0;

    head = construct (head);
    head = head->prev;
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 