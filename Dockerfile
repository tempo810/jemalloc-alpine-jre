FROM adoptopenjdk/openjdk15:alpine-jre AS builder
RUN apk add git build-base cmake linux-headers
RUN wget -O - https://github.com/microsoft/mimalloc/archive/v1.6.7.tar.gz | tar -xz && \
    cd mimalloc-1.6.7 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install
FROM adoptopenjdk/openjdk15:alpine-jre
COPY --from=builder /mimalloc-1.6.7/build/*.so.* /lib
RUN ln -s /lib/libmimalloc.so.* /lib/libmimalloc.so
ENV LD_PRELOAD=/lib/libmimalloc.so
ENV MIMALLOC_LARGE_OS_PAGES=1
