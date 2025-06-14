FROM ruby:3.4.2-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gnupg \
    wget \
    build-essential \
    libpq-dev \
    nodejs \
    libyaml-dev && \
    wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*


COPY src/Gemfile src/Gemfile.lock ./

RUN gem install rails -v 8.0.2 && bundle install

COPY src/ .

EXPOSE 3000

ENV RAILS_ENV=development

CMD ["sh", "-c", "rails db:migrate && rails db:seed && rails server -b 0.0.0.0"]
