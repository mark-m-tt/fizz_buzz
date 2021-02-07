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
    setup [:create_favourite]

    test "deletes chosen favourite", %{conn: conn, favourite: favourite} do
      conn = delete(conn, Routes.favourite_path(conn, :delete, favourite))
      assert get_flash(conn, :info) == "Favourite deleted successfully."
      assert redirected_to(conn) == Routes.home_path(conn, :index)
    end
  end

  defp create_favourite(_) do
    favourite = insert(:favourite)
    %{favourite: favourite}
  end
end
