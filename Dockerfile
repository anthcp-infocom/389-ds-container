#!BuildTag: 389-ds-container
FROM opensuse/tumbleweed:latest
MAINTAINER wbrown@suse.de

EXPOSE 3389 3636

# RUN zypper ar -G obs://network:ldap network:ldap
# RUN zypper mr -p 97 "network:ldap"
# RUN zypper --gpg-auto-import-keys ref
# RUN zypper ar http://download.opensuse.org/update/leap/15.1/oss/ u && \
#     zypper ar http://download.opensuse.org/distribution/leap/15.1/repo/oss/ m && \
#     zypper ar http://download.opensuse.org/repositories/network:ldap/openSUSE_Leap_15.1/         "network:ldap" && \

RUN zypper in -y 389-ds

RUN mkdir -p /data/config && \
    mkdir -p /data/ssca && \
    mkdir -p /data/run && \
    mkdir -p /var/run/dirsrv && \
    ln -s /data/config /etc/dirsrv/slapd-localhost && \
    ln -s /data/ssca /etc/dirsrv/ssca && \
    ln -s /data/run /var/run/dirsrv

COPY dscontainer /usr/lib/dirsrv/

# Temporal volumes for each instance
VOLUME /data

HEALTHCHECK --start-period=5m --timeout=5s --interval=5s --retries=2 \
    CMD /usr/lib/dirsrv/dscontainer -H

CMD [ "/usr/lib/dirsrv/dscontainer", "-r" ]
