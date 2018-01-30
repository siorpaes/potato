/** SSD sample application for Potato Processor
 * david.siorpaes@gmail.com
 */

#include <stdio.h>
#include <stdint.h>

#include "platform.h"
#include "ssd.h"


void exception_handler(uint32_t cause, void * epc, void * regbase)
{
	ssdPrintInt(cause);
	while(1);
}


void delay(int delay)
{
	volatile int i;

	while(delay--)
		for(i=0; i<1000; i++);
}

int main(void)
{
	int val = 0;
	
	while(1){
		ssdPrintInt(val++);
		delay(50);
	}

	return 0;
}

