import shogi
import subprocess
import time
import re
from dotenv import load_dotenv
import random
import os
import signal

def env():
    if os.path.exists(".debug"):
        load_dotenv(override=True)
        flag = os.environ.get("FLAG")
        if flag:
            print("debugging... flag is:", flag)
            return True
    return False

class TimeoutError(Exception):
    pass

def timeout_handler(signum, frame):
    raise TimeoutError("Time's up!")

def timed_input(prompt, timeout=10):
    """Get input with a timeout"""
    signal.signal(signal.SIGALRM, timeout_handler)
    signal.alarm(timeout)
    
    try:
        result = input(prompt)
        signal.alarm(0)  # Cancel the alarm
        return result
    except TimeoutError:
        print(f"\nTime's up! You took longer than {timeout} seconds.")
        return "TIMEOUT"
    finally:
            signal.alarm(0)  

class ShogiGame:
    def __init__(self, stockfish_path):
        self.board = shogi.Board()
        self.stockfish_path = stockfish_path
        try:
            self.engine = subprocess.Popen(
                self.stockfish_path,
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                universal_newlines=True
            )
            self.move_history = []
            self._send_command("usi")
            self._send_command("setoption name Threads value 1")
            self._send_command("setoption name USI_OwnBook value false")
            self._send_command("isready")
            self._wait_for_response("readyok")
            self.engine_available = True
        except (FileNotFoundError, OSError):
            print(f"Warning: Could not find engine at {stockfish_path}")
            print("Running in fallback mode without AI assistance.")
            self.engine = None
            self.engine_available = False

    def _send_command(self, command):
        sanitized_command = command.replace('\n', '').replace('\r', '')
        print(f"Sending to engine: {sanitized_command}")
        self.engine.stdin.write(sanitized_command + "\n")
        self.engine.stdin.flush()

    def _wait_for_response(self, expected, timeout=5):
        print(f"Waiting for engine response: {expected}")
        start = time.time()
        while time.time() - start < timeout:
            line = self.engine.stdout.readline().strip()
            if line:
                print(f"Engine response: {line}")
            if line.startswith(expected):
                return line
        raise TimeoutError(f"Expected {expected}, but engine did not respond.")

    def get_ai_move(self):
        sfen = self.board.sfen()
        print(f"SFEN >>>>> {sfen}")
        self._send_command(f"position sfen {sfen}")
        self._send_command("go depth 25")

        start_time = time.time()
        bestmove = None
        while time.time() - start_time < 25:
            line = self.engine.stdout.readline().strip()
            if line.startswith("bestmove"):
                bestmove = line.split()[1]
                break

        print(f"AI bestmove from engine: {bestmove}")

        if not bestmove or bestmove == "(none)":
            legal_moves = list(self.board.legal_moves)
            if legal_moves:
                return legal_moves[0].usi()
            else:
                raise ValueError("No legal moves available")

        try:
            move_obj = shogi.Move.from_usi(bestmove)
            if move_obj in self.board.legal_moves:
                return bestmove
            else:
                legal_moves = list(self.board.legal_moves)
                if legal_moves:
                    return random.choice(legal_moves).usi()
                else:
                    raise ValueError("No legal moves available")
        except ValueError as e:
            legal_moves = list(self.board.legal_moves)
            if legal_moves:
                return random.choice(legal_moves).usi()
            else:
                raise ValueError("No legal moves available")

    def display_board(self):
        board_str = str(self.board)
        print("\n  9  8  7  6  5  4  3  2  1")
        print("+---------------------------+")
        rows = board_str.strip().split('\n')
        for i, row in enumerate(rows):
            print(f"| {row} | {chr(ord('a') + i)}")
        print("+---------------------------+")
        print(f"Black (Sente/AI) pieces in hand: {self.board.pieces_in_hand[shogi.BLACK]}")
        print(f"White (Gote/You) pieces in hand: {self.board.pieces_in_hand[shogi.WHITE]}")
        print(f"Turn: {'Black (AI)' if self.board.turn == shogi.BLACK else 'White (You)'}")
        print(f"Current SFEN: {self.board.sfen()}")

    def is_legal_move(self, move_str):
        try:
            move = shogi.Move.from_usi(move_str)
            if move not in self.board.legal_moves:
                return False, "Illegal move: The move is not allowed or a piece is blocking the path."
            return True, ""
        except ValueError as e:
            return False, str(e)

    def get_legal_moves(self):
        return [move.usi() for move in self.board.legal_moves]

    def get_random_move(self):
        legal_moves = list(self.board.legal_moves)
        if legal_moves:
            return random.choice(legal_moves).usi()
        return None

    def play(self):
        print("""

   _____  _                                           
  / ____|| |                                          
 | (___  | |__    ___    __ _   __ _   ___   ___  ____
  \___ \ | '_ \  / _ \  / _` | / _` | / _ \ / _ \|_  /
  ____) || | | || (_) || (_| || (_| ||  __/|  __/ / / 
 |_____/ |_| |_| \___/  \__, | \__, | \___| \___|/___|
                         __/ |  __/ |                 
                        |___/  |___/                  

""")
        print("Welcome to Shogi! The AI plays as Sente (Black) and moves first.")
        print("You play as Gote (White).")
        print("Enter moves in USI format (e.g., '7c7d', '5e5d+', 'S*5e').")
        print("Commands: 'quit','legal'")
        print("⏰ TIME LIMIT: You have 10 seconds per move " )

        if not self.engine_available:
            print("\nWARNING: Running in fallback mode without Stockfish engine.")
            print("AI moves will be selected randomly from legal moves.")

        print("\nAI thinking...")
        try:
            ai_move = self.get_ai_move() if self.engine_available else self.get_random_move()
            if ai_move:
                print(f"AI is playing move: {ai_move}")
                self.board.push_usi(ai_move)
                self.move_history.append(ai_move)
            else:
                print("AI could not make a move. Game terminated.")
                return
        except ValueError as e:
            print(f"Error with AI move: {e}. Game terminated.")
            return

        while not self.board.is_game_over():
            if env():
                return

            self.display_board()
            while True:
                print(f"⏰ You have 5 seconds to make your move...")
                move = timed_input("Your move: ", timeout=5).strip()

                if move == "TIMEOUT":
                    print("Game over!")
                    return

                if env():
                    return

                elif move.lower() == "quit":
                    print("Thanks for playing!")
                    return
                elif move.lower() == "legal":
                    legal_moves = self.get_legal_moves()
                    print(f"Legal moves ({len(legal_moves)}): {', '.join(legal_moves)}")
                    continue

                try:
                    if "*" in move and re.fullmatch(r"[PLNSGBR][*][1-9][a-i]", move.split('\n')[0]):
                        move_parts = move.split('\n')
                        drop_move = move_parts[0]

                        is_legal, error_msg = self.is_legal_move(drop_move)
                        if not is_legal:
                            print(error_msg)
                            continue
                        
                        move_obj = shogi.Move.from_usi(drop_move)
                        self.board.push(move_obj)
                        self.move_history.append(drop_move)

                        sfen = self.board.sfen()
                        self._send_command(f"position sfen {sfen} moves {drop_move}")

                        if len(move_parts) > 1:
                            for option in move_parts[1:]:
                                option = option.strip()
                                if option: 
                                    self._send_command(option)

                        continue

                    is_legal, error_msg = self.is_legal_move(move)
                    if not is_legal:
                        print(error_msg)
                        continue

                    self.board.push_usi(move)
                    self.move_history.append(move)
                    break
                except ValueError as e:
                    print(f"Invalid move: {e}")
                    print("Type 'legal' to see valid moves.")

            if self.board.is_game_over():
                break

            print("AI thinking...")
            try:
                ai_move = self.get_ai_move() if self.engine_available else self.get_random_move()
                if ai_move:
                    self.board.push_usi(ai_move)
                    self.move_history.append(ai_move)
                    print(f"AI move: {ai_move}")
                else:
                    print("AI could not make a move. Game terminated.")
                    return
            except ValueError as e:
                print(f"Error with AI move: {e}. Game terminated.")
                return

        self.display_board()
        print("Game over!")
        if self.board.is_checkmate():
         if self.board.turn == shogi.WHITE:
             print("Checkmate! You win!")
             if self.engine_available:
                 try:
                     print("babushka mode enabled.")
                     print("""⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠛⠛⠋⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠙⠛⠛⠛⠿⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⡀⠠⠤⠒⢂⣉⣉⣉⣑⣒⣒⠒⠒⠒⠒⠒⠒⠒⠀⠀⠐⠒⠚⠻⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⡠⠔⠉⣀⠔⠒⠉⣀⣀⠀⠀⠀⣀⡀⠈⠉⠑⠒⠒⠒⠒⠒⠈⠉⠉⠉⠁⠂⠀⠈⠙⢿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠔⠁⠠⠖⠡⠔⠊⠀⠀⠀⠀⠀⠀⠀⠐⡄⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⠀⠉⠲⢄⠀⠀⠀⠈⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠊⠀⢀⣀⣤⣤⣤⣤⣀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠜⠀⠀⠀⠀⣀⡀⠀⠈⠃⠀⠀⠀⠸⣿⣿⣿⣿
⣿⣿⣿⣿⡿⠥⠐⠂⠀⠀⠀⠀⡄⠀⠰⢺⣿⣿⣿⣿⣿⣟⠀⠈⠐⢤⠀⠀⠀⠀⠀⠀⢀⣠⣶⣾⣯⠀⠀⠉⠂⠀⠠⠤⢄⣀⠙⢿⣿⣿
⣿⡿⠋⠡⠐⠈⣉⠭⠤⠤⢄⡀⠈⠀⠈⠁⠉⠁⡠⠀⠀⠀⠉⠐⠠⠔⠀⠀⠀⠀⠀⠲⣿⠿⠛⠛⠓⠒⠂⠀⠀⠀⠀⠀⠀⠠⡉⢢⠙⣿
⣿⠀⢀⠁⠀⠊⠀⠀⠀⠀⠀⠈⠁⠒⠂⠀⠒⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⢀⣀⡠⠔⠒⠒⠂⠀⠈⠀⡇⣿
⣿⠀⢸⠀⠀⠀⢀⣀⡠⠋⠓⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠈⠢⠤⡀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⡠⠀⡇⣿
⣿⡀⠘⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠈⠑⡦⢄⣀⠀⠀⠐⠒⠁⢸⠀⠀⠠⠒⠄⠀⠀⠀⠀⠀⢀⠇⠀⣀⡀⠀⠀⢀⢾⡆⠀⠈⡀⠎⣸⣿
⣿⣿⣄⡈⠢⠀⠀⠀⠀⠘⣶⣄⡀⠀⠀⡇⠀⠀⠈⠉⠒⠢⡤⣀⡀⠀⠀⠀⠀⠀⠐⠦⠤⠒⠁⠀⠀⠀⠀⣀⢴⠁⠀⢷⠀⠀⠀⢰⣿⣿
⣿⣿⣿⣿⣇⠂⠀⠀⠀⠀⠈⢂⠀⠈⠹⡧⣀⠀⠀⠀⠀⠀⡇⠀⠀⠉⠉⠉⢱⠒⠒⠒⠒⢖⠒⠒⠂⠙⠏⠀⠘⡀⠀⢸⠀⠀⠀⣿⣿⣿
⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠑⠄⠰⠀⠀⠁⠐⠲⣤⣴⣄⡀⠀⠀⠀⠀⢸⠀⠀⠀⠀⢸⠀⠀⠀⠀⢠⠀⣠⣷⣶⣿⠀⠀⢰⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠁⢀⠀⠀⠀⠀⠀⡙⠋⠙⠓⠲⢤⣤⣷⣤⣤⣤⣤⣾⣦⣤⣤⣶⣿⣿⣿⣿⡟⢹⠀⠀⢸⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠑⠀⢄⠀⡰⠁⠀⠀⠀⠀⠀⠈⠉⠁⠈⠉⠻⠋⠉⠛⢛⠉⠉⢹⠁⢀⢇⠎⠀⠀⢸⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⠈⠢⢄⡉⠂⠄⡀⠀⠈⠒⠢⠄⠀⢀⣀⣀⣰⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⢀⣎⠀⠼⠊⠀⠀⠀⠘⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠉⠢⢄⡈⠑⠢⢄⡀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⢀⠀⠀⠀⠀⠀⢻⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⡈⠑⠢⢄⡀⠈⠑⠒⠤⠄⣀⣀⠀⠉⠉⠉⠉⠀⠀⠀⣀⡀⠤⠂⠁⠀⢀⠆⠀⠀⢸⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⡀⠁⠉⠒⠂⠤⠤⣀⣀⣉⡉⠉⠉⠉⠉⢀⣀⣀⡠⠤⠒⠈⠀⠀⠀⠀⣸⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣶⣤⣤⣤⣤⣀⣀⣤⣤⣤⣶⣾⣿⣿⣿⣿⣿""")
                     cmd = input("")
                     self._send_command(cmd)
                 except Exception as e:
                     print(f"Engine command error: {e}")
             env()
         else:
             print("Checkmate! AI wins.")



        else:
            print("Game ended in a draw or stalemate.")

    def __del__(self):
        try:
            if hasattr(self, 'engine') and self.engine:
                self._send_command("quit")
        except:
            pass

if __name__ == "__main__":
    STOCKFISH_PATH = "./YaneuraOu/source/YaneuraOu-by-gcc"
    try:
        game = ShogiGame(STOCKFISH_PATH)
        if not game.engine_available:
            print("Kindly rerun i dont think it intialized properly")
    except Exception as e:
        print(f"Error initializing game: {e}")
    game.play()