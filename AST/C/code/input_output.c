#include <stdio.h>

int main()
{
  char str[100];
  int i;
  char ch;

  printf("Enter a string: ");
  fgets(str, sizeof(str), stdin);

  puts("You entered: ");
  puts(str);

  scanf("%d", &i);
  while ((getchar()) != '\n')
    ;

  ch = getchar();
  putchar(ch);
  putchar('\n');

  return 0;
}
