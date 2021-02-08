# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fizz_buzz,
  ecto_repos: [FizzBuzz.Repo]

# Configures the endpoint
config :fizz_buzz, FizzBuzzWeb.Endpoint,
  http: [ip: {0,0,0,0}],
  secret_key_base: "glii7PvBDNFA72CoXLzWSTbK67756nIHL3fSrO3YzM5E0BFCzesGjrOAKA5Wslnz",
  render_errors: [view: FizzBuzzWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FizzBuzz.PubSub,
  live_view: [signing_salt: "C9PeoCVz"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :fizz_buzz, FizzBuzz.Guardian, issuer: "FizzBuzz"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
