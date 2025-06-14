from fastapi import FastAPI, Form, UploadFile, File, HTTPException
import uuid
import os
from pydub import AudioSegment
import mimetypes
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import asyncio
import os
import re
from pydub import AudioSegment
import subprocess

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

VALID_FILENAME_REGEX = re.compile(r'^[\w,\s-]+\.[A-Za-z]{3,4}$')


# Max file size (4 MB)
MAX_FILE_SIZE = 4 * 1024 * 1024
# Max audio duration (31 seconds)
MAX_AUDIO_DURATION = 31


def sanitize_input(text: str) -> str:
    """Sanitize user input to prevent command injection."""
    # Block common dangerous characters
    dangerous_chars = ["'", ";", "&", "|", "`", "$", "\n", "\r"]
    if any(char in text for char in dangerous_chars):
        raise HTTPException(status_code=400, detail="Invalid input detected.")
    return text.strip()


@app.get("/", response_class=HTMLResponse)
async def index():
    return templates.TemplateResponse("index.html", {"request": {}})


@app.post("/api/chat")
async def chat_response(user_text: str = Form(...)):

    sanitized_text = sanitize_input(user_text)
    print("got here")

    # Run the chatbot command in a subprocess
    result = subprocess.run(
        ['python3', 'chatbot.py', sanitized_text],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True  # ensures output is captured as a string instead of bytes
    )

    stdout = result.stdout


    # Decode output from bytes to string
    return JSONResponse(content={"response": stdout.strip()})



def is_valid_audio_file(file: UploadFile) -> tuple[bool, str]:
    """Validate that the uploaded file is a WAV or MP3 audio file."""
    # Check file size
    if file.size > MAX_FILE_SIZE:
        raise HTTPException(status_code=400, detail="File size exceeds 4MB limit.")
    
    file.filename = sanitize_input(file.filename)
    # Check MIME type
    mime_type, _ = mimetypes.guess_type(file.filename)
    if mime_type not in ["audio/wav", "audio/mpeg", "audio/x-wav"]:
        raise HTTPException(status_code=400, detail="Only WAV or MP3 files are allowed.")

    # Generate a unique temporary filename
    unique_filename = f"/tmp/{uuid.uuid4()}.wav"
    
    try:
        # Save file temporarily
        with open(unique_filename, "wb") as buffer:
            buffer.write(file.file.read())

        # Validate audio file with pydub
        audio = AudioSegment.from_file(unique_filename)
        duration_seconds = len(audio) / 1000  # pydub returns duration in milliseconds

        # Check duration
        
        if duration_seconds > MAX_AUDIO_DURATION:
            os.remove(unique_filename)
            raise HTTPException(status_code=400, detail="Audio duration exceeds 20 seconds.")

        # Verify file format
        if audio.frame_rate is None or audio.channels < 1:
            os.remove(unique_filename)
            raise HTTPException(status_code=400, detail="Invalid audio file format.")

        return True, unique_filename
    except Exception as e:
        if os.path.exists(unique_filename):
            os.remove(unique_filename)
        raise HTTPException(status_code=400, detail=f"Invalid audio file: {str(e)}")

@app.post("/api/audio-chat")
async def audio_response(audio: UploadFile = File(...)):
    try:
        # Validate audio file
        is_valid, audio_file_path = is_valid_audio_file(audio)
        if not is_valid:
            return JSONResponse(content={"error": "Invalid audio file."}, status_code=400)

        try:
            result = subprocess.run(
                [
                    "python3", "whisper.py", "--model", "tiny.en", audio_file_path,
                    "--language", "English", "--best_of", "5", "--beam_size", "None"
                ],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )

            # Check for errors
            if result.returncode != 0:
                return JSONResponse(content={"error": "Error processing audio file."}, status_code=500)

            transcription = result.stdout.strip()
            if not transcription:
                return JSONResponse(content={"error": "No transcription generated."}, status_code=400)

            print("Transcription",transcription)
            chatbot_proc = await asyncio.create_subprocess_shell(
                f"python3 chatbot.py '{transcription}'",
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.STDOUT
            )
            chatbot_stdout, chatbot_stderr = await chatbot_proc.communicate()
            return JSONResponse(content={"response": chatbot_stdout.decode().strip(), "transcription": transcription})
        finally:
            # Clean up temporary file
            if os.path.exists(audio_file_path):
                os.remove(audio_file_path)

    except HTTPException as e:
        return JSONResponse(content={"error": e.detail}, status_code=e.status_code)
    except Exception:
        return JSONResponse(content={"error": "An unexpected error occurred."}, status_code=500)

