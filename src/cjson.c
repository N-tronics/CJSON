#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <cjson/cjson.h>
#include <cjson/utils.h>

void cjson_setValue(cjson_t *cj, cjson_valueType type, void *value) {
    cjson_value_t *cjValue = &cj->value;
    cj->vType = type;
    switch (type) {
        case CJ_INT: {
            cjValue->v_int = *(int*) value;
            break;
        }
        case CJ_FLT: {
            cjValue->v_flt = *(float*) value;
            break;
        }
        case CJ_STR: {
            strncpy(cjValue->v_str, (char*) value, MAX_STR_LEN);
            cjValue->v_str[MAX_STR_LEN - 1] = 0;
            break;
        }
        case CJ_O: case CJ_O_ARR: {
            cj->value_count = 1;
            cj->value_size = 2;
            if (cjValue->v_cj != NULL) {
                // TODO: Destroy cjson_t instead of free
                free(cjValue->v_cj);
            }
            cjValue->v_cj = calloc(cj->value_size, sizeof(cjson_t));
            *cjValue->v_cj = *(cjson_t*) value;
            break;
        }
    }
}

void cjson_setName(cjson_t *cj, char *name) {
    if (name == NULL) {
        cj->name[0] = 0;
    }
    else {
        strncpy(cj->name, name, MAX_STR_LEN);
        cj->name[MAX_STR_LEN - 1] = 0;
    }
}

void cjson_create(cjson_t *cj, cjson_valueType type, char *name, void *value) {
    cj->value.v_cj = NULL;
    cjson_setValue(cj, type, value);
    cjson_setName(cj, name);
}

void cjson_print(cjson_t *cj, uint32_t indentSize, uint32_t indent) {
    indentLn(indentSize, indent);
    if (cj->name[0] != 0) {
        printf("\"%s\": ", cj->name);
    }
    switch (cj->vType) {
        case CJ_INT: {
            printf("%d\n", cj->value.v_int);
            break;
        }
        case CJ_FLT: {
            printf("%f\n", cj->value.v_flt);
            break;
        }
        case CJ_STR: {
            printf("\"%s\"\n", cj->value.v_str);
            break;
        }
        case CJ_O: {
            printf("{\n");
            size_t i;
            for (i = 0; i < cj->value_count; i++) {
                cjson_print(cj->value.v_cj + i, indentSize, indent + 1);
            }
            indentLn(indentSize, indent);
            printf("}\n");
        }
    }
}

void cjson_destroy(cjson_t *cj) {
    if (cj->vType == CJ_O || cj->vType == CJ_O_ARR) {
        for (size_t i = 0; i < cj->value_count; i++) {
            cjson_destroy(cj->value.v_cj + i);
        }
        free(cj->value.v_cj);
    }
}

int cjson_add(cjson_t *parent, cjson_t* child) {
    if (parent->vType != CJ_O && parent->vType != CJ_O_ARR) return -1;
    if (parent->value_count == parent->value_size) {
        parent->value_size += 2;
        parent->value.v_cj = realloc(parent->value.v_cj, parent->value_size * sizeof(cjson_t));
    }
    parent->value.v_cj[parent->value_count++] = *child;
    return 0;
}

int cjson_remove(cjson_t *parent) {
    if (parent->vType != CJ_O && parent->vType != CJ_O_ARR) return -1;
    if (parent->value_count == 0) return -1;
    parent->value_count--;
    cjson_destroy(parent->value.v_cj + parent->value_count);
    if (parent->value_count % 2 == 0) {
        parent->value_size -= 2;
        parent->value.v_cj = realloc(parent->value.v_cj, parent->value_size * sizeof(cjson_t));
    }
}
