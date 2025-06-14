# syntax=docker/dockerfile:1

FROM ubuntu:22.04

# Install app dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-pip gunicorn ffmpeg

COPY requirements.txt /

COPY tiny.en.pt /root/.cache/whisper/tiny.en.pt 

# Install Python dependencies
RUN pip install --no-cache-dir -r /requirements.txt
RUN pip install torch==2.0.1+cpu -f https://download.pytorch.org/whl/torch_stable.html

COPY chatapp /chatapp
COPY whisper /chatapp/whisper
COPY chatbot.py /chatapp
COPY whisper.py /chatapp/whisper.py

# Expose port for the app
EXPOSE 8005

# Copy flag file for challenge
COPY flag /chal/flag

# Set working directory for the app
WORKDIR /chatapp

# Start the app with Gunicorn and Uvicorn worker
CMD ["gunicorn", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "app:app", "--bind", "0.0.0.0:8005"]

