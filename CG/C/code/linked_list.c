#include <stdio.h>
#include <stdlib.h>

typedef struct Node
{
  int data;
  struct Node *next;
} Node;

Node *createNode(int data);
void insertNode(Node **head, int data);
void printList(Node *node);

int main()
{
  Node *head = NULL;
  insertNode(&head, 10);
  insertNode(&head, 20);
  insertNode(&head, 30);

  printList(head);

  return 0;
}

Node *createNode(int data)
{
  Node *newNode = (Node *)malloc(sizeof(Node));
  newNode->data = data;
  newNode->next = NULL;
  return newNode;
}

void insertNode(Node **head, int data)
{
  Node *newNode = createNode(data);
  newNode->next = *head;
  *head = newNode;
}

void printList(Node *node)
{
  while (node != NULL)
  {
    printf("%d ", node->data);
    node = node->next;
  }
  printf("\n");
}
