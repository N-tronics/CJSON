#include <stdio.h>
#include <stdint.h>
#include <cjson/utils.h>

void indentLn(uint32_t indentSize, uint32_t indent) {
    for (uint32_t _ = 0; _ < indentSize * indent; _++) {
        printf(" ");
    }
}
