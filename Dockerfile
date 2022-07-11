FROM composer:2.0 as composer

COPY composer.lock /src/
COPY composer.json /src/

ARG ALPINE=false
ENV ALPINE=$ALPINE

WORKDIR /src/

RUN composer install --ignore-platform-reqs --optimize-autoloader --prefer-dist

FROM php:8.0.18-cli as build

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH=/root/.cargo/bin:$PATH

RUN apt-get update && apt-get install clang-11 build-essential git curl tree -y
RUN rustup target add $(uname -m)-unknown-linux-musl

RUN mkdir /src/

COPY ./Cargo.toml /src/Cargo.toml
COPY ./Cargo.lock /src/Cargo.lock
COPY ./src /src/src
COPY ./.cargo /src/.cargo

WORKDIR /src

# Install zigbuild for alpine
RUN curl https://ziglang.org/builds/zig-linux-$(uname -m)-0.10.0-dev.2674+d980c6a38.tar.xz --output /tmp/zig.tar.xz && \
    tar -xf /tmp/zig.tar.xz -C /tmp/ && cp -r /tmp/zig-linux-$(uname -m)-0.10.0-dev.2674+d980c6a38 /tmp/zig/ && \
    PATH=/tmp/zig:$PATH && \
    cargo install cargo-zigbuild

ENV RUSTFLAGS="-C target-feature=-crt-static"
ENV PATH=/tmp/zig:$PATH

# Build alpine and gnu targets
RUN CARGO_NET_GIT_FETCH_WITH_CLI=true cargo build && \
    cargo zigbuild --workspace --target $(uname -m)-unknown-linux-musl

RUN tree

RUN cp target/$(uname -m)-unknown-linux-musl/debug/libphp_scrypt.so target/libscrypt_php_alpine.so

# Create GNU Image
FROM php:8.0.18-cli as gnu

WORKDIR /usr/src/code

COPY --from=build /src/target/debug/libphp_scrypt.so /usr/local/lib/php/extensions/no-debug-non-zts-20200930/libphp_scrypt.so
COPY --from=composer /src/vendor /src/vendor

RUN echo extension=libphp_scrypt.so >> /usr/local/etc/php/conf.d/libphp_scrypt.ini

COPY ./phpunit.xml /src/phpunit.xml
COPY ./tests /src/tests

ENTRYPOINT ["/src/vendor/bin/phpunit"]

FROM php:8.0.18-cli-alpine3.15 as alpine

WORKDIR /usr/src/code

COPY --from=build /src/target/libscrypt_php_alpine.so /usr/local/lib/php/extensions/no-debug-non-zts-20200930/libphp_scrypt.so
COPY --from=composer /src/vendor /src/vendor

RUN echo extension=libphp_scrypt.so >> /usr/local/etc/php/conf.d/libphp_scrypt.ini

COPY ./phpunit.xml /src/phpunit.xml
COPY ./tests /src/tests

ENTRYPOINT ["/src/vendor/bin/phpunit"]