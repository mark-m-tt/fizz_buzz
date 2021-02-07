defmodule FizzBuzzWeb.FavouriteControllerTest do
  use FizzBuzzWeb.ConnCase

  import FizzBuzz.Factory

  @create_attrs %{number: 42, user_id: 1}
  @invalid_attrs %{number: nil}

  describe "create favourite" do
    test "redirects to the home path when data is valid", %{conn: conn} do
      insert(:user, id: 1)
      conn = post(conn, Routes.favourite_path(conn, :create), favourite: @create_attrs)
      assert get_flash(conn, :info) == "Favourite created successfully."

      assert redirected_to(conn) == Routes.home_path(conn, :index)
    end

    test "does the same with a flash when invalid", %{conn: conn} do
      conn = post(conn, Routes.favourite_path(conn, :create), favourite: @invalid_attrs)
      assert redirected_to(conn) == Routes.home_path(conn, :index)
      assert get_flash(conn, :error) == "Something went wrong"
    end
  end

  describe "delete favourite" do
    setup [:create_user_and_favourite_and_login]

    test "deletes chosen favourite when the user is signed in", %{
      conn: conn,
      favourite: favourite
    } do
      conn = delete(conn, Routes.favourite_path(conn, :delete, favourite))
      assert get_flash(conn, :info) == "Favourite deleted successfully."
      assert redirected_to(conn) == Routes.home_path(conn, :index)
    end

    test "renders a 404 when the incorrect user is signed in", %{
      conn: conn,
      favourite: favourite
    } do
      conn = conn |> delete_session(:current_user_id)
      conn = delete(conn, Routes.favourite_path(conn, :delete, favourite))
      assert get_flash(conn, :warning) == "Page not found"
    end
  end

  defp create_user_and_favourite_and_login(_) do
    user = insert(:user)
    favourite = insert(:favourite, user: user)
    conn = build_conn() |> Plug.Test.init_test_session(current_user_id: user.id)

    {:ok, user: user, conn: conn, favourite: favourite}
  end
end
