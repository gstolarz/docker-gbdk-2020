FROM ubuntu AS build

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bison flex g++ libboost-dev libz-dev make texinfo wget \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

ARG SDCC_VERSION=4.1.0
ARG GBDK_2020_VERSION=4.0.3

RUN wget https://sourceforge.net/projects/sdcc/files/sdcc/${SDCC_VERSION}/sdcc-src-${SDCC_VERSION}.tar.bz2 \
  && tar xfj sdcc-src-${SDCC_VERSION}.tar.bz2 \
  && cd sdcc \
  && mkdir build \
  && cd build \
  && ../configure \
    --prefix=/opt/sdcc \
    --disable-mcs51-port \
    --disable-z80-port \
    --disable-z180-port \
    --disable-r2k-port \
    --disable-r2ka-port \
    --disable-r3ka-port \
    --disable-tlcs90-port \
    --disable-ez80_z80-port \
    --disable-z80n-port \
    --disable-ds390-port \
    --disable-ds400-port \
    --disable-pic14-port \
    --disable-pic16-port \
    --disable-hc08-port \
    --disable-s08-port \
    --disable-stm8-port \
    --disable-pdk13-port \
    --disable-pdk14-port \
    --disable-pdk15-port \
    --disable-pdk16-port \
  && make \
  && make install \
  && find /opt/sdcc/bin -type f ! -name as2gbmap -perm /a=x -exec strip {} \;

RUN wget https://github.com/gbdk-2020/gbdk-2020/archive/refs/tags/${GBDK_2020_VERSION}.tar.gz -O gbdk-2020-${GBDK_2020_VERSION}.tar.gz \
  && tar xfz gbdk-2020-${GBDK_2020_VERSION}.tar.gz \
  && cd gbdk-2020-${GBDK_2020_VERSION} \
  && SDCCDIR=/opt/sdcc make \
  && SDCCDIR=/opt/sdcc make install \
  && find /opt/gbdk/bin -type f -perm /a=x -exec strip {} \;

FROM ubuntu

RUN apt-get update \
  && apt-get install -y make \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/gbdk /opt/gbdk
COPY --from=build /opt/sdcc /opt/sdcc
ENV PATH /opt/gbdk/bin:$PATH
WORKDIR /workdir
