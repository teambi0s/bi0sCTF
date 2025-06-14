#!/bin/sh

emcc -s WASM=1 -g -s EXPORTED_RUNTIME_METHODS='["cwrap", "addFunction","HEAPU8"]' -s ALLOW_TABLE_GROWTH ./module.c --no-entry -o ./static/module/module.js
wasm2wat static/module/module.wasm > static/module/module.wat