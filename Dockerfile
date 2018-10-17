FROM alpine:edge
MAINTAINER Asish Soudhamma

ENV STRESS_VERSION=1.0.4

RUN \
  apk add --update bash g++ make wget && \
  cd tmp && \
  wget https://people.seas.harvard.edu/~apw/stress/stress-${STRESS_VERSION}.tar.gz && \
  tar xvf stress-${STRESS_VERSION}.tar.gz && rm stress-${STRESS_VERSION}.tar.gz && \
  cd stress-${STRESS_VERSION} && \
  ./configure && make && make install && \
  apk del g++ make curl && \
  cd / && \
  rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

CMD bash
