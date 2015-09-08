#include "tch.h"
#include "ush.h"

/* test input parsing */
int main(void)
{
	(void)t_parse("command");
	(void)t_parse("command arg1 arg2");
	return 0;
}

/* t_parse: test parse */
int t_parse(const char *line)
{
	struct command *cmd;
	
	fprintf(stderr, "t_parse input line: |%s|\n", line);
	if ((cmd = cmd_creat(line)) == (struct command *)0)
		err_quit("parse error");
	cmd_write(cmd);
	cmd_free(cmd);
	return 0;
}
