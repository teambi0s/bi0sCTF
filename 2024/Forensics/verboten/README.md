# verboten

### Challenge Description

Randon, an IT employee finds a USB on his desk after recess. Unable to contain his curiosity he decides to plug it in. Suddenly the computer goes haywire and before he knows it, some windows pops open and closes on its own. With no clue of what just happened, he tries seeking help from a colleague. Even after Richard's effort to remove the malware, Randon noticed that the malware persisted after his system restarted.

NOTE: All timestamps are in IST.

**Challenge File**:
+ [Primary Link](https://drive.google.com/drive/folders/1nPeDwniE4gHdXz_x70_oC433f3cXLvbe?usp=sharing)
+ [Mirror Link](https://mega.nz/file/MvkzWBTA#SNdR2q4_8EhqHFUI-1_1Ae0k1wI5ZwVJLsgyBrYV05o)
+ nc link

**MD5 Hash**: 

`afbb06aad57bba44e880879eda221904  -  verboten.ad1`

### Short Writeup

+  From SYSTEM registry hive, navigating to CurrentControlSet/Enum/USBSTOR, we can find the serial number,Device name,Manufacturer and timestamps
+  The SAM hive contains the user-id,the username,ResetData etc. ResetData entry has the answers to the backup questions.
+  Users/randon/AppData/Local/Google/Chrome/UserData/Default contains the chrome data like history etc. which can give the url that was visited by the usb.
+  ActivitiesCache.db with entry Type as 10 will contain the copied one-time use code.
+  mal.exe which was persisting even after efforts to remove can be found in the startup folder.
+  The conversations of slack can be found in the slack's appdata folder, as well as cache of attachements that were sent in the conversation.
+  Prefetch can give the time of execution of shredder (Blank and Secure)
+  AnyDesk artifacts connection_trace.txt and ad_svc.trace etc can give the timestamp and the user id of the incoming connection.
+  C\Users\randon\AppData\Local\Google\DriveFS\110922692857671422467\content_cache has the cached content of all the synced files.

### Flag

bi0sctf{w3ll_th4t_w4s_4_v3ry_34sy_chall_b9s0w7}

### Author

|            |           |                 |               |
|------------|-----------|-----------------|---------------|
| **sp3p3x** | **jl_24** | **gh0stkn1ght** | **hrippi.x_** |
|            |           |                 |               |