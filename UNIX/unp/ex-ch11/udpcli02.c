/* Authors: W. R. Stevens, B. Fenner, A. M. Rudoff */

#include	"unp.h"

/*
 * Run this client against server udpcliserv/udpserv01
 */  

int
main(int argc, char **argv)
{
	int					sockfd;
	struct sockaddr_in	servaddr;

	if (argc != 2)
		err_quit("usage: udpcli <IPaddress>");

	bzero(&servaddr, sizeof(servaddr));
#ifdef	HAVE_SOCKADDR_SA_LEN
	servaddr.sin_len = sizeof(servaddr);
#endif
	servaddr.sin_family = AF_INET;
	servaddr.sin_port = htons(argv[2]);
	Inet_pton(AF_INET, argv[1], &servaddr.sin_addr);

	sockfd = Socket(AF_INET, SOCK_DGRAM, 0);

	dg_cli(stdin, sockfd, (SA *) &servaddr, sizeof(servaddr));

	exit(0);
}