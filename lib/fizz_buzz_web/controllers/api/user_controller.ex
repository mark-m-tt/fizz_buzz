defmodule FizzBuzzWeb.Api.UserController do
  use FizzBuzzWeb, :controller

  alias FizzBuzz.Accounts
  alias FizzBuzz.Guardian

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, %Accounts.User{} = user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:created)
        |> render("jwt.json", jwt: token)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(FizzBuzzWeb.Api.ErrorView)
        |> render("error.json", changeset: changeset)
    end
  end
end
