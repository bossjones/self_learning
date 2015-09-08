#include "tch.h"
#include "ush.h"
#include <linux/limits.h>
#define PROMPT "ush> "

static void prompt(void);

int main(void)
{
	char *input;
	struct command *cmd;
	pid_t pid;
	
	for ( ; ; ) {
		prompt();
		if ((input = getinput()) == NULL) {
			DP("%s", "getinput error");
			continue; /* read error */
		}
		if ((cmd = cmd_creat(input)) == NULL) {
			DP("%s", "cmd_creat error");
			continue;
		}
		if ((pid = fork()) < 0) {
			DP("%s", "fork error");
			continue;
		} else if (pid == 0) { /* child */
			cmd_exec(cmd);			
		} else {
			(void)wait(NULL);
		}
		
		cmd_free(cmd);
	}
	return 0;
}

/* prompt: print prompt to stdout */
static void prompt(void)
{
	fprintf(stdout, "%s", PROMPT);
}