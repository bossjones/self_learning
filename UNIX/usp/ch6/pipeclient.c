#include "tch.h"
#include <errno.h>
#include <fcntl.h>
#include <time.h>
#include "restart.h"

#ifndef PIPE_BUF
#define PIPE_BUF 255
#endif

int main(int argc, char *argv[])
{
	
	time_t curtime;
	int len;
	char buf[PIPE_BUF];
	int fd;

	if (argc != 2)
		err_quit("Usage: %s filename", argv[0]);

	if ((fd = open(argv[1], O_WRONLY)) == -1)
		err_sys("client: open logfile failed: %s", argv[1]);

	curtime = time(NULL);
	snprintf(buf, PIPE_BUF, "%d: %s", (int)getpid(), ctime(&curtime));
	len = strlen(buf);
	if (r_write(fd, buf, len) != len)
		err_sys("client: failed to write");
	r_close(fd);
	return 0;
} 
