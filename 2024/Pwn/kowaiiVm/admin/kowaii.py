from dn3 import p64, p32, p16, p8

opcodes = {
    "ADD":               0xb0,
    "SUB":               0xb1,
    "MUL":               0xb2,
    "SHR":               0xb3,
    "SHL":               0xb4,
    "PUSH":              0xb5,
    "POP":               0xb6,
    "GET":               0xb7,
    "SET":               0xb8,
    "MOV":               0xb9,
    "CALL":              0xba,
    "RET":               0xbb,
    "NOP":               0xbc,
    "HLT":               0xbf,
    "X0":                0x0,
    "X1":                0x1,
    "X2":                0x2,
    "X3":                0x3,
    "X4":                0x4,
    "X5":                0x5,
}


class kowaiiBin():
    

    def __init__(self, entry:int, bss:int):
        self.entry = entry
        self.bss =  bss
        self.bssData = {}
        self.funcEntries = {}
        return


    def raw(self) -> str:

        funcAddrs = list(self.funcEntries.keys())
        bssOffsets = list(self.bssData.keys())
        funcAddrs.sort()

        raw_bin  = ""
        raw_bin += "KOWAII"                  # Header
        raw_bin += p16(self.entry)           # Entry point
        raw_bin += p32(0xdeadc0de)           # Magic value
        raw_bin += p16(self.bss)             # .bss start
        raw_bin += p8(len(funcAddrs))        # No.of functions

        for addr in funcAddrs:
            funcEntry  = ""
            funcEntry += self.funcEntries[addr]["hash"]             # Hash/Unique identifier
            funcEntry += p64(addr)                                  # Address
            funcEntry += p8(len(self.funcEntries[addr]["code"]))    # Size
            funcEntry += p8(0)                                      # Call count
            raw_bin += funcEntry

        for addr in funcAddrs:
            raw_bin = raw_bin.ljust(addr,"\x00")
            raw_bin += self.funcEntries[addr]["code"]    # Place code at correct offsets

        raw_bin = raw_bin.ljust(self.bss, "\x00")
        
        for offset in bssOffsets:
            raw_bin = raw_bin.ljust(self.bss+offset, "\x00")
            raw_bin += p64(self.bssData[offset])

        raw_bin += "\n"
        return raw_bin
    

    def addFunc(self, hash:str, address: int, code: str):
        self.funcEntries[address] = {"hash": hash, "code": self.assembleCode(code)}

    
    def addConst(self, val: int, offset: int):
        self.bssData[offset] = val


    def assembleCode(self, code: str) -> str:

        bytecode = ""
        prev_opcode = ""

        for line in code.split("\n"):
            curr_op = ""
            count = 1
        
            line = line.replace(",", "")
            line = line.rstrip(" ").lstrip(" ")

            if line.startswith("#"):
                continue

            line = line.split()
            if len(line) > 2 and line[-2] == "*":
                count = int(line[-1])
                line = line[:-2]

            for token in line:
                token = token.upper()

                if token not in opcodes.keys():
                    try: 
                        if prev_opcode == "CALL":
                            curr_op += token.lower()[:2]
                            continue

                        if "X" in token:
                            num = int(token,16)
                        else:
                            num = int(token)

                        if prev_opcode in ["MOV", "GET", "SET"]:
                            curr_op += p32(num)
                        elif prev_opcode in ["SHR", "SHL"]:
                            curr_op += p8(num)
                        continue

                    except:
                        continue

                curr_op += chr(opcodes[token])
                if not token.startswith("X"):
                    prev_opcode = token.upper()

            bytecode += curr_op*count

        return bytecode