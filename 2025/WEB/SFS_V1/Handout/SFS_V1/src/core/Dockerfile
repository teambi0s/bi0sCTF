FROM ruby:3.4.2-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

COPY src/Gemfile src/Gemfile.lock ./

RUN gem install rails -v 8.0.2 && bundle install

COPY src/ .

EXPOSE 3000

ENV RAILS_ENV=development

CMD ["sh", "-c", "rails db:migrate && rails db:seed && rails server -b 0.0.0.0"]
