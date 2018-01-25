/** GPIO sample application for Potato Processor
 * david.siorpaes@gmail.com
 */

#include <stdint.h>

#include "platform.h"

#define DIGIT0 *((uint32_t*)(0xc0006000))
#define DIGIT1 *((uint32_t*)(0xc0006004))
#define DIGIT2 *((uint32_t*)(0xc0006008))
#define DIGIT3 *((uint32_t*)(0xc000600c))

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

