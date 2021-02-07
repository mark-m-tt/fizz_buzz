defmodule FizzBuzzWeb.Helpers.Auth do
  @moduledoc """
  Helper methods for controllers and views
  """

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    id_present?(user_id)
  end

  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    if user_id do
      FizzBuzz.Repo.get(FizzBuzz.Accounts.User, user_id)
    else
      nil
    end
  end

  def current_user_id(conn) do
    Plug.Conn.get_session(conn, :current_user_id)
  end

  defp id_present?(nil), do: false
  defp id_present?(_id), do: true
end
