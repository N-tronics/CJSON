# CJSON - A JSON parser for C/C++
\* Still under development

### Building
Building using `make` will create a `build` directory and compile cjson into it. The .o files will be under `build/obj/src/`. When building, be sure to maintain `src/main.c` file.

### Usage
Clone the repository and add `include/` in your include path. Also add the `src/` in your linker path.
Be sure to remove or move `src/main.c` to a different directory.

**NOTE:** The JSON files under `test/` may not always be valid JSON files
