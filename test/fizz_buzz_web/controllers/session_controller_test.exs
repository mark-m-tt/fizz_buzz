defmodule FizzBuzzWeb.SessionControllerTest do
  use FizzBuzzWeb.ConnCase
  use ExUnit.Case

  import FizzBuzz.Factory
  import Mock

  alias Comeonin.Bcrypt

  describe "create" do
    setup do
      user = insert(:user)
      conn = build_conn()

      {:ok, conn: conn, user: user}
    end

    test "it signs in the user if the password is correct", %{conn: conn, user: user} do
      with_mock Bcrypt, check_pass: fn user, _password -> {:ok, user} end do
        conn = post(conn, Routes.session_path(conn, :create), session: auth_params(user))
        assert Plug.Conn.get_session(conn, :current_user_id) == user.id
        assert redirected_to(conn) == Routes.home_path(conn, :index)
        assert get_flash(conn, :info) == "Signed in successfully."
      end
    end

    test "it renders the sign in page with an flash error if the password is incorrect", %{
      conn: conn,
      user: user
    } do
      with_mock Bcrypt, check_pass: fn _user, _password -> {:error, ""} end do
        conn = post(conn, Routes.session_path(conn, :create), session: auth_params(user))
        assert Plug.Conn.get_session(conn, :current_user_id) == nil
        assert html_response(conn, 200) =~ "Sign in"
        assert get_flash(conn, :error) == "There was a problem with your username/password"
      end
    end
  end

  describe "delete" do
    setup do
      conn = build_conn() |> Plug.Test.init_test_session(current_user_id: 1)

      {:ok, conn: conn}
    end

    test "clears the current_user_id from the conn and redirects to the index page", %{conn: conn} do
      conn = delete(conn, Routes.session_path(conn, :delete))
      assert Plug.Conn.get_session(conn, :current_user_id) == nil
      assert redirected_to(conn) == Routes.home_path(conn, :index)
    end
  end

  defp auth_params(user) do
    %{username: user.username, password: 'password'}
  end
end
