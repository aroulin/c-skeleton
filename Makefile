# Executable or library name
PROJECT = my_project

# Files containing main or entry points (to be removed from tests)
MAIN_FILES = ./src/main.c

# compiler and linker flags
CC = gcc
AS = as
CFLAGS = -g -O3 -Wall -Wextra -pedantic -ansi --coverage -fdiagnostics-color=always
LDFLAGS = --coverage
LIBS =

# Project folders
BUILD_DIR = build
INCLUDE_DIR = include .
DOC_DIR = doc
TESTS_DIR = tests
COV_DIR=coverage

# - Do not edit below this line unless you know what you are doing -

# Include directories
C_HEADERS := $(foreach d, $(INCLUDE_DIR), -I$(d))
# Uncomment if you want include directories for all headers
# C_HEADERS := $(addprefix -I, $(sort $(dir $(shell find . -name '*.h' -not -path "./$(BUILD_DIR)/*"))))

C_SOURCES := $(shell find . -name '*.c' -not -path "./$(BUILD_DIR)/*" -not -path "./$(TESTS_DIR)/*")
C_OBJECTS := $(foreach file, $(C_SOURCES), $(BUILD_DIR)/$(basename $(file)).o)
C_HSOURCES := $(shell find . -name '*.h' -not -path "./$(BUILD_DIR)/*" -not -path "./$(TESTS_DIR)/*")

ASM_SOURCES := $(shell find . -name '*.s' -not -path "./$(BUILD_DIR)/*" -not -path "./$(TESTS_DIR)/*")
ASM_OBJECTS := $(foreach file, $(ASM_SOURCES), $(BUILD_DIR)/$(basename $(file)).o)

MAIN_OBJECTS = $(foreach file, $(MAIN_FILES), $(BUILD_DIR)/$(basename $(file)).o)

TESTS_SOURCES := $(shell find $(TESTS_DIR) -name '*.c')
TESTS := $(foreach file, $(TESTS_SOURCES), $(BUILD_DIR)/$(basename $(file)).test)
TESTS_DEPS = $(C_OBJECTS) $(ASM_OBJECTS)
TESTS_DEPS := $(filter-out $(MAIN_OBJECTS), $(TESTS_DEPS))

.PHONY: default all doc checkstyle tests coverage clean

default: $(BUILD_DIR)/$(PROJECT)

all: doc $(BUILD_DIR)/$(PROJECT)

C_DEPS := $(C_OBJECTS:.o=.d)
-include $(C_DEPS)

$(C_OBJECTS): $(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c $< $(CFLAGS) $(C_HEADERS) -o $@

$(ASM_OBJECTS): $(BUILD_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	$(AS) $< -o $@

$(BUILD_DIR)/%.d: %.c
	@mkdir -p $(dir $@)
	$(CC) $< $(CFLAGS) $(C_HEADERS) -MM -MT $(basename $@).o -MF $@

$(BUILD_DIR)/$(PROJECT): $(C_OBJECTS) $(ASM_OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS)

doc:
	doxygen $(DOC_DIR)/Doxyfile

checkstyle:
	for file in $(C_SOURCES) $(C_HSOURCES) $(TESTS_SOURCES); do \
		echo Checkstyling $$file; \
		./$(DOC_DIR)/checkstyle.pl --terse --file --no-tree $$file; \
	done

$(TESTS): $(BUILD_DIR)/%.test: %.c $(C_OBJECTS) $(ASM_OBJECTS)
	@mkdir -p $(dir $@)
	$(CC) -c $< $(CFLAGS) $(C_HEADERS) -o $(basename $@).o
	$(CC) $(basename $@).o $(TESTS_DEPS) -o $@ $(LDFLAGS) $(LIBS)

tests: $(TESTS)
	sh ./tests/run_tests.sh

coverage:
	@mkdir -p $(COV_DIR)
	lcov --capture --directory $(BUILD_DIR)/ --output-file $(COV_DIR)/coverage.info
	genhtml $(COV_DIR)/coverage.info --output-directory $(COV_DIR)

clean:
	rm -rf $(BUILD_DIR) $(DOC_DIR)/html $(DOC_DIR)/doxygen_* $(COV_DIR)
