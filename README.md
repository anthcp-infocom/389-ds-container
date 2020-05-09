# 389-ds-container
The Docker container is based on https://build.opensuse.org/package/view_file/home:firstyear/389-ds-container/Dockerfile?expand=1.

The startup was modified to;
* Start the ns-slapd program in a consistent manner by deleting stale locks before startup! (Actually this may be redundant it looks like this was caused by the lack of SIGTERM handler in dscontainer...
* Added SIGTERM handling to ensure gracefull shutdown of LDAP process in Docker. This lack of this resulting in a correct LDAP database on shutdown until this was added!
* Added try/except to healthcheck to catch any "can't talk to LDAP server" errors..  
 
