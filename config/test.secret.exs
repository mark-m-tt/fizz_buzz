import Config

config :fizz_buzz, FizzBuzz.Repo,
  username: "postgres",
  password: "postgres",
  database: "fizz_buzz_test",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox

config :fizz_buzz, FizzBuzz.Guardian, secret_key: "test"
