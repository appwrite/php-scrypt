FROM composer:2.0@sha256:b3703ad1ca8e91a301c2653844633a9aa91734f3fb278c56e2745f58965713f3 as composer

COPY composer.lock /src/
COPY composer.json /src/

ARG ALPINE=false
ENV ALPINE=$ALPINE

WORKDIR /src/

RUN composer install --ignore-platform-reqs --optimize-autoloader --prefer-dist

FROM php:8.5-cli@sha256:f324fcb4dc009ac0470a7d614cd122499dcee3ca47a9bab620fc14c0eb759ba2 as build

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH=/root/.cargo/bin:$PATH

RUN apt-get update && apt-get install clang build-essential git curl -y
RUN rustup target add $(uname -m)-unknown-linux-musl

RUN mkdir /src/

COPY ./Cargo.toml /src/Cargo.toml
COPY ./Cargo.lock /src/Cargo.lock
COPY ./src /src/src
COPY ./.cargo /src/.cargo

WORKDIR /src

# Install zigbuild for alpine
RUN curl https://ziglang.org/download/0.14.0/zig-linux-$(uname -m)-0.14.0.tar.xz --output /tmp/zig.tar.xz && \
    tar -xf /tmp/zig.tar.xz -C /tmp/ && cp -r /tmp/zig-linux-$(uname -m)-0.14.0 /tmp/zig/ && \
    PATH=/tmp/zig:$PATH && \
    cargo install cargo-zigbuild --locked

ENV RUSTFLAGS="-C target-feature=-crt-static"
ENV PATH=/tmp/zig:$PATH

# Build alpine and gnu targets
RUN CARGO_NET_GIT_FETCH_WITH_CLI=true cargo build && \
    cargo zigbuild --workspace --target $(uname -m)-unknown-linux-musl

RUN cp target/$(uname -m)-unknown-linux-musl/debug/libphp_scrypt.so target/libscrypt_php_alpine.so

# Create GNU Image
FROM php:8.5-cli@sha256:f324fcb4dc009ac0470a7d614cd122499dcee3ca47a9bab620fc14c0eb759ba2 as gnu

WORKDIR /usr/src/code

COPY --from=build /src/target/debug/libphp_scrypt.so /tmp/libphp_scrypt.so
RUN mv /tmp/libphp_scrypt.so $(php-config --extension-dir)/libphp_scrypt.so
COPY --from=composer /src/vendor /src/vendor

RUN echo extension=libphp_scrypt.so >> /usr/local/etc/php/conf.d/libphp_scrypt.ini

COPY ./phpunit.xml /src/phpunit.xml
COPY ./tests /src/tests

ENTRYPOINT ["tail", "-f", "/dev/null"]

FROM php:8.5-cli-alpine@sha256:b9d7db51a2b83c41420ba04de0b90e6078d4b6440e5cc480fc4dc51b18e0b6db as alpine

WORKDIR /usr/src/code

COPY --from=build /src/target/libscrypt_php_alpine.so /tmp/libphp_scrypt.so
RUN mv /tmp/libphp_scrypt.so $(php-config --extension-dir)/libphp_scrypt.so
COPY --from=composer /src/vendor /src/vendor

RUN echo extension=libphp_scrypt.so >> /usr/local/etc/php/conf.d/libphp_scrypt.ini

COPY ./phpunit.xml /src/phpunit.xml
COPY ./tests /src/tests

ENTRYPOINT ["tail", "-f", "/dev/null"]