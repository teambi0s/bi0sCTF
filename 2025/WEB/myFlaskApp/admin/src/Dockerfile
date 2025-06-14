# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV ADMIN_PASSWORD "IFoRrkwMFRay7DBzuZ7m"
ENV FLAG "bi0sCTF{i_d0n't_f1nd_bugs!!_bug5_f1nd_m3:)}"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN python -m playwright install --with-deps

COPY . .

# Expose the application port
EXPOSE 5000

# Start MongoDB and the Flask application
CMD python app.py