import socket
import subprocess
import os
import select
import requests

PORT = int(os.getenv('PORT', 4000))
HOST = '0.0.0.0'

def handle_client(client_socket):
    try:
        client_socket.send(b"Enter shell commands (end with 'END' on a new line to check service connectivity):\n")
        data = b""
        # Start an interactive shell
        shell_process = subprocess.Popen(
            ['/bin/bash'],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1,  # Line buffering
            universal_newlines=True
        )
        
        # Set non-blocking mode for stdout and stderr
        os.set_blocking(shell_process.stdout.fileno(), False)
        os.set_blocking(shell_process.stderr.fileno(), False)
        
        while True:
            try:
                # Check for input from client or shell output
                readable, _, _ = select.select([client_socket, shell_process.stdout, shell_process.stderr], [], [], 10)
                
                # Handle client input
                if client_socket in readable:
                    chunk = client_socket.recv(1024)
                    if not chunk:  # Client closed connection
                        client_socket.send(b"Error: Connection closed before END\n")
                        break
                    data += chunk
                    # Check for "END" on a new line
                    if b'\nEND\n' in data:
                        data = data.replace(b'\nEND\n', b'')
                        # Send any remaining input to shell
                        if data.strip():
                            shell_process.stdin.write(data.decode('utf-8') + '\n')
                            shell_process.stdin.flush()
                        break
                    # Send input to shell
                    shell_process.stdin.write(chunk.decode('utf-8'))
                    shell_process.stdin.flush()

                # Read shell output
                if shell_process.stdout in readable:
                    stdout_data = shell_process.stdout.readline()
                    if stdout_data:
                        client_socket.send(stdout_data.encode('utf-8'))
                
                # Read shell errors
                if shell_process.stderr in readable:
                    stderr_data = shell_process.stderr.readline()
                    if stderr_data:
                        client_socket.send(stderr_data.encode('utf-8'))
            
            except socket.timeout:
                client_socket.send(b"Error: Input timeout\n")
                break
            except Exception as e:
                client_socket.send(f"Error: {str(e)}\n".encode('utf-8'))
                break

        # Terminate the shell process
        try:
            shell_process.terminate()
            shell_process.wait(timeout=1)
        except subprocess.TimeoutExpired:
            shell_process.kill()

        # Test connectivity to core service
        try:
            response = requests.get('http://core:3000', timeout=2)
            core_status = f"Core service reachable: {response.status_code}\n"
        except requests.RequestException:
            core_status = "Core service unreachable\n"

        # Attempt to contact legacy service (should fail due to network isolation)
        try:
            response = requests.get('http://legacy:3001', timeout=2)
            legacy_status = f"Unexpected: Legacy service reachable: {response.status_code}\n"
        except requests.RequestException:
            legacy_status = "Legacy service unreachable (as expected)\n"

        response = f"{core_status}{legacy_status}"
        client_socket.send(response.encode('utf-8'))
    except Exception as e:
        client_socket.send(f"Error: {str(e)}\n".encode('utf-8'))
    finally:
        client_socket.close()

def main():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.settimeout(30)  # Set timeout for accepting connections
    server_socket.bind((HOST, PORT))
    server_socket.listen(5)
    print(f"Runner service listening on {HOST}:{PORT}")

    while True:
        try:
            client_socket, addr = server_socket.accept()
            client_socket.settimeout(60)  # Timeout for client input
            print(f"Connection from {addr}")
            handle_client(client_socket)
        except socket.timeout:
            print("Timeout waiting for client connection")
            continue
        except KeyboardInterrupt:
            print("Shutting down server")
            break
        except Exception as e:
            print(f"Server error: {e}")
    
    server_socket.close()

if __name__ == "__main__":
    main()