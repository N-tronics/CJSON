BUILD_DIR=build
HDR_DIR=include
SRC_DIR=src
OBJ_DIR=$(BUILD_DIR)/obj
TGT=$(BUILD_DIR)/cjson
BUILD_TGT=$(BUILD_DIR)/dist/cjson.o
USER_TEST=$(BUILD_DIR)/usertest

HDR=$(wildcard $(HDR_DIR)/*.h)
SRC=$(wildcard $(SRC_DIR)/*.c)
OBJ=$(patsubst %.o,$(OBJ_DIR)/%.o,$(patsubst $(SRC)/%.o,%.o,$(SRC:.c=.o)))

CC=gcc-11
CFLAGS=
INCLUDE=-I$(HDR_DIR)
RUNFLAGS=$(CURDIR)/tests/data.json

ORNG:=\e[33m
GRN:=\e[32m
CLR_END:=\e[m

.PHONY: clean

$(BUILD_TGT): $(OBJ)
	@echo -e "$(ORNG)Building '$(BUILD_TGT)'...$(CLR_END)"
	@if [ ! -d $(BUILD_DIR)/dist ]; then mkdir -pv ./$(BUILD_DIR)/dist; fi
	ld -r $(OBJ) -o $(BUILD_TGT)
	@echo -e "$(GRN)Successfully built '$(BUILD_TGT)'$(CLR_END)"

$(TGT): $(OBJ) $(OBJ_DIR)/src/main.o
	@echo -e "$(ORNG)Building '$(TGT)'...$(CLR_END)"
	$(CC) -o $@ $^ $(CFLAGS) $(INCLUDE)
	@echo -e "$(GRN)Successfully built '$(TGT)'$(CLR_END)"

$(OBJ_DIR)/src/main.o: main.c
	$(CC) -o $@ -c $< $(CFLAGS) $(INCLUDE)

$(OBJ_DIR)/src/%.o: $(SRC_DIR)/%.c $(HDR)
	@if [ ! -d $(BUILD_DIR)/obj/src ]; then mkdir -pv ./$(BUILD_DIR)/obj/src; fi
	$(CC) -o $@ -c $< $(CFLAGS) $(INCLUDE)

build_init:
	@if [ ! -d $(BUILD_DIR) ]; then mkdir -pv ./$(BUILD_DIR); fi

run: build_init $(TGT)
	@echo
	sh -c "$(CURDIR)/$(TGT) $(RUNFLAGS)"

build: build_init $(BUILD_TGT)

usertest: build
	@echo -e "$(ORNG)Building '$(USER_TEST)'...$(CLR_END)"
	$(CC) -o $(USER_TEST) main.c $(BUILD_TGT) $(CFLAGS) $(INCLUDE)
	@echo -e "$(GRN)Successfully built '$(USER_TEST)'$(CLR_END)"
	@echo
	@sh -c "$(CURDIR)/$(USER_TEST) $(RUNFLAGS)"

clean:
	rm -rf $(BUILD_DIR)
