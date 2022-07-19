# PHP Scrypt

[![Discord](https://img.shields.io/discord/564160730845151244?label=discord&style=flat-square)](https://appwrite.io/discord)
[![Twitter Account](https://img.shields.io/twitter/follow/appwrite?color=00acee&label=twitter&style=flat-square)](https://twitter.com/appwrite)
[![Follow Appwrite on StackShare](https://img.shields.io/badge/follow%20on-stackshare-blue?style=flat-square)](https://stackshare.io/appwrite)
[![appwrite.io](https://img.shields.io/badge/appwrite-.io-f02e65?style=flat-square)](https://appwrite.io)

A simple PHP Extension written in Rust to create scrypt password hashes. Supports building on X86-64 and ARM platforms.

## Installation

### Compiling Requirements
- Linux, MacOS or Windows-based operating system
- Latest Version of Rust Stable
- PHP 8.0 or newer
- Clang 5.0 or Later

### Notes for Windows compilation
- This extension can only be compiled for PHP installations sourced from https://windows.php.net.
- Rust Nightly is required for Windows compilation.
- This extension requires the `cl.exe` compiler. This is usually bundled with Visual Studio.
- Stub generation does not work on Windows.

### Building The Extension
Clone the repository into your project directory.
```bash
git clone https://github.com/appwrite/php-scrypt.git && \
cd php-scrypt
```
Compile the extension
```bash
cargo build --release
```

<details>
<summary>

### Building for Alpine

</summary>
While writing this extension we found out that [Rust in general](https://github.com/rust-lang/rust/issues/59302) still has a few issues with [musl libc](https://musl.libc.org/) found in Alpine. It is possible to build this project successfully by using an alternative linker and building on a gnu-based system targetting `linux-unknown-musl`.

We strongly recommend using [zigbuild](https://github.com/messense/cargo-zigbuild) as the linker for this project as we found it's the most stable and easy to install alternate linker. we also use the "-C target-feature=crt-static" compiler flags to aid with building on musl as stated [here](https://github.com/rust-lang/rust/issues/59302).

The build command for these platforms will look like so:
```sh
RUSTFLAGS="-C target-feature=-crt-static" cargo zigbuild --workspace --all-targets --target x86_64-unknown-linux-musl --release
```
This will produce a .so file similar to a normal build.
</details>

### Installing the Extension
Copy the compiled extension from the `target` directory into your PHP extension directory.

If you don't know where your PHP extension directory is you can run the following command:
```bash
php -i | grep extension_dir
```

Copy the extension to the directory outputted
```bash
cp target/release/libphp-scrypt.so /path/to/extension_dir
```

> Depending on your OS, your extension may end with `.dll` for windows or `.dylib` for macOS.

### Enabling the extension

After compiling and moving the extension into the correct directory, you can enable the extension by adding the following line to your `php.ini` file:

```
extension=libphp-scrypt.so
```
> Change .so to .dll for Windows or .dylib for macOS.

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

## Authors

**Bradley Schofield**

-   [https://github.com/pineappleionic](https://github.com/pineappleionic)

**Matej Bačo**

-   [https://github.com/meldiron](https://github.com/meldiron)

**Eldad Fux**
-   [https://github.com/eldadfux](https://github.com/eldadfux)

## Special Thanks
-  [davidcole1340](https://github.com/davidcole1340) -  For developing the [ext-php-rs](https://github.com/davidcole1340/ext-php-rs) bindings used for this project.

## Contributing

All code contributions - including those of people having commit access - must go through a pull request and approved by a core developer before being merged. This is to ensure proper review of all the code.

We truly ❤️ pull requests! If you wish to help, you can learn more about how you can contribute to this project in the [contribution guide](CONTRIBUTING.md).

## Copyright and license

The MIT License (MIT) http://www.opensource.org/licenses/mit-license.php