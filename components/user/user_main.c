#include "user_interface.h"
#include <stdint.h>

int ets_printf(const char *format, ...)  __attribute__ ((format (printf, 1, 2)));


void user_pre_init(void)
{
}


void user_init(void)
{
  uint32_t heap = system_get_free_heap_size();
  ets_printf("Hello, esp8266!\nFree heap is %u\n", heap);
  for(;;)
    ;
}
