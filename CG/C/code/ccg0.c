#include <stdio.h>
void readInput(int *id, int *noOfHours, int *payRate);
void printOutputs(int id, double grossPay);
double computeSalary1(int noOfHours, int payRate);
void computeSalary2(int noOfHours, int payRate, double *grossPay);

int main()
{
   int id = -1, noOfHours, payRate;
   double grossPay;
   readInput(&id, &noOfHours, &payRate);
   while (id != -1)
   {
      grossPay = computeSalary1(noOfHours, payRate);
      computeSalary2(noOfHours, payRate, &grossPay);
      readInput(&id, &noOfHours, &payRate);
   }
   return 0;
}
void readInput(int *id, int *noOfHours, int *payRate)
{
   scanf("%d", id);

   if (*id == -1)
      return;
   scanf("%d", noOfHours);
   scanf("%d", payRate);
   if (*noOfHours < 0 || *payRate < 0)
      *id = -1;
}
void printOutputs(int id, double grossPay)
{
   ;
}
double computeSalary1(int noOfHours, int payRate)
{
   return noOfHours * payRate;
}
void computeSalary2(int noOfHours, int payRate, double *grossPay)
{
   *grossPay = noOfHours * payRate;
}