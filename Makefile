# Executable or library name
PROJECT=my_project

# compiler and linker flags
CC=gcc
CFLAGS=-g -O3 -Wall -Wextra -pedantic -ansi
LFLAGS=
LIBS=
DEPENDENCY_FLAGS=-MM

# Project organisation
SRC_DIR=src/
INC_DIR=include/
BUILD_DIR=build/

# - Do not edit below this line unless you know what you are doing -

# Find all source files
SRC_FILES=$(foreach d, $(SRC_DIR), $(wildcard $(d)*.[hcs]))
# Derive an object file from every source file
OBJECTS=$(patsubst %.[hcs], %.o, $(SRC_FILES))
# Dependencies
DEPENDENCIES=$(patsubst %.[hcs], %.d, $(SRC_FILES))


