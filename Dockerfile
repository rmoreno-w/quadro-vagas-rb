FROM ruby:3.4.2

RUN apt-get update -qq && apt-get install -y \
  postgresql-client \
  nodejs \
  yarn \
  chromium \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/ruby_nos_trilhos

COPY . .

RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]