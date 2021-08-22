FROM fithwum/debian-base:bullseye
MAINTAINER fithwum

ARG USER_ID=99
ARG GROUP_ID=100

ENV FTP_USER **String**
ENV FTP_PASS **Random**
ENV PASV_ADDRESS **IPv4**
ENV PASV_ADDR_RESOLVE NO
ENV PASV_ENABLE YES
ENV PASV_MIN_PORT 21100
ENV PASV_MAX_PORT 21110
ENV XFERLOG_STD_FORMAT NO
ENV LOG_STDOUT **Boolean**
ENV FILE_OPEN_MODE 0666
ENV LOCAL_UMASK 077
ENV REVERSE_LOOKUP_ENABLE YES
ENV PASV_PROMISCUOUS NO
ENV PORT_PROMISCUOUS NO

# URL's for files
ARG INSTALL_SCRIPT=https://raw.githubusercontent.com/fithwum/ftp-server/master/files/Install_Script.sh

# Install & Update
RUN apt-get -y update \
	&& apt-get install -y vsftpd iproute2 \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# folder creation.
RUN mkdir -p /ftp-server-temp /home/vsftpd \
	&& chmod 777 -R /ftp-server-temp \
	&& chown 99:100 -R /ftp-server-temp \
	&& chown -R 99:100 /home/vsftpd/
ADD "${INSTALL_SCRIPT}" /ftp-server-temp
RUN chmod +x /ftp-server-temp/Install_Script.sh

# directory where data is stored
VOLUME /home/vsftpd
VOLUME /var/log/vsftpd

# 25565 default.
EXPOSE 20/tcp 21/tcp

# Run command
CMD [ "/bin/bash", "./ftp-server-temp/Install_Script.sh" ]
