#include "platform.h"
#include "ssd.h"

/** Prints decimal value on SSD
 */
void ssdPrintInt(unsigned int val)
{
	DIGIT0 = (val/1)     % 10;
	DIGIT1 = (val/10)    % 10;
	DIGIT2 = (val/100)   % 10;
	DIGIT3 = (val/1000)  % 10;
}
