FROM ubuntu

# MAINTAINER Achyut Devkota "achyut.devkota@yipl.com.np"
MAINTAINER Luar Roji "cyberplant@roji.net"

RUN apt-get update && apt-get -fy install build-essential wget libssl-dev \
            libncurses5-dev libnewt-dev libxml2-dev libjansson-dev \
            linux-headers-$(uname -r) libsqlite3-dev uuid-dev \
            unzip

# NOTE: latest dahdi was failing, see: http://forums.asterisk.org/viewtopic.php?f=1&t=96455
# http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz \

RUN cd /usr/src/ && wget \
    http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-2.10.2+2.10.2.tar.gz \
    http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz \
    http://downloads.asterisk.org/pub/telephony/libss7/libss7-2.0-current.tar.gz \
    http://downloads.asterisk.org/pub/telephony/certified-asterisk/certified-asterisk-13.1-current.tar.gz \
    https://github.com/asterisk/pjproject/archive/master.zip && \
    for i in *tar.gz; do tar xvfz $i; rm $i; done && unzip master.zip && rm master.zip

RUN cd /usr/src/dahdi-linux* && make && make install && make config
RUN cd /usr/src/libpri* && make && make install
RUN cd /usr/src/libss7* && make && make install
RUN cd /usr/src/pjproject-master && \
    ./configure --enable-shared --prefix=/usr --libdir=/usr/lib \
                --disable-sound --disable-resample \
                --disable-video --disable-opencore-amr \
                CFLAGS='-O2 -DNDEBUG' && \
    make dep && make && make install

RUN cd /usr/src/certified-asterisk-13.1-cert* && \
    ./configure && \
    make menuselect.makeopts && \
    menuselect/menuselect --list-options && \
    make && \
    make install && make config && make samples

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

CMD /usr/sbin/asterisk -vvvvd
