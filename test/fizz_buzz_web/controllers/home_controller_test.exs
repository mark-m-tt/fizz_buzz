defmodule FizzBuzzWeb.HomeControllerTest do
  use FizzBuzzWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Fizz Buzz!"
  end
end
