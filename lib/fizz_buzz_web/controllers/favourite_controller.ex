defmodule FizzBuzzWeb.FavouriteController do
  use FizzBuzzWeb, :controller

  alias FizzBuzz.Accounts

  def create(conn, %{"favourite" => favourite_params}) do
    case Accounts.create_favourite(favourite_params) do
      {:ok, _favourite} ->
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

    if current_user_id(conn) == favourite.user_id do
      {:ok, _favourite} = Accounts.delete_favourite(favourite)

      conn
      |> put_flash(:info, "Favourite deleted successfully.")
      |> redirect(to: Routes.home_path(conn, :index))
    else
      conn
      |> put_flash(:warning, "Page not found")
      |> put_status(:not_found)
      |> redirect(to: Routes.home_path(conn, :index))
    end
  end
end
