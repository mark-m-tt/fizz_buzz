FROM ruby:3.0.0

WORKDIR /app
COPY . /app
RUN gem install bundler:2.2.7
RUN bundle install
RUN ls

COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN ls
CMD ["./irb.sh"]