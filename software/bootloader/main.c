// The Potato Processor Benchmark Applications
// (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
// Report bugs and issues on <https://github.com/skordal/potato/issues>

#include <stdint.h>

#include "platform.h"
#include "uart.h"

#define APP_START (0xffffc000)
#define APP_LEN   (0x2000)
#define APP_ENTRY (0xffffc200)

static struct uart uart0;


void exception_handler(uint32_t cause, void * epc, void * regbase)
{
	while(uart_tx_fifo_full(&uart0));
	uart_tx(&uart0, 'E');
}


int main(void)
{
	const char* hello_string = "\n\r  ** Welcome to Potato chip ! **\n\r";
	const char* boot_string = "\n\rBooting\n\r";

	uart_initialize(&uart0, (volatile void *) PLATFORM_UART0_BASE);
	uart_set_divisor(&uart0, uart_baud2divisor(115200, PLATFORM_SYSCLK_FREQ));

	/* Print welcome message */
	for(int i = 0; hello_string[i] != 0; ++i){
		while(uart_tx_fifo_full(&uart0));
		uart_tx(&uart0, hello_string[i]);
	}
	
	/* Read application from UART and store it in RAM */
	for(int i = 0; i<APP_LEN; i++){

		/* Fill RAM */
		while(uart_rx_fifo_empty(&uart0));
		*((uint8_t*)(APP_START + i)) = uart_rx(&uart0);

#if 0
		/* Print some dots */
		while(uart_tx_fifo_full(&uart0));
		uart_tx(&uart0, '.');

		if((i % 80) == 0){
			while(uart_tx_fifo_full(&uart0));
			uart_tx(&uart0, '\n');
			while(uart_tx_fifo_full(&uart0));
			uart_tx(&uart0, '\r');
		}
#endif
	}

	/* Print booting message */
	for(int i = 0; boot_string[i] != 0; ++i){
		while(uart_tx_fifo_full(&uart0));
		uart_tx(&uart0, boot_string[i]);
	}

	
	/* Jump in RAM */
	goto *APP_ENTRY;

	return 0;
}

