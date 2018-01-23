/** GPIO sample application for Potato Processor
 * david.siorpaes@gmail.com
 */

#include <stdint.h>

#include "platform.h"
#include "gpio.h"

static struct gpio gpio0;

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

	gpio_initialize(&gpio0, (volatile void *) PLATFORM_GPIO_BASE);
	gpio_set_direction(&gpio0, 0xf << 8);
	
	while(1){
		gpio_set_pin(&gpio0, 8);
		gpio_set_pin(&gpio0, 9);
		gpio_set_pin(&gpio0, 10);
		gpio_set_pin(&gpio0, 11);
		delay(500);

		gpio_clear_pin(&gpio0, 8);
		gpio_clear_pin(&gpio0, 9);
		gpio_clear_pin(&gpio0, 10);
		gpio_clear_pin(&gpio0, 11);
		delay(500);
	}

	return 0;
}

