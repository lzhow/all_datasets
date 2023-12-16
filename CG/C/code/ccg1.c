#include <stdio.h>
#include <string.h>
#define MAX 100
typedef struct
{
   char name[40];
   char telno[40];
   int id;
   double salary;
} Employee;
int readin(Employee *p);
void printEmp(Employee *p, int size);
int search(Employee *p, int size, char *target);
int addEmployee(Employee *p, int size, char *target);
int main()
{
   Employee emp[MAX];
   char name[10];
   int k, size, found = 0, ans, choice, result;
   do
   {
      scanf("%d", &choice);
      switch (choice)
      {
      case 1:
         size = readin(emp);
         break;
      case 2:
         scanf("\n");
         gets(name);
         result = search(emp, size, name);
         if (result != 1)
            break;
      case 3:
         scanf("\n");
         gets(name);
         result = search(emp, size, name);
         if (result != 1)
            size = addEmployee(emp, size, name);
         else
            ;
         break;
      case 4:
         printEmp(emp, size);
         break;
      default:
         break;
      }
   } while (choice < 5);
   return 0;
}
int readin(Employee *p)
{
   int i = 0;

   getchar();
   gets(p[0].name);

   while (strcmp(p[i].name, "#") != 0)
   {
      gets(p[i].telno);
      scanf("%d", &p[i].id);
      scanf("%lf", &p[i].salary);
      i++;
      getchar();
      gets(p[i].name);
   }

   return i ? i : 0;
}
void printEmp(Employee *p, int size)
{
   int i;

   if (size > MAX)
      return;

   for (i = 0; i < size; i++)
   {
      ;
   }
}
int search(Employee *p, int size, char *target)
{
   int i;

   if (size > MAX)
      return 0;

   for (i = 0; i < size; i++)
   {
      if (strcmp(p[i].name, target) == 0)
      {
         return 1;
      }
   }

   return 0;
}
int addEmployee(Employee *p, int size, char *target)
{
   if (size > MAX)
      size = 0;

   strcpy(p[size].name, target);
   gets(p[size].telno);
   scanf("%d", &p[size].id);
   scanf("%lf", &p[size].salary);

   return ++size;
}