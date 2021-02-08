defmodule FizzBuzzWeb.Api.FavouriteControllerTest do
  use FizzBuzzWeb.ConnCase
  use ExUnit.Case
  import FizzBuzz.Guardian

  import FizzBuzz.Factory

  describe "index/2" do
    setup [:create_user_and_login_via_jwt]

    test "renders the current users favourites and returns a 200", %{conn: conn, user: user} do
      favourite_1 = insert(:favourite, number: 1, user: user)
      favourite_2 = insert(:favourite, number: 2, user: user)
      conn = get(conn, Routes.api_favourite_path(conn, :index))

      assert json_response(conn, 200)["favourites"] == [
               %{
                 "id" => favourite_1.id,
                 "number" => 1,
                 "user_id" => user.id
               },
               %{
                 "id" => favourite_2.id,
                 "number" => 2,
                 "user_id" => user.id
               }
             ]
    end
  end

  describe "create/2" do
    setup [:create_user_and_login_via_jwt]

    test "with valid params it creates a record and returns a 201", %{conn: conn, user: user} do
      conn = post(conn, Routes.api_favourite_path(conn, :create), number: 1)
      assert json_response(conn, 201)["favourite"]["number"] == 1
      assert json_response(conn, 201)["favourite"]["user_id"] == user.id
    end

    test "with invalid params it renders a 422", %{conn: conn} do
      conn = post(conn, Routes.api_favourite_path(conn, :create), number: 0)
      assert json_response(conn, 422)["errors"] != nil
    end
  end

  describe "find_by_number/2" do
    setup [:create_user_and_login_via_jwt]

    test "when a favourite exists for the logged in user", %{conn: conn, user: user} do
      insert(:favourite, user: user, number: 1)
      conn = get(conn, Routes.api_favourite_by_number_path(conn, :find_by_number, 1))
      assert json_response(conn, 200)["favourite"]["number"] == 1
      assert json_response(conn, 200)["favourite"]["user_id"] == user.id
    end

    test "when a favourite exists but for another user", %{conn: conn} do
      insert(:favourite, user: insert(:user), number: 4)
      conn = get(conn, Routes.api_favourite_by_number_path(conn, :find_by_number, 4))
      assert json_response(conn, 404)
    end

    test "when no favourite exists", %{conn: conn} do
      conn = get(conn, Routes.api_favourite_by_number_path(conn, :find_by_number, 1))
      assert json_response(conn, 404)
    end
  end

  describe "show/2" do
    setup [:create_user_and_login_via_jwt]

    test "when a favourite exists for the logged in user", %{conn: conn, user: user} do
      favourite = insert(:favourite, user: user, number: 1)
      conn = get(conn, Routes.api_favourite_path(conn, :show, favourite))
      assert json_response(conn, 200)["favourite"]["number"] == 1
      assert json_response(conn, 200)["favourite"]["user_id"] == user.id
    end

    test "when a favourite does not exist for the logged in user", %{conn: conn} do
      favourite = insert(:favourite, user: insert(:user), number: 4)
      conn = get(conn, Routes.api_favourite_path(conn, :show, favourite))
      assert json_response(conn, 404)
    end

    test "when no favourite exists", %{conn: conn} do
      conn = get(conn, Routes.api_favourite_path(conn, :show, 1))
      assert json_response(conn, 404)
    end
  end

  describe "delete/2" do
    setup [:create_user_and_login_via_jwt]

    test "when a favourite exists for the logged in user deletes the record", %{
      conn: conn,
      user: user
    } do
      favourite = insert(:favourite, user: user, number: 1)
      conn = delete(conn, Routes.api_favourite_path(conn, :delete, favourite))
      assert json_response(conn, 204)
    end

    test "when a favourite does not exist for the logged in user renders a 404", %{conn: conn} do
      favourite = insert(:favourite, user: insert(:user), number: 4)
      conn = delete(conn, Routes.api_favourite_path(conn, :delete, favourite))
      assert json_response(conn, 404)
    end

    test "when no favourite exists renders a 404", %{conn: conn} do
      conn = delete(conn, Routes.api_favourite_path(conn, :delete, 1))
      assert json_response(conn, 404)
    end
  end

  defp create_user_and_login_via_jwt(_) do
    user = insert(:user)
    {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer " <> token)

    %{conn: conn, user: user}
  end
end
