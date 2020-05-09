# 389-ds-container
The Docker container to run the 389ds LDAP server is based on https://build.opensuse.org/package/view_file/home:firstyear/389-ds-container/Dockerfile?expand=1.

The container startup program (dscontainer) was modified to;
* Start the ns-slapd program in a consistent manner by deleting stale locks before startup! (Actually this may be redundant as it looks like this was caused by the lack of SIGTERM handler in dscontainer...
* Added SIGTERM handling to ensure the gracefull shutdown of LDAP process in Docker. This fix stopped the corruption of the LDAP database on container shutdown (why was this missing in the first place?) 
* Added try/except to healthcheck to catch any "can't talk to LDAP server" errors..  
 
