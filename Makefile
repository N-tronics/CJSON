BUILD_DIR=build
INCLUDE_DIR=include
SRC_DIR=src
OBJ_DIR=$(BUILD_DIR)/obj
TGT=$(BUILD_DIR)/cjson

HDR=$(wildcard $(INCLUDE_DIR)/*.h)
SRC=$(wildcard $(SRC_DIR)/*.c)
OBJ=$(patsubst %.o,$(OBJ_DIR)/%.o,$(patsubst $(SRC)/%.o,%.o,$(SRC:.c=.o)))

CC=gcc
CFLAGS=-I$(INCLUDE_DIR)
RUNFLAGS=$(CURDIR)/tests/data.json
DEPS=$(SRC) $(HDR)

.PHONY: all clean

all: dirs $(TGT)

dirs: $(DEPS)
	@if [ ! -d $(OBJ_DIR) ]; then mkdir -pv ./$(OBJ_DIR)/src; fi

$(TGT): $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

$(OBJ_DIR)/src/%.o: $(SRC_DIR)/%.c $(HDR)
	$(CC) -o $@ -c $< $(CFLAGS)

run: all
	@echo
	./$(TGT) $(RUNFLAGS)

clean:
	rm -rf $(BUILD_DIR)
