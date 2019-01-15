#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "strcpy.h"

int main(int argc, char **argv)
{
 char d1[14];
 char d2[14];
 int i;


 printf("align = %#x\n", (unsigned int)((unsigned long)d1 & (unsigned long)0x7));

 for (i=0; i < 10000; i++) {
   my_strcpy(d1, "hellozxxxxx");
   strcpy(d2,    "hellozxxxxx");
  }

  printf("dst1 = %s\n", d1);
  printf("dst2 = %s\n", d2);


}
