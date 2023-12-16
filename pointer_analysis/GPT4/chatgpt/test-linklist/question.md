You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    extern void * malloc(unsigned);
extern void free (void *);

struct list {
    int flag;
    struct list * next;
};

void destroy (struct list * head) {
    struct list * cur = head;
    while (cur->flag != -1) {
        cur = cur->next;
        free (cur);
    }
}

struct list * construct (unsigned idx) {
    struct list * head;
    unsigned i = 0;
    head = malloc(sizeof(struct list));
    head->next = 0;
    head->flag = -1;
    for (i =0; i<idx; i++){
        struct list * cur = malloc(sizeof(struct list));
        cur->flag = idx;
        cur->next = head;
        head = cur;
    }
    return head;
}

struct list * addlist (struct list * l, struct list * elem) {
    struct list * head = l;
    struct list * t;
    while (t = head->next) 
        head = t;

    head->next = elem;
    return l;
}

void main () {
    struct list * head;
    struct list * head1;
    head = construct (10);
    head1 = construct (2);

    if (head->flag == 5) 
        head1 = head;

    head = addlist(head, head1);

    destroy (head);
}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 