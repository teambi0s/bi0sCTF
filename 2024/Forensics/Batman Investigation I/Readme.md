# Batman Investigation I - Like Father Like Son
## Category: `Forensics`
## Difficulty: `Medium`

## Description

Damian Wayne stored a secret in his old pc, but Dr. Simon Hurt who got this information, planned a contingency against Damian by the help of Starlab's techies, poor Damaian was so eager to view the encrypted secret file that Raven sent him long back but Simon knows this piece of information as well as the decryption process, will he win this situation like a Wayne? will Damaian's Redemption be successful!?

File Password : vOCorthoAGESeNsivEli

## Handout
+ [Primary Link](https://drive.google.com/file/d/1Ewusc9amOY6GbWTWqPut45EyL7wGBweO/view?usp=sharing)
+ [Mirror Link](https://mega.nz/file/giFxmCJR#YFJICgO-0hVKalHCImRam49ErvNHsG-JY38pEVLFKxE)


`Flag format: bi0sCTF{...}`

## Short writeup

Malware that injects a dll via remote dll injection. The dll sets up the key as well teh process is reveiled via the injection on notepad as well notepad's origin, the file that has the encrypted flag is not retreivable and its present in the malware's heap as it is not flushed after further encryption by the malware and reversing should be done to figure out the heap as well as for decryption of the flag.

## Author
- Azr43lKn1ght

### Flag: 
`bi0sCTF{M4lw4r3_4n4ly51s_4nd_DF1R_1s_4w3s0m3_4nd_4ppr3c14t3d_th4t_y0u_s0lv3d_<33}`
