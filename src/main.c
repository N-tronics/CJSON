#include <stdio.h>
#include <stdlib.h>
#include <cjson/cjson.h>

int main(int argc, char **argv) {
    // Ensure that a JSON file is specified
    if (argc < 2) {
        printf("JSON file not specified\n");
        return 1;
    }

    // Open a file stream to the JSON file
    FILE *jsonFile = fopen(argv[1], "r");
    if (jsonFile == NULL) {
        printf("Error opening %s!\n", argv[1]);
        return 1;
    }

    // Get the size of the JSON file
    fseek(jsonFile, 0, SEEK_END);
    size_t fsize = ftell(jsonFile);
    rewind(jsonFile);

    // Read the contents
    char *fileBuffer = calloc(fsize, sizeof(char));
    fread(fileBuffer, sizeof(char), fsize, jsonFile);
    fclose(jsonFile);

    // printf("%s\n", fileBuffer);
    cjson_t rt;
    cjson_create(&rt, CJ_STR, "name", "Nischay");
    cjson_print(&rt, 4, 0);

    free(fileBuffer);
}