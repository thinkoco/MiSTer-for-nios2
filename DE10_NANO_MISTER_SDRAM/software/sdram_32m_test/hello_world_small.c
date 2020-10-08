#include <stdio.h>
#include "system.h"
#include "string.h"

unsigned char * ram8 = (unsigned char *)(MISTER_SDRAM32M_BASE);
unsigned short * ram16 = (unsigned short *)(MISTER_SDRAM32M_BASE);
unsigned int * ram32 = (unsigned int *)(MISTER_SDRAM32M_BASE);

int main(void)
{
int i;

for(i=0;i<100;i++){
	*(ram8++) = i;
}

for(i=0;i<100;i++){
	printf("%d\n",*(--ram8));
}

for(i=0;i<100;i++){
	*(ram16++) = i+256;
}

for(i=0;i<100;i++){
	printf("%x\n",*(--ram16));
}

for(i=0;i<100;i++){
	*(ram32++) = i+10000;
}

for(i=0;i<100;i++){
	printf("%d\n",*(--ram32));
}
return 0;
}
