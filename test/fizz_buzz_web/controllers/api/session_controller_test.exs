defmodule FizzBuzzWeb.Api.SessionControllerTest do
  use FizzBuzzWeb.ConnCase
  use ExUnit.Case

  import FizzBuzz.Factory
  import Mock

  alias Comeonin.Bcrypt

  describe "create/2" do
    setup do
      user = insert(:user)
      conn = build_conn()

      {:ok, conn: conn, user: user}
    end

    test "it returns a 200 with the JWT when given a valid username and password", %{
      conn: conn,
      user: user
    } do
      with_mock Bcrypt, check_pass: fn user, _password, _options -> {:ok, user} end do
        conn =
          post(conn, Routes.api_session_path(conn, :create),
            session: %{username: user.username, password: ""}
          )

        assert json_response(conn, 200)["jwt"] != nil
      end
    end

    test "it returns a 401 when not given a valid username and password", %{
      conn: conn
    } do
      with_mock Bcrypt, check_pass: fn _user, _password, _options -> {:error, ""} end do
        conn =
          post(conn, Routes.api_session_path(conn, :create),
            session: %{username: "", password: ""}
          )

        assert json_response(conn, 401)
      end
    end
  end
end
