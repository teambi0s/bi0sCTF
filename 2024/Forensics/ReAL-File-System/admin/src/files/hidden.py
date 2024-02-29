Answers = ['3cb4381fc7e910845780f3a08f4cdc8364c0128eec4c575e154b6db13f276101', 'ac28abc0bcda9eda3790859f0f22011cc3ebe912942a491604a5bf46055a28b7', 'db35103d6ca1d118a2f3b10d279a056eafa119f67bc289e2f95c829acd62b0a1', 'f79ca28a450fe030247638f8f9da75ebc5806d59d85ddae995167748eaa40bcb', '630200e362f7f79feb4a18060cfb00e78d838152ca221a12d4cbfc3b8816447e', 'af535fa9c04e91052853bc3aa536a4e0b393ab0bcc7fdebbb3333d751800ad17']


QuEsTiOn_Pool = [
"Question 1 : List all directories that have been renamed, including their original names and the timestamps of when they were renamed.\nTimeZone - UTC(+05:30) [YYYY-MM-DD HH:MM:SS.XX]\n \
Format - [ ['OriginalDirName', 'RenamedDirName', 'TimeStamp'] , .. ]"
,

"Question 2 : Name all the deleted directories with deletion timestamps.\nTimeZone : UTC(+05:30) [YYYY-MM-DD HH:MM:SS.XX]\n Format - [ ['DirectoryName' , 'TimeStamp'] , .. ]"
,

"Question 3 : List all directories with their creation times, including originals if any that has been renamed or deleted. (Note : If a directory was renamed, include its original name and creation time.)\nTimeZone : UTC(+05:30) [YYYY-MM-DD HH:MM:SS.XX]\n Format - [ ['DirectoryName' , 'CreatedTime'] , .... ]"
,

"Question 4 : Recover the files that have been deleted, and provide the md5sum of each recovered file.\nFormat - [ ['filehash1'] , ['filehash2'], ... ]"
,

"Question 5 : Identify all files that have been deleted (Simple + Permanent), including their deletion timestamps.\nTimeZone : UTC(+05:30) [YYYY-MM-DD HH:MM:SS.XX]\nFormat - [ [ 'filename' , 'TimeStamp' , 'Simple/Permanent' ] , .. ]"
,

"Question 6: Restore all encrypted files, decrypt them, and provide the md5sum of each decrypted file after removing any extra bytes before computing the hash.\n Format - [ ['hash1'] , ['hash2'], ',..] "

]
