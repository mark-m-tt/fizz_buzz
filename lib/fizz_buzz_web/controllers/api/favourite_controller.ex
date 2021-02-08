defmodule FizzBuzzWeb.Api.FavouriteController do
  use FizzBuzzWeb, :controller

  alias FizzBuzz.Accounts
  alias FizzBuzz.Guardian
  alias FizzBuzz.Repo

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> render("index.json", favourites: user(conn).favourites)
  end

  def create(conn, %{"number" => number}) do
    params = %{user_id: user(conn).id, number: number}

    case Accounts.create_favourite(params) do
      {:ok, favourite} ->
        conn
        |> put_status(:created)
        |> render("show.json", favourite: favourite)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(FizzBuzzWeb.Api.ErrorView)
        |> render("error.json", changeset: changeset)
    end
  end

  def find_by_number(conn, %{"number" => number}) do
    case Accounts.get_favourite_by_number(number, user(conn).id) do
      favourite = %Accounts.Favourite{} ->
        conn
        |> put_status(:ok)
        |> render("show.json", favourite: favourite)

      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(FizzBuzzWeb.Api.ErrorView)
        |> render("raw_error.json", error: "Not found")
    end
  end

  def show(conn, %{"id" => id}) do
    case Accounts.get_favourite(id) do
      favourite = %Accounts.Favourite{} ->
        if favourite.user_id == user(conn).id do
          conn
          |> put_status(:ok)
          |> render("show.json", favourite: favourite)
        else
          render_not_found(conn)
        end

      nil ->
        render_not_found(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.get_favourite(id) do
      favourite = %Accounts.Favourite{} ->
        if user(conn).id == favourite.user_id do
          Accounts.delete_favourite(favourite)

          conn
          |> put_status(204)
          |> render("index.json", favourites: user(conn).favourites)
        else
          render_not_found(conn)
        end

      nil ->
        render_not_found(conn)
    end
  end

  defp user(conn) do
    Guardian.Plug.current_resource(conn) |> Repo.preload(:favourites)
  end

  defp render_not_found(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(FizzBuzzWeb.Api.ErrorView)
    |> render("raw_error.json", error: "Not found")
  end
end
