from flask import Flask,render_template,request, make_response, redirect
from urllib.parse import urlparse
import requests
import os
import requests

app = Flask(__name__)

app.config['TEMPLATES_AUTO_RELOAD'] = True

@app.route('/',methods=['GET'])
def index():
    username = os.environ.get('username')
    password = os.environ.get('password')
    if request.cookies.get('username') == username and request.cookies.get('password') == password:
        return render_template('index.html')
    else:
        return "Not authorized, please login first"

@app.route('/auth',methods=['GET','POST'])
def auth():
    username = os.environ.get('username')
    password = os.environ.get('password')
    if request.method == 'GET':
        return """
                <html>
                    <body>
                        <h1>Auth</h1>
                        <form method="POST" action="/auth">
                            <input type="text" name="username" placeholder="Username: ">
                            <input type="text" name="password" placeholder="Password: ">
                            <input type="submit" value="Check">
                        </form>
                    </body>
                </html>
            """
    else:
        user = request.form.get('username')
        passw = request.form.get('password')
        if username == user and password == passw:
            resp = make_response(redirect('/'))
            resp.set_cookie('username', user)
            resp.set_cookie('password', passw) 
            return resp
        else:
            return "Invalid creds"

@app.route('/okay',methods=['POST'])
def test():
    blocked_hosts = ["registry"]
    url = request.form.get('url')
    try:
        parsed_url = urlparse(url).hostname
    except Exception as e:
        return render_template('index.html',data=e)
    
    if parsed_url in blocked_hosts:
        return render_template('index.html',data="Not okay, blocked host")
    else:
        try:
            r = requests.get(url,allow_redirects=False)
            return r.content
        except Exception as e:
            return render_template('index.html',data=e)
        
@app.route('/internal',methods=['GET'])
def internal():
    return """
           <h5>
            <br>
            Debug info page:
            <br>
            The following are the available internal service routes
            <br>
            <br>
            http://core:1234     [EXPOSED SERVICE] 
            <br>
            http://registry:5000 [INTERNAL SERVICE] 
            <br>
            http://vec:3000      [EXPOSED SERVICE] 
            <br>
           </h5>
           """
        
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=1234, debug=False)