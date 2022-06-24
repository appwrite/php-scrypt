#  scrypt-php

A PHP Extension written in Rust to create scrypt password hashes

## Usage
Using the scrypt extension is easy, just add the extension to your PHP installation and use the scrypt functions like so:
```php
<?php
/**
* @param $password The string you want to hash (required)
* @param $salt The salt you want to use (required)
* @param $cpu_difficulty The CPU difficulty [default=32768]
* @param $memory_difficulty The memory difficulty [default=8]
* @param $parallel_difficulty The parallel difficulty [default=1]
* @param $len The length of the generated hash [default=8]
**/

$hash = \scrypt("password", "salt", 32768, 8, 1, 64);
```

## Building the extension
Building this extension requires that you have a version of PHP installed that has the `php-config` command.

After all the prequisites are met simply run
```sh
cargo build --release
```
to build a release version of the extension

### Building for Alpine
While writing this extension we found out that [rust in general](https://github.com/rust-lang/rust/issues/59302) still has a few issues with musl libc found in Alpine. It is possible to build this project successfully by using a alternative linker and building on a gnu based system targetting linux-unknown-musl.

We strongly recommend using [zigbuild](https://github.com/messense/cargo-zigbuild) as the linker for this project as we found it's the most stable and easy to install alternate linker.

The build command for these platforms will look like so:
```sh
cargo zigbuild --workspace --all-targets --target x86_64-unknown-linux-musl --release
```
This will produce a .so file similar to a normal build.

## Authors

**Bradley Schofield**

-   [https://github.com/pineappleionic](https://github.com/pineappleionic)

**Matej Bačo**

-   [https://github.com/meldiron](https://github.com/meldiron)

## Copyright and license

The MIT License (MIT) [http://www.opensource.org/licenses/mit-license.php](http://www.opensource.org/licenses/mit-license.php)



