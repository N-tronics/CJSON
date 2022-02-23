#ifndef CJSON_H
#define CJSON_H

#include <stdlib.h>
#include <stdint.h>

#define MAX_STR_LEN 512

typedef struct _cjson_t cjson_t;

typedef union _cjson_value_t {
    int v_int;
    float v_flt;
    char v_str[MAX_STR_LEN];
    cjson_t *v_cj;
} cjson_value_t;

typedef enum _cjson_valueType {
    CJ_INT, CJ_FLT, CJ_STR, CJ_O, CJ_O_ARR
} cjson_valueType;

struct _cjson_t {
    cjson_value_t value;
    cjson_valueType vType;
    char name[MAX_STR_LEN];
    size_t value_count, value_size;
};

void cjson_setValue(cjson_t *cj, cjson_valueType type, void *value);
void cjson_setName(cjson_t *cj, char *name);
void cjson_create(cjson_t *cj, cjson_valueType type, char *name, void *value);
void cjson_print(cjson_t *cj, uint32_t indentSize, uint32_t indent);

#endif