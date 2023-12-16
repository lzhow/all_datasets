#include <stdio.h>
void Bubble_sort(int arr[], int size)
{
  int j, i, tem;
  for (i = 0; i < size - 1; i++) 
  {
    int count = 0;
    for (j = 0; j < size - 1 - i; j++)
    {
      if (arr[j] > arr[j + 1]) 
      {
        tem = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = tem;
        count = 1;
      }
    }
    if (count == 0)
      break;
  }
}