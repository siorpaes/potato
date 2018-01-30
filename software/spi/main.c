/** SSD sample application for Potato Processor
 * david.siorpaes@gmail.com
 */

#include <stdio.h>
#include <stdint.h>

#include "platform.h"
#include "ssd.h"

#define TXR *((uint32_t*)(0xc0007000))
#define RXR *((uint32_t*)(0xc0007004))
#define DIV *((uint32_t*)(0xc0007008))
#define BSY *((uint32_t*)(0xc000700c))

void exception_handler(uint32_t cause, void * epc, void * regbase)
{

}


void delay(int delay)
{
	volatile int i;

	while(delay--)
		for(i=0; i<1000; i++);
}


int main(void)
{
	uint32_t val = 0;

	DIV = 128;
	ssdPrintInt(DIV);
	
	while(1){
		TXR = val & 0xff;
		val++;
		delay(50);
	}

	return 0;
}

