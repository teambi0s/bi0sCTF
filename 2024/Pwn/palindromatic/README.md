# palindromatic

### Challenge Description

An unnecessarily complex palindrome checker, implemented as a kernel driver. What could possibly go wrong? 

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1wIMTFjU3_eVyX45kbXp97h6PZOpyPXTg/view?usp=sharing)
+ [Mirror Link](https://1drv.ms/u/s!AuMSH5328nQ7hF0UaF9AIRFj1hy6?e=b6Zgmx)

**MD5 Hash**: 9bd2d0c87224258098be2b8f638f312d

### Short Writeup

+ Sanitizing a request causes null byte overflow, corrupting type of adjacent request
+ Processing request with corrupted type, ends up in both queues
+ This can be abused for UAF, allowing for free primitive using reset
+ Spray requests and sanitize
+ Process until queue capacity doesn't change, indicating corrupted requset
+ Reset request to start of incoming queue
+ Process and reap all requests, leaving UAF request in incoming queue
+ Perform cross-cache and allocate pipe_buffers in place of UAF chunk
+ Trigger free using reset on UAF request
+ Spray pipe_buffers and compare contents to find victim pipe_buffer
+ Free all pipe_buffers while holding dangling reference to victim
+ Spray msg_msgsegs in place of pipe_buffers
+ Splice on victim pipe, causing it to be updated
+ Read msg_msgseg to leak pipe_buffer
+ Write forged pipe_buffer with flags=PIPE_BUF_CAN_MERGE using msgsnd
+ Now writing to pipe, commits to file
+ Overwrite /etc/passwd to change root's password
+ Profit!

### Flag

bi0sctf{p4l1ndr0me5_4r3_pr0bl3m4t1c_frfr_b851ea94}

### Author

**k1R4**  
