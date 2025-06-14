# DEScent

*Writeup not meant for public release*

The challenge is made up of two parts:
    1. The DES parity bit issue, which allows for forced collisions, or regenerating same values out of the RNG
    2. The complex number output that can be solved using LLL. Let's call this complex encoding.

Complex encoding works by converting the input into a polynomial in the complex field. The coefficients are each byte.
It returns one random root of the given polynomial. This can be solved using LLL, as modelled in solve.sage

Idea is
1. Generate a secret value (16 bytes) that needs to be guessed. 
2. User can provide any seed, which passes through the DES RNG, but not for the secret. Only for their own messages
3. The program complex encodes the secret, and then a random (DES) value is complex encoded as well, and added to it. Let's call that an error. The random DES value comprises of user_seed + server_seed, out of which server_seed will always be secret. When secret value is being encoded, the program generates its own user_seed, and it's provided alongside the output. 
4. Attack is to provide your own message, alongside a vulnerable seed derived from the server-generated user_seed to get the same error as before. The server checks for duplicate user_seeds, which is why this step is necessary.
5. Attacker can subtract their own complex encoded message out of the output to get the error. 
6. Attacker can then subtract the recovered error out of <encoded secret + error> 
7. Finally, use LLL to recover secret and submit it to the oracle.
8. Challenge should only allow 3 queries in total. Intended solution would be  
    Query 1: To get encoded secret + error  
    Query 2: Known message + forced error  
    Query 3: Submit recovered secret to get the flag

## Flag: `bi0sctf{th4t_w4snt_t0o_c0mpl3x}`