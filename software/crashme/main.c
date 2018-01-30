// The Potato Processor Benchmark Applications
// (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
// Report bugs and issues on <https://github.com/skordal/potato/issues>

#include <stdint.h>

#include "platform.h"
#include "uart.h"

static struct uart uart0;


void exception_handler(uint32_t cause, void * epc, void * regbase)
{
	while(uart_tx_fifo_full(&uart0));
	uart_tx(&uart0, 'E');
}


/* Crashes if using int. Does not crash if using unsigned int
 * Crashes if using O0, does not crash if using other optimizations
 * Only crashes if argument is 0x80000000
 */
uint32_t crashBuffer[2];
void crashTest(int val)
{
	crashBuffer[1] = (val/10) % 10;
}

int main(void)
{
	
	uart_initialize(&uart0, (volatile void *) PLATFORM_UART0_BASE);
	uart_set_divisor(&uart0, uart_baud2divisor(115200, PLATFORM_SYSCLK_FREQ));
	
	while(1){
		while(uart_tx_fifo_full(&uart0));
		uart_tx(&uart0, 'A');
		
		crashTest(0x80000000);
		
		while(uart_tx_fifo_full(&uart0));
		uart_tx(&uart0, 'B');
	}
	
	return 0;
}

