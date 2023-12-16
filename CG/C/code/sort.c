#include <stdio.h>

// 函数声明
void bubbleSort(int arr[], int n);
void selectionSort(int arr[], int n);
void sort(int arr[], int n, void (*sortFunction)(int[], int));

int main()
{
  int arr[] = {64, 34, 25, 12, 22, 11, 90};
  int n = sizeof(arr) / sizeof(arr[0]);

  sort(arr, n, bubbleSort);
  // sort(arr, n, selectionSort);

  for (int i = 0; i < n; i++)
    printf("%d ", arr[i]);
  printf("\n");

  return 0;
}

void bubbleSort(int arr[], int n)
{
  for (int i = 0; i < n - 1; i++)
    for (int j = 0; j < n - i - 1; j++)
      if (arr[j] > arr[j + 1]){
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
}

void selectionSort(int arr[], int n)
{
  int i, j, min_idx;
  for (i = 0; i < n - 1; i++)
  {
    min_idx = i;
    for (j = i + 1; j < n; j++)
      if (arr[j] < arr[min_idx])
        min_idx = j;

    int temp = arr[min_idx];
    arr[min_idx] = arr[i];
    arr[i] = temp;
  }
}

void sort(int arr[], int n, void (*sortFunction)(int[], int))
{
  sortFunction(arr, n);
}
