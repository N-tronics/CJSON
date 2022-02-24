# CJSON - A JSON parser for C
\* Still under development

## Building
Building with `make run` will create a `build/` directory and the compiled executable
can be found at 
`build/cjson`. The .o files will be under `build/obj/src/`. When building, be sure to 
maintain the `main.c` file.

## Usage
Compile CJSON with `make build`. This will create `build/dist/cjson.o`. When building
your project with CJSON, link `build/dist/cjson.o` to your project files and include
`cjson/cjson.h`

### Example
1. Create a directory named `cjson/` in your project directory. 
2. Move `include/` and `build/dist/cjson.o` to `cjson/include/` and `cjson/dist/cjson.o`
    respectively.
3. Include `<cjson/cjson.h>` in your project files
4. Compile your project for example, with 
`gcc -o awesomeProj awesomeProj.c cjson/dist/cjson.o -Icjson/include`. 
Be sure to add `cjson/dist/cjson.o` when linking and `cjson/include` in the include path.
