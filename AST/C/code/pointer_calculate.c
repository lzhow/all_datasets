void main()
{
  int numbers[5] = {1, 2, 3, 4, 5};
  int *ptr = numbers;

  printf("%d\n", *ptr); 

  ptr++;             
  printf("%d\n", *ptr); 
}