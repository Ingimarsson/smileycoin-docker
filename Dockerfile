FROM ubuntu:20.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  build-essential \
  libtool \
  autotools-dev \
  autoconf \
  libssl-dev \
  libdb-dev \
  libdb++-dev \
  wget

RUN apt-get remove libboost-all-dev && apt-get install -y libboost1.67-all-dev

RUN apt-get install -y pkg-config

RUN wget https://github.com/smileycoin/smileyCoin/archive/v2.2.4.tar.gz && \
  tar -xzvf v2.2.4.tar.gz && \
  cd smileyCoin-2.2.4 && \
  ./autogen.sh && \
  ./configure && \
  make

FROM ubuntu:20.04

LABEL maintainer .0="Brynjar Ingimarsson (@Ingimarsson)"

WORKDIR /lib/x86_64-linux-gnu

COPY --from=builder /lib/x86_64-linux-gnu/libboost_system.so.1.67.0 .
COPY --from=builder /lib/x86_64-linux-gnu/libboost_filesystem.so.1.67.0 .
COPY --from=builder /lib/x86_64-linux-gnu/libboost_program_options.so.1.67.0 .
COPY --from=builder /lib/x86_64-linux-gnu/libboost_thread.so.1.67.0 .
COPY --from=builder /lib/x86_64-linux-gnu/libboost_chrono.so.1.67.0 .
COPY --from=builder /lib/x86_64-linux-gnu/libdb_cxx-5.3.so .
COPY --from=builder /lib/x86_64-linux-gnu/libssl.so.1.1 .
COPY --from=builder /lib/x86_64-linux-gnu/libcrypto.so.1.1 .
COPY --from=builder /lib/x86_64-linux-gnu/libstdc++.so.6 .
COPY --from=builder /lib/x86_64-linux-gnu/libm.so.6 .
COPY --from=builder /lib/x86_64-linux-gnu/libgcc_s.so.1 .
COPY --from=builder /lib/x86_64-linux-gnu/libpthread.so.0 .
COPY --from=builder /lib/x86_64-linux-gnu/libc.so.6 .
COPY --from=builder /lib/x86_64-linux-gnu/libdl.so.2 .

COPY --from=builder /smileyCoin-2.2.4/src/smileycoind /usr/bin/smileycoind
COPY --from=builder /smileyCoin-2.2.4/src/smileycoin-cli /usr/bin/smileycoin-cli

COPY entrypoint.sh /

EXPOSE 14242

VOLUME ["/data"]

CMD ["smileycoind", "-datadir=/data"]

ENTRYPOINT ["/entrypoint.sh"]

