#  PHP Scrypt

A simple PHP Extension written in Rust to create scrypt password hashes.

## Installation
Once you have a compiled version, either through a release or building it yourself, you can install the extension by moving it to your PHP extension directory which is usually `/usr/local/lib/php/extensions/`. on Linux and `C:\php\extensions` on Windows.

Next you need to add the extension to your php.ini file.

MacOS:
```php
extension=libphp_scrypt.dylib
```

Linux:
```php
extension=libphp_scrypt.so
```

Windows:
```php
extension=libphp_scrypt.dll
```

After that the extension will be available to you, check out **Usage** below to see how to use it.

## Usage
Using the scrypt extension is easy, there is only one function in this extension the usage is as follows:
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
\var_dump("Your hash is " . $hash);
```

## Building the extension
Building this extension requires that you have a version of PHP installed that has the `php-config` command.

After all the prequisites are met simply run the following command to build a release version of the extension:
```sh
cargo build --release
```

### Building for Alpine
While writing this extension we found out that [Rust in general](https://github.com/rust-lang/rust/issues/59302) still has a few issues with [musl libc](https://musl.libc.org/) found in Alpine. It is possible to build this project successfully by using an alternative linker and building on a gnu-based system targetting linux-unknown-musl.

We strongly recommend using [zigbuild](https://github.com/messense/cargo-zigbuild) as the linker for this project as we found it's the most stable and easy to install alternate linker. we also use the "-C target-feature=crt-static" compiler flags to aid with building on musl as stated [here](https://github.com/rust-lang/rust/issues/59302).

The build command for these platforms will look like so:
```sh
RUSTFLAGS="-C target-feature=-crt-static" cargo zigbuild --workspace --all-targets --target x86_64-unknown-linux-musl --release
```
This will produce a .so file similar to a normal build.

## Authors

**Bradley Schofield**

-   [https://github.com/pineappleionic](https://github.com/pineappleionic)

**Matej Bačo**

-   [https://github.com/meldiron](https://github.com/meldiron)

**Eldad Fux**
-   [https://github.com/eldadfux](https://github.com/eldadfux)

## Copyright and license

The MIT License (MIT) [http://www.opensource.org/licenses/mit-license.php](http://www.opensource.org/licenses/mit-license.php)



