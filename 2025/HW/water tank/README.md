# Water Tank

## Challenge Description
You've gained access to a water tank control system at a critical infrastructure facility. The tank is currently filling with water and will soon overflow! Your mission is to understand the industrial control protocol to find and close the right valves before it's too late.

A packet capture of Modbus network traffic is available. Analyze it to find the login credentials required to access the system.

### Challenge Files
- [Primary Link](https://drive.google.com/file/d/1R84mp8BMFP_q8quSjCnhiuVIB7PxzhQQ/view?usp=sharing)
- [Mirror Link](https://1drv.ms/f/c/95fb325e3ede6b6c/EmFXN0hkWz5OpBwBZ-1RjKoBl-XaZjq0qVYroZNouwMKqQ?e=eQJPdI)

**a39b181196903fa3d46f626828e3a71f  modbus_capture.pcap**

## Short writeup
- The valve control coils might be anywhere in the first 50 addresses
- Find the correct coils that control the valves
- Close the valves to prevent the tank from overflowing
- Read the flag from the holding registers after successfully closing the valve

## Flag
`bi0s{n0_m0r3_w3t_p4nts_0n_my_w4tch}`

## Author
3ji
