## Requirements

* toolchain

https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers

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
make gdb
```

> default baud rate is 115200
