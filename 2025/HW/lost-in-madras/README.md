# lost-in-madras

## Challenge description

I recently vistied Madras and I got carjacked T.T 
Luckily, I had a wireless OBD adapter connected to my car through which I was able to obtain the CAN log for the whole journey. It's so unfortunate that I can't make sense of the content in the log file.

To confirm that it is mine, find the VIN for my car.
Can you help me find where my car ended up?

Flag format: bi0s{VIN_Landmark Name}
Example flag: bi0s{1FTFW1R6XBFB08616_Eiffel Tower}

## Challenge Files
- [Primary Link](https://drive.google.com/file/d/1hf4KIGbQzeSRryktbaeoECKT5LilcGoH/view?usp=sharing)
- [Mirror Link](https://1drv.ms/f/c/95fb325e3ede6b6c/EkYtNYp9ssFMiorFZme0pi8BbItnkz9MeLYOWCiSkw67Lg?e=UH53iC)

**63d38a9d0ebc17c4a628e13a10abe8b2  canlog.txt**

## Short writeup
- Find the UDS service ID and DID for requesting VIN and for flow control wthin the log file
- Convert the hex to ascii text in the UDS response for VIN
- Find the DBC file for the specific model coresponding to VIN obtained 
- Find CAN ID for the coordinates.Obtain the coordinates,apply the offset and factor to obatined value according to the DBC file

## Flag
`bi0s{1FMHK7D82BGA34954_M. A. Chidambaram Stadium}`

## Authors
cyberhawk, br34dcrumb
