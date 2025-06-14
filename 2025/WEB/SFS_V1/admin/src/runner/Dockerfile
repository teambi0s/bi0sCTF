FROM python:3.9-slim

RUN apt-get update && apt-get install -y netcat-openbsd wget curl && apt-get clean
RUN pip install requests

RUN groupadd -r appuser && useradd -r -g appuser -m -d /home/appuser appuser

WORKDIR /app

COPY runner.py .

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 4000

CMD ["python", "runner.py"]
