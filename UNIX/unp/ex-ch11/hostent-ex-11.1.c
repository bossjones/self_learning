/* orginal file: ../names/hostent.c */ 
#include "unp.h" 

int main(int argc, char **argv) 
{ 
	char *ptr, **pptr; 
	char str[INET_ADDRSTRLEN]; 
	struct hostent *hptr;
				/* for gethostbyaddr */
	struct hostent *h; 
	struct in_addr *addr;

	while (--argc > 0) { 
		ptr = *++argv; 
		if ( (hptr = gethostbyname(ptr)) == NULL) { 
			err_msg("gethostbyname error for host: %s: %s", 
				ptr, hstrerror(h_errno)); 
			continue; 
		} 
		printf("official hostname: %s\n", hptr->h_name); 
 
		for (pptr = hptr->h_aliases; *pptr != NULL; pptr++) 
			printf("\talias: %s\n", *pptr); 
 
		switch (hptr->h_addrtype) { 
		case AF_INET: 
			pptr = hptr->h_addr_list; 
			for ( ; *pptr != NULL; pptr++) 
				printf("\taddress: %s\n", 
				       Inet_ntop(hptr->h_addrtype, *pptr, str, sizeof(str))); 
			break; 
 
		default: 
			err_ret("unknown address type"); 
			break; 
		} 
				/* call gethostbyaddr and print h_name */
		for (pptr = hptr->h_addr_list; *pptr != NULL; pptr++) {
			addr = (struct in_addr *) (*pptr);
			if ( (h = gethostbyaddr(addr, sizeof(struct in_addr),
						AF_INET)) == NULL) { 
				err_msg("gethostbyaddr error",
					ptr, hstrerror(h_errno)); 
				continue;
			}
			printf("h_name: %s\n", h->h_name); 
		}
	} 
	exit(0); 
} 
