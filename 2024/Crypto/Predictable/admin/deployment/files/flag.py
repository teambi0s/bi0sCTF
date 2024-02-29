import os
try:
    flag = int.from_bytes(os.environ['FLAG'].encode(), 'big')
except KeyError:
    flag = int.from_bytes(b'bi0sctf{fake_flag_for_testing}', 'big')