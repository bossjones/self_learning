#include "apue.h"
#include <stdarg.h>

/* msg: write fmt string to stderr */
void msg(const char *fmt, ...)
{
	va_list		ap;

	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	fprintf(stderr, "\n");
	va_end(ap);
}
