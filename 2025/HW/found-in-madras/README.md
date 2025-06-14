# found-in-madras

## Challenge description

Thanks to you, I found my car. 
Just to be safe I want to check if the thief went above the speed limit or not. Get me the highest speed achieved by the car during the theft.

Also, can you check what was he trying to access? 
It seems like he was trying to gain access to Security level 15. Can you get me the SEED and KEY for the approved access?

(Based on the same CAN log as `lost-in-madras`)

Flag format: bi0s{max speed_SEED_KEYY}
Example flag: bi0s{12.23kph_DEADBEEF_CAFEBABE}

## Challenge Files
- [Primary Link](https://drive.google.com/file/d/1hf4KIGbQzeSRryktbaeoECKT5LilcGoH/view?usp=sharing)
- [Mirror Link](https://1drv.ms/f/c/95fb325e3ede6b6c/EkYtNYp9ssFMiorFZme0pi8BbItnkz9MeLYOWCiSkw67Lg?e=UH53iC)

**63d38a9d0ebc17c4a628e13a10abe8b2  canlog.txt**

## Short writeup
- Find the CAN ID corresponding to speed from the DBC file 
- Apply the factor and offset value according to DBC file to the obtained speed from the log file
- Find the UDS service ID and response related to security access,observes the request and response for the correct flag and seed

## Flag
`bi0s{65.13kph_35779486_CA43ABBE}`

## Authors
cyberhawk, br34dcrumb
