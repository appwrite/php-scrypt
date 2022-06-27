FROM composer:2.0 as composer

COPY composer.lock /src/
COPY composer.json /src/

WORKDIR /src/

RUN composer install --ignore-platform-reqs --optimize-autoloader --prefer-dist

FROM php:8.0.18-cli

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH=/root/.cargo/bin:$PATH

RUN apt-get update && apt-get install clang-11 build-essential git -y

RUN mkdir /src/

COPY ./Cargo.toml /src/Cargo.toml
COPY ./Cargo.lock /src/Cargo.lock
COPY ./src /src/src
COPY ./.cargo /src/.cargo

WORKDIR /src

RUN CARGO_NET_GIT_FETCH_WITH_CLI=true cargo build && \
    mv /src/target/debug/libphp_scrypt.so /usr/local/lib/php/extensions/no-debug-non-zts-20200930/libphp_scrypt.so && \
    echo extension=libphp_scrypt.so >> /usr/local/etc/php/conf.d/libphp_scrypt.ini

COPY ./phpunit.xml /src/phpunit.xml
COPY ./tests /src/tests

COPY --from=composer /src/vendor /src/vendor

ENTRYPOINT ["/src/vendor/bin/phpunit"]