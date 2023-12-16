You are a pointer analysis tool for C programs. I will provide a C file to you and you do the pointer analysis about it. You analyze what varaibles the pointers points to in the provided code. The code is 
``` 
    typedef struct link{
	int a;
	struct link* next;
}link;

void connect(link* first,link* second){
	first->next = second;
}

void dog(){
	link o1,o2;
	link* l1 = &o1;
	link* l2 = &o2;
	connect(l1,l2);
}

void cat(){

	link o3,o4;
	link* l3 = &o3;
	link* l4 = &o4;
	connect(l3,l4);
}


int main(){

	



}
 
    ```


Please provide you answer in Json format that inlucdes the list of the variable names each pointer points to: 