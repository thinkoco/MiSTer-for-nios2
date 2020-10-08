#include "sys/alt_stdio.h"
#include "system.h"

typedef struct
{
	unsigned long int DATA;
	unsigned long int DIRECTION;
	unsigned long int INTERRUPT_MASK;
	unsigned long int EDGE_CAPTURE;
}PIO_STR;

#define LED ((volatile PIO_STR *) PIO_LED_BASE)
#define mister_addr ((volatile unsigned char *) MISTER_SDRAM_BASE)
unsigned char mask = 1;
int main()
{
  //int i;
  alt_putstr("Hello from Nios II!\n");

  /* Event loop never exits. */
  while (1){
	  LED->DATA = mask;
	  mask = (mask << 1) | (mask >> 7);
	  //alt_printf("mask data is %d!\n",mask);
	  for(int i=0;i < 1000000;i++){
	  };

  };

  return 0;
}
