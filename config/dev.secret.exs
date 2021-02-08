import Config

config :fizz_buzz, FizzBuzz.Repo,
  username: "postgres",
  password: "postgres",
  database: "fizz_buzz_dev",
  hostname: "db"

config :fizz_buzz, FizzBuzz.Guardian,
  secret_key: "nMKsPXThtfIEaf7VVgJ6buuifgOBl0r2eEmorvKFubn3LktNtf/UWhC88YssgXvV"

config :fizz_buzz, max_size: 100_000_000_000
