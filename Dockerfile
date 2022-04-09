# Declare build environment
FROM clux/muslrust:1.60.0

# We need to install protobuf
RUN apt-get update && curl -OL https://github.com/google/protobuf/releases/download/v3.4.0/protoc-3.4.0-linux-x86_64.zip \
    && apt-get install unzip wget \
    && yes | unzip -u protoc-3.4.0-linux-x86_64.zip -d protoc3 \
    && mv protoc3/bin/* /usr/local/bin/ \
    && mv protoc3/include/* /usr/local/include/ \
    && chown $(whoami) /usr/local/bin/protoc \
    && chown -R $(whoami) /usr/local/include/google

RUN wget https://github.com/mozilla/sccache/releases/download/v0.2.15/sccache-v0.2.15-x86_64-unknown-linux-musl.tar.gz
RUN tar -xzf sccache-v0.2.15-x86_64-unknown-linux-musl.tar.gz
RUN mv ./sccache-v0.2.15-x86_64-unknown-linux-musl/sccache /usr/bin/sccache
RUN chmod +x /usr/bin/sccache
ENV RUSTC_WRAPPER=/usr/bin/sccache
RUN rm -rf sccache-v0.2.15-x86_64-unknown-linux-musl.tar.gz
RUN rm -rf sccache-v0.2.15-x86_64-unknown-linux-musl
RUN rustup target add x86_64-unknown-linux-musl
