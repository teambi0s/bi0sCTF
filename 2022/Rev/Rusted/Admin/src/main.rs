//#[cfg(target_os = "linux")]
//#[cfg(not(debug_assertions))]
extern crate libc;
//use debugoff;
use std::mem;
use std::io;
use std::ops::{Index, IndexMut};

const SM4_BOXES_TABLE: [u8; 256] = [
    0xd6, 0x90, 0xe9, 0xfe, 0xcc, 0xe1, 0x3d, 0xb7, 0x16, 0xb6, 0x14, 0xc2, 0x28, 0xfb, 0x2c, 
    0x05, 0x2b, 0x67, 0x9a, 0x76, 0x2a, 0xbe, 0x04, 0xc3, 0xaa, 0x44, 0x13, 0x26, 0x49, 0x86, 
    0x06, 0x99, 0x9c, 0x42, 0x50, 0xf4, 0x91, 0xef, 0x98, 0x7a, 0x33, 0x54, 0x0b, 0x43, 0xed, 
    0xcf, 0xac, 0x62, 0xe4, 0xb3, 0x1c, 0xa9, 0xc9, 0x08, 0xe8, 0x95, 0x80, 0xdf, 0x94, 0xfa, 
    0x75, 0x8f, 0x3f, 0xa6, 0x47, 0x07, 0xa7, 0xfc, 0xf3, 0x73, 0x17, 0xba, 0x83, 0x59, 0x3c, 
    0x19, 0xe6, 0x85, 0x4f, 0xa8, 0x68, 0x6b, 0x81, 0xb2, 0x71, 0x64, 0xda, 0x8b, 0xf8, 0xeb, 
    0x0f, 0x4b, 0x70, 0x56, 0x9d, 0x35, 0x1e, 0x24, 0x0e, 0x5e, 0x63, 0x58, 0xd1, 0xa2, 0x25, 
    0x22, 0x7c, 0x3b, 0x01, 0x21, 0x78, 0x87, 0xd4, 0x00, 0x46, 0x57, 0x9f, 0xd3, 0x27, 0x52, 
    0x4c, 0x36, 0x02, 0xe7, 0xa0, 0xc4, 0xc8, 0x9e, 0xea, 0xbf, 0x8a, 0xd2, 0x40, 0xc7, 0x38, 
    0xb5, 0xa3, 0xf7, 0xf2, 0xce, 0xf9, 0x61, 0x15, 0xa1, 0xe0, 0xae, 0x5d, 0xa4, 0x9b, 0x34, 
    0x1a, 0x55, 0xad, 0x93, 0x32, 0x30, 0xf5, 0x8c, 0xb1, 0xe3, 0x1d, 0xf6, 0xe2, 0x2e, 0x82, 
    0x66, 0xca, 0x60, 0xc0, 0x29, 0x23, 0xab, 0x0d, 0x53, 0x4e, 0x6f, 0xd5, 0xdb, 0x37, 0x45, 
    0xde, 0xfd, 0x8e, 0x2f, 0x03, 0xff, 0x6a, 0x72, 0x6d, 0x6c, 0x5b, 0x51, 0x8d, 0x1b, 0xaf, 
    0x92, 0xbb, 0xdd, 0xbc, 0x7f, 0x11, 0xd9, 0x5c, 0x41, 0x1f, 0x10, 0x5a, 0xd8, 0x0a, 0xc1, 
    0x31, 0x88, 0xa5, 0xcd, 0x7b, 0xbd, 0x2d, 0x74, 0xd0, 0x12, 0xb8, 0xe5, 0xb4, 0xb0, 0x89, 
    0x69, 0x97, 0x4a, 0x0c, 0x96, 0x77, 0x7e, 0x65, 0xb9, 0xf1, 0x09, 0xc5, 0x6e, 0xc6, 0x84, 
    0x18, 0xf0, 0x7d, 0xec, 0x3a, 0xdc, 0x4d, 0x20, 0x79, 0xee, 0x5f, 0x3e, 0xd7, 0xcb, 0x39, 
    0x48
];

const SM4_FK: [u32; 4] = [0xa3b1bac6, 0x56aa3350, 0x677d9197, 0xb27022dc];

const SM4_CK: [u32; 32] = [
    0x00070e15, 0x1c232a31, 0x383f464d, 0x545b6269, 
    0x70777e85, 0x8c939aa1, 0xa8afb6bd, 0xc4cbd2d9, 
    0xe0e7eef5, 0xfc030a11, 0x181f262d, 0x343b4249, 
    0x50575e65, 0x6c737a81, 0x888f969d, 0xa4abb2b9, 
    0xc0c7ced5, 0xdce3eaf1, 0xf8ff060d, 0x141b2229, 
    0x30373e45, 0x4c535a61, 0x686f767d, 0x848b9299, 
    0xa0a7aeb5, 0xbcc3cad1, 0xd8dfe6ed, 0xf4fb0209, 
    0x10171e25, 0x2c333a41, 0x484f565d, 0x646b7279
];

fn round_key(ka: u32) -> u32 {
    let mut b: [u8; 4] = [0, 0, 0, 0];
    let a = ka.to_be_bytes();
    b[0] = SM4_BOXES_TABLE[a[0] as usize];
    b[1] = SM4_BOXES_TABLE[a[1] as usize];
    b[2] = SM4_BOXES_TABLE[a[2] as usize];
    b[3] = SM4_BOXES_TABLE[a[3] as usize];
    let bb = u32::from_be_bytes(b);
    let rk = bb ^ (bb.rotate_left(13)) ^ (bb.rotate_left(23));
    rk
}

fn sm4_l_t(ka: u32) -> u32 {
    let mut b: [u8; 4] = [0, 0, 0, 0];
    let a = ka.to_be_bytes();
    b[0] = SM4_BOXES_TABLE[a[0] as usize];
    b[1] = SM4_BOXES_TABLE[a[1] as usize];
    b[2] = SM4_BOXES_TABLE[a[2] as usize];
    b[3] = SM4_BOXES_TABLE[a[3] as usize];
    let bb = u32::from_be_bytes(b);
    bb ^ (bb.rotate_left(2)) ^ (bb.rotate_left(10)) ^ (bb.rotate_left(18)) ^ (bb.rotate_left(24))
}

fn f(x0: u32, x1: u32, x2: u32, x3: u32, rk: u32) -> u32 {
    x0 ^ sm4_l_t(x1 ^ x2 ^ x3 ^ rk)
}

fn xor(a: &Vec<u8>, b: &Vec<u8>) -> Vec<u8> {
    assert_eq!(a.len(), b.len());
    (0..a.len()).map(|i| a[i] ^ b[i]).collect()
}

fn padding(data: Vec<u8>) -> Vec<u8> {
    let mut result: Vec<u8> = data.clone();
    let mut append: Vec<u8> = vec![(16 - &data.len() % 16) as u8; 16 - &data.len() % 16];
    result.append(&mut append);
    result
}

fn unpadding(data: Vec<u8>) -> Vec<u8> {
    data[0..(data.len() - data[data.len() - 1] as usize)].to_vec()
}

fn set_key(key: &[u8], mode: &str) -> Vec<u32> {
    let mut sk: Vec<u32> = vec![0; 32];
    let mut mk: Vec<u32> = vec![0, 0, 0, 0];
    let mut k: Vec<u32> = vec![0; 36];
    mk[0] = u32::from_be_bytes([key[0], key[1], key[2], key[3]]);
    mk[1] = u32::from_be_bytes([key[4], key[5], key[6], key[7]]);
    mk[2] = u32::from_be_bytes([key[8], key[9], key[10], key[11]]);
    mk[3] = u32::from_be_bytes([key[12], key[13], key[14], key[15]]);
    let temp: Vec<u32> = (0..4).map(|i| mk[i] ^ SM4_FK[i]).collect();
    k[0..4].clone_from_slice(&temp);
    for i in 0..32 {
        k[i + 4] = k[i] ^ (round_key(k[i + 1] ^ k[i + 2] ^ k[i + 3] ^ SM4_CK[i]));
        sk[i] = k[i + 4];
    }
    if mode == "SM4_DECRYPT" {
        for idx in 0..16 {
            let t = sk[idx];
            sk[idx] = sk[31 - idx];
            sk[31 - idx] = t;
        }
    }
    sk
}

fn one_round(sk: Vec<u32>, in_put: Vec<u8>) -> Vec<u8> {
    let mut out_put = vec![];
    let mut ulbuf = vec![0; 36];
    ulbuf[0] = u32::from_be_bytes([in_put[0], in_put[1], in_put[2], in_put[3]]);
    ulbuf[1] = u32::from_be_bytes([in_put[4], in_put[5], in_put[6], in_put[7]]);
    ulbuf[2] = u32::from_be_bytes([in_put[8], in_put[9], in_put[10], in_put[11]]);
    ulbuf[3] = u32::from_be_bytes([in_put[12], in_put[13], in_put[14], in_put[15]]);
    for idx in 0..32 {
        ulbuf[idx + 4] = f(ulbuf[idx], ulbuf[idx + 1], ulbuf[idx + 2], ulbuf[idx + 3], sk[idx]);
    }
    out_put.append(&mut ulbuf[35].to_be_bytes().to_vec());
    out_put.append(&mut ulbuf[34].to_be_bytes().to_vec());
    out_put.append(&mut ulbuf[33].to_be_bytes().to_vec());
    out_put.append(&mut ulbuf[32].to_be_bytes().to_vec());
    out_put
}

fn encrypt_cbc(input_data: &[u8], key: &[u8], iv: &[u8]) -> Vec<u8> {
    let sk = set_key(key, "SM4_ENCRYPT");
    let mut i = 0;
    let mut output_data: Vec<u8> = vec![];
    let mut tmp_input: Vec<u8>;
    let mut iv = iv.to_vec();
    let input_data = padding(input_data.to_vec());
    let mut length = input_data.len();
    while length > 0 {
        tmp_input = xor(&input_data[i..(i + 16)].to_vec(), &iv[0..16].to_vec());
        output_data.append(&mut one_round(sk.to_owned(), tmp_input[0..16].to_vec()));
        iv = output_data[i..(i + 16)].to_vec();
        i += 16;
        length -= 16;
    }
    output_data
}


fn encrypt_cbc_to_file(input_data: &str, output_file: &str, key: &[u8], iv: &[u8]) {
    let output_file=format!("./{}/{}","storage",output_file);
    let output_file = std::path::Path::new(&output_file);
    let output_data = encrypt_cbc(input_data.as_bytes(), key, iv);
    std::fs::write(output_file, &output_data[..]).unwrap();
}

fn decrypt_cbc(input_data: &[u8], key: &[u8], iv: &[u8]) -> Vec<u8> {
    let sk = set_key(key, "SM4_DECRYPT");
    let mut i = 0;
    let mut output_data: Vec<u8> = vec![];
    let mut iv = iv.to_vec();
    let mut length = input_data.len();
    while length > 0 {
        output_data.append(&mut one_round(sk.to_owned(), input_data[i..(i + 16)].to_vec()));
        let tmp_copy = xor(&output_data[i..(i + 16)].to_vec(), &iv[0..16].to_vec());
        let (_left1, right1) = output_data.split_at_mut(i);
        let (left2, _right2) = right1.split_at_mut(16);
        left2.copy_from_slice(&tmp_copy);
        iv = input_data[i..(i + 16)].to_vec();
        i += 16;
        length -= 16
    }
    unpadding(output_data)
}

pub struct CryptSM4CBC<'a> {
    pub key: &'a [u8], 
    pub iv: &'a [u8]
}

impl<'a> CryptSM4CBC<'a> {
    pub fn new(key: &'a [u8], iv: &'a [u8]) -> Self {
        CryptSM4CBC{key: key, iv: iv}
    }

    pub fn encrypt_cbc(&self, input_data: &[u8]) -> Vec<u8> {
        encrypt_cbc(input_data, self.key, self.iv)
    }

    pub fn encrypt_to_file(&self, input_file: &str, output_file: &str) {
        encrypt_cbc_to_file(input_file, output_file, self.key, self.iv)
    }
    pub fn decrypt_cbc(&self, input_data: &[u8],key: &[u8],iv: &[u8]) -> Vec<u8> {
        decrypt_cbc(input_data, key, iv)
    }

}

extern {
    fn memset(s: *mut libc::c_void, c: u32, n: libc::size_t) -> *mut libc::c_void;
}

const PAGE_SIZE: usize = 4096;

struct JitMemory {
    contents : *mut u8
}

impl JitMemory {
    fn new(num_pages: usize) -> JitMemory {
        let contents : *mut u8;
        unsafe {
            let size = num_pages * PAGE_SIZE;
            let mut _contents : *mut libc::c_void = mem::uninitialized();
            libc::posix_memalign(&mut _contents, PAGE_SIZE, size);
            libc::mprotect(_contents, size, libc::PROT_EXEC | libc::PROT_READ | libc::PROT_WRITE);

            memset(_contents, 0xc3, size);

            contents = mem::transmute(_contents);
        }

        JitMemory { contents: contents }        
    }
}

impl Index<usize> for JitMemory {
    type Output = u8;

    fn index(&self, _index: usize) -> &u8 {
        unsafe {&*self.contents.offset(_index as isize) }
    }
}

impl IndexMut<usize> for JitMemory {
    fn index_mut(&mut self, _index: usize) -> &mut u8 {
        unsafe {&mut *self.contents.offset(_index as isize) }
    }
}


fn main() {
    //#[cfg(target_os = "linux")]
    //#[cfg(not(debug_assertions))]
    let mut inp = String::new();
    io::stdin().read_line(&mut inp).expect("failed to readline");
    if inp.len() >15{
        let mut ret = enc(&inp);
        let fun = run_jit(&ret);
        if fun() == 0 {
            println!("Good Job");
        }
        else {
            println!("Try again");
        }

    }
}


fn enc(inp: &str) -> Vec<u8> {
    let key = "UBHPjBKlsQ2TuNSk".as_bytes();
    let iv = "7y0M69TQScm7mfXv".as_bytes();
    let sm4_cbc = CryptSM4CBC::new(key, iv);
    return sm4_cbc.encrypt_cbc(inp.as_bytes());
}


fn run_jit(inp: &Vec<u8>) -> fn() -> i64 {
    let mut jit : JitMemory = JitMemory::new(2);
    jit[0] = 0x48;
    jit[1] = 0xc7;
    jit[2] = 0xc0;
    jit[3] = inp[3];
    jit[4] = inp[2];
    jit[5] = inp[1];
    jit[6] = inp[0];
    jit[7] = 0x48;
    jit[8] = 0xc7;
    jit[9] = 0xc1;
    jit[10] = 0xcd;
    jit[11] = 0xf3;
    jit[12] = 0xa3;
    jit[13] = 0x93;
    jit[14] = 0x48;
    jit[15] = 0x29;
    jit[16] = 0xc0 | (1<<3) | 0;
    jit[17] = 0x48;
    jit[18] = 0xc7;
    jit[19] = 0xc1;
    jit[20] = inp[7];
    jit[21] = inp[6];
    jit[22] = inp[5];
    jit[23] = inp[4];
    jit[24] = 0x48;
    jit[25] = 0x01;
    jit[26] = 0xc0 | (1<<3) | 0;
    jit[27] = 0x48;
    jit[28] = 0xc7;
    jit[29] = 0xc1;
    jit[30] = 0xEF;
    jit[31] = 0xBE;
    jit[32] = 0x37;
    jit[33] = 0x13;
    jit[34] = 0x48;
    jit[35] = 0x31;
    jit[36] = 0xc0 | (1<<3) | (0<<0);
    jit[37] = 0x48;
    jit[38] = 0xc7;
    jit[39] = 0xc1;
    jit[40] = 0xcb;
    jit[41] = 0xf5;
    jit[42] = 0xae;
    jit[43] = 0x33;
    jit[44] = 0x48;
    jit[45] = 0x29;
    jit[46] = 0xc0 | (1<<3) | 0;
    jit[47] = 0x48;
    jit[48] = 0xc7;
    jit[49] = 0xc1;
    jit[50] = inp[11];
    jit[51] = inp[10];
    jit[52] = inp[9];
    jit[53] = inp[8];
    jit[54] = 0x48;
    jit[55] = 0x01;
    jit[56] = 0xc0 | (1<<3) | 0;
    jit[57] = 0x48;
    jit[58] = 0xc7;
    jit[59] = 0xc1;
    jit[60] = inp[15];
    jit[61] = inp[14];
    jit[62] = inp[13];
    jit[63] = inp[12];
    jit[64] = 0x48;
    jit[65] = 0xc7;
    jit[66] = 0xc2;
    jit[67] = inp[19];
    jit[68] = inp[18];
    jit[69] = inp[17];
    jit[70] = inp[16];
    jit[71] = 0x48;
    jit[72] = 0x89;
    jit[73] = 0xc0 | (0<<3) | (3<<0);
    jit[74] = 0x48;
    jit[75] = 0x31;
    jit[76] = 0xc0 | (2<<3) | (0<<0);
    jit[77] = 0x48;
    jit[78] = 0x31;
    jit[79] = 0xc0 | (1<<3) | (3<<0);
    jit[80] = 0x48;
    jit[81] = 0xc7;
    jit[82] = 0xc2;
    jit[83] = 0xce;
    jit[84] = 0x68;
    jit[85] = 0x0d;
    jit[86] = 0x55;
    jit[87] = 0x48;
    jit[88] = 0x29;
    jit[89] = 0xc0 | (2<<3) | 0;
    jit[90] = 0x48;
    jit[91] = 0xc7;
    jit[92] = 0xc2;
    jit[93] = 0xeb;
    jit[94] = 0x51;
    jit[95] = 0x97;
    jit[96] = 0x5f;
    jit[97] = 0x48;
    jit[98] = 0x29;
    jit[99] = 0xc0 | (2<<3) | 3;
    jit[100] = 0x48;
    jit[101] = 0x01;
    jit[102] = 0xc0 | (3<<3) | 0;
    jit[103] = 0x48;
    jit[104] = 0xc7;
    jit[105] = 0xc1;
    jit[106] = inp[23];
    jit[107] = inp[22];
    jit[108] = inp[21];
    jit[109] = inp[20];
    jit[110] = 0x48;
    jit[111] = 0xc7;
    jit[112] = 0xc2;
    jit[113] = inp[27];
    jit[114] = inp[26];
    jit[115] = inp[25];
    jit[116] = inp[24];
    jit[117] = 0x48;
    jit[118] = 0x01;
    jit[119] = 0xc0 | (0<<3) | 1;
    jit[120] = 0x48;
    jit[121] = 0x01;
    jit[122] = 0xc0 | (0<<3) | 2;
    jit[123] = 0x48;
    jit[124] = 0xc7;
    jit[125] = 0xc0;
    jit[126] = inp[31];
    jit[127] = inp[30];
    jit[128] = inp[29];
    jit[129] = inp[28];
    jit[130] = 0x48;
    jit[131] = 0x31;
    jit[132] = 0xc0 | (0<<3) | (2<<0);
    jit[133] = 0x48;
    jit[134] = 0x31;
    jit[135] = 0xc0 | (0<<3) | (1<<0);
    jit[136] = 0x48;
    jit[137] = 0xc7;
    jit[138] = 0xc0;
    jit[139] = 0xa4;
    jit[140] = 0x34;
    jit[141] = 0xaa;
    jit[142] = 0x04;
    jit[143] = 0x48;
    jit[144] = 0xc7;
    jit[145] = 0xc3;
    jit[146] = 0x53;
    jit[147] = 0x65;
    jit[148] = 0x78;
    jit[149] = 0x2c;
    jit[150] = 0x48;
    jit[151] = 0x29;
    jit[152] = 0xc0 | (2<<3) | 3;
    jit[153] = 0x48;
    jit[154] = 0x29;
    jit[155] = 0xc0 | (1<<3) | 0;
    jit[156] = 0x48;
    jit[157] = 0x01;
    jit[158] = 0xc0 | (3<<3) | 0;
    jit[159] = 0x48;
    jit[160] = 0xc7;
    jit[161] = 0xc1;
    jit[162] = inp[11];
    jit[163] = inp[10];
    jit[164] = inp[9];
    jit[165] = inp[8];
    jit[166] = 0x48;
    jit[167] = 0x01;
    jit[168] = 0xc0 | (1<<3) | 0;
    jit[169] = 0x48;
    jit[170] = 0xc7;
    jit[171] = 0xc1;
    jit[172] = inp[15];
    jit[173] = inp[14];
    jit[174] = inp[13];
    jit[175] = inp[12];
    jit[176] = 0x48;
    jit[177] = 0xc7;
    jit[178] = 0xc2;
    jit[179] = inp[19];
    jit[180] = inp[18];
    jit[181] = inp[17];
    jit[182] = inp[16];
    jit[183] = 0x48;
    jit[184] = 0x31;
    jit[185] = 0xc0 | (2<<3) | (0<<0);
    jit[186] = 0x48;
    jit[187] = 0x31;
    jit[188] = 0xc0 | (1<<3) | (0<<0);
    jit[189] = 0x48;
    jit[190] = 0xc7;
    jit[191] = 0xc3;
    jit[192] = 0x51;
    jit[193] = 0x00;
    jit[194] = 0x18;
    jit[195] = 0x74;
    jit[196] = 0x48;
    jit[197] = 0x29;
    jit[198] = 0xc0 | (3<<3) | 0;
    jit[199] = 0x48;
    jit[200] = 0xc7;
    jit[201] = 0xc1;
    jit[202] = inp[23];
    jit[203] = inp[22];
    jit[204] = inp[21];
    jit[205] = inp[20];
    jit[206] = 0x48;
    jit[207] = 0x01;
    jit[208] = 0xc0 | (1<<3) | 0;
    jit[209] = 0x48;
    jit[210] = 0xc7;
    jit[211] = 0xc1;
    jit[212] = inp[27];
    jit[213] = inp[26];
    jit[214] = inp[25];
    jit[215] = inp[24];
    jit[216] = 0x48;
    jit[217] = 0xc7;
    jit[218] = 0xc2;
    jit[219] = inp[31];
    jit[220] = inp[30];
    jit[221] = inp[29];
    jit[222] = inp[28];
    jit[223] = 0x48;
    jit[224] = 0x31;
    jit[225] = 0xc0 | (2<<3) | (0<<0);
    jit[226] = 0x48;
    jit[227] = 0x31;
    jit[228] = 0xc0 | (1<<3) | (0<<0);
    jit[229] = 0x48;
    jit[230] = 0xc7;
    jit[231] = 0xc3;
    jit[232] = 0x4c;
    jit[233] = 0x99;
    jit[234] = 0x07;
    jit[235] = 0x3e;
    jit[236] = 0x48;
    jit[237] = 0x29;
    jit[238] = 0xc0 | (3<<3) | 0;
    unsafe { mem::transmute(jit.contents) }
}