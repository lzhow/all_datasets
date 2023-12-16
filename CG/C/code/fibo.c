#include <stdio.h>

// 函数声明
int fibonacci(int n);

int main()
{
  int n = 10;
  printf("Fibonacci of %d: %d\n", n, fibonacci(n));
  return 0;
}

// 函数定义
int fibonacci(int n)
{
  if (n <= 1)
    return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}
