defmodule FizzBuzzWeb.AuthTest do
  use FizzBuzzWeb.ConnCase
  use ExUnit.Case, async: true

  alias FizzBuzzWeb.Helpers.Auth

  import FizzBuzz.Factory

  setup %{conn: conn} do
    user = insert(:user)

    conn =
      conn
      |> Plug.Test.init_test_session(current_user_id: user.id)

    {:ok, user: user, conn: conn}
  end

  describe "signed_in?/1" do
    test "returns true when a user_id is present", %{conn: conn} do
      assert conn |> Auth.signed_in?() == true
    end

    test "returns false when no user_id is present on conn", %{conn: conn} do
      assert conn
             |> delete_session(:current_user_id)
             |> Auth.signed_in?() == false
    end
  end

  describe "current_user" do
    test "returns the user struct when signed in", %{conn: conn, user: user} do
      assert conn |> Auth.current_user() == user
    end

    test "returns nil when no user is signed in", %{conn: conn} do
      assert conn
             |> delete_session(:current_user_id)
             |> Auth.current_user() == nil
    end
  end
end
