#Pull base image

FROM resin/rpi-raspbian  as build_env

RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    tk-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline6-dev \
    libdb5.3-dev \
    libgdbm-dev \
    libsqlite3-dev \
    libssl-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    zlib1g-dev \
    libffi-dev \
    libc6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && wget -O openssl.tar.gz https://github.com/openssl/openssl/archive/OpenSSL_1_1_1d.tar.gz \
    && tar xvfz openssl.tar.gz \
    && cd openssl-OpenSSL_1_1_1d \
    && ./config --openssldir=/usr/local/ssl \
    && make \
    && make install \
    \
    && mv /usr/bin/openssl /usr/bin/openssl.bak \
    && ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl \
    && echo /usr/local/lib >> /etc/ld.so.conf.d/usrlocal.conf \
    && ldconfig 
   
RUN set -ex \
    && wget https://www.python.org/ftp/python/3.7.5/Python-3.7.5.tgz \
    && tar zxvf Python-3.7.5.tgz \
    && cd Python-3.7.5 \
    && ./configure \
        --prefix=/usr/local \
        --without-ensurepip \
    && make \
    && make install 

RUN set -ex \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py
    
FROM resin/rpi-raspbian:latest

COPY --from=build_env /usr/local/ /usr/local/

RUN set -ex apt-get update \
    && touch /etc/ld.so.conf.d/usrlocal.conf \
    && echo /usr/local/lib >> /etc/ld.so.conf.d/usrlocal.conf \
    && ldconfig \

# Define working directory 
WORKDIR /work

# Define default command
CMD ["bash"]
