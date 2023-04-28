#!/bin/sh

# data
mkdir "/data"
mkdir "/data/ftp"

# drop
docker rmi -f "alpine-ftp-server"

# build
docker build --no-cache -t "alpine-ftp-server" "/data/container/alpine-ftp-server/."

# ip
ip=$(curl ifconfig.me)
echo $ip

# config
FTP_USER="user"
FTP_PASS="password"

# drop
docker rm -f "ftp"

# run
docker run --name "ftp" \
	-v "/data/ftp":"/data/ftp" \
	-v "/data/ftp":"/home/${FTP_USER}" \
	-e "FTP_USER=${FTP_USER}" \
	-e "FTP_PASS=${FTP_PASS}" \
	-e "PASV_ADDRESS=${ip}" \
	-e "PASV_MIN=21100" \
	-e "PASV_MAX=21110" \
	-p 21:21 \
	-p 21100-21110:21100-21110 \
	--memory=1g \
	--cpus=1.0 \
	--restart=always \
	-d "alpine-ftp-server":"latest"

# attach
docker attach "ftp"
docker exec -it "ftp" "/bin/bash"

# start
docker start "ftp"

#
