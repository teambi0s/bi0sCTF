# AnansiTap

### Challenge Description

Pete recently got really into how decentralized money works.With some impressive gains under his belt, the budding dev in him began exploring crypto projects and reaching out online for collaborations.
But one day, his system began acting strange—files misbehaving, programs glitching, and performance taking a hit.
Being notoriously forgetful, Pete had scattered small notes and digital breadcrumbs across his system to help him remember things… but those were gone too.
Panicked, Pete tried to fix things himself. That made it worse. In desperation, he called you—his digital forensics friend—to figure out how things went south.

Your mission:

Investigate the compromise.
Identify the external host that initiated the malicious activity.
Recover the wallet password from what's left behind.

Flag-format:-  bi0sctf{192.168.0.11:9001_superSecretpswd4ReAL}

**Challenge file**
+ [Link](https://drive.google.com/file/d/1cOHgaVulS030zs7tmnPxuzaFwvKplujG/view?usp=sharing) 

### Short Writeup

Malicious activity was triggered through exploitation of Git v2.40 via CVE-2024-32002.
A GitHub repository was cloned, which contained a crafted symlink.
Upon --recurse-submodules, the symlink activated a malicious post-checkout hook.
This led to remote command execution, establishing a connection to an external host.
A file exfiltration payload was executed, siphoning sensitive data from the system.

### Author

hrippi.x_ , the.m3chanic