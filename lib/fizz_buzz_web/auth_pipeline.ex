defmodule FizzBuzz.Guardian.AuthPipeline do
  @moduledoc """
  Responsible for ensuring a valid JWT is present in headers
  """

  use Guardian.Plug.Pipeline,
    otp_app: :fizz_buzz,
    module: FizzBuzz.Guardian,
    error_handler: FizzBuzzWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
