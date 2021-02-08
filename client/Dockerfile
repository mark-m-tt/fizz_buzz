FROM ruby:3.0.0

WORKDIR /app
RUN gem install bundler:2.2.7
COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN bundle install

COPY . .

CMD ["./irb.sh"]
