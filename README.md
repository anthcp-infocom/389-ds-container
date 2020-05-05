# 389-ds-container
The Docker conianer is based on https://build.opensuse.org/package/view_file/home:firstyear/389-ds-container/Dockerfile?expand=1.

The startup was modified to;
* Start the ns-slapd program in a consistant manner!
* Prevent the docker container closing if the prgram did not start (temp)


 
