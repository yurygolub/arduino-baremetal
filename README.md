## Requirements

* toolchain: https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers
* make
* avrdude

```sh
sudo apt install avrdude
```

## Build

```sh
make
```

## Upload

```sh
make upload
```

## Debug

https://github.com/jdolinay/avr_debug

```sh
CONFIG=debug make gdb
```

> default baud rate is 115200

## LSP

```sh
sudo apt install bear clangd
```

vscode clangd

```sh
code --install-extension llvm-vs-code-extensions.vscode-clangd
```

generate **compile_commands.json**

```sh
CONFIG=debug bear -- make
```
