# Dont-Whisper

## Challenge Description
many say that neural networks are non deterministic and generating mappings between input and output is non TRIVIAL

## Short Writeup 
- Whisper model converts audio to text
- text is passed through subprocess and not sanitized
- difficult to generate a command injection through manual voice
- Need to invert the Neural network that will generate the audio file we need 
- Implement Inversion of the model.
- Generate the audio file and send, get flag!

## Flag
`bi0sctf{DiD_Y0u_kn0w_NN_c4n_b3_1nv3rt3d-1729}`

## Author 
w1z

