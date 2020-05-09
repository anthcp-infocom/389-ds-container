# 389-ds-container
The Docker container to run the 389ds LDAP server is based on https://build.opensuse.org/package/view_file/home:firstyear/389-ds-container/Dockerfile?expand=1.

The container startup program (dscontainer) was modified to;
* Start the ns-slapd program in a consistent manner by deleting stale locks before startup! (Actually this may be redundant as it looks like this was caused by the lack of SIGTERM handler in dscontainer...
* Added SIGTERM handling to ensure the gracefull shutdown of LDAP process in Docker. This fix stopped the corruption of the LDAP database on container shutdown (why was this missing in the first place?) 
* Added try/except to healthcheck to catch any "can't talk to LDAP server" that caused pythonic stack dump errors instaed of just returning false!..  

An example docker-compose.yml
```version: '3'

services:
    # LDAP server    
    ldap:
         environment:
           - DS_DM_PASSWORD=${DS_DM_PASSWORD}
         image: infocomsystems/389ds
         ports:
             - "389:3389"
             - "636:3636"
#         command: /bin/bash -c '/usr/lib/dirsrv/dscontainer -r ; tail -f /dev/null'
         volumes:
            - ${CONFIG}:/data:Z
         stop_grace_period: 1m30s
```
Never force this container to shutdown (e.g with a SIGINT) or it may corrupt the LDAP database

This is the output on startup...
```ldap_1  | INFO: The 389 Directory Server Container Bootstrap
ldap_1  | INFO: Inspired by works of: ITS, The University of Adelaide
ldap_1  | INFO: 389 Directory Server Version: 1.4.3.4
ldap_1  | INFO: Checking for PEM TLS files ...
ldap_1  | INFO: Have /data/tls/server.key -> False
ldap_1  | INFO: Have /data/tls/server.crt -> False
ldap_1  | INFO: Have /data/tls/ca -> False
ldap_1  | INFO: Have /data/config/pwdfile.txt -> True
ldap_1  | INFO: Unable to configure TLS from PEM, missing a required file.
ldap_1  | INFO: Starting 389-ds-container ...
ldap_1  | INFO: Clearing stale lock directory...
ldap_1  | INFO: Starting process /usr/sbin/ns-slapd -D /etc/dirsrv/slapd-localhost -i /data/run/slapd-localhost.pid -d 266354688
ldap_1  | INFO: Waiting 5 seconds for ldap subprocess to start
ldap_1  | DEBUG: Allocate local instance <class 'lib389.DirSrv'> with None
ldap_1  | DEBUG: systemd status -> False
ldap_1  | DEBUG: pid file -> 7
ldap_1  | DEBUG: Pid of 7 for localhost and running
ldap_1  | DEBUG: open(): Connecting to uri ldapi://%2Fdata%2Frun%2Fslapd-localhost.socket
ldap_1  | DEBUG: Using dirsrv ca certificate /etc/dirsrv/slapd-localhost
ldap_1  | DEBUG: Using external ca certificate /etc/dirsrv/slapd-localhost
ldap_1  | DEBUG: Using external ca certificate /etc/dirsrv/slapd-localhost
ldap_1  | DEBUG: Using certificate policy 1
ldap_1  | DEBUG: ldap.OPT_X_TLS_REQUIRE_CERT = 1
ldap_1  | DEBUG: open(): Using root autobind ...
ldap_1  | DEBUG: Allocate local instance <class 'lib389.DirSrv'> with None
ldap_1  | DEBUG: systemd status -> False
ldap_1  | DEBUG: pid file -> 7
ldap_1  | DEBUG: Pid of 7 for localhost and running
ldap_1  | DEBUG: open(): Connecting to uri ldapi://%2Fdata%2Frun%2Fslapd-localhost.socket
ldap_1  | DEBUG: Using dirsrv ca certificate /etc/dirsrv/slapd-localhost
ldap_1  | DEBUG: Using external ca certificate /etc/dirsrv/slapd-localhost
ldap_1  | DEBUG: Using external ca certificate /etc/dirsrv/slapd-localhost
ldap_1  | DEBUG: Using certificate policy 1
ldap_1  | DEBUG: ldap.OPT_X_TLS_REQUIRE_CERT = 1
ldap_1  | DEBUG: open(): Using root autobind ...
ldap_1  | DEBUG: open(): bound as cn=Directory Manager
ldap_1  | DEBUG: Retrieving entry with [('',)]
ldap_1  | DEBUG: Retrieved entry [dn: 
ldap_1  | vendorVersion: 389-Directory/1.4.3.4 B2020.077.00
ldap_1  | 
ldap_1  | ]
ldap_1  | INFO: Applying environment configuration (if present) ...
ldap_1  | DEBUG: Allocate local instance <class 'lib389.DirSrv'> with None
ldap_1  | DEBUG: open(): Connecting to uri ldapi://%2Fdata%2Frun%2Fslapd-localhost.socket
ldap_1  | DEBUG: Using dirsrv ca certificate /etc/dirsrv/slapd-localhost
ldap_1  | DEBUG: Using external ca certificate /etc/dirsrv/slapd-localhost
ldap_1  | DEBUG: Using external ca certificate /etc/dirsrv/slapd-localhost
ldap_1  | DEBUG: Using certificate policy 1
ldap_1  | DEBUG: ldap.OPT_X_TLS_REQUIRE_CERT = 1
ldap_1  | DEBUG: open(): Using root autobind ...
ldap_1  | DEBUG: open(): bound as cn=Directory Manager
ldap_1  | DEBUG: Retrieving entry with [('',)]
ldap_1  | DEBUG: Retrieved entry [dn: 
ldap_1  | vendorVersion: 389-Directory/1.4.3.4 B2020.077.00
ldap_1  | 
ldap_1  | ]
ldap_1  | INFO: Using DS_DM_PASSWORD env var for Directory Manager password
ldap_1  | DEBUG: cn=config set REPLACE: ('nsslapd-rootpw', '********')
ldap_1  | INFO: 389-ds-container started.
``` 
