# Executable or library name
PROJECT = my_project

# compiler and linker flags
CC = gcc
CFLAGS = -g -O3 -Wall -Wextra -pedantic -ansi
LDFLAGS =
LIBS =

# Project folders
BUILD_DIR = build

# - Do not edit below this line unless you know what you are doing -

C_SOURCES := $(shell find . -name '*.c' -not -path "./$(BUILD_DIR)/*")
C_OBJECTS := $(foreach file, $(C_SOURCES), $(BUILD_DIR)/$(basename $(file)).o)

all: $(PROJECT)

$(PROJECT): $(C_OBJECTS)
	$(CC) -o $(BUILD_DIR)/$@ $^ $(LDFLAGS) $(LIBS)

$(C_OBJECTS): $(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c $^ -o $@ $(CFLAGS)

clean:
	rm -rf $(BUILD_DIR)
