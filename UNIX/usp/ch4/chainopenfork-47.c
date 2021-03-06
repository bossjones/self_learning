/* attribution: UNIX Systems Programming - Robbins and Robbins */
/* Program 4.19 */
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <string.h>

#define CREATE_FLAGS (O_WRONLY | O_CREAT | O_APPEND)
#define CREATE_PERMS (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)

int main(int argc, char *argv[])
{
	char buf[BUFSIZ];
	pid_t childpid = 0;
	int i, n;
	char *infile, *prog;
	FILE *fp;
	
	prog = argv[0];
	if (argc != 3) {
		fprintf(stderr, "Usage: %s process filename\n", prog);
		return 1;
	}

	infile = argv[2];
	fp = fopen(infile, "a+");
	/*fd = open(infile, CREATE_FLAGS, CREATE_PERMS);*/
	if (fp == NULL) {
		fprintf(stderr, "Failed to open file: %s", infile);
		return 1;
	}
	
	n = atoi(argv[1]);
	for (i = 0; i < n; i++) 
		if ((childpid = fork()))
			break;
	if (childpid == -1) {
		perror("Failed to fork");
		return 1;
	}
				/* write twice to common log file */
	sprintf(buf, "i:%d process:%ld parent:%ld child:%ld\n",
		i, (long)getpid(), (long)getppid(), (long)getpid());
	fprintf(fp, "%s", buf);
	return 0;
}

