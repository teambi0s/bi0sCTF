FROM python:3.11

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV FLAG=flag{test__flaaggg}

RUN python -m playwright install --with-deps

COPY . .

EXPOSE 4000

CMD ["python", "app.py"]
