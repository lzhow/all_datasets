#include <stdlib.h>
typedef struct Point
{
  int x;
  int y;
} Point;

void main(){
  Point *a = (Point *)malloc(sizeof(Point));
  a->x = 2;
  a->y = 1;
}