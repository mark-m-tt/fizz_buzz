defmodule FizzBuzzWeb.FavouriteController do
  use FizzBuzzWeb, :controller

  alias FizzBuzz.Accounts
  alias FizzBuzz.Accounts.Favourite

  def create(conn, %{"favourite" => favourite_params}) do
    case Accounts.create_favourite(favourite_params) do
      {:ok, favourite} ->
        conn
        |> put_flash(:info, "Favourite created successfully.")
        |> redirect(to: Routes.home_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: Routes.home_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    favourite = Accounts.get_favourite!(id)
    {:ok, _favourite} = Accounts.delete_favourite(favourite)

    conn
    |> put_flash(:info, "Favourite deleted successfully.")
    |> redirect(to: Routes.home_path(conn, :index))
  end
end
