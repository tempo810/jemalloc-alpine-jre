FROM adoptopenjdk/openjdk15:alpine-jre AS builder
RUN apk add build-base
RUN wget -O - https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj && \
    cd jemalloc-5.2.1 && \
    ./configure && \
    make && \
    make install
FROM adoptopenjdk/openjdk15:alpine-jre
COPY --from=builder /usr/local/lib/libjemalloc.so.2 /usr/local/lib/
RUN apk add --no-cache libstdc++
ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so.2
