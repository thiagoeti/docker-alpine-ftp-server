#++++++++++++++++++++++++++++++++++++++
# Docker/Podman - Alpine - FTP Server
#++++++++++++++++++++++++++++++++++++++

# so
FROM alpine:latest

# by
MAINTAINER Thiago Silva - thiagoeti@gmail.com

# update
RUN apk --no-cache update && apk --no-cache upgrade

# bash
RUN apk add bash

# library
RUN apk add vsftpd

# environment
ENV FTP_USER=user \
	FTP_PASS=password \
	PASV_ADDRESS=127.0.0.1 \
	PASV_MIN_PORT=21100 \
	PASV_MAX_PORT=21110

# config
RUN echo "local_enable=YES" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "chroot_local_user=YES" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "allow_writeable_chroot=YES" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "background=NO" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "ftpd_banner=Welcome to FTP Server" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "dirmessage_enable=YES" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "max_clients=10" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "max_per_ip=5" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "write_enable=YES" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "local_umask=022" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "passwd_chroot_enable=yes" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "pasv_enable=Yes" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "listen_ipv6=NO" >> "/etc/vsftpd/vsftpd.conf" && \
	echo "seccomp_sandbox=NO" >> "/etc/vsftpd/vsftpd.conf" && \
	sed -i "s/anonymous_enable=YES/anonymous_enable=NO/" /etc/vsftpd/vsftpd.conf

# www
RUN mkdir /data

# exec
COPY "vsftpd.sh" "/data"
RUN chmod +x "/data/vsftpd.sh"

# work
WORKDIR /data

# port
EXPOSE 21 21100-21110

# start
CMD ["/data/vsftpd.sh"]

#
