import socket
import threading
import sys
import os
import platform
import psutil
from datetime import datetime
from web3 import Web3
import json
from dotenv import load_dotenv
import subprocess
import time
class ServerInstance:
    def __init__(self):
        self.start_time = datetime.now()
        self.setup=""
        self.rpc_url_local="http://blockchain:8545"

        self.setup_contract_abi = [
            {
                "inputs": [],
                "name": "isSolved",
                "outputs": [{"internalType": "bool", "name": "", "type": "bool"}],
                "stateMutability": "view",
                "type": "function"
            }
        ]

        
        load_dotenv()

    def get_instance_details(self,client_socket):
        if(self.setup==""):
            client_socket.send("\nHang tight! Your instance is being created...\n\n".encode())
            result = subprocess.run(["make", "deploy"])

            with open("instance_details.json", "r") as f:
                data = json.load(f)
            self.setup=data.get("setup")
            self.Player=data.get("player")
            self.player_pk= data.get("player_pk")
            self.rpc_url=os.getenv("RPC_URL")

            try:
                self.w3 = Web3(Web3.HTTPProvider(self.rpc_url_local))
                if self.w3.is_connected():
                    print(f"[+] Connected to blockchain at {self.rpc_url_local}")
                    self.contract = self.w3.eth.contract(
                        address=self.setup,
                        abi=self.setup_contract_abi
                    )
                else:
                    print("[!] Failed to connect to blockchain")
                    self.w3 = None
                    self.contract = None
            except Exception as e:
                print(f"[!] Web3 initialization error: {e}")
                self.w3 = None
                self.contract = None

        

        try:
            details = {
                "setup": self.setup,
                "player": self.Player,
                "player_pk": self.player_pk,
                "rpc_url": self.rpc_url,
            }
            box_width = 80
            
            top_border = "╔" + "═" * box_width + "╗"
            title_line = "║" + "INSTANCE DETAILS".center(box_width) + "║"
            separator = "╠" + "═" * box_width + "╣"
            bottom_border = "╚" + "═" * box_width + "╝"
            
            formatted_details = top_border + "\n"
            formatted_details += title_line + "\n"
            formatted_details += separator + "\n"
            
            for key, value in details.items():
                display_value = str(value)
                content = f" {key:<10} : {display_value}"
                padded_content = content.ljust(box_width)
                formatted_details += "║" + padded_content + "║\n"
            
            formatted_details += bottom_border + "\n"
            
            client_socket.send(formatted_details.encode())
            
        except Exception as e:   
            client_socket.send(f"Error getting instance details: {str(e)}\n".encode()) 
    
    def get_flag(self,client_socket):
        SOLVED = self.contract.functions.isSolved().call()
        if(SOLVED):
            client_socket.send(f"\n🏁: {os.getenv('FLAG')}\n".encode())
        else:
            return client_socket.send("Chall Unsolved!!".encode())
        

class Server:
    def __init__(self, host='localhost', port=8888):
        self.host = host
        self.port = port
        self.instance = ServerInstance()
        self.running = True
        
    def handle_client(self, client_socket, address):
        """Handle individual client connections"""
        print(f"[+] Connection from {address}")
        
        try:
            welcome_msg = f"""

Available Options:
╔══════════════════════════════════════╗
║1. Get instance details               ║
║2. Get flag                           ║
╚══════════════════════════════════════╝

Enter your choice (1-2): """
            
            client_socket.send(welcome_msg.encode())
            
            while True:
                try:
                    response = client_socket.recv(1024).decode().strip()
                    if not response:
                        break
                        
                    choice = response
                    
                    if choice == '1':
                        self.instance.get_instance_details(client_socket)
                        break           
                    elif choice == '2':
                        self.instance.get_flag(client_socket)
                        break
                        
                    else:
                        error_msg = f"\n❌ Invalid choice: {choice}\nPlease enter 1 or 2\n"
                        client_socket.send(error_msg.encode())
                    
                    menu_msg = "\nEnter your choice (1-2): "
                    client_socket.send(menu_msg.encode())
                    
                except socket.timeout:
                    break
                except Exception as e:
                    print(f"[!] Error handling client {address}: {e}")
                    break
                    
        except Exception as e:
            print(f"[!] Connection error with {address}: {e}")
        finally:
            client_socket.close()
            print(f"[-] Connection closed with {address}")
    
    def start(self):
        try:
            server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            server_socket.bind((self.host, self.port))
            server_socket.listen(5)
            
            
            while self.running:
                try:
                    client_socket, address = server_socket.accept()
                    client_socket.settimeout(300) 
                    
                    client_thread = threading.Thread(
                        target=self.handle_client,
                        args=(client_socket, address)
                    )
                    client_thread.daemon = True
                    client_thread.start()
                    
                except Exception as e:
                    print(f"[!] Server error: {e}")
                    
        except Exception as e:
            print(f"[!] Failed to start server: {e}")
        finally:
            try:
                server_socket.close()
            except:
                pass
            print("[+] Server stopped")

def main():
    HOST = '0.0.0.0'
    PORT = 8888

    server = Server(HOST, PORT)
    server.start()

if __name__ == "__main__":
    main()