/** SSD sample application for Potato Processor
 * david.siorpaes@gmail.com
 */

#include <stdio.h>
#include <stdint.h>

#include "platform.h"
#include "ssd.h"

#define TXR *((volatile uint32_t*)(0xc0007000))
#define RXR *((volatile uint32_t*)(0xc0007004))
#define DIV *((volatile uint32_t*)(0xc0007008))
#define BSY *((volatile uint32_t*)(0xc000700c))

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
	unsigned int val = 0;

	/* Set SPI divisor */
	DIV = 100;

	ssdPrintInt(DIV);
	delay(1000);
	
	while(1){
		/* Send data over SPI */
		TXR = val & 0xff;

		/* Wait until completed */
		while(BSY);

		/* Read data sent by slave and print it on SSD */
		ssdPrintInt(RXR);

		delay(50);
		
		val++;
	}

	return 0;
}

