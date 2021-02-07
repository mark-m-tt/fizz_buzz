defmodule FizzBuzzWeb.UserController do
  use FizzBuzzWeb, :controller

  alias FizzBuzz.Accounts
  alias FizzBuzz.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed up successfully.")
        |> redirect(to: Routes.home_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    if correct_user_is_logged_in?(conn, id) do
      user = Accounts.get_user!(id)
      changeset = Accounts.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      render_not_found(conn)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    if correct_user_is_logged_in?(conn, id) do
      user = Accounts.get_user!(id)

      case Accounts.update_user(user, user_params) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: Routes.home_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    else
      render_not_found(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    if correct_user_is_logged_in?(conn, id) do
      user = Accounts.get_user!(id)
      {:ok, _user} = Accounts.delete_user(user)

      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(
        to: Routes.home_path(conn, :index),
        list: default_fizz_buzz_list,
        calculator: default_calculator
      )
    else
      render_not_found(conn)
    end
  end

  defp correct_user_is_logged_in?(conn, id), do: to_string(current_user_id(conn)) == id

  defp render_not_found(conn) do
    conn
    |> put_flash(:warning, "Page not found")
    |> put_status(:not_found)
    |> redirect(to: Routes.home_path(conn, :index))
  end
end
