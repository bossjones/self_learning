/* orginal file: ../intro/daytimetcpsrv1.c */ 
#include "unp.h" 
#include <time.h> 

#define PORT 9999

int 
main(int argc, char **argv) 
{ 
	int listenfd, connfd; 
	socklen_t len; 
	struct sockaddr_in servaddr, cliaddr; 
	char buff[MAXLINE]; 
	time_t ticks; 
 
	listenfd = Socket(AF_INET, SOCK_STREAM, 0); 
 
	bzero(&servaddr, sizeof(servaddr)); 
	servaddr.sin_family = AF_INET; 
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY); 
	servaddr.sin_port = htons(PORT); 
 
	/* Bind(listenfd, (SA *) &servaddr, sizeof(servaddr));  */

	Listen(listenfd, LISTENQ); 

	len = (socklen_t)sizeof(servaddr);
	getsockname(listenfd, &servaddr, &len);
	pp_sock((SA *) &servaddr, (socklen_t)sizeof(servaddr)); 

	for ( ; ; ) { 
		len = sizeof(cliaddr); 
		connfd = Accept(listenfd, (SA *) &cliaddr, &len); 
		printf("connection from %s, port %d\n", 
		       Inet_ntop(AF_INET, &cliaddr.sin_addr, buff, sizeof(buff)), 
		       ntohs(cliaddr.sin_port)); 
 
		ticks = time(NULL); 
		snprintf(buff, sizeof(buff), "%.24s\r\n", ctime(&ticks)); 
		Write(connfd, buff, strlen(buff)); 
 
		Close(connfd); 
	} 
} 
