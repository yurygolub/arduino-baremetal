AVR_BIN_DIR=../avr8-gnu-toolchain-linux_x86_64/bin
AVR_DEBUG_DIR=../avr_debug/avr8-stub
CC=$(AVR_BIN_DIR)/avr-gcc

BOARD_NAME=atmega328p
PORT=/dev/ttyUSB0
BAUD_RATE=57600

BUILD_DIR=build
BINARY=$(BUILD_DIR)/main.bin
HEX=$(BUILD_DIR)/main.hex

AVR_DEBUG_SRC_FILES=$(AVR_DEBUG_DIR)/avr8-stub.c
AVR_DEBUG_OBJ_FILES=$(BUILD_DIR)/avr_debug/avr8-stub.o

SRC_FILES=$(wildcard *.c)
OBJ_FILES=$(patsubst %.c,$(BUILD_DIR)/%.o,$(SRC_FILES))

OPT=-Os
DEBUG_FLAGS=-O0 -g -DAVR_DEBUG -DAVR8_USER_BAUDRATE=57600 -DDEBUG $(foreach D,$(AVR_DEBUG_DIR),-I$(D))
BOARD_FLAGS=-DF_CPU=16000000UL -mmcu=$(BOARD_NAME)

C_FLAGS=$(BOARD_FLAGS)

ifeq ($(CONFIG),debug)
    C_FLAGS += $(DEBUG_FLAGS)
    OBJ_FILES += $(AVR_DEBUG_OBJ_FILES)
else
    C_FLAGS += $(OPT)
endif

all: $(BINARY)

gdb: $(BINARY)
	$(AVR_BIN_DIR)/avr-gdb -x script_com $(BINARY)

$(HEX): $(BINARY)
	$(AVR_BIN_DIR)/avr-objcopy -O ihex -R .eeprom $(BINARY) $(HEX)

$(BINARY): $(OBJ_FILES)
	@mkdir -p $(@D)
	$(CC) $(C_FLAGS) -o $@ $^

$(AVR_DEBUG_OBJ_FILES): $(AVR_DEBUG_SRC_FILES)
	@mkdir -p $(@D)
	$(CC) $(C_FLAGS) -c -o $@ $<

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(C_FLAGS) -c -o $@ $<

upload: $(HEX)
	sudo avrdude -v -V -c arduino -p $(BOARD_NAME) -P $(PORT) -b $(BAUD_RATE) -U flash:w:$(HEX)

clean:
	rm -r $(BUILD_DIR)

.PHONY: all gdb upload clean
