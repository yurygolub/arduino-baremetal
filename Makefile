AVR_BIN_DIR=../avr8-gnu-toolchain-linux_x86_64/bin

BOARD_NAME=atmega328p
PORT=/dev/ttyUSB1
BAUD_RATE=57600

BUILD_DIR=build

OPT=-Os
BOARD_FLAGS=-DF_CPU=16000000UL -mmcu=$(BOARD_NAME)

all: $(BUILD_DIR)/main.hex

$(BUILD_DIR)/main.hex: $(BUILD_DIR)/main.bin
	$(AVR_BIN_DIR)/avr-objcopy -O ihex -R .eeprom $(BUILD_DIR)/main.bin $(BUILD_DIR)/main.hex

$(BUILD_DIR)/main.bin: $(BUILD_DIR)/main.o
	@mkdir -p $(BUILD_DIR)
	$(AVR_BIN_DIR)/avr-gcc $(OPT) $(BOARD_FLAGS) -o $(BUILD_DIR)/main.bin $(BUILD_DIR)/main.o

$(BUILD_DIR)/main.o: main.c
	@mkdir -p $(BUILD_DIR)
	$(AVR_BIN_DIR)/avr-gcc $(OPT) $(BOARD_FLAGS) -c -o $(BUILD_DIR)/main.o main.c

upload: $(BUILD_DIR)/main.hex
	sudo avrdude -v -V -c arduino -p $(BOARD_NAME) -P $(PORT) -b $(BAUD_RATE) -U flash:w:$(BUILD_DIR)/main.hex

clean:
	rm -r $(BUILD_DIR)

.PHONY: all upload clean
