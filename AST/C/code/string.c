#include <stdio.h>
#include <string.h>

int main()
{
  char str1[20] = "Hello";
  char str2[20] = "World";
  char str3[40];

  // strlen
  printf("Length of str1: %zu\n", strlen(str1));

  // strcpy and strncpy
  strcpy(str3, str1);
  strncpy(str3, str2, 3);
  str3[3] = '\0'; 
  printf("str3 after strncpy: %s\n", str3);

  // strcat and strncat
  strcat(str3, str2);
  strncat(str3, "!!!", 2);
  printf("str3 after strncat: %s\n", str3);

  // strcmp and strncmp
  printf("strcmp(str1, str2): %d\n", strcmp(str1, str2));
  printf("strncmp(str1, str2, 3): %d\n", strncmp(str1, str2, 3));

  // strchr and strrchr
  printf("First occurrence of 'l' in str1: %s\n", strchr(str1, 'l'));
  printf("Last occurrence of 'l' in str1: %s\n", strrchr(str1, 'l'));

  // strstr
  printf("Substring 'lo' in str1: %s\n", strstr(str1, "lo"));

  return 0;
}
