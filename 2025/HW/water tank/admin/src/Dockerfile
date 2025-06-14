FROM python:alpine

RUN apk update

WORKDIR /app

COPY requirements.txt .
COPY .env .
COPY server.py .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5020

CMD ["python3", "server.py"]