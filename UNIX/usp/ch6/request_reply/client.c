#include "tch.h"
#include "rr.h"
#include <errno.h>
#include <linux/limits.h>

int rr_request_msg(pid_t pid, char **msg_loc);

int main(void)
{
	char *rq_fifo = RQ_FIFO; /* request */
	int rq_fd;
	char rq_buf[PIPE_BUF];
	char *rs_fifo;		/* response */
	int rs_fd;
	char rs_buf[PIPE_BUF];	

	pprint_hdr();	
				/* get rs_fifo name and make fifo */
	if (rr_pipe_name(getpid(), &rs_fifo))
		err_quit("rr_pipename error");
	if ((mkfifo(rs_fifo, PIPE_PERMS) == -1) && (errno != EEXIST))
		err_sys("mkfifo error");
	pprint_pid(0, "rs_fifo: %s", rs_buf);

				/* open rq_fifo and write message */
	if (rr_request_msg(getpid(), &rq_buf))
		err_quit("rr_request_msg");
	if ((rq_fd = open(rq_fifo, O_WRONLY)) == -1)
		err_sys("open error");
	pprint_pid(0, "writing: %s", rq_buf);
	Write(rq_fd, rq_buf, strlen(rq_buf));
	Close(rq_fd);
	
				/* get response from (fifo) server */
	rs_fd = Open(rs_fifo, O_RDONLY, O_CREAT);
	Read(rs_fd, rs_buf, PIPE_BUF);
	pprint_pid(0, "%s", rs_buf);
	Close(rs_fd);

	unlink(rs_fifo);
	return 0;
}

/* rr_request_msg: fill msg_loc with request message, 
   caller responsible freeing memory */
int rr_request_msg(pid_t pid, char **msg_loc)
{
	FILE *fp;
	char *buf;
	size_t size;

	if ((fp = open_memstream(&buf, &size)) == NULL)
		return -1;

	fprintf(fp, "%d", (int)pid);
	Fclose(fp);
	*msg_loc = buf;
	return 0;
}
