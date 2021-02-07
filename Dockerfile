FROM elixir:1.11.3-alpine

RUN apk update && apk upgrade && apk add bash \
  build-base \
  less \
  inotify-tools \
  make \
  nodejs \
  npm \
  postgresql-client

RUN mix local.hex --force && \
  mix local.rebar --force
WORKDIR   /app

COPY assets/package.json        ./assets/
COPY assets/package-lock.json   ./assets/
RUN npm install --prefix ./assets

COPY mix.exs    .
COPY mix.lock   .
ADD config ./config
RUN mix deps.get
RUN mix deps.compile

COPY . .

CMD ["/app/entrypoint.sh"]
