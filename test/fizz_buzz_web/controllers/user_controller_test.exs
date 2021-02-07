defmodule FizzBuzzWeb.UserControllerTest do
  use FizzBuzzWeb.ConnCase
  use ExUnit.Case

  import FizzBuzz.Factory

  @create_attrs %{encrypted_password: "some encrypted_password", username: "some username"}
  @update_attrs %{
    encrypted_password: "some updated encrypted_password",
    username: "some updated username"
  }
  @invalid_attrs %{encrypted_password: nil, username: nil}

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user when the correct user is signed in" do
    setup [:create_user_and_login]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "edit user when the correct user is not signed in" do
    setup [:create_user]

    test "returns a 404", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert get_flash(conn, :warning) == "Page not found"
    end
  end

  describe "update user when the correct user is signed in" do
    setup [:create_user_and_login]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user when the correct user is not signed in" do
    setup [:create_user]

    test "returns a 404", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert get_flash(conn, :warning) == "Page not found"
    end
  end

  describe "delete user when the correct user is logged in" do
    setup [:create_user_and_login]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "delete user when the correct user is not logged in" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert get_flash(conn, :warning) == "Page not found"
    end
  end

  defp create_user(_) do
    user = insert(:user)
    %{user: user}
  end

  defp create_user_and_login(_) do
    user = insert(:user)
    conn = build_conn() |> Plug.Test.init_test_session(current_user_id: user.id)

    {:ok, user: user, conn: conn}
  end
end
