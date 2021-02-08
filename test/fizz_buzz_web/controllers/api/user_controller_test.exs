defmodule FizzBuzzWeb.Api.UserControllerTest do
  use FizzBuzzWeb.ConnCase
  use ExUnit.Case

  @create_attrs %{
    password: "some password",
    password_confirmation: "some password",
    username: "some username"
  }

  @invalid_attrs %{username: 1}

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create), user: @create_attrs)
      assert json_response(conn, 201)["jwt"] != nil
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create), user: @invalid_attrs)

      assert json_response(conn, 422)["errors"] == %{
               "password_confirmation" => ["can't be blank"],
               "username" => ["is invalid"]
             }
    end
  end
end
