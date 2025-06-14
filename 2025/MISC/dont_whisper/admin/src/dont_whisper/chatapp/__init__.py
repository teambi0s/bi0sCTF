def run():
    from chatapp.wsgi import ChatApplication
    ChatApplication().run()

def debug():
    import os
    import uvicorn
    os.environ["DEBUG"] = "1"
    uvicorn.run("chatapp.app:app", reload=True, port=8005)
