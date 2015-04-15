#asterisk from ubuntu 
#

FROM dockerfile/ubuntu

#maintainer
MAINTAINER Achyut Devkota "achyut.devkota@yipl.com.np"

#downloading dependencies
RUN echo 'Installing dependencies'
RUN apt-get install build-essential wget libssl-dev libncurses5-dev  libnewt-dev  libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev libjansson-dev subversion
#Download asterisk 
RUN cd /usr/src/
RUN wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
RUN wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz
RUN wget http://downloads.asterisk.org/pub/telephony/libss7/libss7-2.0-current.tar.gz
RUN wget http://downloads.asterisk.org/pub/telephony/certified-asterisk/certified-asterisk-13.1-current.tar.gz

#extract zip file
RUN tar zxvf dahdi-linux-complete-current.tar.gz
RUN tar zxvf libpri-1.4-current.tar.gz
RUN tar zxvf certified-asterisk-13.1-current.tar.gz

#Install Dahdi
RUN cd /usr/src/dahdi-linux*
RUN make && make install && make config

#Install PRI and SS7
RUN cd /usr/src/libpri*
RUN make && make install
RUN cd /usr/src/libss7-2.0.0
RUN make && make install

#Install Asterisk
RUN cd /usr/src/certified-asterisk-13.1-cert1 
RUN ./configure && make menuselect && make && make install && make config && make samples
#make menuselect generates selection window and has to select required addon/plugin for asterisk 

RUN mkdir -p startup 
ADD docker-startup.sh /startup/docker-startup.sh

#Start asterisk
CMD /bin/sh /startup/docker-startup.sh
