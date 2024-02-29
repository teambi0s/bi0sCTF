FROM python:3.11.3

WORKDIR /app

COPY requirements.txt ./requirements.txt

RUN pip install -r requirements.txt

COPY app.py .

CMD ["python3", "./app.py"]