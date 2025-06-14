FROM ruby:3.4.2-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential curl\
    && rm -rf /var/lib/apt/lists/*

RUN gem install webrick

COPY . /app

RUN mkdir -p /app/internal_uploads

EXPOSE 3001

CMD ["ruby", "legacy_storage.rb"]