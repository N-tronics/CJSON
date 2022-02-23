BUILD_DIR=build
INCLUDE_DIR=include
SRC_DIR=src
OBJ_DIR=$(BUILD_DIR)/obj
TGT=$(BUILD_DIR)/cjson
BUILD_TGT=$(BUILD_DIR)/dist/cjson.a

HDR=$(wildcard $(INCLUDE_DIR)/*.h)
SRC=$(wildcard $(SRC_DIR)/*.c)
OBJ=$(patsubst %.o,$(OBJ_DIR)/%.o,$(patsubst $(SRC)/%.o,%.o,$(SRC:.c=.o)))

CC=gcc
CFLAGS=-I$(INCLUDE_DIR)
RUNFLAGS=$(CURDIR)/tests/data.json

.PHONY: clean

build: dirs $(OBJ)
	@if [ ! -d $(BUILD_DIR)/dist ]; then mkdir -pv ./$(BUILD_DIR)/dist; fi
	ar cr $(BUILD_TGT) $(OBJ)
	@echo Successfully built \'$(BUILD_TGT)\'

dirs:
	@if [ ! -d $(BUILD_DIR) ]; then mkdir -pv ./$(BUILD_DIR); fi

$(TGT): $(OBJ) $(OBJ_DIR)/src/main.o 
	$(CC) -o $@ $^ $(CFLAGS)
	@echo Successfully built \'$(TGT)\'

$(OBJ_DIR)/src/main.o: main.c
	$(CC) -o $@ -c $< $(CFLAGS)

$(OBJ_DIR)/src/%.o: $(SRC_DIR)/%.c $(HDR)
	@if [ ! -d $(BUILD_DIR)/obj/src ]; then mkdir -pv ./$(BUILD_DIR)/obj/src; fi
	$(CC) -o $@ -c $< $(CFLAGS)

run: dirs $(TGT)
	@echo
	sh -c "$(CURDIR)/$(TGT) $(RUNFLAGS)"

usertest: build
	$(CC) -o $@ main.c $(BUILD_TGT) $(CFLAGS)
	@echo
	sh -c "$(CURDIR)/$(@) $(RUNFLAGS)"

clean:
	rm -rf $(BUILD_DIR) usertest
