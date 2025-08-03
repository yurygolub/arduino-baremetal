AVR_BIN_DIR=../avr8-gnu-toolchain-linux_x86_64/bin
AVR_DEBUG_DIR=../avr_debug/avr8-stub

BOARD_NAME=atmega328p
PORT=/dev/ttyUSB0
BAUD_RATE=57600

BUILD_DIR=build

OPT=-Os
DEBUG_FLAGS=-O0 -g -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -DAVR_DEBUG -DAVR8_USER_BAUDRATE=57600
BOARD_FLAGS=-DF_CPU=16000000UL -mmcu=$(BOARD_NAME)

C_FLAGS=$(foreach D,$(AVR_DEBUG_DIR),-I$(D))

C_FLAGS += $(BOARD_FLAGS)

all: C_FLAGS += $(OPT)
all: $(BUILD_DIR)/main.hex

debug: C_FLAGS += $(DEBUG_FLAGS)
debug: $(BUILD_DIR)/main.hex

gdb: debug
	$(AVR_BIN_DIR)/avr-gdb -x script_com $(BUILD_DIR)/main.bin

$(BUILD_DIR)/main.hex: $(BUILD_DIR)/main.bin
	$(AVR_BIN_DIR)/avr-objcopy -O ihex -R .eeprom $(BUILD_DIR)/main.bin $(BUILD_DIR)/main.hex

$(BUILD_DIR)/main.bin: $(BUILD_DIR)/main.o
	@mkdir -p $(BUILD_DIR)
	$(AVR_BIN_DIR)/avr-gcc $(C_FLAGS) -o $(BUILD_DIR)/main.bin $(BUILD_DIR)/main.o $(BUILD_DIR)/avr_debug/avr8-stub/avr8-stub.o

$(BUILD_DIR)/main.o: main.c
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/avr_debug/avr8-stub
	$(AVR_BIN_DIR)/avr-gcc $(C_FLAGS) -c -o $(BUILD_DIR)/main.o main.c
	$(AVR_BIN_DIR)/avr-gcc $(C_FLAGS) -c -o $(BUILD_DIR)/avr_debug/avr8-stub/avr8-stub.o $(AVR_DEBUG_DIR)/avr8-stub.c
#	$(AVR_BIN_DIR)/avr-gcc $(C_FLAGS) -c -o $(BUILD_DIR)/avr_debug/avr8-stub/app_api.o $(AVR_DEBUG_DIR)/app_api.c

upload: $(BUILD_DIR)/main.hex
	sudo avrdude -v -V -c arduino -p $(BOARD_NAME) -P $(PORT) -b $(BAUD_RATE) -U flash:w:$(BUILD_DIR)/main.hex

clean:
	rm -r $(BUILD_DIR)

.PHONY: all upload clean
