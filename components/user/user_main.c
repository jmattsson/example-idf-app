#include <stdio.h>

int ets_printf(const char *format, ...)  __attribute__ ((format (printf, 1, 2)));


void user_pre_init(void)
{
}


void user_init(void)
{
  ets_printf("Hello, esp8266!\n");
  for(;;)
    ;
}
