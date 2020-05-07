# 389-ds-container
The Docker container is based on https://build.opensuse.org/package/view_file/home:firstyear/389-ds-container/Dockerfile?expand=1.

The startup was modified to;
* Start the ns-slapd program in a consistent manner by deleting stale locks before startup!
* Added SIGTERM handling to ensure gracefull shutdown of LDAP process
 
