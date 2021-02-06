defmodule FizzBuzz.Repo do
  use Ecto.Repo,
    otp_app: :fizz_buzz,
    adapter: Ecto.Adapters.Postgres
end
