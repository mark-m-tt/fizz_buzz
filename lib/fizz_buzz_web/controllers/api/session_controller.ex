defmodule FizzBuzzWeb.Api.SessionController do
  use FizzBuzzWeb, :controller

  alias FizzBuzz.Accounts
  alias FizzBuzz.Guardian

  def create(conn, %{"session" => auth_params}) do
    user = Accounts.get_by_username(auth_params["username"])

    case Comeonin.Bcrypt.check_pass(user, auth_params["password"], hash_key: :password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:ok)
        |> put_view(FizzBuzzWeb.Api.UserView)
        |> render("jwt.json", jwt: token)

      {:error, error} ->
        IO.puts(error)

        conn
        |> put_status(:unauthorized)
        |> put_view(FizzBuzzWeb.Api.ErrorView)
        |> render("raw_error.json", error: "There was a problem with your username/password")
    end
  end
end
