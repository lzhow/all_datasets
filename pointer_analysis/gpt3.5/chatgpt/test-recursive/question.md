You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    struct list {
    unsigned field;
    struct list * next;
    struct list * prev;
};

extern void * malloc(unsigned);
struct list * construct (struct list * head, unsigned i) {
    if (i > 0) {
        struct list * tmp = malloc(sizeof(struct list));
        tmp->field = 0;
        tmp->next = head;
        head->prev = tmp;
        tmp->prev = 0;

        return construct (tmp, i--);


    } 
    return head;
}

int main () {
    struct list * head;


    head = malloc(sizeof(struct list));
    head->field = 0;
    head->next = 0;
    head->prev = 0;

    head = construct (head, 10);
}


 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 