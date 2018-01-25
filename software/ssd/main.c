/** SSD sample application for Potato Processor
 * david.siorpaes@gmail.com
 */

#include <stdio.h>
#include <stdint.h>

#include "platform.h"
#include "ssd.h"


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

	while(1){
		DIGIT0 = (val/1)     % 10;
		DIGIT1 = (val/10)    % 10;
		DIGIT2 = (val/100)   % 10;
		DIGIT3 = (val/1000)  % 10;

		val++;

		delay(50);
	}

	return 0;
}

