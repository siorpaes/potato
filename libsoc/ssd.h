#include <stdint.h>

#define DIGIT0 *((volatile uint32_t*)(PLATFORM_SSD_BASE))
#define DIGIT1 *((volatile uint32_t*)(PLATFORM_SSD_BASE + 4))
#define DIGIT2 *((volatile uint32_t*)(PLATFORM_SSD_BASE + 8))
#define DIGIT3 *((volatile uint32_t*)(PLATFORM_SSD_BASE + 0xc))

void ssdPrintInt(unsigned int val);

