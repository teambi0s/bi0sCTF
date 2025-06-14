import lief


def encrypt_function(binary, funcs, key):
    for func in funcs:
        offset = funcs[func][0]
        size = funcs[func][1]
        # print(f"Encrypting {func} at {hex(offset)}")0xdb
        text_section = binary.get_section(".text")
        text_offset = offset - text_section.virtual_address
        text_section_file_offset = text_section.file_offset
        target_function_offset = text_section_file_offset + text_offset

        with open("program", "rb") as f:
            packed = list(f.read())
        
        for i in range(size):
            packed[target_function_offset + i] ^= key[i % len(key)]

        with open("program", "wb") as f:
            f.write(bytes(packed))

        # print(f"Encrypted {func} at {hex(offset)}")


if __name__ == "__main__":
    init_list = ["chacha20_init_block","chacha20_block_set_counter","chacha20_init_context","chacha20_block_next","chacha20_xor","setup","rest_of_input_check","check"
    ]   

    key = bytes([0x69, 0x79, 0x34, 0x23, 0x56, 0x23, 0x56, 0x35,
                 0x64, 0x45, 0x56, 0x34, 0x57, 0x73, 0x23, 0x23])

    binary = lief.parse("program")

    functions = {}

    for symbol in binary.symbols:
        # print(symbol)
        # FIX HERE: compare symbol.type AS STRING
        if "FUNC" in str(symbol.type):
            print(symbol)
            functions[symbol.name] = {
                'address': symbol.value,
                'size': symbol.size,
                'visibility': str(symbol.visibility),
                'binding': str(symbol.binding),
            }

    to_encrypt = {}

    for func in init_list:
        if func not in functions:
            print(f"[-] Function {func} not found in binary symbols!")
            continue
        offset = functions[func]['address']
        size = functions[func]['size']
        print(f"[+] Found {func} at {hex(offset)}, size {size}")
        to_encrypt[func] = [offset, size]

    encrypt_function(binary, to_encrypt, key)
