#!/bin/python3

import time
import threading
import random
import os
import sys
from pymodbus.server import StartTcpServer
from pymodbus.device import ModbusDeviceIdentification
from pymodbus.datastore import ModbusSequentialDataBlock, ModbusSlaveContext, ModbusServerContext
from dotenv import load_dotenv

load_dotenv()

FLAG = os.getenv("FLAG")

VALVE_OPEN_COUNT_HR = 10
FLOW_RATE_HR = 11
CURRENT_TANK_LEVEL_HR = 12
VALVE_CONFIG_HR_START = 13  

TANK_MAX_LEVEL = 5000
FILL_RATE = 10
VALVE_COIL_ADDRESSES = random.sample(range(0, 50), 3)

def generate_safe_valve_logics(num_valves):
    logics = [0] + [random.choice([0, 1]) for _ in range(num_valves - 1)]
    random.shuffle(logics)
    return logics

VALVE_LOGICS = [random.choice([0, 1]) for _ in VALVE_COIL_ADDRESSES]

FLAG_REGISTER_START = random.randint(50, 150)

class TankSimulation:
    def __init__(self, context):
        self.context = context
        self.running = True
        self.flag_revealed = False
        self.tank_level = 200  
        self.lock = threading.Lock()

    def update_tank(self):
        slave_id = 0x01
        
        while self.running and self.tank_level < TANK_MAX_LEVEL:
            try:
                with self.lock: 
                    all_closed = True
                    valve_states = []

                    time.sleep(1)
                    print("\n[~] Valve Status Check:", flush=True)

                    for idx, addr in enumerate(VALVE_COIL_ADDRESSES):
                        coil_value = self.context[slave_id].getValues(1, addr, count=1)[0]
                        logic_type = VALVE_LOGICS[idx]
                        is_closed = coil_value == 1 if logic_type == 0 else coil_value == 0
                        state_str = "CLOSED" if is_closed else "OPEN"

                        config_value = (addr << 8) | logic_type
                        print(f"    - Valve #{idx+1}: coil[{addr}], logic={logic_type}, state={state_str}, config=0x{config_value:04X}", flush=True)

                        valve_states.append((addr, coil_value, logic_type, is_closed))

                        if not is_closed:
                            all_closed = False


                    time.sleep(0.5)
                    print(f"[*] Tank level: {self.tank_level}/{TANK_MAX_LEVEL}", flush=True)

                    open_valves = sum(1 for _, _, _, closed in valve_states if not closed)
                    dynamic_fill_rate = FILL_RATE * open_valves

                    if all_closed:
                        if not self.flag_revealed:
                            print("[+] All valves CLOSED! Tank secured.", flush=True)
                            print("[+] The flag has been written to the holding registers.", flush=True)
                            flag_registers = []
                            for i in range(0, len(FLAG), 2):
                                first = ord(FLAG[i]) << 8
                                second = ord(FLAG[i + 1]) if i + 1 < len(FLAG) else 0
                                flag_registers.append(first | second)
                            
                            self.context[slave_id].setValues(3, FLAG_REGISTER_START, flag_registers)
                            self.flag_revealed = True
                        else:
                            print("[+] All valves remain CLOSED. Tank secured. Make another connection!", flush=True)
                    else:
                        open_valves = sum(1 for _, _, _, closed in valve_states if not closed)
                        dynamic_fill_rate = FILL_RATE * open_valves
                        self.tank_level += dynamic_fill_rate
                        print(f"[!] {open_valves} valve(s) OPEN! Tank filling at rate {dynamic_fill_rate}/cycle", flush=True)

                        if self.tank_level >= TANK_MAX_LEVEL:
                            print("[!] Tank overflow! Your pants are wet :P ", flush=True)
                            self.running = False
                            break

                    self.context[slave_id].setValues(3, CURRENT_TANK_LEVEL_HR, [self.tank_level])
                    self.context[slave_id].setValues(3, VALVE_OPEN_COUNT_HR, [open_valves])
                    self.context[slave_id].setValues(3, FLOW_RATE_HR, [dynamic_fill_rate])

                    status = 2 if self.tank_level > 800 else 1 if self.tank_level > 600 else 0
                    self.context[slave_id].setValues(3, 1, [status])

                time.sleep(4)
            except KeyboardInterrupt:
                self.running = False
                break
            except Exception as e:
                print(f"[!] Error in tank simulation: {e}", flush=True)
                time.sleep(1)

def generate_garbage_values(size):
    values = []
    for _ in range(size):
        value_type = random.randint(0, 3)
        if value_type == 0:
            values.append(random.randint(20, 80))
        elif value_type == 1:
            values.append(random.randint(100, 500))
        elif value_type == 2:
            values.append(random.randint(0, 5))
        else:
            values.append(random.randint(1000, 9999))
    return values

def run_server():
    try:
        hr_values = generate_garbage_values(200)
        hr_values[0] = 200  
        hr_values[1] = 0    

        flag_length = (len(FLAG) + 1) // 2
        for i in range(FLAG_REGISTER_START, FLAG_REGISTER_START + flag_length):
            if i < len(hr_values):
                hr_values[i] = 0

        for i, (addr, logic) in enumerate(zip(VALVE_COIL_ADDRESSES, VALVE_LOGICS)):
            config_value = (addr << 8) | logic
            hr_values[VALVE_CONFIG_HR_START + i] = config_value

        store = ModbusSlaveContext(
            di=ModbusSequentialDataBlock(0, generate_garbage_values(100)),
            co=ModbusSequentialDataBlock(0, [0]*100),
            hr=ModbusSequentialDataBlock(0, hr_values),
            ir=ModbusSequentialDataBlock(0, generate_garbage_values(100)),
        )

        context = ModbusServerContext(slaves=store, single=True)

        for addr in VALVE_COIL_ADDRESSES:
            store.setValues(1, addr, [0])

        identity = ModbusDeviceIdentification()
        identity.VendorName = 'WaterTank'
        identity.ProductCode = 'W-A-T-E-R'
        identity.VendorUrl = 'https://garlicbread.com'
        identity.ProductName = 'WaterTank Controller'
        identity.ModelName = 'Sintex'
        identity.MajorMinorRevision = '1.0'

        simulator = TankSimulation(context)
        sim_thread = threading.Thread(target=simulator.update_tank)
        sim_thread.daemon = True
        sim_thread.start()

        print("\n+-------------------- System Information ----------------------+", flush=True)
        print("| Holding Registers : 200                                      |", flush=True)
        print("| Coils             : 100                                      |", flush=True)
        print("| Discrete Inputs   : 100                                      |", flush=True)
        print("| Input Registers   : 100                                      |", flush=True)
        print("| Tank Status: 0=normal, 1=high, 2=critical                    |", flush=True)
        print("+--------------------------------------------------------------+\n", flush=True)

        try:
            StartTcpServer(context, identity=identity, address=("0.0.0.0", 5020))
        except Exception as e:
            print(f"[!] Failed to start Modbus server: {e}", flush=True)
            
    except KeyboardInterrupt:
        print("\n[!] Server shutdown requested by user", flush=True)
        sys.exit(0)
    except Exception as e:
        print(f"[!] Server error: {e}", flush=True)
        sys.exit(1)

def main():
    try:
        server_thread = threading.Thread(target=run_server)
        server_thread.daemon = True
        server_thread.start()

        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n[!] Program interrupted by user", flush=True)
        sys.exit(0)
    except Exception as e:
        print(f"[!] Unexpected error: {e}", flush=True)
        sys.exit(1)

if __name__ == "__main__":
    main()
