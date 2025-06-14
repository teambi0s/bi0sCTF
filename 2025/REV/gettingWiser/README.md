# gettingWiser 

## Challenge Description 
hey buster! get the hell outta the way, you're blocking the road! 

**MD5 Hash: d7125c00cc8a53727fe5727188b690df**

## Short Writeup 
- Userland program does some environment and hardware checks to see if hypervisors are supported on the machine 
- If supported, a hypervisor driver is decrytped and dropped to `C:\bi0s.sys`
- Userland program uses `DeviceIOControl` calls to interact with the now loaded hypervisor 
- Input is taken by userland program and sent to the driver 
- Driver receives 65 byte input, input is checked in the following format: 
    - 1st byte must be `a`
    - 2nd-33rd byte is the "key", checked by an embedded virtual machine 
    - 34th-65th byte is the "username", checked using blowfish encryption 
- Upon successful verification, the driver returns a success status, and failure for anything else 

## Flag
`bi0sctf{aBAHHCEUVDTINFuk7567r87kkjd3rtyyjsdogaeurrandom_stuffwerjgeorhdfy}`

## Author(s)
[the.m3chanic](https://x.com/the_m3chanic_), Cheetzu, y0urk4rma 
